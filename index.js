const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('file:///' + process.cwd() + '/resume.html', {waitUntil: 'networkidle2'});
  await page.pdf({path: 'resume.pdf'});

  await browser.close();
})();
