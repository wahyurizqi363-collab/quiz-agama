import 'package:flutter/material.dart';
import '../models/question.dart';

// Tambah / ubah soal di sini.
const List<Category> kCategories = [
  Category('Akidah', Icons.favorite, [
    Question(
      'Berapa jumlah rukun iman?',
      ['4', '5', '6', '7'],
      2,
      'Rukun iman ada 6: Allah, malaikat, kitab, rasul, hari akhir, dan qada & qadar.',
    ),
    Question(
      'Iman kepada kitab-kitab Allah merupakan rukun iman yang ke...',
      ['Pertama', 'Kedua', 'Ketiga', 'Keempat'],
      2,
      'Urutannya: 1) Allah, 2) Malaikat, 3) Kitab-kitab, 4) Rasul, 5) Hari akhir, 6) Qada & qadar.',
    ),
    Question(
      'Malaikat yang bertugas menyampaikan wahyu kepada para nabi adalah...',
      ['Mikail', 'Jibril', 'Israfil', 'Izrail'],
      1,
      'Malaikat Jibril bertugas menyampaikan wahyu dari Allah kepada para nabi dan rasul.',
    ),
    Question(
      'Tauhid yang meyakini bahwa Allah satu-satunya Pencipta dan Pengatur alam semesta disebut...',
      ['Tauhid Rububiyah', 'Tauhid Uluhiyah', 'Tauhid Asma wa Sifat', 'Tauhid Mulkiyah'],
      0,
      'Tauhid Rububiyah adalah mengesakan Allah dalam hal penciptaan, kepemilikan, dan pengaturan.',
    ),
  ]),
  Category('Ibadah', Icons.mosque, [
    Question(
      'Zakat merupakan rukun Islam yang ke...',
      ['Dua', 'Tiga', 'Empat', 'Lima'],
      1,
      'Urutannya: syahadat, shalat, zakat, puasa Ramadhan, haji.',
    ),
    Question(
      'Berapa jumlah shalat fardhu dalam sehari semalam?',
      ['3', '4', '5', '6'],
      2,
      'Shalat fardhu ada 5: Subuh, Zuhur, Asar, Magrib, dan Isya.',
    ),
    Question(
      'Manakah yang termasuk rukun wudhu?',
      ['Berkumur', 'Membasuh muka', 'Mengusap telinga', 'Mencuci telapak tangan'],
      1,
      'Membasuh muka adalah rukun wudhu. Berkumur, mengusap telinga, dan mencuci telapak tangan termasuk sunnah.',
    ),
    Question(
      'Zakat fitrah wajib ditunaikan paling lambat sebelum...',
      ['Awal Ramadhan', 'Shalat Idulfitri', 'Hari Arafah', 'Tahun baru Hijriah'],
      1,
      'Zakat fitrah dikeluarkan pada bulan Ramadhan dan paling lambat sebelum shalat Idulfitri.',
    ),
  ]),
  Category("Al-Qur'an & Hadis", Icons.menu_book, [
    Question(
      "Berapa jumlah surah dalam Al-Qur'an?",
      ['110', '112', '114', '116'],
      2,
      "Al-Qur'an terdiri dari 114 surah.",
    ),
    Question(
      "Surah pertama dalam susunan mushaf Al-Qur'an adalah...",
      ['Al-Baqarah', 'Al-Fatihah', 'An-Nas', 'Al-Ikhlas'],
      1,
      'Al-Fatihah adalah surah pembuka (Al-Fatihah = pembukaan).',
    ),
    Question(
      'Wahyu pertama yang diturunkan kepada Nabi Muhammad SAW adalah surah...',
      ["Al-'Alaq", 'Al-Muddassir', 'Al-Fatihah', 'Al-Baqarah'],
      0,
      "Wahyu pertama adalah Surah Al-'Alaq ayat 1-5 di Gua Hira.",
    ),
    Question(
      "Sumber hukum Islam yang kedua setelah Al-Qur'an adalah...",
      ['Ijmak', 'Qiyas', 'Hadis (Sunnah)', 'Ijtihad'],
      2,
      "Urutan sumber hukum: Al-Qur'an, Hadis/Sunnah, Ijmak, lalu Qiyas.",
    ),
  ]),
  Category('Sejarah & Akhlak', Icons.history_edu, [
    Question(
      'Nabi Muhammad SAW dilahirkan di kota...',
      ['Madinah', 'Makkah', 'Taif', 'Yaman'],
      1,
      'Nabi Muhammad SAW lahir di Makkah pada tahun Gajah.',
    ),
    Question(
      'Nabi Muhammad SAW berhijrah dari Makkah menuju...',
      ['Habasyah', 'Taif', 'Madinah (Yatsrib)', 'Syam'],
      2,
      'Hijrah ke Madinah (dahulu Yatsrib) menjadi awal tahun Hijriah.',
    ),
    Question(
      'Khalifah pertama dalam Khulafaur Rasyidin adalah...',
      ['Umar bin Khattab', 'Utsman bin Affan', 'Ali bin Abi Thalib', 'Abu Bakar ash-Shiddiq'],
      3,
      'Urutannya: Abu Bakar, Umar, Utsman, lalu Ali radhiyallahu anhum.',
    ),
    Question(
      'Sifat wajib rasul "Tabligh" artinya...',
      ['Jujur', 'Dapat dipercaya', 'Menyampaikan', 'Cerdas'],
      2,
      'Shiddiq = jujur, Amanah = dapat dipercaya, Tabligh = menyampaikan, Fathanah = cerdas.',
    ),
  ]),
];
