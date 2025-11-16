import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _translations = {
    'ar': {
      'appTitle': 'SOTKonya — تجمع طلابي في قونية',
      'visitor': 'زائر',
      'user': 'مستخدم',
      'admin': 'إداري',
      'createAccount': 'إنشاء حساب',
      'news': 'الأخبار',
      'events': 'الفعاليات',
      'forum': 'المنتدى',
      'housing': 'السكنات الطلابية',
      'gallery': 'المعرض',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'adminPanel': 'لوحة تحكم الإدارة',
      'login': 'تسجيل الدخول',
      'logout': 'تسجيل الخروج',
      'language': 'اللغة',
      'theme': 'الوضع الليلي',
      'male': 'ذكر',
      'female': 'أنثى',
      'home': 'الرئيسية',
      'startBrowsing': 'ابدأ التصفح',
      'visitorWelcome': 'مرحبًا بك في SOTKonya!\nيمكنك تصفح الأخبار والفعاليات والخدمات الطلابية كزائر.\nللمشاركة الكاملة، يرجى تسجيل الدخول أو الانتساب.',
    },
    'tr': {
      'appTitle': 'SOTKonya — Konya Öğrenci Topluluğu',
      'visitor': 'Ziyaretçi',
      'user': 'Üye',
      'admin': 'Yönetici',
      'createAccount': 'Hesap Oluştur',
      'news': 'Haberler',
      'events': 'Etkinlikler',
      'forum': 'Forum',
      'housing': 'Öğrenci Yurtları',
      'gallery': 'Galeri',
      'profile': 'Profil',
      'settings': 'Ayarlar',
      'adminPanel': 'Yönetici Paneli',
      'login': 'Giriş Yap',
      'logout': 'Çıkış Yap',
      'language': 'Dil',
      'theme': 'Karanlık Mod',
      'male': 'Erkek',
      'female': 'Kadın',
      'home': 'Anasayfa',
      'startBrowsing': 'Gözatmaya Başla',
      'visitorWelcome': 'SOTKonya\'ya hoş geldiniz!\nHaberleri, etkinlikleri ve öğrenci hizmetlerini ziyaretçi olarak görüntüleyebilirsiniz.\nTam katılım için lütfen giriş yapın veya üye olun.',
    }
  };

  String t(String key) {
    final lang = locale.languageCode;
    return _translations[lang]?[key] ?? _translations['ar']![key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'tr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
