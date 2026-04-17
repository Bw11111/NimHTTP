import std/[asynchttpserver]

type Page = tuple[
  code: HttpCode,
  path: string,
  html: string
]
export Page