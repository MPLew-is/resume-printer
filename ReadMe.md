# Resume Printer #

This repository contains a simple `Node.js` application designed to automate printing of an HTML resume to PDF (using the excellent [Puppeteer package](https://github.com/puppeteer/puppeteer)), along with a [`Makefile`](Makefile) so you can just run `make` and have your HTML resume printed automatically. I fully realize that this is pretty excessive, but I got extremely tired of having to launch a browser, load or refresh my resume, print it to PDF, and then open it in yet another program just to see if my formatting or content changes came out the way I wanted. I'm also an automation enthusiast, and this was a chance to exercise those muscles a little.

There's no reason you couldn't use this to print other things, but I've made some assumptions on formatting and number of pages that are really designed to


## Quick-start ##

If you have [`Homebrew`](https://brew.sh) installed (or are willing to have it installed for you), all you have to do is:

```sh
$ git clone https://github.com/mplew-is/resume-printer
$ cd resume-printer
$ cp /path/to/resume.html [/path/to/resume.css] Sources/
$ make open
```

The `Makefile` is set up to automatically:
1. Install Homebrew if it is not installed
2. Install Node through Homebrew if not installed
3. Install the Node dependencies needed
4. Print your resume to PDF
	- **Note that it is assumed your resume is named `resume.html`, see [`Advanced usage`](#advanced-usage) below for other options**
5. Open your resume in your OS-configured PDF viewer


## Advanced usage ##

The above quick-start is great just to make sure everything works, but the real value of having an HTML resume to me is to be able to source-control it, and in order to do that using the prescribed `Sources` directory above, you'd have to fork this repository and make your changes - which you can absolutely do, but I also don't want to force you to do that if there's a better option.

To that end, this repository is designed to be used as a [git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) in a sub-directory of your actual resume source. [A sample Makefile](sample.mk) is provided to allow you to easily configure printing from a different directory than the standalone defaults; the intent is that you copy this file into the "supermodule" containing your resume, customize it with your actual parameters, and then can run `make open` as before.

That is, you can run the following from your resume repository:
```sh
$ git submodule add https://github.com/mplew-is/resume-printer
$ cp resume-printer/sample.mk ./Makefile
$ make open
```

The default configuration has your HTML file being `./resume.html` (relative to your `Makefile`) and will save to `./resume.pdf`, but those and a few more options are easily configurable. The following targets are exposed for convenience, and constitute the API for this build system (anything else that happens to be present is an implementation detail and is subject to change):

- `make [build]`: build your PDF to your configured location
- `make open`: open your built PDF with your OS-registered document viewer
- `make clean`: delete the built PDF


## Non-Homebrew dependencies ##

Personally I really like Homebrew (and it's gotten really good on Linux nowadays), so by default I assume you're willing to use it and make anything else opt-out. The good news is that it's really easy to do that: literally just install `node` (that is, have `npm` available on your `PATH` somewhere) via the method of your choosing, and none of the Homebrew installation steps will run.

The reason I did this is that I'm a big fan of [Zero Install](https://en.wikipedia.org/wiki/Zero_Install) and similar techniques that minimize user interaction with regards to dependency management and bootstrapping a new project. One of the most frustrating things I find is when the documentation on how to get started from scratch is either incomplete or outdated; by explicitly encoding the bootstrapping as part of the code, it means all of that is part of the project itself and much more likely to remain up-to-date.
