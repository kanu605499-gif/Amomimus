import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace import
    content = content.replace(
        "import 'package:amomimus/language/language_manager.dart';",
        "import 'package:amomimus/i18n/strings.g.dart';"
    )

    # Replace context.read<LanguageManager>().getString('key') -> Translations.of(context).key
    pattern = re.compile(r'context\.(?:read|watch)<LanguageManager>\(\)\.getString\([\'"](.*?)[\'"]\)')
    content = pattern.sub(r'Translations.of(context).\1', content)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f'Processed {filepath}')

process_file('lib/widgets/feed/feed_post_card.dart')
process_file('lib/widgets/feed/comment_bottom_sheet.dart')
