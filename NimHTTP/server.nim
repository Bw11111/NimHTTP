import std/[os, asynchttpserver, asyncdispatch, tables, strformat, strutils]
import pages/[home, http404, script]
import nimhttp/nimhttp

var pages = @[homePage, script]

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
      await serveStatic(req, req.url.path)
      return

    for data in pages:
      if data.path == req.url.path:
        await req.respond(data.code, data.html)
        return

    await req.respond(Http404, errorPage404.html)

let server = newAsyncHttpServer()
waitFor server.serve(Port(2000), makeCb(pages, page404))
