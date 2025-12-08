# Monster Hunter Compendium

Un'applicazione Flutter modulare e scalabile per esplorare il database completo di Monster Hunter World, sviluppata da **Biagio Scaglia**.

## 📱 Descrizione

Monster Hunter Compendium è un'app mobile completa che permette di consultare tutte le informazioni su mostri, armi, armature, oggetti, skill, location, eventi e molto altro dal mondo di Monster Hunter World. L'app utilizza l'API pubblica [mhw-db.com](https://mhw-db.com) per fornire dati sempre aggiornati.

## ✨ Caratteristiche

- 🎯 **Architettura Modulare**: Struttura pulita e scalabile con separazione delle responsabilità
- 🔄 **API Integration**: Integrazione completa con l'API mhw-db.com
- 📱 **Design Responsive**: Interfaccia utente ottimizzata per tutti i dispositivi
- 🎨 **UI Moderna**: Design moderno con Material Design 3 e tema personalizzato
- ⚡ **Performance**: Caricamento ottimizzato delle immagini e caching intelligente
- 🌐 **Navigazione Intuitiva**: Hub centrale e navigazione tramite tab bar e drawer
- 🌓 **Dark/Light Mode**: Supporto completo per tema chiaro e scuro
- 🎭 **Animazioni Fluide**: Transizioni animate tra schermate e micro-interazioni
- 🎨 **Componenti Modulari**: Card con gradienti, badge rari, shimmer loader e molto altro

## 🎨 Design System

### Palette Colori

