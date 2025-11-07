# Auth Flow Project

This project demonstrates a complete authentication flow in Flutter using Riverpod, GoRouter, Dio, and other modern packages.

## Getting Started

### Prerequisites

- Flutter SDK
- An editor like VS Code or Android Studio

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/auth_flow_project.git
   ```
2. Navigate to the project directory:
   ```sh
   cd auth_flow_project
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```

### Configuration

This project uses a `.env` file for environment variables.

1. Create a `.env` file in the root of the project. You can copy the example file:
   ```sh
   cp .env.example .env
   ```
2. Open the `.env` file and set the required variables:
   - `API_BASE_URL`: The base URL of your backend API.
   - `APP_SCHEME`: The custom URL scheme for deep linking (e.g., `myapp`).

### Running the App

```sh
flutter run
```

### Running Build Runner

To watch for file changes and automatically generate code, run:
```sh
dart run build_runner watch --delete-conflicting-outputs
```
