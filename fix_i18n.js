const fs = require('fs');
const files = ['en.i18n.json', 'id.i18n.json', 'th.i18n.json', 'tm.i18n.json', 'de.i18n.json', 'ja.i18n.json'];
const additions = {
  'en': {
    'presence_cooldown_hours': 'Your status change could be reset by next ${hours} hours',
    'presence_cooldown_minutes': 'Your status change could be reset by next ${minutes} minutes'
  },
  'id': {
    'presence_cooldown_hours': 'Perubahan status Anda dapat direset dalam ${hours} jam ke depan',
    'presence_cooldown_minutes': 'Perubahan status Anda dapat direset dalam ${minutes} menit ke depan'
  },
  'th': {
    'presence_cooldown_hours': '????????????????????????????????????????? ${hours} ???????????????',
    'presence_cooldown_minutes': '????????????????????????????????????????? ${minutes} ????????????'
  },
  'tm': {
    'presence_cooldown_hours': 'Status üýtgemäniz indiki ${hours} sagadyn dowamynda nol edilip bilner',
    'presence_cooldown_minutes': 'Status üýtgemäniz indiki ${minutes} minudyn dowamynda nol edilip bilner'
  },
  'de': {
    'presence_cooldown_hours': 'Ihre Statusänderung kann in den nächsten ${hours} Stunden zurückgesetzt werden',
    'presence_cooldown_minutes': 'Ihre Statusänderung kann in den nächsten ${minutes} Minuten zurückgesetzt werden'
  },
  'ja': {
    'presence_cooldown_hours': '??????????? ${hours} ????????????????????',
    'presence_cooldown_minutes': '??????????? ${minutes} ???????????????????'
  }
};
files.forEach(f => {
  const lang = f.split('.')[0];
  const path = 'lib/i18n/' + f;
  const data = JSON.parse(fs.readFileSync(path, 'utf8'));
  data['presence_cooldown_hours'] = additions[lang]['presence_cooldown_hours'];
  data['presence_cooldown_minutes'] = additions[lang]['presence_cooldown_minutes'];
  fs.writeFileSync(path, JSON.stringify(data, null, 2));
});
