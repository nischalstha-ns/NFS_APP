# Admin Panel Setup

## Overview
The admin panel is restricted to users with admin role. Currently, only `nischal@gmail.com` is configured as an admin user.

## How it works
1. User roles are stored in Firestore under the `users` collection
2. Each user document has a `role` field (`admin` or `user`)
3. Admin access is checked using the `AdminService` class
4. The admin dashboard is protected by the `AdminGuard` widget

## Admin User Setup
The admin user is automatically initialized when the app starts. The system will:
1. Check if `nischal@gmail.com` exists in Firestore
2. Create or update the user document with admin role
3. Allow access to admin panel for this user only

## Accessing Admin Panel
1. Login with `nischal@gmail.com`
2. Go to Profile page
3. Click on "Admin Panel" button (only visible to admin users)
4. Admin dashboard will load with full access

## Database Structure
```
users (collection)
├── nischal@gmail.com (document)
│   ├── uid: "user_uid"
│   ├── email: "nischal@gmail.com"
│   ├── role: "admin"
│   └── displayName: "Admin User"
└── other@email.com (document)
    ├── uid: "user_uid"
    ├── email: "other@email.com"
    ├── role: "user"
    └── displayName: "Regular User"
```

## Security Features
- Role-based access control
- Admin guard protection
- Firestore security rules should be configured
- Only authenticated users can access user data
- Admin role verification on every admin action