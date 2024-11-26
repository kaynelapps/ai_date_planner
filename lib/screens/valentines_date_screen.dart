import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'valentines_date_detail_screen.dart';
import '../models/valentines_date_idea.dart';

class ValentinesDateScreen extends StatelessWidget {
  static final List<ValentinesDateIdea> indoorDates = [
  ValentinesDateIdea(
  title: 'Romantic Candlelit Dinner',
  imageUrl: 'assets/images/candlelit_dinner.jpg',
  description: 'Create a fine dining experience in the comfort of your home with personalized touches.',
  steps: [
  'Set the Mood: Decorate your dining area with candles, rose petals, and soft background music.',
  'Cook Together: Prepare a special meal, like recreating the dish from your first date or trying something new.',
  'Dress Up: Dress as if you\'re at a fancy restaurant to make it feel more special.',
  'Personalize It: Write heartfelt notes to each other to read during dinner.',
  'Surprise Dessert: End with a surprise dessert, like chocolate fondue with fruits.',
  ],
  ),
  ValentinesDateIdea(
  title: 'Indoor Picnic Under Fairy Lights',
  imageUrl: 'assets/images/indoor_picnic.jpg',
  description: 'Transform your living room into a magical picnic spot for an intimate and relaxed date.',
  steps: [
  'Set the Scene: Use fairy lights, blankets, and pillows to create a cozy space.',
  'Prepare a Picnic Basket: Pack finger foods like cheese, crackers, chocolate-covered strawberries, and wine.',
  'Play a Game: Bring along a trivia game about your relationship or a card game for couples.',
  'Create a Playlist: Play a mix of romantic songs to enhance the atmosphere.',
  'Cuddle Time: Watch a romantic movie or read love letters to each other post-picnic.',
  ],
  ),
  ValentinesDateIdea(
  title: 'DIY Couples\' Art Night',
  imageUrl: 'assets/images/art_night.jpg',
  description: 'Explore your creative side by painting, crafting, or drawing together.',
  steps: [
  'Gather Supplies: Buy canvases, paints, brushes, and aprons. Choose a theme for your art.',
  'Set a Challenge: Paint portraits of each other or create a piece that represents your relationship.',
  'Sip and Paint: Pair the activity with a bottle of wine or cocktails.',
  'Exchange Art: Sign and gift your creations to each other at the end.',
  'Gallery Moment: Display the artwork at home to remember the night.',
  ],
  ),
    ValentinesDateIdea(
      title: 'At-Home Spa Date',
      imageUrl: 'assets/images/spa_date.jpg',
      description: 'Pamper yourselves with a relaxing spa experience at home.',
      steps: [
        'Set the Mood: Light candles, dim the lights, and play calming music.',
        'DIY Treatments: Create homemade face masks, scrubs, and aromatherapy blends.',
        'Massage Each Other: Take turns giving massages with fragrant oils.',
        'Bubble Bath for Two: If you have a tub, prepare a bubble bath with rose petals and bath salts.',
        'End with Dessert: Enjoy chocolate truffles or strawberries dipped in melted chocolate post-relaxation.',
      ],
    ),
    ValentinesDateIdea(
      title: 'Memory Lane Scrapbooking',
      imageUrl: 'assets/images/scrapbooking.jpg',
      description: 'Relive your favorite memories by creating a scrapbook together.',
      steps: [
        'Prepare Materials: Collect photos, ticket stubs, and other mementos from your relationship.',
        'Decorate Together: Use stickers, markers, and washi tape to personalize each page.',
        'Add Love Notes: Write captions or love letters to accompany your favorite photos.',
        'Reminisce: Share stories behind the items as you craft.',
        'Set Goals: Dedicate a page to future plans or dreams you want to achieve together.',
      ],
    ),
  ];

  static final List<ValentinesDateIdea> outdoorDates = [
  ValentinesDateIdea(
  title: 'Sunset Hike with a View',
  imageUrl: 'assets/images/sunset_hike.jpg',
  description: 'Embark on a hike and enjoy a breathtaking sunset together.',
  steps: [
  'Choose a Scenic Trail: Pick a spot with great views and moderate difficulty.',
  'Pack Essentials: Bring a picnic basket with champagne, snacks, and a blanket.',
  'Surprise Touch: Leave a love note for your partner to find along the trail.',
  'Capture the Moment: Take photos or selfies at the peak to commemorate the date.',
  'Stargazing: Stay a little longer to watch the stars appear after sunset.',
  ],
  ),
  ValentinesDateIdea(
  title: 'Ice Skating Date',
  imageUrl: 'assets/images/ice_skating.jpg',
  description: 'Glide hand-in-hand on an ice skating rink for a romantic winter activity.',
  steps: [
  'Choose a Picturesque Rink: Look for outdoor rinks with festive lighting.',
  'Matching Accessories: Wear matching gloves or scarves for a cute touch.',
  'Add a Challenge: Playfully challenge each other to skating tricks or races.',
  'Warm Up Together: End the skate with hot cocoa or cider at a nearby café.',
  'Photo Memory: Capture a photo on the rink with your skates on.',
  ],
  ),
  ValentinesDateIdea(
  title: 'Romantic Horseback Ride',
  imageUrl: 'assets/images/horseback_ride.jpg',
  description: 'Take a serene horseback ride through a scenic countryside or beach.',
  steps: [
  'Choose the Location: Find a ranch or beach offering couples\' rides.',
  'Themed Gear: Wear romantic or vintage-inspired outfits for the occasion.',
  'Personal Surprise: Bring a small gift, like a handwritten letter, to exchange during a break.',
  'Post-Ride Picnic: Arrange for a picnic or snack break to relax after the ride.',
  'Capture the Romance: Take a photo or video while riding to remember the adventure.',
  ],
  ),
    ValentinesDateIdea(
      title: 'Outdoor Movie Night',
      imageUrl: 'assets/images/outdoor_movie.jpg',
      description: 'Watch a romantic movie under the stars for an intimate and cinematic experience.',
      steps: [
        'Find the Location: Set it up in your backyard or attend a drive-in theater.',
        'Cozy Up: Use blankets, pillows, and fairy lights to create a warm atmosphere.',
        'Snacks Galore: Pack heart-shaped cookies, popcorn, and champagne.',
        'Personal Playlist: Play a short video of your favorite memories before the movie starts.',
        'Starry Surprise: Use a star projector or real stargazing as an intermission activity.',
      ],
    ),
    ValentinesDateIdea(
      title: 'Garden Stroll & Picnic',
      imageUrl: 'assets/images/garden_stroll.jpg',
      description: 'Stroll through a botanical garden or park for a peaceful and romantic outing.',
      steps: [
        'Choose a Scenic Spot: Find a location with blooming flowers, fountains, or scenic views.',
        'Pack a Basket: Bring snacks and sparkling water for a short picnic on a bench.',
        'Share a Love Note: Write a poem or love letter to read to your partner during the walk.',
        'Couple\'s Photos: Capture the beauty of the setting with a few romantic selfies.',
        'End with a Gesture: Plant a small flower or tree if the location allows, as a lasting memory.',
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
                    _buildDateSection(context, 'Indoor Valentine\'s Dates', indoorDates),
                    _buildDateSection(context, 'Outdoor Valentine\'s Dates', outdoorDates),
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
            'Valentine\'s Date Ideas',
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

  Widget _buildDateSection(BuildContext context, String title, List<ValentinesDateIdea> dates) {
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

  Widget _buildDateCard(BuildContext context, ValentinesDateIdea date, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ValentinesDateDetailScreen(dateIdea: date),
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
