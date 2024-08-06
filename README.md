![Logo](https://github.com/KodeInnovate-WorkSpace/s1media_app/blob/master/assets/full_logo.png)
# S1Media Flutter App
 Welcome to the S1Media Flutter App repository! This app is developed by Kodeinnovate Solutions and is maintained for future development. This README provides an overview of the project, setup instructions, and other necessary details to help future developers continue the project seamlessly.

## Table of Contents
- Project Overview
- Features
- Technologies Used
- File Structure
- Color Reference
- Setup Instructions
- Credentials Setup

# Project Overview
The S1Media Flutter App is designed to provide a seamless login experience using email OTP authentication. This app utilizes Firebase for database storage and GetX for state management. Custom fonts Satoshi and CabinetGrotesk are used for an enhanced UI.

# Features
- **Email OTP Authentication**: Users can log in using an OTP sent to their email.
- **State Management**: `GetX` is used for efficient state management.
- **Firebase Integration**: Firebase is used to store user details and other data.

# Technologies Used
- Flutter
- GetX for state management
- Firebase for database
- Gmail SMTP Client for sending OTP emails
- Custom Fonts: Satoshi and CabinetGrotesk

# File Structure
```
|-- assets/
|-- controller/       # Logic controllers
|-- model/            # Data models
|-- screens/          # UI and user interaction screens
|-- pubspec.yaml
|-- README.md
```
# Color Reference

| Color             | Hex                                                                |
| ----------------- | ------------------------------------------------------------------ |
| Primary Color | ![#dc3545](https://via.placeholder.com/10/dc3545?text=+) #dc3545 |
| Secondary Color | ![#ffffff](https://via.placeholder.com/10/ffffff?text=+) #ffffff |
| Form Fill Color | ![#f7f8fa](https://via.placeholder.com/10/f7f8fa?text=+) #f7f8fa |
| Fomr Hint Color | ![#dcdcdc](https://via.placeholder.com/10/dcdcdc?text=+) #dcdcdc |
| Form Border Color | ![#E8E9EB](https://via.placeholder.com/10/E8E9EB?text=+) #E8E9EB |

# Setup Instructions
1. Clone the Repository
    ```
    git clone https://github.com/your-username/s1media-flutter-app.git
    cd s1media-flutter-app
    ```
2. Install Dependencies
```flutter pub get```
3. Run the App
```flutter run```

# Credentials Setup
The credentials for email OTP authentication are stored in the assets/.env file, which is not uploaded to GitHub for security reasons. Future developers need to create this file with the appropriate credentials.

1. Create the `.env` File

- Navigate to the assets directory.
- Create a file named `.env`.
- Add the necessary credentials in the following format: <br/>
   `EMAIL="<Email from which mails will be sent for otp>"`<br/>
   `APP_PASSWORD="<App password for the gmail account>"`<br/>

2. Configure Firebase
- Ensure that the Firebase project is set up and the google-services.json file is added to the android/app directory.