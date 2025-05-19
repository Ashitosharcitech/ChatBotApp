String highlightImportantWords(String text) {
  final keywords = ['important', 'unique', 'value', 'key', 'highlight', 'note']; // Customize as needed

  for (var word in keywords) {
    final pattern = RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false);
    text = text.replaceAllMapped(pattern, (match) => '**${match[0]}**');
  }

  return text;
}