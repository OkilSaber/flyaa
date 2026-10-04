# Flyaa

A beautiful, intuitive Flutter Android client for browsing and downloading torrents from nyaa.si.

## 📱 Features

- **🔍 Smart Torrent Search**: Search nyaa.si by keyword
- **🎯 Uploader-Specific Filtering**: Use @username or username: prefix
- **💾 Persistent Bookmarking**: Save favorite uploaders
- **📥 Multiple Download Options**: Download .torrent or copy magnet links
- **📋 Comprehensive Torrent Info**: Size, date, seeders, leechers
- **🖥️ Clean Material Design**: Modern, responsive interface
- **📊 Dual-Tab Interface**: Search and Favorites tabs
- **⚡ Fast & Lightweight**: Optimized performance
- **🔒 Privacy Focused**: No accounts or tracking
- **🌐 Offline Favorites**: Access favorites offline

## 🛠️ Technical Implementation

### Key Technologies
- **Framework**: Flutter 3.13+ with Dart 3
- **State Management**: Provider/Riverpod
- **Networking**: `http`: ^1.1.0
- **HTML Parsing**: `html`: ^0.15.0
- **Local Storage**: `shared_preferences`: ^2.0.0

### API Interaction (Reverse Engineered)
Since nyaa.si lacks an official public API, Flyaa implements:
- **Search Endpoint**: `GET https://nyaa.si/?q={query}&c=0_0&f=0&p={page}`
- **Response Parsing**: Extracts data from `.torrentlist tbody tr` rows
- **Data Models**: Structured `TorrentResult` class with factory methods

### Performance Optimizations
- `ListView.builder` for lazy loading
- Debounced search (300ms delay)
- Request cancellation for outdated searches
- Proper memory management

## 📦 Installation

### Option 1: Install from APK (Recommended)
1. Download latest APK from [Releases](../../releases)
2. Transfer APK to Android device
3. Install APK (enable "Install from unknown sources" if needed)
4. Launch Flyaa and start searching!

### Option 2: Build from Source
> **Prerequisites**: Flutter SDK installed

1. `git clone https://github.com:OkilSaber/flyaa.git && cd flyaa`
2. `flutter pub get`
3. Verify `pubspec.yaml` includes `http`, `html`, `shared_preferences`
4. `flutter build apk --release`
5. Install generated APK

### Option 3: Development Build
```bash
flutter run
```
Use `r` for hot reload or `R` for hot restart.

## 🔧 Configuration

### Default Search Parameters
- **Categories**: `0_0` (All categories)
- **Filters**: `0` (No filters)
- **Results Per Page**: 25
- **Sort**: Date descending (newest first)

### Advanced Settings (via UI)
- Request timeout (default 15s)
- User agent customization
- Maximum results per search
- Thumbnail display (when available)

## 📱 Platform Support

### Currently Supported
- **Android**: 5.0 (API 21) and above
- ARMv7, ARM64, x86, x86_64
- Phones, tablets, foldables, ChromeOS

### Planned/Experimental
- iOS (requires testing)
- Web (responsive layout)
- Desktop (Linux/macOS/Windows)

## ⚖️ Legal & Ethical Considerations

### Copyright Compliance
Flyaa provides access to publicly available torrents. Users must:
- Verify rights to download specific content
- Comply with local copyright laws
- Respect content creators' intellectual property
- Understand that torrenting copyrighted material without permission may be illegal

### Disclaimer
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## 🤝 Contributing

We welcome contributions! To contribute:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/name`)
3. Make your changes
4. Ensure proper testing
5. Commit changes (`git commit -m 'feat: add feature'`)
6. Push to branch (`git push origin feature/name`)
7. Open a Pull Request

### Development Guidelines
- Follow Dartfmt conventions (`flutter format`)
- Use descriptive, consistent names
- Comment complex logic
- Add unit tests for new functionality
- Update documentation as needed

## 🐛 Troubleshooting

### Common Issues
- **"No results"**: Check internet, nyaa.si accessibility, search terms
- **App crashes**: Update, clear cache/data, reinstall
- **Slow search**: Check connection, increase timeout, off-peak hours
- **Download fails**: Ensure torrent client, verify associations, try magnet link
- **Access errors**: May require VPN for regional restrictions

### Getting Help
When reporting issues, include:
- Device model, Android version, Flyaa version
- Clear, numbered steps to reproduce
- Expected vs actual behavior
- Screenshots/videos when applicable
- Error messages or crash details
- Network info (Wi-Fi/mobile, VPN usage)

## 📚 Dependencies

### Core Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| flutter | SDK | UI framework |
| http | ^1.1.0 | HTTP requests |
| html | ^0.15.0 | HTML parsing |
| shared_preferences | ^2.0.0 | Local storage |
| flutter_lints | ^6.0.0 | Code analysis |

### Development Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| flutter_test | SDK | Testing framework |
| pedantic | ^1.11.1 | Additional lints |

## 📜 License

MIT License

Copyright (c) 2026 OkilSaber

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## 📞 Contact & Support

### Official Channels
- **Issue Tracker**: [GitHub Issues](../../issues)
- **Discussions**: [GitHub Discussions](../../discussions)
- **Email**: flyaa-app@protonmail.com

### Community
- **Reddit**: r/FlyaaApp
- **Discord**: discord.gg/flyaa
- **Twitter/X**: @FlyaaApp

---

*Last updated: October 4, 2026*  
*Version: 1.0.0*  
*Built with ❤️ using Flutter and Dart*  

> **Flyaa** - Search smarter, download easier, enjoy freely.  
> *Torrenting should be simple. We make it simple.*