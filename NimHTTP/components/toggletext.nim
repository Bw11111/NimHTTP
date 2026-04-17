import std/[htmlgen, asynchttpserver]
import ../nimhttp/[nimhttp]

const toggletext* = h1(
    onclick="this.style.display = this.style.display === 'none' ? 'block' : 'none';",
    id="toggle",
    "Toggle"
)
