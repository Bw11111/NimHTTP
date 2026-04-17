import std/[os, asynchttpserver, asyncdispatch, tables, strformat, strutils]
import pages/[home, http404, script]
import nimhttp/nimhttp

var pages = @[homePage, script]

proc serveDirectory(req: Request, dirPathA: string) {.async.} =
  let fullPath = "public" & dirPathA
  var dirPath = dirPathA;
  if dirPath == "":
    dirPath = "/static/"
  if not dirExists(fullPath):
    await req.respond(Http404, "Directory not found")
    return

  var html = "<h1>Index of " & dirPath & "</h1><ul>"

  for kind, path in walkDir(fullPath):
    let name = path.splitFile().name
    let ext = path.splitFile().ext

    if kind == pcFile:
      html.add("<li><a href=\"" & dirPath & name & ext & "\">" & name & ext &  "</a></li>")

    elif kind == pcDir:
      html.add("<li><a href=\"" & dirPath & name & "/\">" & name & "/</a></li>")

  html.add("</ul>")

  await req.respond(Http200, html)

proc serveStatic(req: Request, fpath: string) {.async.} =
  let path = fpath.replace("/static/", "")
  let filePath = "public/" & path

  stdout.write(path);

  if fileExists(filePath):
    let content = readFile(filePath)

    let mime =
      if filePath.endsWith(".js"): "text/javascript"
      elif filePath.endsWith(".css"): "text/css"
      elif filePath.endsWith(".html"): "text/html"
      else: "text/plain"

    req.headers["Content-Type"] = mime
    await req.respond(Http200, content)
  else:
    await req.respond(Http404, "Not found " & path)

proc makeCb(pages: seq[Page], errorPage404: ErrorPage): proc (req: Request): Future[void] {.closure, gcsafe.} =
  return proc (req: Request): Future[void] {.async, gcsafe.} =
    
    if req.url.path.startsWith("/static/"):
      let path = req.url.path.replace("/static/", "")

      let fullPath = "public/" & path

      if dirExists(fullPath):
        await serveDirectory(req, path)
      else:
        await serveStatic(req, path)

      return

    for data in pages:
      if data.path == req.url.path:
        await req.respond(data.code, data.html)
        return

    await req.respond(Http404, errorPage404.html)

let server = newAsyncHttpServer()
waitFor server.serve(Port(2000), makeCb(pages, page404))
