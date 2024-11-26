import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soulplan_ai_fun_date_ideas/services/places_service.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/loading_screen1.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/place_details_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/at_home_suggestion_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/services/date_idea_service.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlacesScreen extends StatefulWidget {
  final String suggestion;
  final String priceRange;
  final String city;
  final String dateCategory;

  const PlacesScreen({
    Key? key,
    required this.suggestion,
    required this.priceRange,
    required this.city,
    required this.dateCategory,
  }) : super(key: key);

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final PlacesService _placesService = PlacesService();
  List<Map<String, dynamic>> _places = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late List<String> _dateCategory;
  late List<String> _atHomeKeywords;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize keywords after context is available
    _atHomeKeywords = [
      AppLocalizations.of(context)!.atHomeKeyword,
      AppLocalizations.of(context)!.homeKeyword,
      AppLocalizations.of(context)!.netflixKeyword,
      AppLocalizations.of(context)!.movieNightKeyword,
      AppLocalizations.of(context)!.boardGameKeyword,
      AppLocalizations.of(context)!.cookingKeyword,
      AppLocalizations.of(context)!.bakingKeyword,
      AppLocalizations.of(context)!.videoGameKeyword,
      AppLocalizations.of(context)!.puzzleKeyword,
      AppLocalizations.of(context)!.craftKeyword,
    ];

    // Initialize other dependent data
    _dateCategory = DateIdeaService.categorizeDateIdea(widget.suggestion);
    _loadPlaces();
  }

  bool _isAtHomeActivity(String suggestion) {
    return _atHomeKeywords.any((keyword) =>
        suggestion.toLowerCase().contains(keyword));
  }

  Future<void> _loadPlaces() async {
    if (_isAtHomeActivity(widget.suggestion)) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final places = await _placesService.getPlaces(
          widget.suggestion,
          widget.city,
          widget.priceRange,
          _dateCategory.isNotEmpty ? _dateCategory[0] : 'other'
      );

      if (places.isEmpty) {
        final generalPlaces = await _placesService.getPlaces(
            _dateCategory.isNotEmpty ? _dateCategory[0] : 'date',
            widget.city,
            widget.priceRange,
            'other'
        );
        setState(() {
          _places = generalPlaces;
          _isLoading = false;
        });
      } else {
        setState(() {
          _places = places;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = AppLocalizations.of(context)!.failedToLoadPlaces(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen1(
        suggestion: widget.suggestion,
        priceRange: widget.priceRange,
        city: widget.city,
      );
    }

    if (_isAtHomeActivity(widget.suggestion)) {
      return AtHomeSuggestionScreen(suggestion: widget.suggestion);
    }

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
    AppLocalizations.of(context)!.suggestedPlaces,
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
        child: Column(
          children: [
            Expanded(
              child: _errorMessage.isNotEmpty
                  ? _buildErrorMessage()
                  : _places.isEmpty
                  ? _buildEmptyMessage()
                  : _buildPlacesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _places.length,
      itemBuilder: (context, index) {
        final place = _places[index];
        return _buildPlaceCard(place, index);
      },
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceDetailsScreen(
                  placeId: place['id'],
                  placeName: place['name'],
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlaceImage(place),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place['name'] ?? AppLocalizations.of(context)!.noName,
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E2E2E),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        place['address'] ?? AppLocalizations.of(context)!.noAddress,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFE91C40).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.categoryLabel(place['category']),
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Color(0xFFE91C40),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Color(0xFF2E2E2E).withOpacity(0.5)),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY();
  }
  Widget _buildErrorMessage() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
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
        child: Text(
          _errorMessage,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Color(0xFF2E2E2E),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
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
        child: Text(
          AppLocalizations.of(context)!.noPlacesFound,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Color(0xFF2E2E2E),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildPlaceImage(Map<String, dynamic> place) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: FutureBuilder<Map<String, dynamic>>(
        future: _placesService.getPlaceDetails(place['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data!['photos'].isNotEmpty) {
            return Container(
              width: 100,
              height: 100,
              child: Image.network(
                snapshot.data!['photos'][0],
                fit: BoxFit.cover,
              ),
            );
          } else {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFFE91C40).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.image,
                color: Color(0xFFE91C40),
                size: 40,
              ),
            );
          }
        },
      ),
    );
  }
}
