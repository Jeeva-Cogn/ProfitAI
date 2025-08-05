import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'widgets/gradient_background.dart';
import 'widgets/glass_card.dart';
import 'widgets/motivational_quote.dart';
import 'widgets/walletflow_logo.dart';
import 'widgets/budget_progress.dart';
import 'widgets/category_pie_chart.dart';
import 'widgets/transaction_list.dart';
import 'widgets/category_insights_list.dart';
import 'widgets/ai_advisor_card.dart';
import 'widgets/profile_badges.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  runApp(const WalletFlowApp());
}

class WalletFlowApp extends StatelessWidget {
  const WalletFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WalletFlow',
      theme: walletFlowLightTheme,
      darkTheme: walletFlowDarkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    WelcomeScreen(),
    DashboardScreen(),
    TransactionsScreen(),
    CategoryInsightsScreen(),
    AIAdvisorScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.login), label: 'Welcome'),
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Transactions'),
          NavigationDestination(icon: Icon(Icons.category), label: 'Insights'),
          NavigationDestination(icon: Icon(Icons.psychology), label: 'AI Advisor'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              WalletFlowLogo(size: 120),
              const SizedBox(height: 32),
              Text(
                'Welcome to WalletFlow',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your AI-powered personal finance tracker',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Track expenses, set budgets, and get smart financial insights',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement Google Sign-In
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Google Sign-In coming soon!'),
                        backgroundColor: Colors.indigo,
                      ),
                    );
                  },
                  icon: const Icon(Icons.login, size: 24),
                  label: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Continue as guest - limited features available'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: Text(
                  'Continue as Guest',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              WalletFlowLogo(size: 72),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Financial Dashboard',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    BudgetProgress(
                      title: 'Budget',
                      spent: 6500,
                      budget: 10000,
                      icon: Icons.account_balance_wallet,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    CategoryPieChart(
                      data: {
                        'Food': 2500.0,
                        'Shopping': 1800.0,
                        'Bills': 1200.0,
                        'Personal': 1000.0,
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              MotivationalQuote(
                quote: 'Small savings today lead to big achievements tomorrow.',
                author: 'WalletFlow',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final transactions = [
      {'merchant': 'Amazon', 'amount': 1200, 'date': 'Aug 2'},
      {'merchant': 'Swiggy', 'amount': 450, 'date': 'Aug 2'},
      {'merchant': 'Flipkart', 'amount': 800, 'date': 'Aug 1'},
      {'merchant': 'Dream Bakers', 'amount': 620, 'date': 'Jul 31'},
    ];
    return GradientBackground(
      child: TransactionList(transactions: transactions),
    );
  }
}

class CategoryInsightsScreen extends StatelessWidget {
  const CategoryInsightsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final insights = {
      'Food': 2500.0,
      'Shopping': 1800.0,
      'Bills': 1200.0,
      'Personal': 1000.0,
    };
    return GradientBackground(
      child: CategoryInsightsList(insights: insights),
    );
  }
}

class AIAdvisorScreen extends StatelessWidget {
  const AIAdvisorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Center(
        child: AIAdvisorCard(
          trend: 'You’ve spent 25% over your food budget this week.',
          advice: 'Consider skipping outside food for a few days to get back on track!',
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            ProfileBadges(badges: [
              'Saved ₹10,000',
              'Zero Spend Day',
              '7-Day Streak',
              'Level Up!',
            ]),
          ],
        ),
      ),
    );
  }
}

