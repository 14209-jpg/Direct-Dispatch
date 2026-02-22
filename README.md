# Direct Dispatch MVP

> Customer requests a service → Admin sees it → Admin chats with customer →  
> Admin dispatches workers → Job done → Cash payment face-to-face.

No online payments. No agents. Just the core loop — clean and fast.

---

## App Flow

```
[Customer]                        [Admin]
    │                                │
    │  1. Submit request             │
    │ ──────────────────────────────►│
    │                                │  2. Admin sees it on dashboard
    │                                │     (with customer name + phone)
    │                                │
    │  3. Admin opens chat           │
    │ ◄──────────────────────────────│
    │  "Hi! Tell me more about       │
    │   the work needed…"            │
    │                                │
    │  4. Customer replies in chat   │
    │ ──────────────────────────────►│
    │                                │  5. Admin confirms details,
    │                                │     saves notes + worker count
    │                                │
    │  5. Admin goes to labour hub,  │
    │     picks workers, dispatches  │
    │                                │
    │  6. Status updates in real-time│
    │ ◄──────────────────────────────│
    │  "Workers dispatched!"         │
    │                                │
    │         [Workers arrive]       │
    │         [Job complete]         │
    │         [Cash paid F2F]        │
    │                                │
    │  7. Admin marks Completed      │
    │ ◄──────────────────────────────│
```

---

## Roles

| Role | What they do |
|------|-------------|
| **Customer** | Self-registers, submits requests, chats with admin, tracks status |
| **Admin** | Created manually in Firebase, sees all requests, chats, updates statuses |

> **To create an admin account:** Register normally in the app, then go to  
> Firebase Console → Firestore → `users` collection → find the document →  
> change `role` from `"customer"` to `"admin"`.

---

## Request Lifecycle

```
pending → reviewing → confirmed → dispatched → in_progress → completed
                                                           ↘ cancelled
```

| Status | Meaning |
|--------|---------|
| `pending` | Just submitted by customer |
| `reviewing` | Admin opened and is reviewing |
| `confirmed` | Admin spoke to customer, going to get workers |
| `dispatched` | Workers picked up and on their way |
| `in_progress` | Workers on site, job underway |
| `completed` | Done. Cash paid face-to-face |
| `cancelled` | Cancelled for any reason |

---

## Getting Started

### 1 — Prerequisites
- Flutter 3.22+
- Firebase project with: **Firestore**, **Authentication (email/password)**, **FCM**

### 2 — Clone & install
```bash
git clone https://github.com/YOUR_ORG/direct-dispatch.git
cd direct-dispatch
flutter pub get
```

### 3 — Environment
```bash
cp .env.example .env
# Fill in your Firebase values from Firebase Console
```

### 4 — Code generation (run once, re-run after model changes)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5 — Firebase setup
```bash
# Install Firebase CLI
npm install -g firebase-tools
firebase login
firebase use --add   # choose your project

# Deploy Firestore rules
firebase deploy --only firestore:rules
```

### 6 — Run
```bash
flutter run                    # Android/iOS device or emulator
flutter run -d chrome          # Admin dashboard via Flutter Web
```

---

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isAuth()  { return request.auth != null; }
    function uid()     { return request.auth.uid; }
    function role()    {
      return get(/databases/$(database)/documents/users/$(uid())).data.role;
    }
    function isAdmin() { return role() == 'admin'; }

    // Users: read own, admin reads all
    match /users/{userId} {
      allow read, write: if isAuth() && uid() == userId;
      allow read: if isAuth() && isAdmin();
    }

    // Requests: customer creates/reads own; admin reads/writes all
    match /requests/{reqId} {
      allow create: if isAuth();
      allow read:   if isAuth() && (
        resource.data.customerId == uid() || isAdmin()
      );
      allow update: if isAuth() && isAdmin();
    }

    // Conversations: only participants
    match /conversations/{convId} {
      allow read, write: if isAuth() &&
        uid() in resource.data.participantIds;

      match /messages/{msgId} {
        allow read, create: if isAuth() &&
          uid() in get(
            /databases/$(database)/documents/conversations/$(convId)
          ).data.participantIds;
      }
    }
  }
}
```

---

## Extending Later (when you grow)

| Feature | What to add |
|---------|-------------|
| Field Agent app | Add `role: 'agent'` + agent dashboard (already stubbed in constants) |
| Photo uploads | Add `firebase_storage` + `image_picker` to `create_request_screen.dart` |
| Voice messages | Add `record` + `just_audio` packages to chat |
| Online payment | Add Stripe `payment_intent` to `requests_repository.dart` |
| Worker tracking | Add `google_maps_flutter` + GPS location updates |
| Ratings | Add `rating` field to completed requests |
| Admin web panel | `flutter run -d chrome` already works — add admin-only routes |

---

## Testing

```bash
flutter test test/unit/          # Model & logic tests
flutter test test/integration/   # Full request → chat flow (no real Firebase)
flutter test --coverage          # With coverage report
```