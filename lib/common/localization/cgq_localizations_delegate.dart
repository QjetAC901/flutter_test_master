import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'default_localizations.dart';

/// 多语言代理

class CGQLocalizationsDelegate extends LocalizationsDelegate<CGQLocalizations> {

  CGQLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    ///支持中文和英语
    return ['en', 'zh'].contains(locale.languageCode);
  }

  ///根据locale，创建一个对象用于提供当前locale下的文本显示
  @override
  Future<CGQLocalizations> load(Locale locale) {
    return new SynchronousFuture<CGQLocalizations>(new CGQLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<CGQLocalizations> old) {
    return false;
  }

  ///全局静态的代理
  static CGQLocalizationsDelegate delegate = new CGQLocalizationsDelegate();
}
