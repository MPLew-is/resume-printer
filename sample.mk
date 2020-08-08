# This file is designed to be copied into your source tree for use as your primary Makefile after configuring the below variables.
# The `include` at the bottom of this file provides the following targets, which execute based on your configuration.
# - `make [build]`: build your PDF to your configured location
# - `make open`: open your built PDF with your OS-registered document viewer
# - `make clean`: delete the built PDF

# This is the output filename that you want for the PDF.
# Any spaces should be escaped with backslashes (not quotes) due to differences in how make handles quotes when in a target definition versus its component rules.
PDF_FILENAME     := resume.pdf

# This is the directory containing your HTML and CSS sources (it will be recursively traversed with `find` and used in determining whether your PDF should be rebuilt, so make this a subdirectory if you have other `.html` and `.css` files that aren't a part of your resume in this repository).
# If this has spaces, they need to be escaped with backslashes due to the same reasons as `PDF_FILENAME` above.
SOURCE_DIRECTORY := .

# This is the "main" HTML file you want to be printed.
HTML_ENTRYPOINT  := ${SOURCE_DIRECTORY}/resume.html

# This is the directory you want the PDF to be written to, defaulting to the current one for simplicitly.
# If this has spaces, they need to be escaped with backslashes due to the same reasons as `PDF_FILENAME` above.
BUILD_DIRECTORY  := .

# This is the path to the directory containing the [`resume-printer`](https://github.com/mplew-is/resume-printer) submodule.
# Change this if you have the submodule as a different name or in a subdirectory.
RESUME_PRINTER   := resume-printer


# Include the actual functionality in a stub to not complicate this file (which will end up in your source tree and potentially be difficult to update from the submodule version if just copied here).
# You should **not** change this line unless you really know what you're doing.
include ${RESUME_PRINTER}/user-include.mk
