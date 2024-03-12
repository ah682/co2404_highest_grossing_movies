import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'answer.dart'; // Make sure this import points to your correct file
import 'game_over.dart'; // Make sure this import points to your correct file

class Movie {
  final String title;
  final int releaseYear;
  final String imageUrl;

  Movie({
    required this.title,
    required this.releaseYear,
    required this.imageUrl,
  });

  // Dynamically generate movie image for each question
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      releaseYear: DateTime.parse(json['release_date'] as String).year,
      imageUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
    );
  }
}

class MovieApi {
  final String baseUrl = 'https://api.themoviedb.org/3/';
  final String apiKey = 'cb250fc48cd4dc439eae0be94d1d7bd1';

  Future<List<Movie>> fetchPopularMovies() async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> moviesJson = data['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}

class TriviaGame extends StatefulWidget {
  @override
  _TriviaGameState createState() => _TriviaGameState();
}

class _TriviaGameState extends State<TriviaGame> {
  int currentRound = 1;
  int score = 0;
  late Movie currentMovie;
  List<int> answerOptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndSetupRound();
  }

  fetchAndSetupRound() async {
    MovieApi api = MovieApi();
    List<Movie> movies = await api.fetchPopularMovies();
    Random random = Random();
    currentMovie = movies[random.nextInt(movies.length)];

    answerOptions = List.generate(
        4, (index) => currentMovie.releaseYear - random.nextInt(10) + 5);
    answerOptions[random.nextInt(answerOptions.length)] =
        currentMovie.releaseYear;

    setState(() {
      isLoading = false;
    });
  }

  void handleAnswer(int selectedYear) {
    bool isCorrect = selectedYear == currentMovie.releaseYear;
    if (isCorrect) {
      score++;
    }

    if (currentRound < 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnswerScreen(
            isCorrect: isCorrect,
            currentScore: score,
            currentRound: currentRound,
            onNextRound: () {
              Navigator.of(context)
                  .pop(); // Pop the AnswerScreen off the navigation stack
              setState(() {
                currentRound++;
                isLoading = true;
              });
              fetchAndSetupRound();
            },
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameOverScreen(score: score),
        ),
      );
    }
  }

  void resetGame() {
    setState(() {
      currentRound = 1;
      score = 0;
      isLoading = true;
    });
    fetchAndSetupRound();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Movie Trivia')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Trivia'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.network(
                currentMovie
                    .imageUrl, // Use the imageUrl from the currentMovie object
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons
                      .error); // Display an error icon if the image fails to load
                },
              ),
              SizedBox(height: 20),
              Divider(thickness: 2),
              Text(
                'Round $currentRound: What year was "${currentMovie.title}" released?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ...answerOptions
                  .map((year) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () => handleAnswer(year),
                          child: Text(year.toString()),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
