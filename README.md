# Giga Image Upload

An example image upload app, support Android and Web.

# Deeplink

`adb shell am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "gigaupload://view/file/1665834384878"`

# Show Image from another domain on Flutter for Web

## Solution

Solution 1 : Run specific web-renderer

`flutter run -d chrome --web-renderer html`

`flutter build web --web-renderer canvaskit`

Solution 2 : Setup CORS for Cloud Storage

- Goto console => https://console.cloud.google.com/
- Write cors.json

```json
[
  {
    "origin": ["*"],
    "method": ["GET"],
    "maxAgeSeconds": 3600
  }
]
```

- and run this command

  `gsutil cors set cors.json gs://<your-bucket-name>.appspot.com`

Ref

- https://stackoverflow.com/questions/65653801/flutter-web-cant-load-network-image-from-another-domain

- https://stackoverflow.com/questions/66531190/flutter-web-canvaskit-renderer-not-showing-network-images
