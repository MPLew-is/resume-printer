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
			top: "0.25in",
			right: "0.25in",
			bottom: "0.25in",
			left: "0.25in",
		}
	});

	await browser.close();
})();
