class ApiConstants {
  static const String baseUrl = 'https://mhw-db.com';

  static const String monstersEndpoint = '/monsters';
  static const String weaponsEndpoint = '/weapons';
  static const String armorEndpoint = '/armor';
  static const String armorSetsEndpoint = '/armor/sets';
  static const String itemsEndpoint = '/items';
  static const String skillsEndpoint = '/skills';
  static const String ailmentsEndpoint = '/ailments';
  static const String charmsEndpoint = '/charms';
  static const String decorationsEndpoint = '/decorations';
  static const String eventsEndpoint = '/events';
  static const String locationsEndpoint = '/locations';
  static const String motionValuesEndpoint = '/motion-values';

  static String getMonsterById(int monsterId) {
    return '$monstersEndpoint/$monsterId';
  }

  static String getWeaponById(int weaponId) {
    return '$weaponsEndpoint/$weaponId';
  }

  static String getArmorById(int armorId) {
    return '$armorEndpoint/$armorId';
  }

  static String getArmorSetById(int setId) {
    return '$armorSetsEndpoint/$setId';
  }

  static String getItemById(int itemId) {
    return '$itemsEndpoint/$itemId';
  }

  static String getSkillById(int skillId) {
    return '$skillsEndpoint/$skillId';
  }

  static String getAilmentById(int ailmentId) {
    return '$ailmentsEndpoint/$ailmentId';
  }

  static String getCharmById(int charmId) {
    return '$charmsEndpoint/$charmId';
  }

  static String getDecorationById(int decorationId) {
    return '$decorationsEndpoint/$decorationId';
  }

  static String getEventById(int eventId) {
    return '$eventsEndpoint/$eventId';
  }

  static String getLocationById(int locationId) {
    return '$locationsEndpoint/$locationId';
  }

  static String getMotionValueById(int motionValueId) {
    return '$motionValuesEndpoint/$motionValueId';
  }

  static String getMotionValuesByWeaponType(String weaponType) {
    return '$motionValuesEndpoint/$weaponType';
  }

  /// Converte un URL relativo in un URL assoluto
  static String getAbsoluteImageUrl(String? relativeUrl) {
    if (relativeUrl == null || relativeUrl.isEmpty) return '';
    if (relativeUrl.startsWith('http://') || relativeUrl.startsWith('https://')) {
      return relativeUrl;
    }
    // Se inizia con /, aggiungi il baseUrl
    if (relativeUrl.startsWith('/')) {
      return baseUrl + relativeUrl;
    }
    // Altrimenti aggiungi / prima
    return baseUrl + '/' + relativeUrl;
  }
}

