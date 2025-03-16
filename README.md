# TV Show Tracker

A simple web application to search and track information about TV shows using the OMDB API.

## Features

- Search for TV shows
- View detailed information about shows
- Responsive design
- Modern UI with Bootstrap

## Prerequisites

- Java 11 or higher
- Maven
- OMDB API key (get one at http://www.omdbapi.com/apikey.aspx)

## Setup

1. Clone this repository
2. Get an API key from OMDB (http://www.omdbapi.com/apikey.aspx)
3. Open `src/main/java/com/tvtracking/App.java` and replace `YOUR_OMDB_API_KEY` with your actual API key
4. Build the project:
   ```bash
   mvn clean package
   ```
5. Run the application:
   ```bash
   java -jar target/tv-tracking-app-1.0-SNAPSHOT.jar
   ```
6. Open your browser and navigate to `http://localhost:4567`

## Usage

1. Enter a TV show name in the search box
2. Click "Search" to see results
3. Click on any show to view detailed information

## Technologies Used

- Spark Java (Web Framework)
- FreeMarker (Template Engine)
- Bootstrap 5 (UI Framework)
- OMDB API (TV Show Data)
- Gson (JSON Processing) 