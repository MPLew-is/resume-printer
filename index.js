const puppeteer = require('puppeteer');

(async () => {
	const browser = await puppeteer.launch();
	const page = await browser.newPage();
	await page.goto('file:///' + process.cwd() + '/resume.html', {
		waitUntil: 'networkidle2'
	});
	await page.pdf({
		path: 'resume.pdf',
		margin: {
			left: "0.25in",
			right: "0.25in",
			top: "0.25in",
			bottom: "0.5in",
		},
		pageRanges: '1'
	});

	await browser.close();
})();
