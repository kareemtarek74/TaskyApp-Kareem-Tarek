# Kareem Tarek – Calories Tracker App

## 📌 Overview
A modern and user-friendly meal tracking app that allows users to add, view, search, sort, and delete meals. The app integrates with [TheMealDB API](https://www.themealdb.com/api.php) and includes a sleek bottom navigation bar for intuitive navigation between different features.

## 🌟 What's New?
- ✅ Completely revamped **UI/UX** for a modern and smooth experience
- ✅ Introduced a **Bottom Navigation Bar** to navigate easily between:
  - Local Meals
  - Meal Search (API)
  - Meal Categories (API)
- ✅ Smooth transitions and better state handling
- ✅ Enhanced empty/error/loading states with friendly visuals

## 🔧 Tech Stack
- **Framework:** Flutter
- **State Management:** Flutter Bloc
- **Local Storage:** Hive
- **Networking:** Dio
- **Language:** Dart

## 📜 Features

### 🔸 Local Meal Tracking
- Add a meal (name, calories, time, photo)
- View daily meals with total calorie count
- Sort meals by name, calories, or time
- Delete meal entries
- Store meals locally using Hive

### 🔸 TheMealDB API Integration
- Search meals by name (`/api/json/v1/1/search.php?s=`)
- View meal details including ingredients, area, instructions, etc.
- Filter meals by category (`/api/json/v1/1/filter.php?c=`)
- View all available categories

### 🔸 UI/UX Enhancements
- Beautiful and clean UI design
- Shimmer loading effects for better UX
- Friendly empty states and retryable error widgets
- Bottom Navigation for better feature organization
- Dark/light-friendly color contrast

## 🛠 Installation & Running the App

### Prerequisites
- Flutter SDK: [Installation Guide](https://docs.flutter.dev/get-started/install)
- Android Studio or VS Code
- Emulator or physical device

### Steps
```bash
git clone https://github.com/kareemtarek74/calories_tracker
cd calories_tracker
flutter pub get
flutter run
```

## 📱 APK Download
Installable APK:  
🔗 https://drive.google.com/file/d/19H1ppR5DKKStf-6cGb219YCIJvmhuRJi/view?usp=sharing

## 📏 Responsiveness Approach
- Used `MediaQuery`, `Expanded`, and `Flexible` for adaptive layouts
- Responsive UI across screen sizes and orientations
- Scrollable content to handle overflow elegantly

## 📂 Project Structure

```
calories_tracker/
├── lib/
│   ├── Features/
│   │   ├── Local Meals/
│   │   ├── Meal DB/
│   │   └── Main/
│   ├── core/
│   ├── injection_container.dart
│   └── main.dart
├── assets/
├── test/
└── pubspec.yaml
```

## 💡 Notes
- Built using Clean Architecture (Data → Domain → Presentation)
- Bloc/Cubit used for state management
- Modularized UI for reusability and readability
- Meals and categories cached with Hive for performance

---

### 📧 Contact
If you have any questions or feedback, feel free to reach out:

📩 **Email**: Kareemtarek015@gmail.com  
📱 **Phone**: +201275603507
