# Prila Pilot App — Claude Code instructions

Flutter app for drivers ("Pilots") who accept rides.

Shared workspace rules (single source of truth):

@../.cursor/rules/00-prila-core.mdc
@../.cursor/rules/01-server-driven.mdc
@../.cursor/rules/10-flutter.mdc
@../.cursor/rules/40-ride-domain.mdc

Docs: `../docs/ARCHITECTURE.md`, `../docs/API_CONTRACT.md`, `../docs/CONFIG_KEYS.md`, `../docs/UI_REFERENCE.md`, `../docs/DECISIONS.md`

## Commands (after Phase 3 scaffold)

```bash
# Run / build — production only for now (no dev/staging flavors yet)
flutter run --dart-define-from-file=env/prod.json
flutter analyze
flutter test
flutter build apk --dart-define-from-file=env/prod.json
flutter build ipa --dart-define-from-file=env/prod.json

# Codegen
dart run build_runner build --delete-conflicting-outputs
```

App ID: `com.prila.pilot` · Display name: **Prila Pilot** · Languages: EN + TE.

Never commit `.env`, keystores, `google-services.json`, `GoogleService-Info.plist`, or service-account files. Commit `env/*.example.json` instead.

Pilot-only: background / foreground-service location only while online; justify for store review.
