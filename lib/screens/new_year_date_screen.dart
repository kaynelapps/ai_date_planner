import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'new_year_date_detail_screen.dart';
import '../models/new_year_date_idea.dart';

class NewYearDateScreen extends StatelessWidget {
  static final List<NewYearDateIdea> indoorDates = [
  NewYearDateIdea(
  title: 'New Year\'s Eve at Home Gala',
  imageUrl: 'assets/images/home_gala.jpg',
  description: 'Turn your home into an elegant party venue for just the two of you, complete with formal wear, fine dining, and champagne.',
  steps: [
  'Set the Dress Code: Dress up in formal attire as if you\'re attending a grand New Year\'s gala.',
  'Decorate with Glitz: Use fairy lights, candles, and metallic balloons to create a chic atmosphere.',
  'DIY Gourmet Meal: Cook or order a three-course dinner and pair it with your favorite wine or champagne.',
  'Personal Countdown: Reflect on the year by exchanging handwritten notes about your favorite memories together.',
  'Midnight Dance: Slow dance to your favorite song as the clock strikes midnight.',
  ],
  ),
  NewYearDateIdea(
  title: 'New Year\'s Game Night',
  imageUrl: 'assets/images/game_night.jpg',
  description: 'Enjoy a cozy evening with competitive and festive games tailored for two.',
  steps: [
  'Create a Game Zone: Choose a mix of board games, card games, or trivia with a New Year\'s theme.',
  'Add Personal Stakes: The winner gets to make a special New Year\'s wish that the other has to help fulfill.',
  'Mix in Festive Rounds: Include activities like a DIY photo booth, charades with New Year\'s resolutions, or karaoke battles.',
  'Snack Buffet: Prepare a table of finger foods, champagne cocktails, and desserts.',
  'Countdown Moment: Finish with a playful twist, like guessing trivia about the upcoming year just before midnight.',
  ],
  ),
    NewYearDateIdea(
      title: 'Movie Marathon and Blanket Fort',
      imageUrl: 'assets/images/blanket_fort.jpg',
      description: 'Transform your living room into a cozy blanket fort for a romantic night of movies and snuggles.',
      steps: [
        'Build the Fort: Use pillows, fairy lights, and blankets to create a snug space.',
        'Curate a Playlist: Pick movies that reflect different eras of your relationship or your all-time favorites.',
        'Festive Snacks: Prepare popcorn with glittery sprinkles or personalized snack trays.',
        'DIY Countdown: Pause the marathon to watch a live countdown on TV or make your own countdown timer.',
        'Resolution Notes: Share your resolutions on slips of paper and tuck them into your fort as "wishes" for the new year.',
      ],
    ),
    NewYearDateIdea(
      title: 'New Year\'s Spa Night',
      imageUrl: 'assets/images/spa_night.jpg',
      description: 'Relax together with a rejuvenating spa evening to kick off the year stress-free.',
      steps: [
        'Set the Mood: Use candles, calming music, and essential oils like lavender or eucalyptus.',
        'Prepare DIY Treatments: Make face masks or scrubs using natural ingredients like honey and sugar.',
        'Massage Exchange: Take turns giving each other massages with luxurious oils or lotions.',
        'Bubble Bath or Hot Tub: If available, end with a bath filled with flower petals or bath bombs.',
        'Toast at Midnight: Sip herbal tea, mocktails, or champagne while reflecting on the year ahead.',
      ],
    ),
    NewYearDateIdea(
      title: 'Vision Board Craft Night',
      imageUrl: 'assets/images/vision_board.jpg',
      description: 'Spend the evening setting intentions for the new year with creativity and vision boards.',
      steps: [
        'Gather Supplies: Use magazines, markers, stickers, and corkboards for crafting.',
        'Reflect Together: Share your hopes, dreams, and goals for the coming year.',
        'Add Shared Dreams: Create a section of the board dedicated to goals you want to achieve as a couple.',
        'Toast Your Plans: Celebrate finishing your boards with a glass of champagne.',
        'Time Capsule: Write a note to your future selves and tuck it behind the boards for next New Year\'s Eve.',
      ],
    ),
  ];

