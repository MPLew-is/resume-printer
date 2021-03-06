# Default to building the PDF.
.PHONY: default
default: build


# Determine which command to use to open the resulting PDF and the Homebrew prefix path based on the OS being used.
# Note that spaces are used below instead of tabs to force `make` to treat the line as a variable definition, rather than rules to build a target.
ifeq ($(shell uname), Linux)
    OPEN        := xdg-open
    BREW_PREFIX := /home/linuxbrew/.linuxbrew/bin
else
    OPEN        := open
    BREW_PREFIX := /usr/local/bin
endif

# Set some variables for locations of dependencies, providing defaults if not found.
# This allows an existing installation to be re-used without attempting to install via Homebrew, but still provides a non-empty value (that won't exist) if the dependency isn't available, which allows for rules to install the dependencies (`make` ignores empty-string dependencies).
# Note that a recursively-expanded variable is used here (`=`) to only actually shell out when needed.
BREW = $(shell which brew || echo "${BREW_PREFIX}/brew")
NPM  = $(shell which npm  || echo "${BREW_PREFIX}/npm")


# Centralize some common definitions.
SETUP_DIRECTORY          := .build
BUILD_DIRECTORY          := ${SETUP_DIRECTORY}
NPM_INSTALLATION_RECEIPT := ${SETUP_DIRECTORY}/package-lock.json

# Provide a shortcut target to install dependencies.
.PHONY: setup
setup: ${NPM_INSTALLATION_RECEIPT} Brewfile.lock.json

# Create the build/setup directories.
# These are separate rules to allow a repository-internal directory for the installation receipt but still allow the built PDF to be redirected to another directory.
${BUILD_DIRECTORY} ${SETUP_DIRECTORY}:
	@mkdir -p "${@}"

# Install dependencies from stored bundle file and create an installation "receipt" file.
# This file is separate from "package-lock.json" to force dependency installation at least once; otherwise, on a fresh clone of the repository the timestamps may all be the same and `make` will think everything is up to date.
# The content of this file is unimportant (only its existence and timestamp), but by reusing the contents of `package-lock.json` there's at least some evidence of what its purpose is.
${NPM_INSTALLATION_RECEIPT}: package-lock.json package.json | ${SETUP_DIRECTORY} ${NPM}
	@"${NPM}" install
	@cp -f "${<}" "${@}"
	@touch "${@}"


# Use Homebrew to install NPM.
# If you don't want to use Homebrew, make sure `npm` is either on your `PATH` or the location is provided via the `NPM` variable (`make NPM=/path/to/npm`).
${NPM}: Brewfile.lock.json

# Generate the Homebrew lock file from the list of dependencies, which installs them.
Brewfile.lock.json: Brewfile
	@"${BREW}" bundle

# Install Homebrew using external installation script, pulled directly from [Homebrew's homepage](https://brew.sh).
${BREW}:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"


# Centralize definition of the built PDF's filename, defaulting to your user account name.
# If you override this, ensure any spaces are escaped with backslashes; quotes are not sufficient as `make` interprets them differently whether they're in the target definition or the rules body.
PDF_FILENAME      := $(shell whoami).pdf
PDF_PATH          := ${BUILD_DIRECTORY}/${PDF_FILENAME}

# Centralize definition of the source files for cleanliness and external overriding.
SOURCE_DIRECTORY  := Sources
SOURCE_FILES      := $(shell find "${SOURCE_DIRECTORY}" -name '*.html') $(shell find "${SOURCE_DIRECTORY}" -name '*.css')
HTML_ENTRYPOINT   := ${SOURCE_DIRECTORY}/resume.html

# Provide a shortcut target to build the PDF.
.PHONY: build
build: ${PDF_PATH}

# Build the PDF using the node program.
${PDF_PATH}: ${SOURCE_FILES} index.js ${NPM_INSTALLATION_RECEIPT} | ${BUILD_DIRECTORY}
	@"${NPM}" start --silent "${HTML_ENTRYPOINT}" ${PDF_PATH}


# Open the PDF for viewing in the OS-registered viewer.
.PHONY: open
open: ${PDF_PATH}
	@"${OPEN}" ${PDF_PATH}


# Clean up all built files.
.PHONY: clean
clean:
	@rm -rf "${BUILD_DIRECTORY}"
	@rm -rf "${SETUP_DIRECTORY}"
	@rm -rf node_modules
	@rm -f Brewfile.lock.json

