import 'package:flutter/material.dart';

// Helper per gestire le icone degli ailments
class AilmentHelper {
  // Restituisce l'icona appropriata per un ailment basandosi sul nome
  static IconData getAilmentIcon(String ailmentName) {
    final nameLower = ailmentName.toLowerCase();
    
    if (nameLower.contains('fire') || nameLower.contains('fireblight')) {
      return Icons.local_fire_department;
    } else if (nameLower.contains('water') || nameLower.contains('waterblight')) {
      return Icons.water_drop;
    } else if (nameLower.contains('thunder') || nameLower.contains('thunderblight')) {
      return Icons.bolt;
    } else if (nameLower.contains('ice') || nameLower.contains('iceblight')) {
      return Icons.ac_unit;
    } else if (nameLower.contains('dragon') || nameLower.contains('dragonblight')) {
      return Icons.auto_awesome;
    } else if (nameLower.contains('poison')) {
      return Icons.dangerous;
    } else if (nameLower.contains('blast') || nameLower.contains('blastblight')) {
      return Icons.whatshot;
    } else if (nameLower.contains('sleep')) {
      return Icons.bedtime;
    } else if (nameLower.contains('paralysis') || nameLower.contains('paralyze')) {
      return Icons.flash_off;
    } else if (nameLower.contains('stun')) {
      return Icons.radio_button_unchecked;
    } else if (nameLower.contains('bleeding') || nameLower.contains('bleed')) {
      return Icons.bloodtype_outlined;
    } else if (nameLower.contains('effluvial') || nameLower.contains('effluvia')) {
      return Icons.air;
    } else if (nameLower.contains('wind') || nameLower.contains('wind pressure')) {
      return Icons.air;
    } else if (nameLower.contains('defense down') || nameLower.contains('defense')) {
      return Icons.shield_outlined;
    } else if (nameLower.contains('muddy') || nameLower.contains('mud')) {
      return Icons.water;
    } else {
      // Default: warning icon
      return Icons.warning;
    }
  }
  
  // Restituisce il colore appropriato per un ailment
  static Color getAilmentColor(String ailmentName) {
    final nameLower = ailmentName.toLowerCase();
    
    if (nameLower.contains('fire') || nameLower.contains('fireblight')) {
      return Colors.red;
    } else if (nameLower.contains('water') || nameLower.contains('waterblight')) {
      return Colors.blue;
    } else if (nameLower.contains('thunder') || nameLower.contains('thunderblight')) {
      return Colors.yellow[700]!;
    } else if (nameLower.contains('ice') || nameLower.contains('iceblight')) {
      return Colors.lightBlue;
    } else if (nameLower.contains('dragon') || nameLower.contains('dragonblight')) {
      return Colors.purple;
    } else if (nameLower.contains('poison')) {
      return Colors.green[700]!;
    } else if (nameLower.contains('blast') || nameLower.contains('blastblight')) {
      return Colors.orange;
    } else if (nameLower.contains('sleep')) {
      return Colors.indigo;
    } else if (nameLower.contains('paralysis') || nameLower.contains('paralyze')) {
      return Colors.amber;
    } else if (nameLower.contains('stun')) {
      return Colors.orange[700]!;
    } else if (nameLower.contains('bleeding') || nameLower.contains('bleed')) {
      return Colors.red[800]!;
    } else if (nameLower.contains('effluvial') || nameLower.contains('effluvia')) {
      return Colors.brown;
    } else if (nameLower.contains('wind') || nameLower.contains('wind pressure')) {
      return Colors.grey;
    } else if (nameLower.contains('defense down') || nameLower.contains('defense')) {
      return Colors.blueGrey;
    } else if (nameLower.contains('muddy') || nameLower.contains('mud')) {
      return Colors.brown[700]!;
    } else {
      // Default: red
      return Colors.red;
    }
  }
}

