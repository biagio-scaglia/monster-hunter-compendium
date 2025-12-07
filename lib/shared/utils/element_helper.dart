// Helper per gestire le emoji degli elementi
class ElementHelper {
  // Restituisce l'emoji per un elemento
  static String getElementEmoji(String element) {
    final elementLower = element.toLowerCase();
    
    switch (elementLower) {
      case 'fire':
        return '🔥';
      case 'water':
        return '💧';
      case 'thunder':
      case 'lightning':
        return '⚡';
      case 'ice':
        return '❄️';
      case 'dragon':
        return '🐉';
      case 'poison':
        return '☠️';
      case 'blast':
        return '💥';
      case 'sleep':
        return '😴';
      case 'paralysis':
        return '⚡';
      default:
        return '✨';
    }
  }
  
  // Restituisce il nome dell'elemento con emoji
  static String getElementWithEmoji(String element) {
    return '${getElementEmoji(element)} $element';
  }
  
  // Restituisce una lista di elementi con emoji
  static String getElementsWithEmoji(List<String> elements) {
    return elements.map((e) => getElementWithEmoji(e)).join(', ');
  }
}

