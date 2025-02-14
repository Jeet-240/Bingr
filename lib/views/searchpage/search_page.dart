import 'package:bingr/constants/colors.dart';
import 'package:bingr/decorations/text_field_decoration.dart';
import 'package:bingr/widgets/movie_cards.dart';
import 'package:flutter/material.dart';
import 'package:bingr/services/api/Api_service.dart';
import '../../classes/movie_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchInput;
  late Future<List<MovieCard>> list;
  ApiService apiService = ApiService();
  bool _isSearchPressed = false;

  @override
  void initState() {
    _searchInput = TextEditingController();
    list = Future.value([]);
    super.initState();
  }

  @override
  void dispose() {
    _searchInput.dispose();
    super.dispose();
  }

  void _search({required String searchInput}) {
    setState(() {

      _isSearchPressed = true;
      list = apiService.searchMovie(searchQuery: searchInput); // Corrected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              controller: _searchInput,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              style: textFieldTextStyle(),
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search shows, movies',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    if(_searchInput.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Enter something to search.'),
                            duration: Duration(seconds: 3),
                          )
                      );
                    }
                    else {
                      _search(searchInput: _searchInput.text.trim());
                    }
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey.shade50,
                  ),
                ),
              ),
              onSubmitted: (value) {
                if(_searchInput.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Enter something to search.'),
                        duration: Duration(seconds: 3),
                      )
                  );
                }else {
                  _search(searchInput: value.trim());
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded( // Prevents layout overflow issues
              child: FutureBuilder(
                future: list,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: dialogBoxColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    if(snapshot.error.toString().contains('No movies found')){
                      return Center(
                        child: Text(
                          'No Movies or TV shows found!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900
                          ),
                        ),
                      );
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Error: ${snapshot.error}"),
                        ElevatedButton(
                          onPressed: () {
                            _search(searchInput: _searchInput.text.trim());
                          },
                          child: const Text("Retry"),
                        ),
                      ],
                    );
                  } else if(!_isSearchPressed){
                    return Center(
                      child: Text('Search to get results!'),);
                  }
                  else {
                    var searchResult = snapshot.data!;
                    return searchResult.isEmpty
                        ? Center(child: Text("No results found"))
                        : GridView.builder(
                      shrinkWrap: true, // Prevents layout issues
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: searchResult.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2 / 3,
                      ),
                      itemBuilder: (context, index) {
                        var cardDetail = searchResult[index];
                        return MovieCardWidget(
                          posterUrl: cardDetail.posterUrl,
                          movieName: cardDetail.title,
                          align: TextAlign.center,
                          fontSize: 14,
                          imdbId: cardDetail.imdbID,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
