import 'package:flutter/material.dart';

class VocabularyItem {
  String? id;
  TextEditingController termController;
  TextEditingController definitionController;
  String originalTerm;
  String originalDefinition;


  VocabularyItem({
    this.id,
    required this.termController,
    required this.definitionController,
    required this.originalTerm,
    required this.originalDefinition,
  });
}
