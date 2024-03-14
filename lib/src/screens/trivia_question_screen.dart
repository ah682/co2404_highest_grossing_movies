import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'answer.dart'; // Screen to display after answering a question
import 'game_over.dart'; // Screen to display when the game is over
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_screen.dart'; // Ensure this is the correct import for your IntroScreen

// Enum representing the type of question that can be asked.
enum QuestionType { Year, Genre, Director }

// Class to represent a movie with its associated data.
class Movie {
  final String title; // Movie title
  final int releaseYear; // Year the movie was released
  final String imageUrl; // URL for the movie's image
  final List<String> genres; // List of genres the movie belongs to
  final String director; // Director of the movie

  // Constructor for initializing the Movie object.
  Movie({
    required this.title,
    required this.releaseYear,
    required this.imageUrl,
    required this.genres,
    required this.director,
  });

  // Factory constructor to create a Movie object from JSON data.
  factory Movie.fromJson(Map<String, dynamic> json) {
    List<dynamic> crew = json['credits']?['crew'] ?? [];
    String directorName = "Unknown";
    // Find the first crew member who is the director and get their name.
    if (crew.isNotEmpty) {
      final director = crew.firstWhere(
        (member) => member['job'] == 'Director',
        orElse: () => null,
      );
      if (director != null) {
        directorName = director['name'];
      }
    }

    // Return a new Movie object populated with data from the JSON.
    return Movie(
      title: json['title'] as String,
      releaseYear: DateTime.parse(json['release_date'] as String).year,
      imageUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      genres: List<String>.from(json['genre_ids'].map((id) => id.toString())),
      director: directorName,
    );
  }
}

// API class to fetch movies from an online database.
class MovieApi {
  final String baseUrl = 'https://api.themoviedb.org/3/';
  final String apiKey = 'your_api_key_here'; // Place your TMDB API Key here

  // Fetches popular movies and returns a list of Movie objects.
  Future<List<Movie>> fetchPopularMovies() async {
    final url = Uri.parse(
        '$baseUrl/movie/popular?api_key=$apiKey&append_to_response=credits');
    final response = await http.get(url);

    // Checks if the HTTP request was successful.
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> moviesJson = data['results'];
      // Maps through the JSON data and converts each movie to a Movie object.
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}

// StatefulWidget for the main game logic and display.
class TriviaGame extends StatefulWidget {
  @override
  _TriviaGameState createState() => _TriviaGameState();
}

// State class for TriviaGame which holds the state of the game.
class _TriviaGameState extends State<TriviaGame> {
  int currentRound = 1; // Current round number
  int score = 0; // Current score
  late Movie currentMovie; // Current movie being questioned about
  List<dynamic> answerOptions = []; // Options for the user to choose from
  bool isLoading = true; // Loading state indicator
  QuestionType? questionType; // Current type of question

  @override
  void initState() {
    super.initState();
    fetchAndSetupRound(); // Sets up the game round
  }

  // Asynchronously sets up the game round.
  fetchAndSetupRound() async {
    setState(() =>
        isLoading = true); // Shows a loading indicator while data is fetched.
    MovieApi api = MovieApi();
    List<Movie> movies =
        await api.fetchPopularMovies(); // Fetches popular movies.
    Random random = Random();
    // Randomly selects a movie to use for this round.
    currentMovie = movies[random.nextInt(movies.length)];

    // Randomly selects a question type for this round.
    List<QuestionType> questionTypes = QuestionType.values;
    questionType = questionTypes[random.nextInt(questionTypes.length)];

    // Generates answer options based on the question type.
    switch (questionType) {
      case QuestionType.Year:
        // Creates a list of possible release years.
        answerOptions = List.generate(
            4, (_) => currentMovie.releaseYear - random.nextInt(10) + 5);
        // Ensures the correct answer is in the options.
        answerOptions[random.nextInt(4)] = currentMovie.releaseYear;
        break;
      case QuestionType.Genre:
        // List of potential genres. In a real app, this list might be fetched from a server or included in a larger dataset.
        List<String> allGenres = ['Action', 'Drama', 'Comedy', 'Thriller'];
        answerOptions = currentMovie.genres..shuffle();
        // Fills up the answer options to have 4 choices, ensuring no duplicates.
        while (answerOptions.length < 4) {
          String randomGenre = allGenres[random.nextInt(allGenres.length)];
          if (!answerOptions.contains(randomGenre))
            answerOptions.add(randomGenre);
        }
        answerOptions.shuffle();
        break;
      case QuestionType.Director:
        // Prepares a list of potential directors including the correct one.
        answerOptions = [
          'John Doe', // Placeholder names; in a real app, these might come from a database.
          'Jane Smith',
          'Michael Bay',
          currentMovie.director
        ];
        answerOptions.shuffle();
        break;
      default:
        break;
    }

    setState(() => isLoading =
        false); // Hides the loading indicator when setup is complete.
  }

