import 'package:flutter/material.dart';
import 'package:lawlink_lawyer/pages/add_status.dart';
import 'package:lawlink_lawyer/pages/call_requests.dart';
import 'package:lawlink_lawyer/pages/case_requests.dart';
import 'package:lawlink_lawyer/pages/chat_history.dart';
import 'package:lawlink_lawyer/pages/chat_page.dart';
import 'package:lawlink_lawyer/pages/complete_profile.dart';
import 'package:lawlink_lawyer/pages/lawyer_home.dart';
import 'package:lawlink_lawyer/pages/login.dart';
import 'package:lawlink_lawyer/pages/main_home.dart';
import 'package:lawlink_lawyer/pages/manage_cases.dart';
import 'package:lawlink_lawyer/pages/open_case.dart';
import 'package:lawlink_lawyer/pages/signup.dart';
import 'package:lawlink_lawyer/pages/update_profile.dart';
import 'package:lawlink_lawyer/widgets/chatbot.dart';
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
        '/home':(context) => const LawyerHome(),
        '/complete_profile':(context) => const CompleteProfile(),
        '/chat_history':(context) => const ChatHistory(),
        '/chat_page':(context) => const ChatPage(),
        '/call_requests':(context) => const CallRequests(),
        '/case_requests':(context) => const CaseRequests(),
        '/update_profile':(context) => const UpdateProfile(),
        '/manage_cases':(context) => const ManageCases(),
        '/open_case':(context) => const OpenCase(),
        '/chatbot':(context) => const ChatBot(),
        '/add_status':(context) => const AddStatus()
      },

      initialRoute: initialRoute,
    );
  }
}