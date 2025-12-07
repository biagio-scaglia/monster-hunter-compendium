# Monster Hunter Compendium

Un'applicazione Flutter modulare e scalabile per esplorare il database completo di Monster Hunter World, sviluppata da **Biagio Scaglia**.

## 📱 Descrizione

Monster Hunter Compendium è un'app mobile completa che permette di consultare tutte le informazioni su mostri, armi, armature, oggetti, skill, location, eventi e molto altro dal mondo di Monster Hunter World. L'app utilizza l'API pubblica [mhw-db.com](https://mhw-db.com) per fornire dati sempre aggiornati.

## ✨ Caratteristiche

- 🎯 **Architettura Modulare**: Struttura pulita e scalabile con separazione delle responsabilità
- 🔄 **API Integration**: Integrazione completa con l'API mhw-db.com
- 📱 **Design Responsive**: Interfaccia utente ottimizzata per tutti i dispositivi
- 🎨 **UI Moderna**: Design moderno con Material Design
- ⚡ **Performance**: Caricamento ottimizzato delle immagini e caching intelligente
- 🌐 **Navigazione Intuitiva**: Hub centrale e navigazione tramite tab bar e drawer

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
    ├── theme/        # Tema dell'app
    └── widgets/      # Widget riutilizzabili
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

## 📦 Dipendenze Principali

- `http`: Per le chiamate API
- `flutter/material.dart`: Framework UI

## 🎨 Design

L'app utilizza un tema personalizzato con colori ispirati a Monster Hunter:
- Colore primario: Deep Orange
- Design Material Design 3
- Layout responsive con SafeArea
- Immagini ottimizzate con lazy loading

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

## 📝 API

L'app utilizza l'API pubblica [mhw-db.com](https://mhw-db.com):
- Base URL: `https://mhw-db.com`
- Documentazione: [mhw-db.com docs](https://docs.mhw-db.com)
- Supporto per query e proiezioni
- Dati in inglese (default)

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

_Schermate dell'applicazione (da aggiungere)_

---

⭐ Se ti piace questo progetto, lascia una stella!

