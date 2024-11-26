import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/favorite_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:soulplan_ai_fun_date_ideas/services/gemini_service.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatefulWidget {
  final List<String> dateSuggestions;
  final Function() onRetry;

  ResultsScreen({required this.dateSuggestions, required this.onRetry});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}
class _ResultsScreenState extends State<ResultsScreen> {
  Set<String> favoriteDates = {};
  bool isLoading = false;
  Map<String, String> descriptionCache = {};

  @override
  void initState() {
    super.initState();
    _loadFavoriteDates();
    if (widget.dateSuggestions.isEmpty) {
      _retryGeneratingSuggestions();
    }
  }

  Future<void> _loadFavoriteDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        favoriteDates = (prefs.getStringList('favoriteDates') ?? []).toSet();
      });
    }
  }

  Future<void> _saveFavoriteDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteDates', favoriteDates.toList());
  }

  Future<void> _regenerateDescription(String suggestion) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final geminiService = GeminiService();
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code') ?? 'en';

      final newSuggestion = await geminiService.regenerateDescription(suggestion, languageCode);

      if (newSuggestion != null && mounted) {
        setState(() {
          descriptionCache[suggestion] = newSuggestion;
          final index = widget.dateSuggestions.indexOf(suggestion);
          if (index != -1) {
            widget.dateSuggestions[index] = newSuggestion;
          }
        });
      }
    } catch (e) {
      print('Error regenerating description: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _retryGeneratingSuggestions() async {
    setState(() {
      isLoading = true;
    });
    await widget.onRetry();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
        ),
        title: Text(
          AppLocalizations.of(context)!.resultsScreenTitle,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E2E2E),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Color(0xFFE91C40)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoriteScreen()),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFE91C40)))
          : widget.dateSuggestions.isEmpty
          ? _buildErrorWidget()
          : _buildSuggestionsList(),
    );
  }

  Widget _buildSwipeIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.arrow_back_ios,
            color: Color(0xFFE91C40).withOpacity(0.5),
            size: 24,
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFE91C40).withOpacity(0.5),
            size: 24,
          ),
        ],
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).fadeIn(
      duration: 800.ms,
    ).then(delay: 400.ms).fadeOut(
      duration: 800.ms,
    );
  }

  Widget _buildSuggestionsList() {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.dateSuggestions.length,
          itemBuilder: (context, index) {
            final suggestion = widget.dateSuggestions[index];
            final isFavorite = favoriteDates.contains(suggestion);
            return _buildDateCard(suggestion, isFavorite, index);
          },
        ),
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: _buildSwipeIndicator(),
        ),
      ],
    );
  }

  Widget _buildDateCard(String suggestion, bool isFavorite, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with largest text
            Text(
              _getTitle(suggestion),
              style: GoogleFonts.lato(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E2E),
                height: 1.2,
              ),
            ),
            SizedBox(height: 16),
            _buildFavoriteButton(isFavorite, suggestion),
            SizedBox(height: 24),

            // Description sections with hierarchy
            _buildFormattedDescription(suggestion),
            SizedBox(height: 24),
            _buildActionButton(suggestion),

            // Page indicator
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${index + 1}/${widget.dateSuggestions.length}',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100).ms).slideX();
  }


  Widget _buildFavoriteButton(bool isFavorite, String suggestion) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isFavorite) {
            favoriteDates.remove(suggestion);
          } else {
            favoriteDates.add(suggestion);
          }
          _saveFavoriteDates();
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Color(0xFFE91C40),
            size: 24,
          ),
          SizedBox(width: 8),
          Text(
            AppLocalizations.of(context)!.addToFavorites,
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Color(0xFF2E2E2E),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (200).ms);
  }

  Widget _buildActionButton(String suggestion) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(suggestion: suggestion),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE91C40),
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        AppLocalizations.of(context)!.findLocations,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ).animate().fadeIn(delay: (300).ms);
  }
  Widget _buildFormattedDescription(String suggestion) {
    final description = _getDescription(suggestion);
    final parts = description.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parts.map((part) {
        if (part.trim().isEmpty) return SizedBox(height: 16);

        bool isMainHeader = part.trim().startsWith(RegExp(r'^#\s'));
        bool isSubHeader = part.trim().startsWith(RegExp(r'^##\s'));
        bool isBulletPoint = part.trim().startsWith('-');

        TextStyle style = GoogleFonts.lato(
          fontSize: isMainHeader ? 24 : isSubHeader ? 20 : 16,
          fontWeight: isMainHeader || isSubHeader ? FontWeight.bold :
          isBulletPoint ? FontWeight.w500 : FontWeight.normal,
          color: isMainHeader ? Color(0xFFE91C40) :
          isSubHeader ? Color(0xFF2E2E2E) :
          Color(0xFF4A4A4A),
          height: 1.5,
          letterSpacing: isMainHeader || isSubHeader ? -0.5 : 0,
        );

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isMainHeader || isSubHeader ? Color(0xFFFAFAFA) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMainHeader ? Color(0xFFE91C40).withOpacity(0.1) :
              Colors.grey[200]!,
            ),
          ),
          child: Text(part.trim(), style: style),
        );
      }).toList(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.errorMessage,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _retryGeneratingSuggestions,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE91C40),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.retryButton,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY();
  }

  String _getTitle(String suggestion) {
    final parts = suggestion.split('\n');
    return parts.isNotEmpty ? parts[0].trim() : AppLocalizations.of(context)!.dateSuggestionDefault;
  }

  String _getDescription(String suggestion) {
    if (descriptionCache.containsKey(suggestion)) {
      return descriptionCache[suggestion]!;
    }

    final parts = suggestion.split('\n');
    if (parts.length > 1) {
      final description = parts.sublist(1).join('\n').trim();
      if (description.isNotEmpty) {
        descriptionCache[suggestion] = description;
        return description;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _regenerateDescription(suggestion);
    });

    return AppLocalizations.of(context)!.generatingDescription;
  }
}
