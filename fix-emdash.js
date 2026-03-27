const fs = require('fs');
let c = fs.readFileSync('index.html', 'utf8');
// Replace the corrupted em-dash 'â€";' with proper em-dash '—'
c = c.replace(/'â€";'/g, "'—'");
fs.writeFileSync('index.html', c);
console.log('Fixed em-dash');
