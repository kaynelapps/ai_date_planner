import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/main_screen.dart';

class TermsOfServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF2E2E2E)),
          onPressed: () => Navigator.pop(context),
        ).animate().fadeIn(delay: 200.ms),
        title: Text(
          AppLocalizations.of(context)!.termsOfServiceTitle,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E2E2E),
          ),
        ).animate().fadeIn(delay: 300.ms).slideX(),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _buildTermsContent(context),
                ).animate().fadeIn(delay: 200.ms).slideY(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildTermsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(AppLocalizations.of(context)!.termsOfServiceTitle),
        SizedBox(height: 16),
        _buildDateSection('Last updated: 20 September 2024'),
        _buildDivider(),
        Text(
          AppLocalizations.of(context)!.termsOfServiceIntro,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Color(0xFF2E2E2E).withOpacity(0.8),
            height: 1.5,
          ),
        ),
        _buildDivider(),
        _buildTermsItems(context),
        _buildDivider(),
        _buildButtons(context),
      ],
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E2E2E),
      ),
    );
  }

  Widget _buildDateSection(String text) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFFE91C40),
      ),
    );
  }
  Widget _buildTermsItems(BuildContext context) {
    return Column(
      children: [
        TermsItem(number: '1', text: AppLocalizations.of(context)!.termsItem1),
        TermsItem(number: '2', text: AppLocalizations.of(context)!.termsItem2),
        TermsItem(number: '3', text: AppLocalizations.of(context)!.termsItem3),
        TermsItem(number: '4', text: AppLocalizations.of(context)!.termsItem4),
        TermsItem(number: '5', text: AppLocalizations.of(context)!.termsItem5),
        TermsItem(number: '6', text: AppLocalizations.of(context)!.termsItem6),
        TermsItem(number: '7', text: AppLocalizations.of(context)!.termsItem7),
        TermsItem(number: '8', text: AppLocalizations.of(context)!.termsItem8),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE91C40),
            minimumSize: Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('termsAccepted', true);
            await prefs.setString('termsAcceptedDate', DateTime.now().toIso8601String());
            Navigator.of(context).pop(true);
            MainScreen.navigateToIndex(context, 1);
          },
          child: Text(
            AppLocalizations.of(context)!.acceptTermsButton,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            AppLocalizations.of(context)!.declineButton,
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Color(0xFF2E2E2E).withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Container(
        height: 1,
        color: Colors.grey[200],
      ),
    );
  }
}
class TermsItem extends StatelessWidget {
  final String number;
  final String text;

  const TermsItem({Key? key, required this.number, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Color(0xFFE91C40).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.lato(
                  color: Color(0xFFE91C40),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Color(0xFF2E2E2E).withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
