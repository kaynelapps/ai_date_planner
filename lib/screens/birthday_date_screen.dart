import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'birthday_date_detail_screen.dart';
import '../models/birthday_date_idea.dart';

class BirthdayDateScreen extends StatelessWidget {
  static final List<BirthdayDateIdea> indoorDates = [
  BirthdayDateIdea(
  title: 'Surprise Birthday Party for Two',
  imageUrl: 'assets/images/birthday_party.jpg',
  description: 'Throw a mini surprise party at home with all the trimmings, but just for your partner.',
  steps: [
  'Decorate the Space: Use balloons, banners, and party hats to set a festive tone.',
  'Bake a Custom Cake: Personalize a cake with their favorite flavors or a fun design.',
  'Plan Mini Games: Include games like trivia about your relationship or a scavenger hunt for their gift.',
  'Playlist and Dance: Play their favorite songs and have a private dance party.',
  'Midnight Toast: Wrap up the evening with a toast to their year ahead and share your heartfelt wishes.',
  ],
  ),
  BirthdayDateIdea(
  title: 'DIY Movie Night with a Birthday Twist',
  imageUrl: 'assets/images/birthday_movie.jpg',
  description: 'Transform your living room into a private cinema for a birthday-themed movie marathon.',
  steps: [
  'Decorate the Room: Use string lights, a "Happy Birthday" banner, and comfy seating.',
  'Snack Bar: Create a mini concession stand with popcorn, candy, and custom drinks.',
  'Feature Their Favorites: Pick movies or shows that the birthday person loves.',
  'Pause for a Celebration: Between films, surprise them with a candle-lit cupcake or cake.',
  'Memory Montage: Play a short video of pictures and clips celebrating their life so far.',
  ],
  ),
  BirthdayDateIdea(
  title: 'Cooking or Baking Date Night',
  imageUrl: 'assets/images/birthday_cooking.jpg',
  description: 'Spend the evening cooking their favorite dish or learning a new recipe together.',
  steps: [
  'Choose a Theme: Italian night with homemade pizza, French pastries, or sushi-making.',
  'Surprise Apron Gift: Give them a personalized apron as a birthday gift.',
  'Cook as a Team: Divide tasks to make it collaborative and fun.',
  'Birthday Dessert: Bake a small birthday cake or dessert as part of the experience.',
  'Decorated Dining: Serve the food at a beautifully set table with birthday candles.',
  ],
  ),
    BirthdayDateIdea(
      title: 'Memory Lane Scrapbook Session',
      imageUrl: 'assets/images/scrapbook.jpg',
      description: 'Create a scrapbook of your partner\'s best moments as a fun and heartfelt activity.',
      steps: [
        'Collect Memories: Print photos, collect keepsakes, and buy scrapbooking supplies.',
        'Personalize the Pages: Include their favorite colors, doodles, and captions about the memories.',
        'Add Birthday Notes: Write about your favorite things about them and your hopes for their year ahead.',
        'Play Nostalgic Music: Play songs that remind you of shared experiences while you work.',
        'Gift the Scrapbook: Finish the evening by presenting the scrapbook as a heartfelt gift.',
      ],
    ),
    BirthdayDateIdea(
      title: 'Spa Night at Home',
      imageUrl: 'assets/images/birthday_spa.jpg',
      description: 'Turn your home into a relaxing spa for the ultimate birthday pampering session.',
      steps: [
        'Set the Atmosphere: Use scented candles, calming music, and dim lighting.',
        'DIY Treatments: Offer a homemade facial mask, scrubs, and a massage with essential oils.',
        'Bubble Bath Bonus: Run a warm bath with bath bombs or rose petals.',
        'Birthday Treats: Serve champagne, herbal tea, or their favorite drink with light snacks.',
        'Gift a Spa Kit: End the night with a small gift of luxurious skincare products.',
      ],
    ),
  ];

