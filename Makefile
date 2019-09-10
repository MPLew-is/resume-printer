.PHONY: default
default: build


.PHONY: setup
setup:
	@brew bundle


.PHONY: build
build: Michael\ P.\ Lewis,\ Jr.pdf

Michael\ P.\ Lewis,\ Jr.pdf: resume.html resume.css index.js
	@npm start --silent


.PHONY: open
open: | Michael\ P.\ Lewis,\ Jr.pdf
	@open "Michael P. Lewis, Jr.pdf"


.PHONY: clean
clean:
	@rm "Michael P. Lewis, Jr.pdf"
