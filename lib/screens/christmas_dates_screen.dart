import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'christmas_date_detail_screen.dart';
import '../models/christmas_date_idea.dart';

class ChristmasDateScreen extends StatelessWidget {
  static final List<ChristmasDateIdea> indoorDates = [
  ChristmasDateIdea(
  title: 'Christmas Tree Treasure Hunt',
  imageUrl: 'assets/images/tree_treasure_hunt.jpg',
  description: 'Transform picking out your Christmas tree into a playful treasure hunt by incorporating challenges, clues, and a reward at the end.',
  steps: [
  'Select the Location: Choose a Christmas tree farm with plenty of options.',
  'Create a Clue List: Prepare fun riddles or trivia about your favorite Christmas memories.',
  'Incorporate Challenges: Add festive mini-games like "spot the tree that looks like a star".',
  'Personal Touch: Hide a small wrapped gift to place on the chosen tree together.',
  'Post-Date Plan: Decorate the tree with hot cocoa and Christmas music.',
  ],
  ),
  ChristmasDateIdea(
  title: 'DIY Christmas Candle-Making',
  imageUrl: 'assets/images/candle_making.jpg',
  description: 'Spend the evening creating personalized Christmas-scented candles together for cozy winter nights.',
  steps: [
  'Set the Scene: Prepare a workspace with festive decorations and soft Christmas tunes.',
  'Gather Supplies: Pick wax, wicks, molds, and a variety of scents.',
  'Customize Scents: Blend fragrances that remind you of shared holiday memories.',
  'Add Personal Labels: Design custom labels with messages like "Our First Christmas Candle."',
  'Light and Enjoy: Test your creations while watching a Christmas movie afterward.',
  ],
  ),
  ChristmasDateIdea(
  title: 'Private Holiday Light Stroll',
  imageUrl: 'assets/images/holiday_stroll.jpg',
  description: 'Turn a stroll through a decorated neighborhood into a romantic guided tour with surprises along the way.',
  steps: [
  'Choose a Location: Research neighborhoods known for their spectacular light displays.',
  'Pack Essentials: Bring a thermos of mulled wine or hot cocoa, blankets, and snacks.',
  'Create a Playlist: Make a shared holiday playlist to listen to during the walk.',
  'Plan Stops: Surprise your partner with pre-arranged stops for romantic moments.',
  'Capture the Moment: Take polaroid-style photos and create a scrapbook page afterward.',
  ],
  ),
    ChristmasDateIdea(
      title: 'Christmas Cooking Showdown',
      imageUrl: 'assets/images/cooking_showdown.jpg',
      description: 'Challenge each other to a festive cooking competition with Christmas treats.',
      steps: [
        'Set the Rules: Pick two Christmas recipes to "compete" over.',
        'Prepare a Surprise Ingredient: Incorporate a secret ingredient that both dishes must include.',
        'Judge and Reward: Be each other\'s judge or invite family/friends to taste-test.',
        'Decorate Together: Turn the results into an artistic display.',
        'Enjoy Your Creations: Share and savor your creations by the fire or under fairy lights.',
      ],
    ),
    ChristmasDateIdea(
      title: 'Christmas Planetarium Under the Stars',
      imageUrl: 'assets/images/planetarium.jpg',
      description: 'Bring the stars indoors by creating a Christmas-themed planetarium experience at home.',
      steps: [
        'Set the Atmosphere: Use a star projector or glow-in-the-dark decorations.',
        'Incorporate Christmas Themes: Project constellations of Christmas symbols.',
        'Prepare a Story: Share a made-up holiday story about the stars.',
        'Plan Snacks: Serve themed snacks like star-shaped cookies and peppermint tea.',
        'Exchange Small Gifts: Surprise each other with a small gift under your homemade starlight.',
      ],
    ),
  ];

  static final List<ChristmasDateIdea> outdoorDates = [
  ChristmasDateIdea(
  title: 'Christmas Market Adventure',
  imageUrl: 'assets/images/christmas_market.jpg',
  description: 'Stroll through a festive Christmas market while savoring delicious treats and shopping for hidden treasures.',
  steps: [
  'Set a Challenge: Have a scavenger hunt for unique items.',
  'Create a Budget Game: Give each other a small budget for surprise gifts.',
  'Taste-Test Everything: Share and rate festive foods.',
  'Capture the Magic: Take candid photos with market lights.',
  'End with Ice Skating: Pair the market stroll with ice skating nearby.',
  ],
  ),
  ChristmasDateIdea(
  title: 'Sleigh Ride & Stargazing',
  imageUrl: 'assets/images/sleigh_ride.jpg',
  description: 'Cozy up under a blanket while enjoying a scenic sleigh ride followed by stargazing in a peaceful winter spot.',
  steps: [
  'Book a Private Ride: Look for horse-drawn sleigh rides in scenic areas.',
  'Bring a Blanket: Pack a cozy blanket and thermos of hot drinks.',
  'Plan a Stargazing Spot: Find a quiet area after the ride.',
  'Make a Wish: Write your wishes for the coming year on paper stars.',
  'Surprise Touch: Sneak in a small wrapped gift to exchange during the ride.',
  ],
  ),
  ChristmasDateIdea(
  title: 'Outdoor Movie Night',
  imageUrl: 'assets/images/outdoor_movie.jpg',
  description: 'Set up an outdoor Christmas movie screening under twinkling lights.',
  steps: [
  'Choose a Festive Spot: Use a backyard or park for the screening.',
  'Set the Scene: Decorate with fairy lights and a fire pit.',
  'Bundle Up: Bring warm blankets and matching Christmas sweaters.',
  'Snack Bar: Pack themed snacks like peppermint popcorn.',
  'Interactive Fun: Have a trivia game about the movie between scenes.',
  ],
  ),
  ChristmasDateIdea(
  title: 'Christmas Village Visit',
  imageUrl: 'assets/images/christmas_village.jpg',
  description: 'Explore a local Christmas village or amusement park decked out in holiday decor.',
  steps: [
  'Plan Activities: Check for unique experiences like visiting Santa.',
  'Make It Magical: Find the best-lit area for romantic photos.',
  'Sweet Stop: Share warm treats like churros or hot cocoa.',
  'Personal Keepsake: Create a custom ornament together.',
  'Enjoy the Grand Finale: Time your visit with a parade or fireworks.',
  ],
  ),
    ChristmasDateIdea(
      title: 'Winter Hike & Festive Picnic',
      imageUrl: 'assets/images/winter_hike.jpg',
      description: 'Venture into a snow-covered forest or trail and enjoy a cozy picnic surrounded by winter beauty.',
      steps: [
        'Pick a Scenic Spot: Research nearby trails known for snowy landscapes.',
        'Pack a Festive Basket: Include seasonal snacks and treats.',
        'Thermal Magic: Carry a thermos of warm festive drinks.',
        'Deck Your Picnic: Bring a mini Christmas tree or string lights.',
        'Fun Activity: Build a snowman or have a playful snowball fight.',
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
                    _buildDateSection(context, 'Indoor Christmas Dates', indoorDates),
                    _buildDateSection(context, 'Outdoor Christmas Dates', outdoorDates),
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
            'Christmas Date Ideas',
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
  Widget _buildDateSection(BuildContext context, String title, List<ChristmasDateIdea> dates) {
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
  Widget _buildDateCard(BuildContext context, ChristmasDateIdea date, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChristmasDateDetailScreen(dateIdea: date),
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
