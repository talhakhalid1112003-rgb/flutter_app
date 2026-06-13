**Smart Sports Scorer**

A modern Flutter + Firebase based sports scoring application that allows users to manage, score, and track Cricket and Badminton matches in real-time. The application provides team management, tournament management, live scoring, match history, and user authentication with a clean and responsive UI.

**Features**
1. Authentication
2. Email & Password Login
3. Email & Password Registration
4. Forgot Password
5. Google Sign-In
6. Firebase Authentication
7. User-specific data access

**Sport Selection**
After login, users can select:
1. Cricket
2. Badminton
Each sport operates independently with its own scoring system, history, teams, and tournaments.

**Cricket Module**
1. Match Management
2. Create New Match
3. Team Selection
4. Toss Selection
5. Bat / Bowl Selection
6. Overs Selection
7. Live Score Tracking

**Live Scoring**
1. Runs Management
2. Wickets Tracking
3. Overs Tracking
4. Match Status Updates
5. Team Scoreboard

**Tournament Management**
1. Create Tournament
2. Tournament Tracking
3. Match Progression

**History**
1. Match History
2. Tournament History
3. Winner Tracking

**Badminton Module**
Match Formats

**Singles**
1. Player vs Player

**Doubles**
1. Team vs Team
2. Team selection from Firestore

**Point Systems**
Supported Match Formats:
1. 11 Points
2. 15 Points
3. 21 Points

**Live Match Scoring**

1. Team A Score Counter
2. Team B Score Counter
3. Increment Score
4. Decrement Score
5. Automatic Winner Detection
6. Round Tracking
7. Best of 3 Match Logic
8. Match Completion Detection

**Tournament System**

1. Select 4 Teams
2. Automatic Match Pairing
3. Semi-Final 1
4. Semi-Final 2
5. Final Match
6. Champion Selection

**Tournament History**

1. Teams Participated
2. Semi Final Results
3. Final Result
4. Tournament Champion
5. Tournament Date

**Team Management**
Cricket Teams
1. Create Team
2. Edit Team
3. Delete Team
4. Manage Players

**Badminton Teams**
Firestore Collection
Badminton_Teams

**Document Structure**
{
  "teamName": "NTU",
  "players": ["Talha", "Ali"],
  "userId": "firebase-user-id"
}

**Features**
1. Create Team
2. Store Players
3. Edit Team
4. Delete Team
5. Team Selection in Matches
6. Team Selection in Tournaments

**History Management**
Match History Stores
1. Team Names
2. Player Names
3. Match Type
4. Winner
5. Score
6. Date
**Tournament History**

1. Tournament Teams
2. Match Results
3. Champion
4. Date

**Firebase Integration**
Firebase Authentication

Used for:
1. Login
2. Registration
3. Google Sign-In
4. User Management

**Cloud Firestore**

Used for:
1. Collections
2. users
3. matches
4. teams
5. players
6. Badminton_Teams
7. Badminton_Match_History
8. Badminton_Tournament_History

**User Isolation**

Every user only sees:
1. Their own teams
2. Their own matches
3. Their own tournaments
4. Their own history
Data is filtered using: userId
This ensures privacy and secure access.

**Architecture**
The project follows a Feature-First Clean Architecture structure.

lib/
│
├── core/
│   ├── router/
│   ├── theme/
│   ├── providers/
│
├── features/
│   │
│   ├── auth/
│   ├── cricket/
│   ├── badminton/
│   ├── teams/
│   ├── tournaments/
│   ├── history/
│
├── shared/
│
└── main.dart

**Technologies Used**

**Frontend**
1. Flutter
2. Dart
3. Material Design

**Backend**
1. Firebase

**Database**
1. Cloud Firestore

**Authentication**
1. Firebase Authentication
2. Google Sign-In

**State Management**
1. Riverpod

**Navigation**
1. GoRouter

**Data Models**
1. Freezed
2. Json Serializable

**UI Features**
1. Dark Theme UI
2. Responsive Design
3. Mobile Friendly Layout
4. Reusable Components
5. Modern Dashboard Design
6. Bottom Navigation
7. Real-Time Score Updates

**Dependencies**
1. flutter_riverpod
2. firebase_core
3. firebase_auth
4. cloud_firestore
5. google_sign_in
6. go_router
7. freezed
8. json_serializable

**Supported Platforms**
1. Android
2. Web
3. iOS (Structure Ready)

**Future Enhancements**
1. Live Online Scoring
2. Match Sharing
3. Push Notifications
4. Player Statistics
5. AI Match Analysis
6. Leaderboards
7. Tournament Analytics
8. PDF Match Reports

**Developer**
Muhammad Talha Khalid
Ali ul Murtaza Alvi
Project
**Smart Sports Scorer**