  // Processes the user's answer and navigates to the next screen accordingly.
  void handleAnswer(dynamic selectedAnswer) {
    bool isCorrect = false; // Indicator if the user's answer is correct.
    switch (questionType) {
      // Checks if the selected answer is correct based on the question type.
      case QuestionType.Year:
        isCorrect = selectedAnswer == currentMovie.releaseYear;
        break;
      case QuestionType.Genre:
        isCorrect = currentMovie.genres.contains(selectedAnswer);
        break;
      case QuestionType.Director:
        isCorrect = selectedAnswer == currentMovie.director;
        break;
      default:
        break;
    }
    if (isCorrect) score++; // Increments the score if the answer is correct.
    navigateToNextScreen(
        isCorrect); // Navigates to the appropriate next screen.
  }

  // Navigates to the next screen depending on the current round and user's answer.
  navigateToNextScreen(bool isCorrect) {
    if (currentRound < 5) {
      // If not the final round, navigate to the AnswerScreen.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnswerScreen(
            isCorrect: isCorrect,
            currentScore: score,
            currentRound: currentRound,
            onNextRound: () {
              // Pop the AnswerScreen and setup the next round.
              Navigator.of(context).pop();
              setState(() {
                currentRound++;
                fetchAndSetupRound();
              });
            },
          ),
        ),
      );
    } else {
      // If it is the final round, save the score and navigate to the GameOverScreen.
      _saveCurrentScore().then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GameOverScreen(score: score)),
        );
      });
    }
  }

  // Saves the current score to SharedPreferences.
  _saveCurrentScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Fetches the username saved in SharedPreferences.
      String username = prefs.getString('username') ?? 'Player';

      List<String> highScores = prefs.getStringList('highScores') ?? [];
      String newScoreEntry = '$username: $score';

      // Update the high score list with the new score.
      int existingIndex =
          highScores.indexWhere((entry) => entry.startsWith('$username:'));
      if (existingIndex != -1) {
        // Replace existing score if one is found.
        highScores[existingIndex] = newScoreEntry;
      } else {
        // Otherwise, add the new score entry.
        highScores.add(newScoreEntry);
      }

      // Sort the high scores in descending order.
      highScores.sort((a, b) => int.parse(b.split(":")[1].trim())
          .compareTo(int.parse(a.split(":")[1].trim())));

      // Keep only the top 5 high scores if necessary.
      if (highScores.length > 5) {
        highScores = highScores.sublist(0, 5);
      }

      // Save the updated high scores back to SharedPreferences.
      await prefs.setStringList('highScores', highScores);
    } catch (e) {
      // Handle errors in saving the score, such as a failed write to SharedPreferences.
      print('Failed to save score: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show a loading spinner while the game is being set up.
      return Scaffold(
          appBar: AppBar(title: Text('Movie Trivia')),
          body: Center(child: CircularProgressIndicator()));
    }

    // Main game screen with movie image, question, and answer options.
    return Scaffold(
      appBar: AppBar(
          title: Text('Movie Trivia')), // AppBar title for the game screen.
      body: Center(
        child: SingleChildScrollView(
          // Allows the user to scroll if the content does not fit on the screen.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Displays the current movie image.
              Image.network(currentMovie.imageUrl,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.error)), // Error icon if the image fails to load.
              SizedBox(height: 20),
              Divider(thickness: 2), // Visual divider for layout separation.
              // Displays the question based on the current movie and question type.
              Text(
                getQuestionText(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Dynamically creates buttons for each answer option.
              ...answerOptions.map((option) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => handleAnswer(option),
                      child: Text(option.toString()),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // Generates the question text based on the current movie and question type.
  String getQuestionText() {
    switch (questionType) {
      case QuestionType.Year:
        return 'What year was "${currentMovie.title}" released?';
      case QuestionType.Genre:
        return 'Which genre does "${currentMovie.title}" belong to?';
      case QuestionType.Director:
        return 'Who directed "${currentMovie.title}"?';
      default:
        return '';
    }
  }
}
