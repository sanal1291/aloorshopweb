import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AppLocalizations{
  final Locale locale;

  AppLocalizations({this.locale});

  static AppLocalizations of( BuildContext context){
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, String> _localizedValues;

  Future load() async {
    String jsonStringValues = await rootBundle.loadString('lib/Languages/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues = mappedJson.map((key, value) => MapEntry(key,value.toString()));
  }

  String getranslatedValue(String key){
    return _localizedValues[key];
  }
}


class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations>{
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
      return ['en', 'es', 'ml'].contains(locale.languageCode);
    }
  
    @override
    Future<AppLocalizations> load(Locale locale) async{
      AppLocalizations localizations = new AppLocalizations(locale: locale);
      await localizations.load();
      return localizations;
    }
  
    @override
    bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }

}