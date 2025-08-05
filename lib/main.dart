import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
import 'services/auth_service.dart';
import 'theme.dart';

// Stub missing methods for build
Map<String, double> getUserMonthlyData() => {
  'Food': 2500.0,
  'Shopping': 1800.0,
  'Bills': 1200.0,
  'Personal': 1000.0,
};

Map<String, double> getUserDailyData() => {
  'Today': 250.0,
  'Yesterday': 180.0,
};

Map<String, double> getUserYearlyData() => {
  '2024': 85000.0,
  '2023': 78000.0,
};

Future<String> getFinancialAdviceFromOpenAI(String prompt) async => 
    "Based on your spending patterns, consider reducing food expenses by 10% and increasing your savings rate.";

// Biometric/Screen Lock State (simple in-memory for demo, use secure storage in production)
bool biometricLockEnabled = false;

// BillResult class for Mindee API
class BillResult {
  final double amount;
  final String merchant;
  final String date;
  final String category;
  
  BillResult(this.amount, this.merchant, this.date, this.category);
}

// Mindee API integration for bill analysis
Future<BillResult?> analyzeBillWithMindee(List<int> imageBytes) async {
  final apiKey = 'md_4frcb2dfxyrxy3xqbtluj38d0dvpdndo';
  final url = 'https://api.mindee.net/v1/products/mindee/expense_receipts/v5/predict';
  
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $apiKey',
        'Content-Type': 'application/pdf', // or 'image/jpeg' if using JPEG
      },
      body: imageBytes,
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Parse Mindee response for amount, merchant, date, category
      final amount = double.tryParse(data['document']['inference']['prediction']['total_amount']['value']?.toString() ?? '') ?? 0.0;
      final merchant = data['document']['inference']['prediction']['supplier_name']['value'] ?? '';
      final date = data['document']['inference']['prediction']['date']['value'] ?? '';
      final category = data['document']['inference']['prediction']['category']['value'] ?? '';
      return BillResult(amount, merchant, date, category);
    }
  } catch (e) {
    print('Mindee API error: $e');
  }
  return null;
}

Future<bool> authenticateUser(BuildContext context) async {
  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics = await auth.canCheckBiometrics;
  bool isDeviceSupported = await auth.isDeviceSupported();
  
  if (!canCheckBiometrics || !isDeviceSupported) {
    // Fallback to dialog if no biometrics available
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Authenticate'),
          content: const Text('Biometric authentication not available. Use device PIN/Password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Authenticate'),
            ),
          ],
        );
      },
    ) ?? false;
  }
  
  try {
    bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Authenticate to access WalletFlow',
      options: const AuthenticationOptions(
        biometricOnly: false,
        stickyAuth: true,
      ),
    );
    return didAuthenticate;
  } catch (e) {
    // Fallback to dialog on error
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Authenticate'),
          content: const Text('Authentication error. Use device PIN/Password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Authenticate'),
            ),
          ],
        );
      },
    ) ?? false;
  }
}

class BiometricGate extends StatefulWidget {
  final Widget child;
  const BiometricGate({required this.child, super.key});
  
