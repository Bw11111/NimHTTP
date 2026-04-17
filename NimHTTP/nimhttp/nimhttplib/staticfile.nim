import std/[asynchttpserver]

type StaticFile = tuple[
  code: HttpCode,
  path: string,
  html: string
]
export StaticFile