import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/constants.dart';
import 'screens/chat_screen.dart';
import 'package:untitled/provider/models_provider.dart';
import 'provider/chatProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ModelProvider(),),
        ChangeNotifierProvider(create: (_)=>ChatProvider(),)
      ],
      child: MaterialApp(
        title: 'CHAT GPT',
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: cardColor,
          ),
          useMaterial3: true,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}

