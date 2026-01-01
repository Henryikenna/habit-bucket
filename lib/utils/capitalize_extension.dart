extension StringExtension on String {
  String capitalize() {
    // Handle potential empty strings or strings with only spaces
    if (trim().isEmpty) {
      return '';
    }

    // Split the string into words based on spaces
    return split(' ')
        .map((word) {
          // For each word, capitalize its first letter and lowercase the rest
          if (word.isEmpty) return '';
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' '); // Join the capitalized words back together with a space
  }
}
