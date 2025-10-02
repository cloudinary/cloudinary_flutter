# Memories App

A beautiful photo memories app built with Flutter, showcasing Cloudinary SDK integration for cloud-based image storage and management.

## Features

- 📸 Select multiple photos from gallery
- ☁️ Cloud storage with Cloudinary
- 🖼️ Optimized image delivery and transformations
- 📝 Create named memory collections
- 💾 Persistent data storage
- 📅 Automatic date tracking for each memory
- 🗑️ Delete memories and cloud images
- 🌐 Seamless image upload and retrieval
- 🔒 Secure image storage with environment variables

## Cloudinary Integration

This app demonstrates real-world usage of the Cloudinary SDK for Flutter:

- **Image Upload**: Upload photos directly to Cloudinary cloud storage
- **Optimized Delivery**: Automatic image optimization and responsive delivery
- **Image Transformations**: Support for on-the-fly image transformations
- **Secure Configuration**: Environment-based API credentials management
- **Cloud Management**: Delete images from cloud storage when memories are removed

## Screenshots

Place screenshots under `assets/screenshots/` in the project root. Example files:


Preview:

| ![Home screen](screenshots/home.jpg) | ![Add memory](screenshots/add.jpg) | ![Photo viewer](screenshots/view.jpg) |
|:---:|:---:|:---:|
| Home screen | Add memory | Photo viewer |

Recommended: 1080×1920 PNG or JPEG, optimized for mobile.

## Environment Setup

1. Create a `.env` file in the project root:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
CLOUDINARY_UPLOAD_PRESET=your_upload_preset
```

2. Add `.env` to your `.gitignore` to keep credentials secure

3. Get your Cloudinary credentials from [Cloudinary Dashboard](https://cloudinary.com/console)

## Platform Setup

### Android
Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS
Add to `ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to select photos for your memories</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take photos for your memories</string>
```

## How to Use

1. **Set up Cloudinary**: Configure your `.env` file with Cloudinary credentials
2. **Run the app**: `flutter run`
3. **Add a memory**: Tap the + button
4. **Select photos**: Tap "Add Photos" to pick from gallery (uploads to Cloudinary)
5. **Name your memory**: Enter a title for your collection
6. **Save**: Tap "Save" to create the memory
7. **View photos**: Images are loaded from Cloudinary with optimized delivery
8. **Delete**: Remove memories (also deletes images from Cloudinary cloud)

## Dependencies

- `cloudinary_sdk`: Cloudinary SDK for Flutter - cloud image storage
- `flutter_dotenv`: Environment variable management
- `image_picker`: Photo selection from gallery
- `path_provider`: File system access
- `intl`: Date formatting
- `shared_preferences`: Local data persistence
- `http`: Network requests

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Set up your `.env` file with Cloudinary credentials
4. Run the app with `flutter run`

For help with Cloudinary integration, visit the [Cloudinary Documentation](https://cloudinary.com/documentation).

For Flutter development, view the [Flutter documentation](https://docs.flutter.dev/).
