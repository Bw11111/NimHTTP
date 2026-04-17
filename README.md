# NimHTTP

A lightweight, minimal HTTP server framework written in **Nim**, designed for simplicity and rapid page-based routing.

## ✨ Features

* ⚡ Async HTTP server using `asynchttpserver`
* 📄 Simple page-based routing system
* 🧩 Component support for reusable HTML elements
* 🛠️ Clean and minimal structure
* 📦 Easy to extend with custom pages and static files

---

## 📁 Project Structure

```
.
├── server.nim                # Entry point
├── nimhttp/                  # Core framework
│   ├── nimhttp.nim
│   └── nimhttplib/
│       ├── page.nim
│       ├── errorpage.nim
│       ├── staticfile.nim
│       └── component.nim
├── pages/                    # Route definitions
│   ├── home.nim
│   ├── script.nim
│   └── http404.nim
├── components/               # Reusable UI components
│   └── toggletext.nim
```

---

## 🚀 Getting Started

### Prerequisites

* [Nim](https://nim-lang.org/) (recommended ≥ 1.6)

### Run the server

```bash
nim c -r server.nim
```

The server will start on:

```
http://localhost:2000
```

---

## 🧠 How It Works

### Pages

Pages are defined as tuples:

```nim
type Page = tuple[
  code: HttpCode,
  path: string,
  html: string
]
```

Example:

```nim
const homepage: Page = (Http200, "/", html(
  head(title("Welcome")),
  body(h1("Hello world"))
))
```

All pages are registered in `server.nim`:

```nim
var pages = @[homePage, script]
```

---

### Routing

Routing is handled by matching request paths:

```nim
if data.path == req.url.path:
  await req.respond(data.code, data.html)
```

If no match is found, a 404 page is returned.

---

### Error Pages

Error pages use a separate type:

```nim
type ErrorPage = tuple[
  code: HttpCode,
  html: string
]
```

---

### Components

Reusable HTML components can be defined like:

```nim
const toggletext* = h1(
  onclick="this.style.display = this.style.display === 'none' ? 'block' : 'block';",
  id="toggle",
  "Toggle"
)
```

Then included in pages:

```nim
body(
  toggletext
)
```

---

### Static Files

Static routes can be manually defined as pages:

```nim
const script: Page = (Http200, "/static/script.js", """
// JS here
""")
```

---

## 📌 Example Routes

| Path                | Description     |
| ------------------- | --------------- |
| `/`                 | Homepage        |
| `/static/script.js` | JavaScript file |
| `*`                 | 404 fallback    |

---

## ⚠️ Limitations

* No automatic static file serving
* No middleware system
* No parameterized routes (`/user/:id`)
* Manual route registration required

---

## 💡 Future Improvements

* Static file directory support
* Middleware system
* Dynamic routing
* Template system
* Hot reloading

---

## 🛠️ Philosophy

NimHTTP is intentionally minimal. It avoids abstraction-heavy patterns in favor of:

* Explicit routing
* Simple data structures
* Full control over responses

---

## 📄 License

MIT

---

## ❤️ Contributing

Feel free to fork and expand — this project is a solid base for experimenting with Nim web servers.
