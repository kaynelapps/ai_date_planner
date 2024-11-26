import 'package:flutter/material.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> favoriteDates = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteDates();
  }

  _loadFavoriteDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteDates = prefs.getStringList('favoriteDates') ?? [];
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Color(0xFFE91C40),
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noFavoriteDates,
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E2E),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.startAddingDates,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Color(0xFF2E2E2E).withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: favoriteDates.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Container(
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
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(suggestion: favoriteDates[index]),
                  ),
                );
              },
              leading: Icon(
                Icons.favorite,
                color: Color(0xFFE91C40),
                size: 28,
              ),
              title: Text(
                _getTitle(favoriteDates[index]),
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E2E2E),
                ),
              ),
              subtitle: Text(
                _getDescription(favoriteDates[index]),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Color(0xFF2E2E2E).withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF2E2E2E)),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ).animate().fadeIn(delay: (index * 100).ms).slideX();
      },
    );
  }

  String _getTitle(String suggestion) {
    final parts = suggestion.split('\n');
    return parts.isNotEmpty ? parts[0].trim() : AppLocalizations.of(context)!.defaultDateSuggestion;
  }

  String _getDescription(String suggestion) {
    final parts = suggestion.split('\n');
    if (parts.length > 1) {
      return parts.sublist(1).join('\n').trim();
    }
    return '';
  }

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
          AppLocalizations.of(context)!.favoriteDatesTitle,
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
      body: favoriteDates.isEmpty ? _buildEmptyState() : _buildFavoritesList(),
    );
  }
}
