class Exceptions {
  static String goster(String hataKodu) {
    switch (hataKodu) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "Bu mail adresi zaten kullanımda, lütfen farklı bir mail kullanınız";

      case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
        return "Bu e-posta ile ilişkili bir hesap bulunmaktadır.";

      case 'ERROR_USER_NOT_FOUND':
        return "Bu kullanıcı sistemde bulunmamaktadır. Lütfen önce kullanıcı oluşturunuz";

      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return "Facebook hesabınızdaki mail adresi daha önce gmail veya email yöntemi ile sisteme kaydedilmiştir. Lütfen bu mail adresi ile giriş yapın";

      case "ERROR_NETWORK_REQUEST_FAILED":
        return "İnternet bağlantınızı kontrol edin";

      case "ERROR_WRONG_PASSWORD":
        return "Yanlış şifre";

      case "wrong-password":
        return "Yanlış şifre";

      case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
        return "Lütfen girdiğin şifreyi kontrol et";

      case "user-not-found":
        return "Bu e-posta ile kayıtlı bir kullanıcı bulunamamaktadır.";

      case "email-already-in-use":
        return "Bu mail adresi zaten kullanımda, lütfen farklı bir mail kullanınız";

      case "Instance of 'Response'":
        return "Bu mail adresi zaten kullanımda olabilir, lütfen farklı bir mail kullanınız";

      case 'PERMISSION_NOT_GRANTED':
        return "Barkodu okutmak için kamera izni vermeniz gerekiyor";

      case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
        return "Bu e-posta ile kayıtlı bir kullanıcı bulunamamaktadır.";

      case "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or"
          " unreachable host) has occurred.":
        return "İnternet bağlantın olmadan seninle buluşamayız!";

      case "Connection failed":
        return "İnternet bağlantın olmadan seninle buluşamayız!";

      case "Exception: The request failed because it wasn't able to reach the ipify service. This is most likely due to a networking error of some sort.":
        return "İnternet bağlantın olmadan seninle buluşamayız!";

      case "Exception: Kullanıcı bilgisine erişilemedi":
        return "Kullanıcı bilgisine erişilemedi";

      case "Exception: Mağaza çalışma saaatleri dışında":
        return "Mağaza çalışma saaatleri dışında olabilir";

      default:
        return "Bir hata oluştu $hataKodu";
    }
  }
}
