import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:isar/isar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';
import 'services/database_service.dart';
import 'services/auth_service.dart';
import 'services/backup_service.dart';
import 'providers/theme_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/constants.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final LocalAuthentication localAuth = LocalAuthentication();

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  const InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseService.initialize();
  
  // Initialize notifications
  await _initializeNotifications();
  
  // Set preferred orientations for mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const ProExpenseApp());
}

class ProExpenseApp extends StatelessWidget {
  const ProExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final settingsProvider = Provider.of<SettingsProvider>(context);
        
        return MaterialApp(
          title: 'Pro Expense Tracker',
          debugShowCheckedModeBanner: false,
          
          // Theme configuration
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: settingsProvider.themeMode,
          
          // Localizations for multi-language support
          localizationsDelegates: AppConstants.localizationsDelegates,
          supportedLocales: AppConstants.supportedLocales,
          
          // Initial route
          initialRoute: '/',
          
          // Route generation
          onGenerateRoute: AppConstants.generateRoute,
        );
      },
    );
  }
}
