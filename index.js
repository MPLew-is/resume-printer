/**
 * Print an input document to PDF at an input path, designed primarily to print an HTML resume to PDF.
 *
 * @author Mike Lewis <mike@mplew.is>
 * @date 2020-08-08
 *
 * This may seem a little excessive, but I got very tired of manually opening my resume in a browser and printing it to PDF; this way I can fully automate the process with a `Makefile` or similar.
 *
 * Arguments:
 * 1. Path to a document that can be opened and rendered by a Chromium instance (generally HTML)
 * 2. Output path that the PDF should be saved to
 *
 * Example usage:
 * ```sh
 * npm start resume.html resume.pdf
 * ```
 */

const puppeteer = require("puppeteer");
const singleLineLog = require("single-line-log");

// The first 2 arguments are "node" and the filename being run, so strip them off for ease of use.
const arguments = process.argv.slice(2);

// Launch a browser instance, load the document provided as the first argument, print it to PDF, and save it to the path provided in the second argument.
(async () => {
	singleLineLog.stderr("Launching Chromium instance (1/4)")
	const browser = await puppeteer.launch();
	const page = await browser.newPage();

	const document = arguments[0]
	singleLineLog.stderr(`Navigating to '${document}' (2/4)`)
	await page.goto(`file:///${process.cwd()}/${document}`, {
		waitUntil: "networkidle2"
	});

	const outputPath = arguments[1]
	singleLineLog.stderr(`Printing '${document}' to '${outputPath}' (3/4)`)

	/*
	This is designed to be a resume printer, so we assume some common formatting defaults:
	- Use 0.25-inch margins except for the bottom, as getting that close to the bottom edge tends to look strange when paired with the classic large and space-filled header on a resume that contains your name and contact information.
	- Only print the first page, cutting off everything else.

	To-do:
	- [ ] Make these configurable without editing the source, since this is designed to be used as a submodule.
	*/
	await page.pdf({
		path: outputPath,
		margin: {
			left: "0.25in",
			right: "0.25in",
			top: "0.25in",
			bottom: "0.5in",
		},
		pageRanges: "1"
	});

	singleLineLog.stderr("Closing Chromium instance (4/4)")
	await browser.close();

	// Log a newline to reset console to not affect future output.
	singleLineLog.stderr("")
})();
