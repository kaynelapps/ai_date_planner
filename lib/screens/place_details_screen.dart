import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soulplan_ai_fun_date_ideas/services/places_service.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeId;
  final String placeName;

  const PlaceDetailsScreen({Key? key, required this.placeId, required this.placeName}) : super(key: key);

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final PlacesService _placesService = PlacesService();
  Map<String, dynamic>? _placeDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaceDetails();
  }

  Future<void> _loadPlaceDetails() async {
    try {
      final details = await _placesService.getPlaceDetails(widget.placeId);
      setState(() {
        _placeDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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
    ).animate().fadeIn(delay: 200.ms),
    title: Text(
    widget.placeName,
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
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91C40)),
        ),
      )
          : _placeDetails == null
          ? _buildErrorWidget()
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSlideshow(),
            _buildDetailsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Failed to load place details',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E2E),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPlaceDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE91C40),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY();
  }
  Widget _buildImageSlideshow() {
    List<String> photos = _placeDetails!['photos'] as List<String>;
    return Container(
      height: 250,
      child: ImageSlideshow(
        width: double.infinity,
        height: 250,
        initialPage: 0,
        indicatorColor: Color(0xFFE91C40),
        indicatorBackgroundColor: Colors.grey[300],
        children: photos.map((photo) => Image.network(
          photo,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[100],
              child: Icon(Icons.error, color: Color(0xFFE91C40), size: 50),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91C40)),
              ),
            );
          },
        )).toList(),
        autoPlayInterval: 3000,
        isLoop: true,
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildDetailsCard() {
    return Container(
      margin: EdgeInsets.all(16),
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
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _placeDetails!['name'],
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E2E),
              ),
            ).animate().fadeIn(delay: 300.ms),
            SizedBox(height: 12),
            Text(
              _placeDetails!['description'],
              style: GoogleFonts.lato(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[600],
              ),
            ).animate().fadeIn(delay: 400.ms),
            SizedBox(height: 24),
            ..._buildInfoRows(),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY();
  }
  List<Widget> _buildInfoRows() {
    final items = [
      {'icon': Icons.location_on, 'label': 'Address', 'value': _placeDetails!['address']},
      {'icon': Icons.category, 'label': 'Category', 'value': _placeDetails!['category']},
      {'icon': Icons.attach_money, 'label': 'Price', 'value': _placeDetails!['price']},
      {'icon': Icons.star, 'label': 'Rating', 'value': _placeDetails!['rating'].toString()},
      {'icon': Icons.language, 'label': 'Website', 'value': _placeDetails!['website'], 'isLink': true},
      {'icon': Icons.phone, 'label': 'Phone', 'value': _placeDetails!['phone']},
    ];

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return _buildInfoRow(
        item['icon'] as IconData,
        item['label'] as String,
        item['value'] as String,
        isLink: item['isLink'] as bool? ?? false,
      ).animate().fadeIn(delay: (600 + (index * 100)).ms);
    }).toList();
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isLink = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFFE91C40), size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                isLink
                    ? GestureDetector(
                  onTap: () => launch(value),
                  child: Text(
                    value,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Color(0xFFE91C40),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
                    : Text(
                  value,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GlassButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE91C40),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
