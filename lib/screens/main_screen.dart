import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'start_screen.dart';
import 'share_moments_screen.dart';
import 'challenges_screen.dart';
import 'account_settings_screen.dart';
import 'terms_of_service_screen.dart';

class MainScreen extends StatefulWidget {
  static final GlobalKey<_MainScreenState> mainScreenKey = GlobalKey<_MainScreenState>();

  @override
  _MainScreenState createState() => _MainScreenState();

  static void navigateToIndex(BuildContext context, int index) {
    mainScreenKey.currentState?.setIndex(index);
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    StartScreen(),
    ShareMomentsScreen(),
    ChallengesScreen(),
    AccountSettingsScreen(),
  ];

  void setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _checkTermsAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('termsAccepted') ?? false;
  }

  Future<void> _handleMomentsTab() async {
    bool termsAccepted = await _checkTermsAccepted();

    if (!termsAccepted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TermsOfServiceScreen()),
      );

      if (result == true) {
        setState(() => _selectedIndex = 1);
      } else {
        setState(() => _selectedIndex = _selectedIndex);
      }
    } else {
      setState(() => _selectedIndex = 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 1) {
              _handleMomentsTab();
            } else {
              setState(() => _selectedIndex = index);
            }
          },
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFE91C40),
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.share),
              label: 'Moments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flag),
              label: 'Challenges',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}