.PHONY: default
default: build


.PHONY: build
build: resume.pdf

resume.pdf:
	@npm start --silent


.PHONY: open
open: | resume.pdf
	@open resume.pdf
