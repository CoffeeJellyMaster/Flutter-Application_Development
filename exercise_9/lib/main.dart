// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'providers/expense_provider.dart';
// import 'providers/login_provider.dart';
// import 'providers/accounts_provider.dart'; // Ensure this file exists
// import 'firebase_options.dart';
// import 'screens/accounts/account_landing.dart';
// import 'screens/accounts/sign_in.dart';
// import 'screens/accounts/sign_up.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     print("Initializing Firebase...");
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     print("Firebase initialized successfully!");
//   } catch (e) {
//     print("FIREBASE INIT ERROR: $e");
//   }
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AccountsProvider()),
//         ChangeNotifierProvider(create: (_) => LoginProvider()),
//         ChangeNotifierProvider(create: (_) => ExpenseListProvider()),
//         // Add other providers here if needed in the future
//       ],
//       child: MaterialApp(
//         title: 'Expense Tracker',
//         debugShowCheckedModeBanner: false, // Optional: remove debug banner
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         initialRoute: '/',
//         routes: {
//           '/': (context) => const AccountLandingPage(),
//           '/signin': (context) => const SignInPage(),
//           '/signup': (context) => const SignUpPage(),
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'providers/login_provider.dart';
import 'providers/accounts_provider.dart';
import 'firebase_options.dart';
import 'screens/accounts/account_landing.dart';
import 'screens/accounts/sign_in.dart';
import 'screens/accounts/sign_up.dart';
import 'screens/expenses/expenses_list.dart';
import 'api/login_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    print("Initializing Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully!");
  } catch (e) {
    print("FIREBASE INIT ERROR: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final loginApi = LoginAPI();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountsProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseListProvider()),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: loginApi.isUserLoggedIn() ? const ExpensesList() : const AccountLandingPage(),
        routes: {
          '/signin': (context) => const SignInPage(),
          '/signup': (context) => const SignUpPage(),
        },
      ),
    );
  }
}
