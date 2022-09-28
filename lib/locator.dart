import 'package:get_it/get_it.dart';
import 'package:mvrg_app/services/http_service.dart';
import 'package:mvrg_app/services/token_service.dart';

import 'repository/user_repository.dart';
import 'services/firebase/firebase_auth_service.dart';
import 'services/firebase/firebase_storage_service.dart';
import 'services/firebase/firestore_service.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => HttpService());
  locator.registerLazySingleton(() => TokenService());
}
