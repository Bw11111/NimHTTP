import std/[asynchttpserver, asyncdispatch, tables, strformat, htmlgen, macros]

proc component*(arg: string): string = 
    result = arg
