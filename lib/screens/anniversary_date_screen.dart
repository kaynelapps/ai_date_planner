import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'anniversary_date_detail_screen.dart';
import '../models/anniversary_date_idea.dart';

class AnniversaryDateScreen extends StatelessWidget {
  static final List<AnniversaryDateIdea> indoorDates = [
  AnniversaryDateIdea(
  title: 'Recreate Your First Date',
  imageUrl: 'assets/images/first_date.jpg',
  description: 'Relive the magic of your first date by recreating it at home with personalized details.',
  steps: [
  'Recreate the Setting: Decorate your home to match the vibe of your first date spot.',
  'Replicate the Menu: Cook or order the same dishes or drinks you enjoyed together.',
  'Dress the Part: Wear outfits similar to what you wore on your first date.',
  'Share Memories: Look back at photos or discuss your impressions from that day.',
  'Add a Twist: End the night with a heartfelt gift or a video montage of your time together.',
  ],
  ),
  AnniversaryDateIdea(
  title: 'Indoor Stargazing',
  imageUrl: 'assets/images/indoor_stargazing.jpg',
  description: 'Transform your room into a starry night and share stories about your journey as a couple.',
  steps: [
  'Set the Scene: Use a star projector or glow-in-the-dark stickers to mimic the night sky.',
  'Get Cozy: Lay out a soft blanket with pillows, candles, and snacks.',
  'Walk Down Memory Lane: Share your favorite memories or milestones.',
  'Write Your Future: Plan where you want to be together in 5 or 10 years.',
  'Capture the Moment: Write love notes to exchange, or record a video message for your future selves.',
  ],
  ),
  AnniversaryDateIdea(
  title: 'DIY Wine Tasting Night',
  imageUrl: 'assets/images/wine_tasting.jpg',
  description: 'Sample and compare wines or spirits while creating a cozy, upscale atmosphere.',
  steps: [
  'Set the Table: Use elegant glasses, a cheese board, and candlelight for ambiance.',
  'Create a Tasting Menu: Select a variety of wines or whiskeys, each paired with small bites.',
  'Rate Together: Use scorecards to rate your favorites and discover new preferences.',
  'Surprise Element: Hide one special bottle that has a memory or story tied to it.',
  'Cheers to the Years: Toast each year you\'ve spent together and share your hopes for the future.',
  ],
  ),
    AnniversaryDateIdea(
      title: 'Cozy Cooking Class for Two',
      imageUrl: 'assets/images/cooking_class.jpg',
      description: 'Turn your kitchen into a cooking school and learn to make something new together.',
      steps: [
        'Choose the Dish: Pick a cuisine you\'ve never tried making, like sushi, pasta from scratch, or French pastries.',
        'Prepare Ahead: Gather ingredients and watch a tutorial or use a recipe as your guide.',
        'Teamwork Challenge: Divide tasks and help each other create the dish.',
        'Set a Special Table: Decorate with flowers, candles, or even a themed setup for the cuisine.',
        'End with Dessert: Share a pre-made treat or make a simple one like chocolate-covered strawberries.',
      ],
    ),
    AnniversaryDateIdea(
      title: 'Memory Jar Movie Marathon',
      imageUrl: 'assets/images/movie_marathon.jpg',
      description: 'Combine reminiscing about your time together with a binge-worthy movie marathon.',
      steps: [
        'Create a Memory Jar: Write down one memory for each year you\'ve been together and place it in a jar.',
        'Set the Stage: Prepare a cozy space with blankets, snacks, and your favorite drinks.',
        'Pick Movies that Matter: Choose films that were part of your journey.',
        'Pause for Reflections: Open a few memory notes from the jar between movies and talk about them.',
        'Surprise Gift: Hide a small anniversary gift in the jar or among the snacks.',
      ],
    ),
  ];

