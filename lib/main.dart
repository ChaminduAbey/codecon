import 'package:client_app/screens/splash_screen.dart';
import 'package:client_app/services/projects_service.dart';
import 'package:client_app/services/storage_service.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/services/http_service.dart';
import 'package:client_app/services/user_service.dart';
import 'package:client_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;
void main() {
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<AuthService>(() => AuthService(
        storageService: getIt(),
      ));
  getIt.registerLazySingleton<HttpService>(() => HttpService(
        authService: getIt(),
      ));

  getIt.registerLazySingleton<UserService>(() => UserService(
        httpService: getIt(),
        authService: getIt(),
      ));
  getIt.registerLazySingleton<ProjectService>(() => ProjectService(
        httpService: getIt(),
      ));

  runApp(MultiProvider(providers: [
    Provider<UserService>(
      create: (_) => getIt<UserService>(),
    ),
    ChangeNotifierProvider<ProjectService>(
      create: (_) => getIt<ProjectService>(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GovTrack LK',
      theme: ThemeData(
          colorSchemeSeed: primaryColor,
          appBarTheme: const AppBarTheme(
            scrolledUnderElevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          )),
          useMaterial3: true,
          textTheme: GoogleFonts.ralewayTextTheme()),
      home: const SplashScreen(),
    );
  }
}
