import std/[htmlgen, asynchttpserver]
import ../nimhttp/nimhttp


const homepage: Page = (Http200, "/", html(
  head(
    title("Welcome to NimHTTP!")
  ),
  body(
    center(
      h1("NimHTTP is working."),
      p("Running NimHTTP version 1.0.0-beta")
    ),
    script(src="static/script.js")
  )
));
export homepage;