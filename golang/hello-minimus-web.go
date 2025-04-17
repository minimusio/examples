package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	// Define the port to listen on, default to 8080
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Set up the HTTP routes
	http.HandleFunc("/", handleRoot)
	http.HandleFunc("/hello", handleHello)
	http.HandleFunc("/about", handleAbout)
	http.HandleFunc("/contact", handleContact)

	// Start the server
	log.Printf("Server starting on port %s...\n", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}

// Handler for the root path
func handleRoot(w http.ResponseWriter, r *http.Request) {
	// Only respond to exact root path
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return
	}

	w.Header().Set("Content-Type", "text/html")
	fmt.Fprintf(w, `
		<html>
		<head>
			<title>Go Minimus HTTP Server</title>
			<style>
				body {
					font-family: Arial, sans-serif;
					line-height: 1.6;
					max-width: 800px;
					margin: 0 auto;
					padding: 20px;
				}
				h1 {
					color: #333;
				}
				nav {
					margin: 20px 0;
				}
				nav a {
					margin-right: 15px;
					color: #0066cc;
					text-decoration: none;
				}
				nav a:hover {
					text-decoration: underline;
				}
			</style>
		</head>
		<body>
			<h1>Welcome to Minimus Go Server</h1>
			<p>This is a simple Minimus HTTP server written in Go that displays different messages based on the URI.</p>
			<nav>
				<a href="/">Home</a>
				<a href="/hello">Hello</a>
				<a href="/about">About</a>
				<a href="/contact">Contact</a>
			</nav>
			<p>Click on the links above to see different messages.</p>
		</body>
		</html>
	`)
}

// Handler for the /hello path
func handleHello(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html")
	fmt.Fprintf(w, `
		<html>
		<head>
			<title>Hello from Minimus</title>
			<style>
				body {
					font-family: Arial, sans-serif;
					line-height: 1.6;
					max-width: 800px;
					margin: 0 auto;
					padding: 20px;
					background-color: #f0f8ff;
				}
				h1 {
					color: #0066cc;
				}
				a {
					color: #0066cc;
					text-decoration: none;
				}
				a:hover {
					text-decoration: underline;
				}
			</style>
		</head>
		<body>
			<h1>Hello, visitor!</h1>
			<p>Thank you for visiting the hello page of Minimus Go HTTP server.</p>
			<p><a href="/">Return to Home</a></p>
		</body>
		</html>
	`)
}

// Handler for the /about path
func handleAbout(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html")
	fmt.Fprintf(w, `
		<html>
		<head>
			<title>About Minimus</title>
			<style>
				body {
					font-family: Arial, sans-serif;
					line-height: 1.6;
					max-width: 800px;
					margin: 0 auto;
					padding: 20px;
					background-color: #f5f5f5;
				}
				h1 {
					color: #333;
				}
				a {
					color: #0066cc;
					text-decoration: none;
				}
				a:hover {
					text-decoration: underline;
				}
			</style>
		</head>
		<body>
			<h1>About Minimus</h1>
			<p>This is a simple demonstration of a Minimus Go HTTP server that displays different content based on the requested URI path.</p>
			<p>Built with Minimus secure images.</p>
			<p><a href="/">Return to Home</a></p>
		</body>
		</html>
	`)
}

// Handler for the /contact path
func handleContact(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html")
	fmt.Fprintf(w, `
		<html>
		<head>
			<title>Contact Minimus</title>
			<style>
				body {
					font-family: Arial, sans-serif;
					line-height: 1.6;
					max-width: 800px;
					margin: 0 auto;
					padding: 20px;
					background-color: #f0fff0;
				}
				h1 {
					color: #2e8b57;
				}
				a {
					color: #0066cc;
					text-decoration: none;
				}
				a:hover {
					text-decoration: underline;
				}
			</style>
		</head>
		<body>
			<h1>Contact Information</h1>
			<p>This is a demo application. For more information:</p>
			<ul>
				<li>Email: support@minimus.com</li>
				<li>GitHub: github.com/example/go-http-demo</li>
			</ul>
			<p><a href="/">Return to Home</a></p>
		</body>
		</html>
	`)
}