- **Primario**: Deep Orange (#FF5722)
- **Secondario**: Dark Brown (#3E2723)
- **Accent/Highlight**: Verde Acido (#AEEA00)
- **Background Chiaro**: Beige (#FFF8E1)
- **Background Scuro**: Dark Grey (#212121)
- **Testo Principale**: Bianco (#FFFFFF)
- **Testo Secondario**: Light Grey (#B0BEC5)
- **Bottoni Primari**: Gradient da Deep Orange a Dark Orange (#FF5722 → #E64A19)
- **Alert/Error**: Red (#D32F2F)
- **Success**: Green (#388E3C)
- **Info**: Blue (#1976D2)

### Font

- **Titoli**: Font di sistema (bold)
- **Body Text**: Roboto (regular)
- **Bottoni e Badge**: Roboto Condensed (bold)

### Componenti UI

L'app include componenti modulari riutilizzabili:

- **GradientCard**: Card con gradienti, animazioni scale e supporto per item rari
- **ShimmerLoader**: Placeholder shimmer per stati di caricamento
- **RareBadge**: Badge con gradient e glow effect per item rari
- **GradientButton**: Bottoni con gradient e haptic feedback
- **FadeInImageWidget**: Immagini con fade-in e cache automatica
- **SlidableListItem**: Item con azioni swipe per azioni rapide

### Animazioni

- **SharedAxisTransition**: Transizioni animate tra schermate principali
- **Fade-in**: Per immagini e dati caricati dall'API
- **Scale-up**: Animazione per card quando cliccate
- **Swipe-to-refresh**: Per aggiornare le liste
- **Haptic Feedback**: Feedback tattile su interazioni principali

## 📚 Contenuti Disponibili

L'app include informazioni complete su:

- **Mostri**: Lista completa di tutti i mostri con dettagli su tipo, specie, debolezze e ricompense
- **Armi**: Tutte le armi disponibili con statistiche, elementi e crafting
- **Armature**: Armature individuali e set completi con bonus
- **Oggetti**: Consumabili, materiali e oggetti vari
- **Skill**: Tutte le skill disponibili con descrizioni e livelli
- **Location**: Tutte le location del gioco con informazioni sui campi
- **Charms**: Amuleti equipaggiabili con i loro effetti
- **Decorations**: Gemme per le skill
- **Eventi**: Eventi in-game con date e requisiti

## 🏗️ Architettura

L'applicazione segue un'architettura modulare ben strutturata:

```
lib/
├── core/              # Configurazione core dell'app
│   ├── app/          # MaterialApp e configurazione principale
│   └── constants/    # Costanti API e configurazioni
├── features/         # Moduli feature-based
│   ├── monsters/    # Feature mostri
│   ├── weapons/      # Feature armi
│   ├── armor/        # Feature armature
│   ├── items/        # Feature oggetti
│   ├── skills/       # Feature skill
│   ├── locations/    # Feature location
│   ├── armor_sets/   # Feature set armature
│   ├── charms/       # Feature charms
│   ├── decorations/  # Feature decorations
│   ├── events/       # Feature eventi
│   ├── home/         # Home page
│   ├── hub/          # Hub centrale
│   ├── info/         # Pagina informazioni
│   └── navigation/   # Navigazione principale
└── shared/           # Componenti condivisi
    ├── theme/        # Tema dell'app (light/dark)
    └── widgets/      # Widget riutilizzabili
        ├── gradient_card.dart
        ├── shimmer_loader.dart
        ├── rare_badge.dart
        ├── gradient_button.dart
        ├── fade_in_image_widget.dart
        └── slidable_list_item.dart
```

Ogni feature contiene:
- `data/`: Modelli e repository per la gestione dei dati
- `presentation/`: Provider, pagine e widget UI

## 🚀 Getting Started

### Prerequisiti

- Flutter SDK (ultima versione stabile)
- Dart SDK
- Un editor di codice (VS Code, Android Studio, ecc.)

### Installazione

1. Clona il repository:
```bash
git clone https://github.com/biagio-scaglia/monster-hunter-compendium.git
cd monster-hunter-compendium
```

2. Installa le dipendenze:
```bash
flutter pub get
```

3. Esegui l'app:
```bash
flutter run
```

### Eseguire con Chrome in modalità sviluppo (per risolvere problemi CORS)

Per risolvere problemi di CORS durante lo sviluppo, puoi usare Chrome con flag personalizzati:

**Opzione 1: Script batch (Windows)**
```bash
run_chrome_dev.bat
```

**Opzione 2: Script PowerShell (Windows)**
```powershell
.\run_chrome_dev.ps1
```

**Opzione 3: Comando manuale**
```bash
flutter run -d chrome --web-browser-flag="--disable-web-security" --web-browser-flag="--disable-gpu" --web-browser-flag="--user-data-dir=C:/ChromeDev"
```

**Opzione 4: VS Code**
Usa la configurazione "Flutter (Chrome Dev)" dal menu di debug (F5).

## 📦 Dipendenze Principali

- `http`: Per le chiamate API
- `google_fonts`: Font personalizzati (Roboto, Roboto Condensed)
- `shimmer`: Placeholder shimmer per loading states
- `cached_network_image`: Cache intelligente per immagini
- `flutter_slidable`: Azioni swipe per liste
- `photo_view`: Zoom immagini e mappe SVG
- `animations`: Transizioni animate tra schermate
- `flutter_haptic_feedback`: Feedback tattile
- `shared_preferences`: Salvataggio preferenze (tema, ecc.)
- `provider`: State management
- `flutter_svg`: Supporto per immagini SVG

## 🎨 Componenti UI

### GradientCard

Card modulare con gradienti, animazioni e supporto per item rari:

```dart
GradientCard(
  isRare: true, // Aggiunge glow effect
  onTap: () {
    // Navigazione
  },
  child: Column(
    children: [
      Text('Titolo', style: AppTheme.cardTitleStyle),
      Text('Descrizione', style: AppTheme.cardBodyStyle),
    ],
  ),
)
```

### ShimmerLoader

Placeholder shimmer per stati di caricamento:

```dart
if (isLoading)
  ShimmerList(itemCount: 5)
else
  // Contenuto reale
```

### RareBadge

Badge per item rari con gradient e glow:

```dart
RareBadge(
  text: 'RARE',
  withGlow: true,
)
```

### GradientButton

Bottoni con gradient e haptic feedback automatico:

```dart
GradientButton(
  text: 'Clicca qui',
  icon: Icons.star,
  isFullWidth: true,
  onPressed: () {
    // Azione
  },
)
```

## 🔧 Sviluppo

### Struttura del Codice

- **Modelli**: Classi dati per rappresentare le entità
- **Repository**: Gestione delle chiamate API
- **Provider**: State management con ChangeNotifier
- **Pagine**: UI delle schermate principali e di dettaglio

### Best Practices

- Codice modulare e scalabile
- Naming conventions chiare
- Gestione errori completa
- Loading states per tutte le operazioni asincrone
- Componenti UI riutilizzabili e modulari
- Supporto dark/light mode integrato

## 📝 API

L'app utilizza l'API pubblica [mhw-db.com](https://mhw-db.com):
- Base URL: `https://mhw-db.com`
- Documentazione: [mhw-db.com docs](https://docs.mhw-db.com)
- Supporto per query e proiezioni
- Dati in inglese (default)

## 🌓 Dark/Light Mode

L'app supporta automaticamente il tema chiaro e scuro:
- Toggle disponibile nel drawer di navigazione
- Preferenza salvata con `shared_preferences`
- Tutti i colori, font e gradienti si adattano automaticamente
- Componenti UI supportano entrambi i temi

## 🤝 Contribuire

Le contribuzioni sono benvenute! Per favore:

1. Fai un fork del progetto
2. Crea un branch per la tua feature (`git checkout -b feature/AmazingFeature`)
3. Commit delle modifiche (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Apri una Pull Request

## 📄 Licenza

Questo progetto è rilasciato sotto licenza MIT. Vedi il file `LICENSE` per maggiori dettagli.

## 👤 Autore

**Biagio Scaglia**

- GitHub: [@biagio-scaglia](https://github.com/biagio-scaglia)
- Repository: [monster-hunter-compendium](https://github.com/biagio-scaglia/monster-hunter-compendium)

## 🙏 Ringraziamenti

- [mhw-db.com](https://mhw-db.com) per l'API pubblica
- Capcom per Monster Hunter World
- La community di Monster Hunter

## 📱 Screenshots

![Mockup 1](assets/mockup/Screenshot%202025-12-08%20111110-portrait.png)
![Mockup 2](assets/mockup/Screenshot%202025-12-08%20111207-portrait.png)
![Mockup 3](assets/mockup/Screenshot%202025-12-08%20111238-portrait.png)
![Mockup 4](assets/mockup/Screenshot%202025-12-08%20111318-portrait.png)
![Mockup 5](assets/mockup/Screenshot%202025-12-08%20111341-portrait.png)

---

⭐ Se ti piace questo progetto, lascia una stella!
