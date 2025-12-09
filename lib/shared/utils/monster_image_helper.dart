// Helper per gestire le immagini locali dei mostri
class MonsterImageHelper {
  // Mappa diretta dei nomi dei mostri ai nomi dei file
  static final Map<String, String> _monsterNameToFile = {
    'Anjanath': 'MHW-Anjanath_Background.png',
    'Azure Rathalos': 'MHW-Azure_Rathalos_Background.png',
    'Barroth': 'MHW-Barroth_Background.png',
    'Bazelgeuse': 'MHW-Bazelgeuse_Background.png',
    'Behemoth': 'MHW-Behemoth_Background.png',
    'Black Diablos': 'MHW-Black_Diablos_Background.png',
    'Deviljho': 'MHW-Deviljho_Background.png',
    'Diablos': 'MHW-Diablos_Background.png',
    'Dodogama': 'MHW-Dodogama_Background.png',
    'Great Girros': 'MHW-Great_Girros_Background.png',
    'Great Jagras': 'MHW-Great_Jagras_Background.png',
    'Jyuratodus': 'MHW-Jyuratodus_Background.png',
    'Kirin': 'MHW-Kirin_Background.png',
    'Kulu-Ya-Ku': 'MHW-Kulu-Ya-Ku_Background.png',
    'Kulve Taroth': 'MHW-Kulve_Taroth_Background.png',
    'Kushala Daora': 'MHW-Kushala_Daora_Background.png',
    'Lavasioth': 'MHW-Lavasioth_Background.png',
    'Legiana': 'MHW-Legiana_Background.png',
    'Nergigante': 'MHW-Nergigante_Background.png',
    'Odogaron': 'MHW-Odogaron_Background.png',
    'Paolumu': 'MHW-Paolumu_Background.png',
    'Pink Rathian': 'MHW-Pink_Rathian_Background.png',
    'Pukei-Pukei': 'MHW-Pukei-Pukei_Background.png',
    'Radobaan': 'MHW-Radobaan_Background.png',
    'Rathalos': 'MHW-Rathalos_Background.png',
    'Rathian': 'MHW-Rathian_Background.png',
    'Teostra': 'MHW-Teostra_Background.png',
    'Tobi-Kadachi': 'MHW-Tobi-Kadachi_Background.png',
    'Tzitzi-Ya-Ku': 'MHW-Tzitzi-Ya-Ku_Background.png',
    'Uragaan': 'MHW-Uragaan_Background.png',
    'Vaal Hazak': 'MHW-Vaal_Hazak_Background.png',
    "Xeno'jiiva": "MHW-Xeno'jiiva_Background.png",
    'Zorah Magdaros': 'MHW-Zorah_Magdaros_Background.png',
  };
  
  // Restituisce il path dell'asset locale per un mostro, se disponibile
  static String? getLocalMonsterImagePath(String monsterName) {
    final fileName = _monsterNameToFile[monsterName];
    if (fileName == null) {
      return null;
    }
    return 'assets/mostri/$fileName';
  }
  
  // Verifica se esiste un'immagine locale per un mostro
  static bool hasLocalImage(String monsterName) {
    return _monsterNameToFile.containsKey(monsterName);
  }
}

