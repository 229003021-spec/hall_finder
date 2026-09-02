# Hall Finder — Flutter App

A Flutter port of the original React (HallFinderPro.jsx) hall-availability app for
SASTRA SRC, Kumbakonam. Three roles — Dean, Faculty, Student — can check which halls
are free on any floor, for any period, on any day, plus full timetables (with tap-to-reveal
professor names) for the 14 halls that have timetable data.

## Project layout

```
lib/
  main.dart                  # App root: state, live clock timer, screen routing
  theme.dart                 # Shared dark-mode color palette
  models/
    models.dart               # SlotInfo, HallInfo, ScheduleEntry
  data/
    data.dart                 # Generated from the original JSX — course names,
                               # slot timings, hall info (62 halls), timetables (14 halls)
    constants.dart             # Passkeys, day labels
    helpers.dart                # detectDay, getCurSlotId, isHallFree, floorHalls, etc.
  widgets/
    day_bar.dart, floor_bar.dart, floor_picker.dart,
    period_selector.dart, schedule_panel.dart, free_halls_view.dart
  screens/
    landing_screen.dart, login_screen.dart,
    dean_screen.dart, faculty_screen.dart, student_screen.dart
```

## Running it

You'll need the Flutter SDK installed (https://docs.flutter.dev/get-started/install).

```bash
cd hall_finder
flutter pub get
flutter run            # or: flutter run -d chrome
```

## Login passkeys (unchanged from the original)

- Dean: `DEANSRC123`
- Faculty: `FACULTY123`
- Students: no login required

## Notes on the port

- All data (course codes, hall list, timetables) was extracted programmatically from
  the original `.jsx` so nothing was hand-retyped or mistranscribed.
- The "Live" period-following behaviour, the 1-second clock tick, and the free/busy
  logic (`isHallFree`) all match the original JS 1:1.
- Since this sandbox doesn't have the Flutter SDK installed, the code was reviewed
  by hand (brace/bracket balance, constructor-to-call-site parameter matching, and
  Dart's stricter type-import rules vs JS) rather than compiled — run `flutter analyze`
  after `flutter pub get` to catch anything that slipped through.
- To add real timetables for the other ~48 halls, just add entries to the `schedule`
  map in `lib/data/data.dart` following the existing pattern.
