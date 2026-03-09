# kigali_city_directory

A new Flutter project.


## Getting Started

This project is a starting point for a Flutter application.
Kigali City Directory – README

Project Overview

The Kigali City Directory is an app that helps people find and explore Kigali. It is built using Flutter. Provides a simple way to discover public services and leisure locations.

The app lets users view details add, edit and delete listings. They can also bookmark places for access.

The app uses Firebase Firestore for storing and retrieving data. It also uses Firebase Authentication to manage users.

## Features

### User Authentication

Users can sign up log in and log out.

* They can create a profile, with a display name.

### My Listings

* Users can add listings with details.

* Listings automatically get latitude and longitude based on the address.

* Users can. Delete their own listings.

* All listings update in time on the app.

### Listing. Filter

* Users can search listings by name.

* They can filter listings by category.

### Map Integration

* Listings are shown on a map.

* Users can navigate from listing details to the map view.

### Bookmarks

* Users can bookmark places.

* Bookmarked places are stored per user.

### Settings

* Users can manage account details.

* They can. Disable push notifications and location-based notifications.

* They can view app information and privacy policy.

## Firestore Database Structure

The Firestore database has collections and documents.

### 1. Users Collection

* Collection: users

* Document ID: uid

Fields:

* uid: string

* email: string

* displayName: string

* notificationsEnabled: bool

* locationNotificationsEnabled: bool

* createdAt: timestamp

Subcollection: bookmarks

* Document ID: Place name

* Fields:

+ placeName: string

+ addedAt: timestamp

### 2. Listings Collection

* Collection: listings

* Document ID: Auto-generated

Fields:

* name: string

* description: string

* category: string

* address: string

* phone: string

* latitude:

* longitude: double

* createdBy: string

* timestamp: timestamp

## Listings Model

A Listing is represented as a model class.

## State Management

The app uses Provider and StreamBuilder for real-time state management.

### User Authentication State

* FirebaseAuth tracks the logged-in user.

* Profile and preferences are fetched using an async call.

### Listings State

* StreamBuilder listens to Firestore listings collection.

* Any addition, update or deletion triggers a real-time UI update.

## Design Trade-offs and Technical Challenges

### Automatic Latitude & Longitude

* Challenge: Users had to enter coordinates

* Solution: Integrated geocoding package.

### Real-Time Updates

* Challenge: Displaying changes instantly.

* Solution: Used StreamBuilder on Firestore collections.

### Minimal Dependencies

* Decision: Avoided heavy state management libraries.

* Benefit: Lightweight and easy to maintain.

## User. Security

* Firebase Security Rules enforce user data protection.

### Firestore Security Rules Example

```

rules_version = '2';

service cloud.firestore {

match /databases/{database}/documents {

match /listings/{listingId} {

allow read: if true;

allow write: if request.auth != null && request.auth.uid == resource.data.createdBy;

}

match /users/{userId} {

allow read write: if request.auth != null && request.auth.uid == userId;

match /bookmarks/{bookmarkId} {

allow read write: if request.auth !=. & Request.auth.uid == userId;

}

}

}

}

```


A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
