import std/[htmlgen, asynchttpserver]
import ../nimhttp/[nimhttp]

const page404: ErrorPage = (Http404, html(
  head(
    title("404 not found")
  ),
  body(
    h1("Error 404<h3>Page not found</h3>"),
    p("The requested page was not found on the server.")
  )
));

export page404