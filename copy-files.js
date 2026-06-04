import fs from 'fs';
['app', 'portal', 'dealer-signup', 'reset-password'].forEach(f => {
  try {
    fs.copyFileSync('public/' + f + '.html', 'dist/' + f + '.html');
    console.log('Copied ' + f + '.html');
  } catch(e) {
    console.log('Skipped ' + f + '.html');
  }
});
