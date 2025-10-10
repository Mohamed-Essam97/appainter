![logo](images/logo.png)

[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/zeshuaro/appainter?color=orange&label=version)](https://github.com/zeshuaro/appainter/releases)
[![Website](https://img.shields.io/website?url=https%3A%2F%2Fzeshuaro.github.io%2Fappainter%2F)](https://zeshuaro.github.io/appainter/)
[![GitHub license](https://img.shields.io/github/license/zeshuaro/appainter)](https://github.com/zeshuaro/appainter/blob/main/LICENSE)
[![GitHub Actions](https://github.com/zeshuaro/appainter/actions/workflows/github-actions.yml/badge.svg?branch=main&event=push)](https://github.com/zeshuaro/appainter/actions/workflows/github-actions.yml?query=event%3Apush+branch%3Amain)
[![codecov](https://codecov.io/gh/zeshuaro/appainter/branch/main/graph/badge.svg?token=4YM0WZFH3I)](https://codecov.io/gh/zeshuaro/appainter)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/558114f6d82045e1a319d0c9a3ef72a0)](https://app.codacy.com/gh/zeshuaro/appainter/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
[![style: flutter_lints](https://img.shields.io/badge/style-flutter__lints-4BC0F5.svg)](https://pub.dev/packages/flutter_lints)

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/zeshuaro)
[![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/zeshuaro)
[![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/zeshuaro)
[![LiberaPay](https://img.shields.io/badge/Liberapay-F6C915?style=for-the-badge&logo=liberapay&logoColor=black)](https://liberapay.com/zeshuaro/)
[![Patreon](https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white)](https://patreon.com/zeshuaro)
[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/JoshuaTang)

# Appainter - Material Theme Editor & Generator

A comprehensive material theme editor and generator for Flutter that allows you to configure, customize, and preview the overall visual theme of your material app with real-time feedback and advanced customization options.

![Appainter Screenshot](images/screenshot.png)

## 🚀 Features

### 🎨 **Theme Customization**

- **Color Themes**: Customize primary, secondary, surface, and background colors
- **Typography**: Choose from Google Fonts and configure text styles
- **Component Themes**: Customize buttons, cards, app bars, tabs, and more
- **Material 3 Support**: Full support for Material Design 3 specifications

### 🔧 **Advanced Configuration**

- **App Variations**: Configure UI component variations for different app sections
- **Real-time Preview**: See changes instantly in the mobile preview
- **Export/Import**: Save and load theme configurations
- **Cross-platform**: Available for Web, macOS, Windows, and Linux

### 📱 **Mobile Preview**

- **Live Preview**: Real-time preview of your theme on different UI components
- **Multiple Tabs**: Preview buttons, inputs, selections, text, and variations
- **Responsive Design**: See how your theme looks across different screen sizes

### 🎯 **UI Component Variations**

Configure different visual styles for:

- **Feeds Cards**: Social media feed layouts
- **Facility Request Cards**: Service request interfaces
- **Gate Pass Cards**: Access control interfaces
- **Invitation Cards**: Event and community invitations
- **Community Request Cards**: Community management interfaces
- **Dues Cards**: Payment and billing interfaces
- **Profile Components**: User profile layouts
- **Navigation Elements**: Tabs and selectors

## 🌐 Getting Started

### Web Application

Access Appainter directly through your browser:
**[https://zeshuaro.github.io/appainter/](https://zeshuaro.github.io/appainter/)**

### Desktop Applications

Download the desktop version for your operating system:
**[Download from GitHub Releases](https://github.com/zeshuaro/appainter/releases)**

- 🍎 **macOS**: `.dmg` installer
- 🪟 **Windows**: `.exe` installer
- 🐧 **Linux**: `.AppImage` or `.deb` package

## 📖 How to Use Appainter

### 1. **Basic Theme Configuration**

#### **Color Customization**

1. Navigate to the **Color Theme** section
2. Choose your primary and secondary colors using the color picker
3. Adjust surface, background, and error colors as needed
4. See real-time changes in the preview panel

#### **Typography Setup**

1. Go to the **Text Theme** section
2. Select a font family from Google Fonts
3. Configure text sizes for headlines, body text, and captions
4. Preview text styles in the mobile preview

#### **Component Styling**

1. Visit individual component sections (Buttons, Cards, App Bar, etc.)
2. Customize colors, shapes, and sizes
3. Configure elevation and shadows
4. Test interactions in the preview

### 2. **App Variations Configuration**

#### **Setting Up Variations**

1. Navigate to the **App Config** section
2. Click on the **Variations** tab
3. For each component type, select from available variations:
   - `v1`, `v2`, `v3` - Different visual styles
   - Each variation corresponds to a PNG preview image

#### **Adding Variation Images**

1. Create a folder: `assets/variations/` in your project
2. Add PNG images with naming convention:
   ```
   assets/variations/
   ├── feedsCardType_v1.png
   ├── feedsCardType_v2.png
   ├── facilityRequestCardType_v1.png
   ├── gatePassCardType_v1.png
   └── ... (other variation images)
   ```
3. Images will automatically appear in the preview

#### **Variation Types Available**

- **feedsCardType**: Social feed layouts
- **facilityRequestCardType**: Service request cards
- **gatePassCardType**: Access control cards
- **invitationCardType**: Event invitation cards
- **communityRequestCardType**: Community management cards
- **duesCardWidgetType**: Payment/billing cards
- **profileHeaderType**: User profile headers
- **filledTabType**: Filled tab navigation
- **borderTabType**: Outlined tab navigation

### 3. **Preview and Testing**

#### **Mobile Preview Tabs**

- **Buttons**: Test button styles and interactions
- **Inputs**: Preview text fields and form elements
- **Selections**: Check checkboxes, radio buttons, and switches
- **Text**: Review typography and text styles
- **Variations**: See your configured UI component variations

#### **Real-time Updates**

- All changes are reflected immediately in the preview
- Switch between light and dark themes
- Test different screen orientations

### 4. **Exporting Your Theme**

#### **JSON Export**

1. Click the **Export** button in the top toolbar
2. Save the generated JSON file
3. The file contains all your theme configurations

#### **App Config Export**

1. Export includes both theme data and app variations
2. Use the exported configuration in your Flutter app

## 🛠️ Using the Generated Theme

### **Installation**

1. Add `json_theme` dependency to your `pubspec.yaml`:

   ```yaml
   dependencies:
     json_theme: ^7.0.0+3
   ```

2. Add your theme file to assets:
   ```yaml
   flutter:
     assets:
       - assets/appainter_theme.json
   ```

### **Implementation**

```dart
import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: theme,
    );
  }
}
```

### **Using Custom Fonts**

If you've selected a custom font:

1. Download the font from [Google Fonts](https://fonts.google.com/)
2. Add to your `pubspec.yaml`:
   ```yaml
   flutter:
     fonts:
       - family: Montserrat
         fonts:
           - asset: fonts/Montserrat-Regular.ttf
   ```

For complete implementation examples, see [USAGE.md](USAGE.md).

## 🔧 Development

### **Prerequisites**

- Flutter SDK (latest stable version)
- Dart SDK
- Git

### **Setup**

1. Fork and clone the repository:

   ```bash
   git clone https://github.com/your-username/appainter.git
   cd appainter
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Generate code:

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the application:
   ```bash
   flutter run
   ```

### **Project Structure**

```
lib/
├── app_config/          # App configuration and variations
├── basic_theme/         # Basic theme components
├── advanced_theme/      # Advanced theme features
├── color_theme/         # Color customization
├── text_theme/          # Typography configuration
├── theme_preview/       # Mobile preview components
├── home/               # Main application screens
└── widgets/            # Reusable UI components
```

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Support

If you find Appainter helpful, consider supporting the project:

- ⭐ Star the repository
- 🐛 Report bugs and request features
- 💰 Sponsor the project through GitHub Sponsors
- ☕ Buy the maintainer a coffee

## 📞 Contact & Links

- **Website**: [https://zeshuaro.github.io/appainter/](https://zeshuaro.github.io/appainter/)
- **Repository**: [https://github.com/zeshuaro/appainter](https://github.com/zeshuaro/appainter)
- **Issues**: [GitHub Issues](https://github.com/zeshuaro/appainter/issues)
- **Discussions**: [GitHub Discussions](https://github.com/zeshuaro/appainter/discussions)

---

**Made with ❤️ for the Flutter community**
