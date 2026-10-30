import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // dibuat otomatis oleh `flutterfire configure`
import 'repositories/auth_repository.dart';
import 'repositories/history_repository.dart';
import 'repositories/question_repository.dart';
import 'repositories/score_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'views/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repository (lapisan data)
        Provider(create: (_) => QuestionRepository()),
        Provider(create: (_) => HistoryRepository()),
        Provider(create: (_) => AuthRepository()),
        Provider(create: (_) => ScoreRepository()),
        // ViewModel level aplikasi
        ChangeNotifierProvider(
          create: (ctx) => AuthViewModel(ctx.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HomeViewModel(ctx.read<QuestionRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Quiz Pendidikan Agama Islam',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
        home: const AuthGate(),
      ),
    );
  }
}
