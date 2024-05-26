# GameBox-MVVM
## About
GameBox-MVVM is an iOS application that allows you to track your favorite video games and view their details. The app is built using the MVVM (Model-View-ViewModel) architecture and integrates CoreData and API services to provide a seamless user experience.
## Project Tech Stack
Xcode: Version 15.0.2
Language: Swift
Minimum iOS Version: 14.0
Design Pattern: MVVM
Dependency Manager: Swift Package Manager
Dependencies: Lottie
Style Guide: Consistent styling across all files
Made With ❤️
## Features
View Game List: Browse a list of popular games and view detailed information about each game.
Add to Favorites: Add your favorite games to a favorites list and manage it.
Search Games: Easily find specific games using the search functionality.
API Integration: Fetch game information and details via an API.
CoreData Integration: Store your favorite games locally.
Custom Views: Utilize custom views for better UI/UX.
Some Highlighted Things

- ✅ Storyboard Design

- ✅ Organized folder structure

- ✅ Readability with MVVM architecture

- ✅ Custom Views

- ✅ Consistent styling across all files

## MVVM Architecture
![mvvm-pattern](https://github.com/dtemizyurek/GameBox/assets/52003954/231189b6-7106-4a7a-9b99-57b6528348cb)
### Model
- GameDetail: Represents game details fetched from the API.
- GamesUIModel: Represents game data to be displayed in the user interface.
### ViewModel
- HomeViewModel: Manages the game list on the home screen.
- FavoriteGamesViewModel: Manages the favorite games list.
- DetailedGamesViewModel: Manages the details of a selected game.
### View
- HomeViewController: Displays the main game list.
- FavoriteGamesViewController: Displays the list of favorite games.
- DetailedGamesViewController: Displays details of a selected game.
- GamesCollectionViewCell: Cells used to display games in a list.
### Helpers
- APIRequest: Manages API calls.
- CoreDataManager: Manages CoreData operations.
- LoadingShowable: A protocol to manage the loading indicator.
## ScreenShots
<img width="170" src="https://github.com/dtemizyurek/GameBox/assets/52003954/f79af06f-efd5-4766-88a9-ed2d53dc925b"> 
<img width="170" src="https://github.com/dtemizyurek/GameBox/assets/52003954/a1c9f908-21b6-4c6e-a09a-ed6e5abc723e"> 
<img width="170" src="https://github.com/dtemizyurek/GameBox/assets/52003954/629f6581-bc5e-45ef-b9e8-b7e9faeae7f1"> 
<img width="170" src="https://github.com/dtemizyurek/GameBox/assets/52003954/e7cc18c1-7884-4fbc-895d-92e41a997b12"> 

## Video Demo

https://github.com/dtemizyurek/GameBox/assets/52003954/dd33802f-02f7-4812-a719-af9d14de9de9

## Installation
Clone the Repository:

- sh
- copy code
- git clone https://github.com/dtemizyurek/GameBox-MVVM.git
- Open the Project:
- Open the GameBox-MVVM.xcodeproj file with Xcode.

## Build the Project:
Ensure all dependencies are fetched and the project builds successfully.

## Run the App:
Select your target device or simulator and hit Run in Xcode.

## Usage

- Search Games: Use the search bar on the home screen to search for games.
- Add to Favorites: Click the favorite button on a game’s detail page to add it to your favorites.
- View Favorites: View your favorite games in the Favorites tab.
Contributing

- To contribute, please fork the repository and create a pull request with your changes. For major changes, please open an issue first to discuss what you would like to change.
