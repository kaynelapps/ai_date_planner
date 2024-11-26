import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PrivacyPolicyScreen extends StatelessWidget {
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
    'Privacy Policy',
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
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    _buildHeader('Privacy Policy for SoulPlan-AI Fun Date Ideas'),
    SizedBox(height: 16),
    _buildDateSection('Last updated: 20 September 2024'),
    _buildDivider(),
    _buildSection(
    'Introduction',
    'AppSonics Studio ("we," "our," or "us") operates the SoulPlan-AI Fun Date Ideas mobile application (the "App"). This privacy policy informs you of our policies regarding the use of data when you use our App and the choices you have associated with that data.',
    ),
    _buildDivider(),
    _buildSection(
    'Information Collection and Use',
    'Our App is designed to provide fun date ideas using AI technology. We do not collect or store any personal information such as names, email addresses, or birth dates.',
    ),
    _buildDivider(),
    _buildSection(
    'Ad Partners',
    'We use Google AdMob to display advertisements in our App. AdMob may collect and process certain data to provide relevant ads. Please refer to Google\'s privacy policy for more information about their data practices.',
    ),
    _buildDivider(),
    _buildSection(
    'Contact Us',
    'If you have any questions about this Privacy Policy, please contact us:\n\n- By email: dworarena@gmail.com\n- By visiting: dworarena.blogspot.com',
    ),
    ],
    ),
    ).animate().fadeIn(delay: 200.ms).slideY(),
    ],
    ),
        ),
        ),
        ),
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

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E2E2E),
          ),
        ),
        SizedBox(height: 12),
        Text(
          content,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Color(0xFF2E2E2E).withOpacity(0.8),
            height: 1.5,
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
