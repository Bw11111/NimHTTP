import std/[asynchttpserver, asyncdispatch, tables, strformat]
import pages/[home, http404, script]
import nimhttp/nimhttp

var pages = @[homePage, script]



proc makeCb(pages: seq[Page], errorPage404: ErrorPage): proc (req: Request): Future[void] {.closure, gcsafe.} =
  return proc (req: Request): Future[void] {.async, gcsafe.} =
    for data in pages:
      if data.path == req.url.path:
        await req.respond(data.code, data.html)
        return
    await req.respond(Http404, errorPage404.html)

let server = newAsyncHttpServer()
waitFor server.serve(Port(2000), makeCb(pages, page404))