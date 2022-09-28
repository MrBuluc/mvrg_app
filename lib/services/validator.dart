class Validator {
  static String? nameControl(String? name) {
    name = name?.trim();
    RegExp regex = RegExp(
        "^[abcçdefgğhıijklmnoöprsştuüvyzqwxABCÇDEFGHIİJKLMNOÖPRSŞTUÜVYZQWX]+\$");
    if (!regex.hasMatch(name!)) {
      return "İsim numara veya boşluk içermemeli";
    } else {
      return null;
    }
  }

  static String? surnameControl(String? surname) {
    surname = surname?.trim();
    RegExp regex = RegExp(
        "^[abcçdefgğhıijklmnoöprsştuüvyzqwxABCÇDEFGHIİJKLMNOÖPRSŞTUÜVYZQWX]+\$");
    if (!regex.hasMatch(surname!)) {
      return "Soyisim numara veya boşluk içermemeli";
    } else {
      return null;
    }
  }

  static String? emailControl(String? email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email!)) {
      return "Geçersiz email";
    } else {
      return null;
    }
  }

  static String? passwordControl(String? password) {
    if (password!.length < 6) {
      return "En az 6 karakter gerekli";
    }
    return null;
  }

  static String? emptyControl(String? value, String emptyText) {
    if (value!.isEmpty) {
      return emptyText;
    }
    return null;
  }

  static String? listContainsControl(
      String? value, List<String> list, String containsText, String emptyText) {
    if (list.contains(value)) {
      return containsText;
    } else if (value!.isEmpty) {
      return emptyText;
    } else {
      return null;
    }
  }

  static String? checkPrice(String? value) {
    if (int.tryParse(value!) != null) {
      if (int.parse(value) <= 0) {
        return "Lütfen 0 dan büyük bir değer giriniz";
      }
      return null;
    } else {
      return "Lütfen token mikarını belirtecek bir tam sayı giriniz";
    }
  }
}
