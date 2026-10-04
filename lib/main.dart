import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' hide Text;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flyaa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NyaaHomePage(),
    );
  }
}

class NyaaHomePage extends StatefulWidget {
  const NyaaHomePage({super.key});

  @override
  State<NyaaHomePage> createState() => _NyaaHomePageState();
}

class _NyaaHomePageState extends State<NyaaHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<TorrentResult> _results = [];
  bool _isLoading = false;
  String _error = '';
  Set<String> _favorites = {};
  bool _isSearchingByUploader = false;
  final String _favoritesKey = 'favorite_uploaders';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favs = prefs.getStringList(_favoritesKey);
    if (favs != null) {
      setState(() {
        _favorites = Set.from(favs);
      });
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favorites.toList());
  }

  void _toggleFavoriteUploader(String username) {
    setState(() {
      if (_favorites.contains(username)) {
        _favorites.remove(username);
      } else {
        _favorites.add(username);
      }
    });
    _saveFavorites();
  }

  Future<void> _searchTorrents(String query, {bool isUploaderSearch = false}) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _error = '';
        _isSearchingByUploader = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
      _isSearchingByUploader = isUploaderSearch;
    });

    try {
      // Determine search parameters
      final String searchQuery;
      if (isUploaderSearch) {
        // For uploader search, we use the username: prefix in the query
        searchQuery = query;
      } else {
        searchQuery = query;
      }

      final response = await http.get(
        Uri.parse('https://nyaa.si/')
            .replace(queryParameters: {'q': searchQuery, 'c': '0_0', 'f': '0'}),
      );

      if (response.statusCode == 200) {
        final List<TorrentResult> results = _parseSearchResults(response.body);
        setState(() {
          _results = results;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load results: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error: $e';
      });
    }
  }

  List<TorrentResult> _parseSearchResults(String html) {
    final document = parse(html);
    final tableRows = document.querySelectorAll('table > tr');

    final List<TorrentResult> results = [];

    for (final row in tableRows) {
      final cells = row.querySelectorAll('td');
      if (cells.length < 8) continue;

      final nameCell = cells[1];
      final linkCell = cells[2];
      final sizeCell = cells[3];
      final dateCell = cells[4];
      final seedersCell = cells[5];
      final leechersCell = cells[6];

      // Extract title and view link
      final nameLink = nameCell.querySelector('a');
      final String? viewLink = nameLink?.attributes['href'];
      final String? title = nameLink?.text.trim();

      // Extract torrent download link and magnet link
      final torrentLink = linkCell.querySelector('a[href\$=".torrent"]');
      final String? torrentDownloadLink = torrentLink?.attributes['href'];
      final String? magnetLink = linkCell
          .querySelector('a[href^="magnet:"]')
          ?.attributes['href'];

      // Extract size, date, seeders, leechers
      final String size = sizeCell.text.trim();
      final String date = dateCell.text.trim();
      final int seeders = int.tryParse(seedersCell.text.trim()) ?? 0;
      final int leechers = int.tryParse(leechersCell.text.trim()) ?? 0;

      // Try to extract uploader info from the title or other cells
      // In nyaa.si, uploader information is often in the title or in a tooltip
      // For simplicity, we'll try to extract from title if it follows [Uploader] Title format
      String? uploader;
      if (title != null) {
        // Check if title starts with [Uploader]
        final RegExp uploaderRegex = RegExp(r'^\[([^\]]+)\]\s+(.+)$');
        final Match? match = uploaderRegex.firstMatch(title);
        if (match != null) {
          uploader = match.group(1)!;
          // If we want to store the clean title without the uploader prefix
          // final String cleanTitle = match.group(2)!;
        }
      }

      if (viewLink != null &&
          title != null &&
          torrentDownloadLink != null &&
          magnetLink != null) {
        results.add(TorrentResult(
          title: title,
          viewLink: viewLink,
          torrentDownloadLink: torrentDownloadLink,
          magnetLink: magnetLink,
          size: size,
          date: date,
          seeders: seeders,
          leechers: leechers,
          uploader: uploader,
        ));
      }
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flyaa'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Search'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSearchTab(),
            _buildFavoritesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search for torrents...',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (query) => _searchTorrents(query),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  final query = _searchController.text.trim();
                  if (query.isNotEmpty) {
                    // Check if it's an uploader search (starts with @ or username:)
                    if (query.startsWith('@') || query.startsWith('username:')) {
                      final String uploaderQuery = query.replaceFirst(RegExp(r'^@|^username:'), '');
                      _searchTorrents(uploaderQuery, isUploaderSearch: true);
                    } else {
                      _searchTorrents(query);
                    }
                  }
                },
                icon: const Icon(Icons.search),
                label: const Text('Search'),
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (_error.isNotEmpty)
          Expanded(child: Center(child: Text(_error, style: const TextStyle(color: Colors.red))))
        else if (_results.isEmpty)
          const Expanded(child: Center(child: Text('No results. Enter a search query.')))
        else
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                final bool isFavorite = _favorites.contains(result.uploader ?? '');
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      result.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Size: ${result.size}'),
                        Text('Date: ${result.date}'),
                        Text(
                            'Seeders: ${result.seeders} | Leechers: ${result.leechers}'),
                        if (result.uploader != null)
                          Text(
                            'Uploader: ${result.uploader}',
                            style: TextStyle(
                              color: isFavorite ? Colors.orange : Colors.grey[600],
                              fontWeight: isFavorite ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Favorite/Uploader bookmark button
                        if (result.uploader != null)
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                              color: isFavorite ? Colors.orange : Colors.grey,
                            ),
                            tooltip: isFavorite
                                ? 'Remove from favorites'
                                : 'Add uploader to favorites',
                            onPressed: () => _toggleFavoriteUploader(result.uploader!),
                          ),
                        const SizedBox(width: 4),
                        // Download button
                        IconButton(
                          icon: const Icon(Icons.download),
                          tooltip: 'Download .torrent',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Downloading: ${result.title}'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        // Magnet link button
                        IconButton(
                          icon: const Icon(Icons.link),
                          tooltip: 'Copy magnet link',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Magnet link copied!'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: Navigate to detail page
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    if (_favorites.isEmpty) {
      return const Center(
        child: Text(
          'No favorite uploaders yet.\nSearch for torrents and add uploaders to your favorites!',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final uploader = _favorites.elementAt(index);
        return ListTile(
          leading: const Icon(Icons.person, color: Colors.orange),
          title: Text(uploader, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Favorite uploader'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Remove from favorites',
            onPressed: () => _toggleFavoriteUploader(uploader),
          ),
          onTap: () {
            // Search for torrents from this uploader
            _searchController.text = 'username:$uploader';
            _searchTorrents(uploader, isUploaderSearch: true);
            // Switch to search tab
            DefaultTabController.of(context).index = 0;
          },
        );
      },
    );
  }
}

class TorrentResult {
  final String title;
  final String viewLink;
  final String torrentDownloadLink;
  final String magnetLink;
  final String size;
  final String date;
  final int seeders;
  final int leechers;
  final String? uploader; // Extracted from title if available

  TorrentResult({
    required this.title,
    required this.viewLink,
    required this.torrentDownloadLink,
    required this.magnetLink,
    required this.size,
    required this.date,
    required this.seeders,
    required this.leechers,
    this.uploader,
  });
}