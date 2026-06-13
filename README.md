# AI Trading Bot — Flutter Dashboard

Mobilni/desktop dashboard za crypto trading bota. Potpuno odvojen od Python serverskog koda u `../bot/`.

## Preduslovi

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.16+

## Pokretanje

```bash
cd aplikacija
flutter pub get
flutter run
```

Za Windows desktop:

```bash
flutter run -d windows
```

Za web:

```bash
flutter run -d chrome
```

## Struktura

```
lib/
├── main.dart
├── theme/
│   ├── app_colors.dart
│   └── app_theme.dart
├── screens/
│   └── dashboard_screen.dart
└── widgets/
    ├── glow_card.dart
    ├── dashboard_header.dart
    ├── pnl_row.dart
    ├── chart_section.dart
    ├── open_positions_card.dart
    ├── trade_history_card.dart
    ├── action_buttons_row.dart
    ├── risk_management_panel.dart
    ├── diagnostics_panel.dart
    └── bottom_panels_row.dart
```

## Boje

| Token | Hex |
|-------|-----|
| Background | `#020617` |
| Cards | `#0f172a` |
| Blue | `#3b82f6` |
| Purple | `#8b5cf6` |
| Green | `#22c55e` |
| Red | `#ef4444` |
| Text | `#e2e8f0` |
