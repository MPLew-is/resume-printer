## This is intended to be included from the user's supermodule `Makefile` after setting all the needed variables, and is **not** intended to be used on its own.
## This exists only to keep as much functionality centralized and in sync if this repository gets updated; this way, as much functionality as possible is outside the user's source tree and in this one.

# Explicitly default to building the PDF.
.PHONY: default
default: build


# Centralize the definition of the full path to the PDF.
PDF_PATH                  := ${BUILD_DIRECTORY}/${PDF_FILENAME}

# Make the configured path variables absolute for submodule delegation.
PDF_PATH_ABSOLUTE         := ${CURDIR}/${PDF_PATH}
SOURCE_DIRECTORY_ABSOLUTE := ${CURDIR}/${SOURCE_DIRECTORY}
HTML_ENTRYPOINT_ABSOLUTE  := ${CURDIR}/${HTML_ENTRYPOINT}
BUILD_DIRECTORY_ABSOLUTE  := ${CURDIR}/${BUILD_DIRECTORY}

# Provide a shortcut target for building the PDF.
.PHONY: build
build: ${PDF_PATH}

# Make sure the build directory has been created.
${BUILD_DIRECTORY}:
	@mkdir -p "${BUILD_DIRECTORY}"

# Pass all the configuration to the submodule `Makefile` for actual execution.
${PDF_PATH}: | ${BUILD_DIRECTORY}
	@"${MAKE}" build \
		--directory="${RESUME_PRINTER}" \
		PDF_PATH="${PDF_PATH_ABSOLUTE}" \
		SOURCE_DIRECTORY="${SOURCE_DIRECTORY_ABSOLUTE}" \
		HTML_ENTRYPOINT="${HTML_ENTRYPOINT_ABSOLUTE}" \
		BUILD_DIRECTORY="${BUILD_DIRECTORY_ABSOLUTE}"


# Pass all the configuration to the submodule `Makefile` for actual execution.
.PHONY: open
open:
	@"${MAKE}" open \
		--directory="${RESUME_PRINTER}" \
		PDF_PATH="${PDF_PATH_ABSOLUTE}" \
		SOURCE_DIRECTORY="${SOURCE_DIRECTORY_ABSOLUTE}" \
		HTML_ENTRYPOINT="${HTML_ENTRYPOINT_ABSOLUTE}" \
		BUILD_DIRECTORY="${BUILD_DIRECTORY_ABSOLUTE}"


# Clean up the built PDF file.
# We **definitely** don't want to delegate to the submodule `clean`, since that'll delete everything in the current directory (including the submodule) in the default configuration.
.PHONY: clean
clean:
	@rm -f ${PDF_PATH}
