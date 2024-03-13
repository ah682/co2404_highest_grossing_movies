import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'answer.dart';
import 'game_over.dart';

enum QuestionType { Year, Genre, Director }

class Movie {
  final String title;
  final int releaseYear;
  final String imageUrl;
  final List<String> genres;
  final String director;

  Movie({
    required this.title,
    required this.releaseYear,
    required this.imageUrl,
    required this.genres,
    required this.director,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<dynamic> crew = json['credits']?['crew'] ?? [];
    String directorName = "Unknown";
    if (crew.isNotEmpty) {
      final director = crew.firstWhere(
        (member) => member['job'] == 'Director',
        orElse: () => null,
      );
      if (director != null) {
        directorName = director['name'];
      }
    }

    return Movie(
      title: json['title'] as String,
      releaseYear: DateTime.parse(json['release_date'] as String).year,
      imageUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      genres: List<String>.from(json['genre_ids'].map((id) => id.toString())),
      director: directorName,
    );
  }
}

class MovieApi {
  final String baseUrl = 'https://api.themoviedb.org/3/';
  final String apiKey = 'cb250fc48cd4dc439eae0be94d1d7bd1';

  Future<List<Movie>> fetchPopularMovies() async {
    final url = Uri.parse(
        '$baseUrl/movie/popular?api_key=$apiKey&append_to_response=credits');
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
  List<dynamic> answerOptions = [];
  bool isLoading = true;
  QuestionType? questionType;

  @override
  void initState() {
    super.initState();
    fetchAndSetupRound();
  }

  fetchAndSetupRound() async {
    setState(() => isLoading = true);
    MovieApi api = MovieApi();
    List<Movie> movies = await api.fetchPopularMovies();
    Random random = Random();
    currentMovie = movies[random.nextInt(movies.length)];

    List<QuestionType> questionTypes = QuestionType.values;
    questionType = questionTypes[random.nextInt(questionTypes.length)];

    switch (questionType) {
      case QuestionType.Year:
        answerOptions = List.generate(
            4, (_) => currentMovie.releaseYear - random.nextInt(10) + 5);
        answerOptions[random.nextInt(4)] = currentMovie.releaseYear;
        break;
      case QuestionType.Genre:
        List<String> allGenres = [
          'Action',
          'Drama',
          'Comedy',
          'Thriller'
        ]; // Example genres
        answerOptions = currentMovie.genres..shuffle();
        while (answerOptions.length < 4) {
          String randomGenre = allGenres[random.nextInt(allGenres.length)];
          if (!answerOptions.contains(randomGenre))
            answerOptions.add(randomGenre);
        }
        answerOptions.shuffle();
        break;
      case QuestionType.Director:
        answerOptions = [
          'John Doe',
          'Jane Smith',
          'Michael Bay',
          currentMovie.director
        ]; // Example directors
        answerOptions.shuffle();
        break;
      default:
        break;
    }

    setState(() => isLoading = false);
  }

  void handleAnswer(dynamic selectedAnswer) {
    bool isCorrect = false;
    switch (questionType) {
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

    if (isCorrect) score++;
    navigateToNextScreen(isCorrect);
  }

  navigateToNextScreen(bool isCorrect) {
    if (currentRound < 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnswerScreen(
            isCorrect: isCorrect,
            currentScore: score,
            currentRound: currentRound,
            onNextRound: () {
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
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => GameOverScreen(score: score)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
          appBar: AppBar(title: Text('Movie Trivia')),
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Movie Trivia')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.network(currentMovie.imageUrl,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error)),
              SizedBox(height: 20),
              Divider(thickness: 2),
              Text(
                getQuestionText(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
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
