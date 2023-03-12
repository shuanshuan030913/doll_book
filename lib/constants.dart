import 'package:flutter/material.dart';
import 'models/detail_type_button.dart';

/// 狀態選項
final List<String> statusOptions = ['還在徵', '數調中', '已填單', '大貨中', '已回家'];

/// 列表篩選
final List<String> filterOptions = [
  '不限',
  '已回家',
  '大貨中',
  '已填單',
  '數調中',
  '還在徵',
  '已出清'
];

/// 金額明細選項
final List<DetailTypeButton> priceOptionsButton = [
  DetailTypeButton(
    icon: Icons.face,
    color: const Color.fromARGB(255, 255, 169, 119),
    text: '娃娃',
  ),
  DetailTypeButton(
    icon: Icons.checkroom,
    color: const Color.fromARGB(255, 241, 225, 132),
    text: '娃衣',
  ),
  DetailTypeButton(
    icon: Icons.auto_graph,
    color: const Color.fromARGB(255, 217, 154, 239),
    text: '加骨',
  ),
  DetailTypeButton(
    icon: Icons.pets,
    color: const Color.fromARGB(255, 125, 219, 192),
    text: '耳朵',
  ),
  DetailTypeButton(
    icon: Icons.nightlight,
    color: const Color.fromARGB(255, 129, 135, 243),
    text: '尾巴',
  ),
  DetailTypeButton(
    icon: Icons.cut,
    color: const Color.fromARGB(255, 161, 220, 133),
    text: '髮型',
  ),
  DetailTypeButton(
    icon: Icons.cake,
    color: const Color.fromARGB(255, 235, 136, 136),
    text: '出生證',
  ),
  DetailTypeButton(
    icon: Icons.redeem,
    color: const Color.fromARGB(255, 127, 184, 244),
    text: '特典',
  ),
  DetailTypeButton(
    icon: Icons.local_shipping,
    color: const Color.fromARGB(255, 123, 226, 244),
    text: '運費',
  ),
  DetailTypeButton(
    icon: Icons.add_reaction,
    color: const Color.fromARGB(255, 213, 213, 213),
    text: '其他',
  ),
];