  static final List<AnniversaryDateIdea> outdoorDates = [
  AnniversaryDateIdea(
  title: 'Hot Air Balloon Ride',
  imageUrl: 'assets/images/balloon_ride.jpg',
  description: 'Soar to new heights and enjoy breathtaking views while celebrating your love.',
  steps: [
  'Book in Advance: Find a company that offers romantic or private balloon rides.',
  'Add a Toast: Bring champagne or sparkling juice for an in-flight toast.',
  'Surprise Keepsake: Hand your partner a small, meaningful gift mid-flight.',
  'Capture the Moment: Take photos or videos of the beautiful view and your time together.',
  'Celebrate After: End the adventure with a cozy meal at a nearby café or restaurant.',
  ],
  ),
  AnniversaryDateIdea(
  title: 'Sunset Beach Picnic',
  imageUrl: 'assets/images/beach_picnic.jpg',
  description: 'Relax together on the beach as the sun sets, with food and romance in the air.',
  steps: [
  'Plan Ahead: Bring a large blanket, pillows, and a cooler with your favorite foods.',
  'Personalized Menu: Include foods that are special to your relationship.',
  'Decorate the Spot: Use fairy lights, lanterns, or candles for added ambiance.',
  'Love Notes: Write and exchange letters to each other before the sun sets.',
  'Stay for Stargazing: Bring a telescope or app for spotting constellations.',
  ],
  ),
  AnniversaryDateIdea(
  title: 'Anniversary Adventure Hike',
  imageUrl: 'assets/images/adventure_hike.jpg',
  description: 'Celebrate your love with a trek to a scenic lookout or waterfall.',
  steps: [
  'Choose a Romantic Trail: Look for hikes with natural beauty like mountain views or lakes.',
  'Pack a Surprise Picnic: Bring snacks, drinks, and something sweet to enjoy at the summit.',
  'Celebrate Milestones: Reflect on the past year or your relationship journey at the top.',
  'Bring a Gift: Give your partner a small token like a bracelet or charm.',
  'Take Photos: Capture candid moments and couple\'s photos at scenic spots.',
  ],
  ),
    AnniversaryDateIdea(
      title: 'Outdoor Dining & Live Music',
      imageUrl: 'assets/images/outdoor_dining.jpg',
      description: 'Enjoy an al fresco dining experience paired with live music for an unforgettable evening.',
      steps: [
        'Pick a Venue: Choose a romantic restaurant with a patio or an outdoor concert venue.',
        'Reserve the Best Spot: Ensure you get a table with a view or close to the performance.',
        'Dress Up: Treat it like a fancy date night by dressing elegantly.',
        'Special Request: If allowed, request a meaningful song for the live musician to play.',
        'Share a Dance: Sneak in a slow dance under the stars or near your table.',
      ],
    ),
    AnniversaryDateIdea(
      title: 'Kayaking Adventure',
      imageUrl: 'assets/images/kayaking.jpg',
      description: 'Spend quality time on the water, enjoying nature and each other\'s company.',
      steps: [
        'Pick the Water Experience: Choose kayaking, paddle boating, or a private boat rental.',
        'Add Romance: Bring a small bouquet, light snacks, and sparkling water or champagne.',
        'Pause to Reflect: Stop at a scenic spot to exchange heartfelt words or share a toast.',
        'Plan a Surprise: Hide a love letter or small gift in your partner\'s life jacket or bag.',
        'Capture the Adventure: Take photos of your time together on the water.',
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateSection(context, 'Indoor Anniversary Dates', indoorDates),
                    _buildDateSection(context, 'Outdoor Anniversary Dates', outdoorDates),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF2E2E2E)),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Anniversary Date Ideas',
            style: GoogleFonts.lato(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDateSection(BuildContext context, String title, List<AnniversaryDateIdea> dates) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ).animate().fadeIn(duration: 600.ms),
          SizedBox(height: 16),
          MasonryGridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              return _buildDateCard(context, dates[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(BuildContext context, AnniversaryDateIdea date, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnniversaryDateDetailScreen(dateIdea: date),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.asset(
                date.imageUrl,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  date.title,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(
        duration: 600.ms,
        delay: Duration(milliseconds: 200 * index),
      ),
    );
  }
}