  static final List<BirthdayDateIdea> outdoorDates = [
  BirthdayDateIdea(
  title: 'Birthday Picnic in the Park',
  imageUrl: 'assets/images/birthday_picnic.jpg',
  description: 'Celebrate in nature with a scenic picnic tailored to their tastes.',
  steps: [
  'Pick the Perfect Spot: Choose a location with a great view, like a lake, garden, or hilltop.',
  'Pack Their Favorites: Include their favorite snacks, a cozy blanket, and a bottle of wine or juice.',
  'Decorate the Spot: Use balloons, a small "Happy Birthday" sign, or a floral arrangement.',
  'Surprise Activity: Bring a game, kite, or sketchpad for a fun and interactive element.',
  'Cake Reveal: Hide a small cake or cupcakes to surprise them at the end.',
  ],
  ),
  BirthdayDateIdea(
  title: 'Adventure Day',
  imageUrl: 'assets/images/birthday_adventure.jpg',
  description: 'Spend the day doing something thrilling or new that they\'ve always wanted to try.',
  steps: [
  'Choose the Activity: Options include ziplining, rock climbing, parasailing, or a hot air balloon ride.',
  'Capture the Moment: Take plenty of photos or videos to commemorate the experience.',
  'Surprise Touch: Sneak in a small gift or handwritten note to present during the activity.',
  'Fuel the Fun: Bring their favorite snacks or end the activity with a celebratory meal.',
  'Celebrate After: Share a toast to their courage and adventurous spirit.',
  ],
  ),
  BirthdayDateIdea(
  title: 'Rooftop Dinner Under the Stars',
  imageUrl: 'assets/images/rooftop_dinner.jpg',
  description: 'Create an intimate dinner date on a rooftop with a stunning view of the city or night sky.',
  steps: [
  'Find the Spot: Reserve a rooftop restaurant or set up a private table at home if you have access.',
  'Decorate: Use string lights, lanterns, and flowers for a romantic touch.',
  'Custom Menu: Cook or order their favorite meal, and serve with their favorite drink.',
  'Play a Birthday Playlist: Include songs that are special to them or upbeat birthday tunes.',
  'Gift with a View: Present their gift during dessert with the city lights as a backdrop.',
  ],
  ),
    BirthdayDateIdea(
      title: 'Outdoor Movie Night',
      imageUrl: 'assets/images/outdoor_birthday_movie.jpg',
      description: 'Enjoy a private movie screening under the stars in your backyard or at a drive-in theater.',
      steps: [
        'Set the Scene: Bring blankets, cushions, and a portable projector for a backyard setup.',
        'Birthday Snacks: Prepare their favorite movie snacks and a custom birthday drink.',
        'Pick a Special Movie: Choose a film they\'ve been wanting to see or one that has sentimental value.',
        'Pause for Cake: Surprise them with a candle-lit birthday cake during intermission.',
        'Make a Wish: Watch the stars together and encourage them to share their birthday wish.',
      ],
    ),
    BirthdayDateIdea(
      title: 'Scenic Nature Getaway',
      imageUrl: 'assets/images/nature_getaway.jpg',
      description: 'Take a day trip to a scenic location for a relaxing and memorable birthday celebration.',
      steps: [
        'Plan the Destination: Visit a nearby beach, forest, or mountain trail.',
        'Pack a Birthday Basket: Include snacks, drinks, a blanket, and a small birthday banner.',
        'Surprise Element: Hide a handwritten letter or a small gift in the basket.',
        'Do Something Special: Plan an activity like building a sandcastle, picking flowers, or flying a drone.',
        'Reflect Together: Share what makes the birthday person special to you while enjoying the scenery.',
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
                    _buildDateSection(context, 'Indoor Birthday Dates', indoorDates),
                    _buildDateSection(context, 'Outdoor Birthday Dates', outdoorDates),
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
            'Birthday Date Ideas',
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

  Widget _buildDateSection(BuildContext context, String title, List<BirthdayDateIdea> dates) {
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

  Widget _buildDateCard(BuildContext context, BirthdayDateIdea date, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BirthdayDateDetailScreen(dateIdea: date),
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
