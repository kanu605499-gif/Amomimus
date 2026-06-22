const fs = require('fs');
const path = require('path');
const dir = 'lib/i18n';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.json'));

files.forEach(f => {
    const p = path.join(dir, f);
    let content = fs.readFileSync(p, 'utf8');
    
    // Some corrupted strings in translations
    let originalLength = content.length;
    content = content.replace(/â€”/g, '-');
    content = content.replace(/â€“/g, '-');
    
    if (content.length !== originalLength || content !== fs.readFileSync(p, 'utf8')) {
        console.log('Fixed encoding issues in ' + f);
        fs.writeFileSync(p, content, 'utf8');
    }
});
