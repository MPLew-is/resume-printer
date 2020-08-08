# Default to building the PDF.
.PHONY: default
default: build


# Set some variables for locations of dependencies, providing defaults if not found.
# This allows an existing installation to be re-used without attempting to install via Homebrew, but still provides a non-empty value (that won't exist) if the dependency isn't available, which allows for rules to install the dependencies (`make` ignores empty-string dependencies).
# Note that a recursively-expanded variable is used here (`=`) to only actually shell out when needed.
BREW = $(shell which brew || echo "/usr/local/bin/brew")
NPM  = $(shell which npm  || echo "/usr/local/bin/npm")

# Determine which OS-specific command to use to open the resulting PDF.
# Note that spaces are used below instead of tabs to force `make` to treat the line as a variable definition, rather than rules to build a target.
ifeq ($(shell uname), Linux)
    OPEN = xdg-open
else
    OPEN = open
endif


# Centralize some common definitions.
BUILD_DIRECTORY          := .build
NPM_INSTALLATION_RECEIPT := ${BUILD_DIRECTORY}/package-lock.json

# Provide a shortcut target to install dependencies.
.PHONY: setup
setup: ${NPM_INSTALLATION_RECEIPT} Brewfile.lock.json

# Create the build directory.
${BUILD_DIRECTORY}:
	@mkdir -p "${@}"

# Install dependencies from stored bundle file and create an installation "receipt" file.
# This file is separate from "package-lock.json" to force dependency installation at least once; otherwise, on a fresh clone of the repository the timestamps may all be the same and `make` will think everything is up to date.
# The content of this file is unimportant (only its existence and timestamp), but by reusing the contents of `package-lock.json` there's at least some evidence of what its purpose is.
${NPM_INSTALLATION_RECEIPT}: package-lock.json package.json | ${BUILD_DIRECTORY} ${NPM}
	@"${NPM}" install
	@cp -f "${<}" "${@}"
	@touch "${@}"


# Use Homebrew to install NPM.
# If you don't want to use Homebrew, make sure `npm` is either on your `PATH` or the location is provided via the `NPM` variable (`make NPM=/path/to/npm`).
${NPM}: Brewfile.lock.json

#
Brewfile.lock.json: Brewfile
	@"${BREW}" bundle

# Install Homebrew using external installation script, pulled directly from [Homebrew's homepage](https://brew.sh).
${BREW}:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"


# Centralize definition of the built PDF's filename, defaulting to your user account name.
# If you override this, ensure any spaces are escaped with backslashes; quotes are not sufficient as `make` interprets them differently whether they're in the target definition or the rules body.
PDF_FILENAME     := $(shell whoami).pdf
PDF_PATH         := ${BUILD_DIRECTORY}/${PDF_FILENAME}
PDF_PATH_ESCAPED := "${BUILD_DIRECTORY}"/${PDF_FILENAME}


# Provide a shortcut target to build the PDF.
.PHONY: build
build: ${PDF_PATH}

# Build the PDF using the node program.
${PDF_PATH}: resume.html resume.css index.js | ${BUILD_DIRECTORY}
	@"${NPM}" start --silent "${<}" ${PDF_PATH_ESCAPED}


# Open the PDF for viewing in the OS-registered viewer.
.PHONY: open
open: ${PDF_PATH}
	@"${OPEN}" ${PDF_PATH_ESCAPED}


# Clean up all built files.
.PHONY: clean
clean:
	@rm -rf "${BUILD_DIRECTORY}"
