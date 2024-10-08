# 🧠 Zylofite - Your Personal AI Assistant 🤖

Zylofite is a personal AI assistant app built using **Flutter** 🚀 and powered by **Gemini AI** for intelligent conversation 💬 and image analysis 📸. The app provides a private and secure user experience by storing chat data locally 🔒 while using **Firebase** 🔥 for authentication and managing user details.

## ✨ Features

- **💬 Conversational AI**: Powered by the Gemini AI model, providing intelligent responses and engaging conversations.
- **📸 Image Analysis**: Zylofite can analyze images and provide insights based on the content.
- **🔒 Private Chats**: All user chats are stored locally, ensuring privacy and security.
- **🔑 Firebase Authentication**: Secure login and registration using Firebase authentication.
- **🗂️ User Data Storage**: User details are securely stored in Firebase for easy access and management.
- **🔐 Account Management**:
  - **Login Page**: Allows existing users to log into their accounts securely.
  - **Registration Page**: New users can sign up by providing their details, which are stored in Firebase.
  - **Password Recovery**: Users can reset their password through Firebase’s secure password recovery options.

## 🛠️ Tech Stack

- **Flutter**: Frontend development framework. ![Flutter](https://img.shields.io/badge/Flutter-blue?logo=flutter&logoColor=white)
- **Gemini AI**: For conversational AI and image analysis.
- **Firebase**:
  - Authentication: For secure user login, registration, and password recovery. ![Firebase](https://img.shields.io/badge/Firebase-yellow?logo=firebase&logoColor=white)
  - Firestore: For storing and managing user data.
- **Local Storage**: Ensuring that chats are private and stored locally on the user's device.

## ⚙️ Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/zylofite.git
   ```

2. Navigate to the project directory:
   ```bash
   cd zylofite
   ```

3. Install the dependencies:
   ```bash
   flutter pub get
   ```

4. Set up the environment variables. Create a `.env` file in the root of your project and add the following keys:

   ```env
   GEMINI_API_KEY=your-gemini-api-key
   FIREBASE_API_KEY=your-firebase-api-key
   FIREBASE_AUTH_DOMAIN=your-firebase-auth-domain
   FIREBASE_PROJECT_ID=your-firebase-project-id
   FIREBASE_STORAGE_BUCKET=your-firebase-storage-bucket
   FIREBASE_MESSAGING_SENDER_ID=your-firebase-messaging-sender-id
   FIREBASE_APP_ID=your-firebase-app-id
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## 🔥 Firebase Setup

1. Set up a Firebase project from the [Firebase Console](https://console.firebase.google.com/).
2. Add the Firebase configuration to your Flutter app:
   - **Android**: Add your Firebase `google-services.json` in the `/android/app` directory.
   - **iOS**: Add your Firebase `GoogleService-Info.plist` in the `/ios/Runner` directory.
3. Enable Firebase Authentication and Firestore in your Firebase project.
4. In **Firebase Authentication**, enable **Email/Password** for secure login, registration, and password recovery.

## 🧑‍💻 Usage

- **🔐 Login/Sign Up**: 
  - New users can register using Firebase Authentication on the **Registration Page**.
  - Existing users can log in securely using the **Login Page**.
- **🔄 Password Recovery**: 
  - If users forget their password, they can use the **Password Recovery** feature to reset it via Firebase's email recovery system.
- **💬 Start a Chat**: Once logged in, users can start a conversation with Zylofite and access AI-driven responses.
- **📸 Image Analysis**: Users can upload an image, and Zylofite will analyze and provide insights.
- **🔒 Data Privacy**: All conversations are saved locally, ensuring user data privacy.

## 🏗️ Built App

You can download and try the built version of Zylofite from the following sources:

- **APK for Android**: [Download APK](https://www.mediafire.com/file/4pq4qu5f70qruh0/Zyfolite.apk/file)


## 🤝 Contributing

We welcome contributions to Zylofite! Please follow these steps to contribute:

1. Fork the project 🍴.
2. Create a new branch for your feature (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request 🔄.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This version includes sections for **Login**, **Registration**, and **Password Recovery**, as well as how to integrate these using Firebase. Let me know if you need any more updates!
