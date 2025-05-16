import 'package:cloud_firestore/cloud_firestore.dart';

class BarberWalletModel {
  final String barberId;
  final double redeemed;
  final double lifetimeAmount;
  final Timestamp updated;

  BarberWalletModel({
    required this.barberId,
    required this.redeemed,
    required this.lifetimeAmount,
    required this.updated,
  });

  factory BarberWalletModel.fromMap(Map<String, dynamic> map) {
    return BarberWalletModel(
      barberId: map['barberId'] as String,
      redeemed: (map['redeemed'] ?? 0).toDouble(),
      lifetimeAmount: (map['lifetime_amount'] ?? 0).toDouble(),
      updated: map['updated'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'barberId': barberId,
      'redeemed': redeemed,
      'lifetime_amount': lifetimeAmount,
      'updated': updated,
    };
  }
}