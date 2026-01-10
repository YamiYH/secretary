// lib/models/service_model.dart
import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final String preacher;
  final String worshipMinister;

  ServiceModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.preacher,
    required this.worshipMinister,
  });
}
