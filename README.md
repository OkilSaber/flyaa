# Flyaa

A Flutter Android client for nyaa.si torrent site - browse, search, and download torrents without authentication.

## Features

- **Torrent Search**: Search for torrents on nyaa.si by keyword
- **Uploader-Specific Search**: Find torrents from specific uploaders using `@username` or `username:` prefix
- **Uploader Bookmarking**: Save favorite uploaders for quick access (persistent storage)
- **Torrent Details**: View torrent information including size, date, seeders, leechers
- **Download Actions**: Download .torrent files or copy magnet links to clipboard
- **Tab-Based Interface**: Separate tabs for Search and Favorites
- **No Authentication**: Direct access without login/register process
- **Material Design**: Clean, responsive UI following Material Design guidelines

## Screenshots

*(Add screenshots here when available)*

## Installation

### Prerequisites
- Android device running Android 5.0 (Lollipop) or higher
- [Flutter](https://flutter.dev/docs/get-started/install) installed for building from source

### From APK (Recommended)
1. Download the latest APK from the [Releases](../../releases) page
2. Transfer the APK to your Android device
3. Install the APK (you may need to enable "Install from unknown sources" in Settings)
4. Launch the app and start searching!

### Building from Source
1. Clone this repository:
   ```bash
   git clone https://github.com:OkilSaber/flyaa.git
   cd flyaa
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Build the APK:
   ```bash
   flutter build apk --release
   ```
4. Install the generated APK:
   ```
   install build/app/outputs/flutter-apk/app-release.apk
   ```

## Usage

### Basic Search
1. Tap the search bar at the top
2. Enter your search query (e.g., "naruto", "attack on titon")
3. Press enter or tap the search icon
4. Browse through the results

### Uploader-Specific Search
To search for torrents from a specific uploader:
- Use `@username` prefix: `@Erai-raws naruto`
- Or use `username:` prefix: `username:Erai-raws naruto`

The app will automatically detect and handle uploader-specific search syntax.

### Bookmarking Uploaders
1. Find a torrent from an uploader you like
2. Tap the bookmark/star icon in the torrent card
3. The uploader will be added to your favorites
4. Access your favorite uploaders from the Favorites tab

### Download Options
For each torrent result:
- **Download .torrent**: Downloads the torrent file to your device
- **Copy Magnet Link**: Copies the magnet link to clipboard for use in your torrent client

## Technical Details

### How It Works
Since nyaa.si doesn't offer an official public API, Flyaa reverse-engineers the website interface:
- Makes HTTP GET requests to `https://nyaa.si/` with search parameters
- Parses the HTML response to extract torrent data
- Displays results in a clean, scrollable list

### Data Extracted
For each torrent, Flyaa retrieves:
- Title
- View link (to nyaa.si page)
- Torrent download link
- Magnet link
- File size
- Upload date
- Seeders count
- Leeches count
- Uploader name (extracted from title)

### Dependencies
- `http`: ^1.1.0 - For making HTTP requests
- `html`: ^0.15.0 - For parsing HTML responses
- `shared_preferences`: ^2.0.0 - For persistent storage of favorite uploaders

## Configuration

The app uses the following nyaa.si search parameters by default:
- Categories: `0_0` (all categories)
- Filters: `0` (no filters)
- Sort: By date (descending)

These can be modified in the source code if needed.

## FAQ

### Q: Is this app legal?
A: Flyaa is a neutral torrent client that provides access to publicly available torrents from nyaa.si. Users are responsible for ensuring their downloads comply with local laws and copyright regulations.

### Q: Why no login/authentication?
A: As requested during development, login/authentication was deemed unnecessary for basic browsing and downloading since nyaa.si allows public access to most content.

### Q: Can I request new features?
A: Yes! Feel free to open an issue or submit a pull request.

### Q: The app isn't showing results
A: Try:
- Checking your internet connection
- Verifying your search term
- Trying a different search term
- Confirming nyaa.si is accessible in your region

## Troubleshooting

### Common Issues
- **No results**: Check internet connection and search terms
- **Parse errors**: The site structure may have changed; report issues
- **Download fails**: Ensure you have a torrent client installed to handle .torrent files/magnet links

### Reporting Bugs
Please include:
- Device model and Android version
- Steps to reproduce the issue
- Screenshots if applicable
- Any error messages shown

## Development

### Project Structure
```
lib/
  main.dart          # Main application code
```

### Contributing
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is open source and available under the MIT License.

## Acknowledgments
- nyaa.si for providing the torrent indexing service
- The Flutter team for the excellent cross-platform framework
- Open source packages: http, html, shared_preferences

---

**Note**: This app is for educational purposes. Always respect copyright laws and download only content you have the right to access.
