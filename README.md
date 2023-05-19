# Bipolar Disorder Application

This repository contains the source code for a bipolar disorder application designed to assist patients in managing their condition. The application allows users to track their daily mood, view their mood history, access a list of therapies, reserve therapy sessions, perform breathing exercises, watch meditation videos, and communicate with doctors. The frontend is built using SwiftUI, while the backend is developed using Node.js, and the database used is MongoDB.

## Features

The application provides the following features:

1. **Mood Tracking**: Users can enter their daily mood, allowing them to keep track of their emotional state over time.

2. **Mood History**: Users can view a list of their recorded moods, enabling them to observe patterns and monitor their progress.

3. **Therapy List**: A comprehensive list of therapies is available to users, providing information about various treatments.

4. **Therapy Reservation**: Users can reserve therapy sessions based on their preferences, allowing them to schedule appointments conveniently.

5. **Breathing Exercises**: The application offers guided breathing exercises to help users manage stress and anxiety.

6. **Meditation Videos**: Users can access a collection of meditation videos for relaxation and mental well-being.

7. **Doctor Interaction**: Doctors have the ability to add, modify, and delete therapies in the application. They can also accept therapy reservations made by patients.

8. **User Profiles**: Both patients and doctors have dedicated profiles within the application, allowing them to manage their personal information.

## Technology Stack

The application is built using the following technologies:

- **Frontend**: SwiftUI
- **Backend**: Node.js
- **Database**: MongoDB

## Installation

To run the application locally, follow these steps:

1. Clone the repository:

```bash
git clone https://github.com/sawssen-gharbi/BackToLifeFrontIOS
```

2. Navigate to the project directory:

```bash
cd BackToLifeFrontIOS
```

3. Install dependencies:

```bash
npm install
```

4. Set up the database:

   - Install and configure MongoDB on your local machine.
   - Create a MongoDB database for the application.

5. Configure the backend:

   - Rename the `.env.example` file to `.env`.
   - Update the `.env` file with your MongoDB connection details.

6. Run the backend server:

```bash
npm run dev
```

7. Open a new terminal window and navigate to the project directory again:

```bash
cd BackToLifeFrontIOS
```

8. Run the frontend:

```bash
open BipolarDisorderApp.xcodeproj
```

9. Build and run the application from Xcode.

## Contribution

Contributions to the application are welcome. If you'd like to contribute, please follow these steps:

1. Fork the repository.

2. Create a new branch:

```bash
git checkout -b feature/your-feature-name
```

3. Make your changes and commit them:

```bash
git commit -m "Add your commit message here"
```

4. Push your changes to your forked repository:

```bash
git push origin feature/your-feature-name
```

5. Create a pull request on the original repository.

Please ensure that your contributions adhere to the coding standards, and include any necessary tests and documentation.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

If you have any questions or need further assistance, please feel free to contact the project maintainer at sawssen.gharbi@esprit.tn

We hope this application helps individuals with bipolar disorder manage their condition effectively. Thank you for using our application!

