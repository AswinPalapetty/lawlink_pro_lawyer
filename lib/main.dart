import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/pages/login.dart';
import 'package:lawlink_lawyer/pages/main_home.dart';
import 'package:lawlink_lawyer/pages/signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lawlink_lawyer/utils/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: '${dotenv.env['SUPABASE_URL']}',
    anonKey: '${dotenv.env['SUPABASE_ANONKEY']}',
  );

  String initialRoute;
  final data = await SessionManagement.getUserData();
  if(data['name'] != ''){
    initialRoute = '/';
  }
  else{
    initialRoute = '/home';
  }
  
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LawLink Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      
      routes: {
        '/':(context) => const Home(),
        '/login':(context) => const Login(),
        '/signup':(context) => const Signup(),
      },

      initialRoute: initialRoute,
    );
  }
}