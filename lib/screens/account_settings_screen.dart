import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soulplan_ai_fun_date_ideas/services/auth_service.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/privacy_policy_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/main_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:soulplan_ai_fun_date_ideas/mixins/glass_dialog_mixin.dart';
import 'package:soulplan_ai_fun_date_ideas/mixins/glass_dialog_mixin_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/language_selection_screen.dart';
import '../screens/sign_in_screen.dart';


class AccountSettingsScreen extends StatelessWidget with GlassDialogMixin, GlassDialogInputMixin {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF2E2E2E)),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          ),
        ),
        title: Text(
          l10n.accountSettings,
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E2E2E),
          ),
        ),
      ),



      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(l10n.accountManagement),
              SizedBox(height: 16),
              _buildSettingItem(
                icon: Icons.person,
                title: l10n.changeNickname,
                onTap: () => _showChangeNicknameDialog(context, authService),
              ),
              _buildSettingItem(
                icon: Icons.email,
                title: l10n.changeEmail,
                onTap: () => _showChangeEmailDialog(context, authService),
              ),
              _buildSettingItem(
                icon: Icons.lock,
                title: l10n.changePassword,
                onTap: () => _showChangePasswordDialog(context, authService),
              ),
              SizedBox(height: 32),
              _buildSectionTitle(l10n.privacy),
              SizedBox(height: 16),
              _buildSettingItem(
                icon: Icons.visibility,
                title: l10n.privacyPolicy,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                ),
              ),
              _buildSectionTitle(l10n.languageSettings),
              SizedBox(height: 16),
              _buildSettingItem(
                icon: Icons.language,
                title: l10n.selectLanguage,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LanguageSelectionScreen(isFirstTime: false),
                  ),
                ),
              ),
              SizedBox(height: 32),
              _buildSectionTitle(l10n.accountActions),
              SizedBox(height: 16),
              _buildDisconnectButton(context),
              SizedBox(height: 16),
              _buildDeleteAccountButton(context),
            ],
          ),
        ),
      ),

    );
  }
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E2E2E),
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildDisconnectButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Color(0xFF2E2E2E),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () => _showDisconnectDialog(context),
        child: Text(
          AppLocalizations.of(context)!.disconnectAccount,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).animate().fadeIn().slideY();
  }

  void _showDisconnectDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildGlassDialog(
          title: l10n.disconnectAccountTitle,
          content: l10n.disconnectAccountConfirmation,
          actions: [
            buildCancelButton(context),
            buildActionButton(
              text: l10n.disconnectButton,
              onPressed: () async {
                final authService = Provider.of<AuthService>(context, listen: false);
                await authService.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }



  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFFE91C40)),
        title: Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Color(0xFF2E2E2E),
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Color(0xFF2E2E2E)),
        onTap: onTap,
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE91C40),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () => _showDeleteAccountDialog(context),
        child: Text(
          AppLocalizations.of(context)!.deleteAccount,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).animate().fadeIn().slideY();
  }
  void _showChangeNicknameDialog(BuildContext context, AuthService authService) {
    final l10n = AppLocalizations.of(context)!;
    String newNickname = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildGlassInputDialog(
          title: l10n.changeNicknameTitle,
          inputField: TextField(
            onChanged: (value) => newNickname = value,
            style: GoogleFonts.lato(color: Color(0xFF2E2E2E)),
            decoration: buildInputDecoration(l10n.enterNewNickname),
          ),
          actions: [
            buildCancelButton(context),
            buildActionButton(
              text: l10n.changeButton,
              onPressed: () async {
                await authService.changeNickname(newNickname);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.nicknameUpdateSuccess)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangeEmailDialog(BuildContext context, AuthService authService) {
    final l10n = AppLocalizations.of(context)!;
    String newEmail = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildGlassInputDialog(
          title: l10n.changeEmailTitle,
          inputField: TextField(
            onChanged: (value) => newEmail = value,
            style: GoogleFonts.lato(color: Color(0xFF2E2E2E)),
            decoration: buildInputDecoration(l10n.enterNewEmail),
          ),
          actions: [
            buildCancelButton(context),
            buildActionButton(
              text: l10n.changeButton,
              onPressed: () async {
                try {
                  await authService.changeEmail(newEmail);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.emailUpdateSuccess)),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.emailUpdateError(e.toString()))),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context, AuthService authService) {
    final l10n = AppLocalizations.of(context)!;
    String newPassword = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildGlassInputDialog(
          title: l10n.changePasswordTitle,
          inputField: TextField(
            onChanged: (value) => newPassword = value,
            obscureText: true,
            style: GoogleFonts.lato(color: Color(0xFF2E2E2E)),
            decoration: buildInputDecoration(l10n.enterNewPassword),
          ),
          actions: [
            buildCancelButton(context),
            buildActionButton(
              text: l10n.changeButton,
              onPressed: () async {
                try {
                  await authService.changePassword(newPassword);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.passwordUpdateSuccess)),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.passwordUpdateError(e.toString()))),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildGlassDialog(
          title: l10n.deleteAccountTitle,
          content: l10n.deleteAccountConfirmation,
          actions: [
            buildCancelButton(context),
            buildActionButton(
              text: l10n.deleteButton,
              onPressed: () async {
                final authService = Provider.of<AuthService>(context, listen: false);
                await authService.deleteAccount();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        );
      },
    );
  }
}
