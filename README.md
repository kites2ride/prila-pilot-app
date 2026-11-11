# Prila Pilot

Flutter app for drivers. App ID: `com.prila.pilot`. Languages: EN + TE. **Production config only**.

```bash
flutter pub get
flutter run --dart-define-from-file=env/prod.json
flutter analyze
```

KYC uploads use backend R2 presign (`POST /uploads/presign`). Configure R2 in backend `.env` for real uploads.
