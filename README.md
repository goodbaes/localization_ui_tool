# Localization UI Tool

## Description

**Localization UI Tool** is a Flutter desktop application designed to simplify the management of localization files in ARB (Application Resource Bundle) format. It provides a convenient interface for adding, editing, and validating localization keys and their translations.

## Architecture

The project is divided into four main modules:

*   **`core`**: Contains data models, repository interfaces, and business logic (use cases).
*   **`infrastructure`**: Implements repositories, ARB file parsing, and file system interaction.
*   **`application`**: Includes BLoC/Cubit for state management, dependency injection (DI), and coordination between `core` and `presentation`.
*   **`presentation`**: Contains the Flutter UI, navigation, and the application's own localization.

## Features

*   **ARB File Management**: Loading and saving localization data from ARB files.
*   **Adding New Keys**: A convenient interface for creating new localization keys.
*   **Key and Value Validation**: Automatic validation of keys and values according to ARB format rules (e.g., disallowing `@` symbols in keys, checking for emptiness).
*   **Tracking Added Keys**: A list of keys added in the current session for quick access.
*   **Collision Detection**: Highlighting existing keys when attempting to add a duplicate.
*   **Editing Entries**: Editing translations for various locales.
*   **Settings**: Selecting the directory containing ARB files.

## Setup and Running

To run the application, you will need the Flutter SDK installed.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/goodbaes/localization_ui_tool.git
    cd localization_ui_tool
    ```
2.  **Get dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    *   **For Windows:**
        ```bash
        flutter run -d windows
        ```
    *   **For macOS:**
        ```bash
        flutter run -d macos
        ```
    *   **For Linux:**
        ```bash
        flutter run -d linux
        ```

## Building Executables

To create executable files for various platforms:

*   **For Windows:**
    ```bash
    flutter build windows
    ```
    The executable will be located at `build\windows\x64\runner\Release\localization_ui_tool.exe`. Note that the `data` folder and `.dll` files located next to the executable are also required for the application to run.

*   **For macOS:**
    ```bash
    flutter build macos
    ```
    The executable will be located at `build/macos/Build/Products/Release/localization_ui_tool.app`.

    add fullaccess to disk read/write in privacy&secure

*   **For Linux:**
    not tested yet

## Usage

### Setting up the ARB Directory

1.  Click the **gear icon** in the top right corner of the main screen.
2.  On the settings screen, click the **folder icon** next to "ARB Directory".
3.  Select the directory containing your ARB files.

### Adding a New Key

1.  On the main screen, enter the desired key in the **"New Key"** field.
2.  Click the **"Add"** button.
3.  If the key passes validation rules and does not exist, you will be redirected to the editing screen to enter translations.
4.  If the key already exists, it will be highlighted in red, and you can click on it to edit it.
5.  After successful saving on the editing screen, the new key will appear in the **"Keys added in this session"** list.

### Editing an Existing Key

*   **From the "Keys added in this session" list**: Click on a key in this list to go to its editing screen.
*   **Via the "New Key" field**: Enter an existing key in the "New Key" field and click "Add". If the key is found, it will be highlighted, and you can click on it to edit it.

### Validation

When entering keys and values, the application performs validation against the ARB format. In case of errors, appropriate messages will be displayed.


### todo 

- add plurals
- add modified files in session list on home page for quick observe