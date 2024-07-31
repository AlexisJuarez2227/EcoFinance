import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/page/dashboard_asesor.dart'; // Eliminar el duplicado si ya está importado arriba
import 'package:flutter_application_1/src/page/inworking_view.dart';
import 'package:flutter_application_1/src/page/welcome_view.dart';
import 'package:flutter_application_1/src/page/login_view.dart';
import 'package:flutter_application_1/src/page/register_view.dart';
import 'package:flutter_application_1/src/page/dashboard_view.dart';
import 'package:flutter_application_1/src/page/day_view.dart';
import 'package:flutter_application_1/src/page/week_view.dart';
import 'package:flutter_application_1/src/page/month_view.dart';
import 'package:flutter_application_1/src/page/financial_advisors_view.dart';
import 'package:flutter_application_1/src/page/dashboard_arguments.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoFinance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/dashboard':
            final args = settings.arguments as DashboardArguments?;
            return MaterialPageRoute(
              builder: (context) => DashboardView(args: args),
            );
          // Puedes añadir más casos aquí si necesitas manejar rutas dinámicas adicionales
          default:
            return MaterialPageRoute(
              builder: (context) => const WelcomeView(),
            );
        }
      },
      routes: {
        '/': (context) => const WelcomeView(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/dayView': (context) => const DayView(),
        '/weekView': (context) => const WeekView(),
        '/monthView': (context) => const MonthView(),
        '/financialAdvisors': (context) => const FinancialAdvisorsView(),
        '/inworking': (context) => const UnderConstructionView(),
        '/homeAsesor': (context) => const DashboardAsesorView(),
      },
    );
  }
}
