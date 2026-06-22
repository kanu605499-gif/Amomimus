const fs = require('fs');
const path = require('path');

const dir = 'lib/i18n';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.json'));

for (const file of files) {
  const filePath = path.join(dir, file);
  let content = fs.readFileSync(filePath, 'utf8');
  
  // Convert {var} to ${var} for slang compatibility
  content = content.replace(/\{count\}/g, '${count}');
  content = content.replace(/\{tier\}/g, '${tier}');
  content = content.replace(/\{duration\}/g, '${duration}');
  content = content.replace(/\{actor\}/g, '${actor}');
  
  fs.writeFileSync(filePath, content, 'utf8');
}
console.log('Fixed JSON strings successfully.');