  static final List<NewYearDateIdea> outdoorDates = [
  NewYearDateIdea(
  title: 'Fireworks Picnic in the Park',
  imageUrl: 'assets/images/fireworks_picnic.jpg',
  description: 'Welcome the new year under a sky lit with fireworks, complete with a cozy picnic.',
  steps: [
  'Find a Viewing Spot: Research the best location to see fireworks in your area.',
  'Pack a Cozy Setup: Bring a blanket, thermos of hot cocoa, and finger foods like mini sandwiches or desserts.',
  'Add a Personal Touch: Write down your favorite moments from the past year to read together as you wait for midnight.',
  'Celebrate with Sparklers: Bring sparklers or glow sticks to create your own little light show.',
  'Midnight Cuddle: Share a kiss and enjoy the fireworks together as the clock strikes twelve.',
  ],
  ),
  NewYearDateIdea(
  title: 'Outdoor Winter Adventure',
  imageUrl: 'assets/images/winter_adventure.jpg',
  description: 'Spend the evening in a snowy landscape, then cozy up by a bonfire.',
  steps: [
  'Choose an Activity: Go sledding, ice skating, or snowshoeing at a local spot.',
  'Prepare for the Cold: Pack thermals, warm blankets, and extra gloves.',
  'Bonfire Setup: If allowed, build a small bonfire or find a location with a communal fire pit.',
  'DIY S\'mores: Bring marshmallows, chocolate, and crackers to make s\'mores.',
  'Share Resolutions: Exchange your dreams for the coming year while enjoying the warmth.',
  ],
  ),
  NewYearDateIdea(
  title: 'Midnight City Lights Stroll',
  imageUrl: 'assets/images/city_lights.jpg',
  description: 'Wander through the city to enjoy the dazzling New Year\'s lights and festivities.',
  steps: [
  'Pick a Festive Route: Walk through areas decorated with lights or where countdown events are taking place.',
  'Dress Up: Wear something warm yet stylish to mark the occasion.',
  'Street Snacks: Stop at food trucks or street vendors for a festive treat.',
  'Make a Wish: Find a landmark, like a bridge or fountain, to toss a coin and make a wish together.',
  'End at Midnight: Finish the walk at a spot with a view of the city\'s fireworks or skyline.',
  ],
  ),
    NewYearDateIdea(
      title: 'Rooftop New Year\'s Toast',
      imageUrl: 'assets/images/rooftop_toast.jpg',
      description: 'Celebrate on a rooftop with a private view of the city or stars.',
      steps: [
        'Find the Perfect Rooftop: Look for a restaurant, hotel, or private rooftop space.',
        'Bundle Up: Bring blankets and cozy jackets for warmth.',
        'Pack a Midnight Basket: Include champagne, plastic flutes, and midnight snacks.',
        'Photo Memories: Use the backdrop of the city or stars to take memorable photos.',
        'Make it Magical: Use LED candles or lanterns to add a romantic glow.',
      ],
    ),
    NewYearDateIdea(
      title: 'New Year\'s Eve Street Festival',
      imageUrl: 'assets/images/street_festival.jpg',
      description: 'Immerse yourselves in a lively celebration with music, dancing, and countdown energy.',
      steps: [
        'Choose the Event: Look for a nearby street festival with live performances or DJs.',
        'Coordinate Outfits: Wear matching accessories like hats, glow bands, or scarves.',
        'Join the Dance Floor: Embrace the festive energy by dancing together.',
        'Capture the Fun: Snap selfies or short videos to remember the excitement.',
        'Midnight Moment: Share a kiss as the crowd counts down and fireworks light up the sky.',
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
                    _buildDateSection(context, 'Indoor New Year\'s Dates', indoorDates),
                    _buildDateSection(context, 'Outdoor New Year\'s Dates', outdoorDates),
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
            'New Year\'s Date Ideas',
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

  Widget _buildDateSection(BuildContext context, String title, List<NewYearDateIdea> dates) {
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

  Widget _buildDateCard(BuildContext context, NewYearDateIdea date, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewYearDateDetailScreen(dateIdea: date),
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