  @override
  State<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<BiometricGate> {
  bool _authenticated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (biometricLockEnabled) {
        bool result = await authenticateUser(context);
        setState(() {
          _authenticated = result;
        });
      } else {
        setState(() {
          _authenticated = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_authenticated && biometricLockEnabled) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return widget.child;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: BiometricGate(child: const MainNavigation()),
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
    DashboardScreen(),
    TransactionsScreen(),
    InsightsAdvisorScreen(),
    ProfileScreen(),
    SettingsScreen(),
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
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Transactions'),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Insights & Advisor'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
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
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 900),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const WalletFlowLogo(size: 64),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  'WalletFlow ✨',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your AI-powered personal finance tracker',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final auth = AuthService();
                                    final user = await auth.signInWithGoogle();
                                    if (user != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Signed in as ${user.displayName ?? user.email ?? 'Google user'}'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Google sign-in failed.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.login, size: 24),
                                  label: const Text('Sign in with Google'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                  ),
                                  backgroundColor: Colors.black.withValues(alpha: 0.95),
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Add Expense', 
                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                              color: Colors.white, 
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                          const SizedBox(height: 24),
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Scan bill/transcript Mindee API integration placeholder.'), 
                                                  backgroundColor: Colors.indigo
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.qr_code_scanner, size: 24),
                                            label: const Text('Scan Bill / Transcript'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.indigo,
                                              foregroundColor: Colors.white,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  String amount = '';
                                                  String category = '';
                                                  return AlertDialog(
                                                    backgroundColor: Colors.black.withValues(alpha: 0.95),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                                    title: Text(
                                                      'Add Expense Manually', 
                                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)
                                                    ),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          keyboardType: TextInputType.number,
                                                          decoration: const InputDecoration(
                                                            labelText: 'Amount',
                                                            labelStyle: TextStyle(color: Colors.white),
                                                            prefixIcon: Icon(Icons.currency_rupee, color: Colors.white),
                                                          ),
                                                          style: const TextStyle(color: Colors.white),
                                                          onChanged: (v) => amount = v,
                                                        ),
                                                        const SizedBox(height: 12),
                                                        TextField(
                                                          decoration: const InputDecoration(
                                                            labelText: 'Category',
                                                            labelStyle: TextStyle(color: Colors.white),
                                                            prefixIcon: Icon(Icons.category, color: Colors.white),
                                                          ),
                                                          style: const TextStyle(color: Colors.white),
                                                          onChanged: (v) => category = v,
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('Expense added: ₹$amount ($category)'), 
                                                              backgroundColor: Colors.green
                                                            ),
                                                          );
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.green,
                                                          foregroundColor: Colors.white,
                                                        ),
                                                        child: const Text('Add'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.edit, size: 24),
                                            label: const Text('Add Manually'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.white,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.add, size: 24),
                              label: const Text('Add Expense'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
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
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () async {
                              final auth = AuthService();
                              final user = await auth.continueAsGuest();
                              if (user != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Continuing as guest.'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Guest sign-in failed.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Continue as Guest 👤',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 1500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Financial Dashboard 📊',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Flexible(
                            child: BudgetProgress(
                              title: 'Budget',
                              spent: 6500,
                              budget: 10000,
                              icon: Icons.account_balance_wallet,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Flexible(
                            child: CategoryPieChart(
                              data: {
                                'Food': 2500.0,
                                'Shopping': 1800.0,
                                'Bills': 1200.0,
                                'Personal': 1000.0,
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 1800),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: MotivationalQuote(
                          quote: 'Small savings today lead to big achievements tomorrow. 💡',
                          author: 'WalletFlow',
                        ),
                      ),
                    ),
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 900),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        const Icon(Icons.list_alt, color: Colors.indigo, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          'Transactions 💸',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TransactionList(transactions: transactions),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class InsightsAdvisorScreen extends StatelessWidget {
  const InsightsAdvisorScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final Map<String, double> monthlyData = getUserMonthlyData();
    final Map<String, double> dailyData = getUserDailyData();
    final Map<String, double> yearlyData = getUserYearlyData();

    String buildAIPrompt(Map<String, double> daily, Map<String, double> monthly, Map<String, double> yearly) {
      String dailyStr = daily.entries.map((e) => '${e.key}: ₹${e.value.toStringAsFixed(2)}').join(', ');
      String monthlyStr = monthly.entries.map((e) => '${e.key}: ₹${e.value.toStringAsFixed(2)}').join(', ');
      String yearlyStr = yearly.entries.map((e) => '${e.key}: ₹${e.value.toStringAsFixed(2)}').join(', ');
      return 'Analyze my financial data and give actionable advice.\nDaily: $dailyStr\nMonthly: $monthlyStr\nYearly: $yearlyStr';
    }

    final aiPrompt = buildAIPrompt(dailyData, monthlyData, yearlyData);

    return GradientBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 900),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.insights, color: Colors.indigo, size: 32),
                            const SizedBox(width: 12),
                            Text(
                              'Insights & Advisor 💡',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Premium financial insights and smart advice powered by AI.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (monthlyData.isNotEmpty)
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: CategoryInsightsList(insights: monthlyData),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 18),
            if (monthlyData.isNotEmpty || dailyData.isNotEmpty || yearlyData.isNotEmpty)
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 1500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: FutureBuilder<String>(
                        future: getFinancialAdviceFromOpenAI(aiPrompt),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Text('AI suggestion error', style: TextStyle(color: Colors.red));
                          }
                          return AIAdvisorCard(
                            trend: 'AI Trend',
                            advice: snapshot.data ?? 'No advice',
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 32),
          ],
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 900),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.tealAccent, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          'Profile 👤',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: ProfileBadges(badges: [
                      'Saved ₹10,000 🏆',
                      'Zero Spend Day 🧘',
                      '7-Day Streak 🔥',
                      'Level Up! 🚀',
                    ]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 900),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.settings, color: Colors.indigo, size: 32),
                            const SizedBox(width: 12),
                            Text(
                              'Settings ⚙️',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Enable Biometric/Screen Lock'),
                          value: biometricLockEnabled,
                          onChanged: (val) {
                            setState(() {
                              biometricLockEnabled = val;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'If enabled, you will be asked to authenticate every time you open the app.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
