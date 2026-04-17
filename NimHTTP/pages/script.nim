import std/[htmlgen, asynchttpserver]
import ../nimhttp/[nimhttp]

const script: Page = (Http200, "/static/script.js", """



""")

export script;