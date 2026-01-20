# Habit Bucket

A clean, local-first habit tracking app focused on **consistency over pressure**. Build daily, weekly, and monthly habits with streak tracking, smart reminders, and progress analytics.

## Features

### Habit Management
- Create **daily**, **weekly**, and **monthly** habits
- One-tap check-in to mark habits complete
- Automatic period detection based on frequency
- Soft-delete with archive support

### Streak Tracking
- Current and longest streak calculation per habit
- Frequency-aware consecutive period detection
- Visual streak indicators in the UI

### Smart Reminders
- **Random reminders**: Get nudged at a random time between 8am-8pm
- **Fixed time reminders**: Set a specific daily reminder time
- Notifications scheduled 7 days ahead
- Timezone-aware scheduling

### Stats Dashboard
- **Consistency percentage** over customizable ranges (7/30/90 days, all time)
- **Check-ins count** and **missed moments**
- **Per-habit statistics** with completion rates
- **Best habit** identification
- **Longest streak** across all habits
- Visual consistency ring
- Pull-to-refresh support

### User Experience
- Onboarding flow for first-time users
- **Light/Dark/Auto theme** (auto switches at 7am/7pm)
- Week start preference (Monday/Sunday)
- Skeleton loading states
- Compassionate, guilt-free messaging

## Tech Stack

### Frontend
- **Flutter** - Cross-platform UI framework
- **Riverpod** - Reactive state management
- **Google Fonts** (Outfit, Manrope)
- **FontAwesome Icons**

### Local Database
- **Drift (SQLite)** - Type-safe local persistence
- Local-first architecture for offline support
- Automatic schema migrations

### Backend
- **Supabase** - Authentication and cloud sync
- PostgreSQL database with RLS policies
- Background sync (planned)

### Notifications
- **flutter_local_notifications** - Local push notifications
- **timezone** - Timezone-aware scheduling
- **flutter_timezone** - Device timezone detection

### Monetization
- **Google Mobile Ads** - AdMob integration

## Architecture

```
lib/
├── core/
│   ├── local/           # Drift database & repositories
│   ├── notifications/   # Notification service & scheduling
│   ├── repositories/    # Data access layer
│   └── stats/           # Streak calculation logic
├── providers/           # Riverpod providers
├── screens/
│   ├── auth/            # Sign in/up, auth gate
│   ├── habits/          # Daily, weekly, monthly views
│   ├── onboarding/      # First-time user flow
│   ├── settings/        # Profile, theme, notifications
│   └── stats/           # Analytics dashboard
├── theme/               # App theming
├── utils/               # Colors, spacing, fonts
└── widgets/             # Reusable UI components
```

### Data Flow
1. **Local-first**: All data stored in SQLite via Drift
2. **Reactive UI**: Riverpod watches database streams
3. **Background sync**: Changes sync to Supabase (planned)

### Database Schema
- **Profile**: User settings (name, week start preference)
- **Habits**: Habit definitions (title, frequency, reminder settings)
- **Completions**: Check-in records with period keys
- **SyncState**: Sync metadata for cloud sync

## Philosophy

> "Consistency, not pressure. You're building something real."

Most habit apps overwhelm users with guilt-driven UX. Habit Bucket takes a different approach:

- **No guilt**: Missed moments are "still part of the journey"
- **Simple**: Fast habit creation, no manual resets
- **Supportive**: Compassionate copy throughout the app
- **Focused**: Track what matters, skip the noise

## Status

Actively under development. Core habit tracking, streaks, and stats are complete.

### Completed
- Daily/weekly/monthly habit tracking
- Streak calculation and display
- Stats dashboard with aggregates
- Smart notification scheduling
- Theme support (auto/light/dark)
- User authentication
- Local database with migrations

### In Progress
- Background cloud sync
- Weekly/monthly reminder time selection

### Planned
- Habit insights and charts
- Year-end Wrapped experience
- Habit categories/tags
- Export functionality

---

Built with focus, momentum, and consistency in mind.
