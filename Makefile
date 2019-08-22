default: buildAndOpen

buildAndOpen: build open


build: resume.pdf

resume.pdf:
	@npm start --silent


open: | resume.pdf
	@open resume.pdf
