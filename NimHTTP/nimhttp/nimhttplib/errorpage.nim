import std/[asynchttpserver]

type ErrorPage = tuple[
  code: HttpCode,
  html: string
]
export ErrorPage