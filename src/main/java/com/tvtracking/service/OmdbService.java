package com.tvtracking.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.tvtracking.model.Show;

public class OmdbService {
    private static final String OMDB_API_KEY = "5e7a5d56"; // Replace with your OMDB API key
    private static final String BASE_URL = "http://www.omdbapi.com/";
    
    // TMDB API configuration
    private static final String TMDB_API_KEY = "41a38e4f4abff2783f71594079662d92";
    private static final String TMDB_BASE_URL = "https://api.themoviedb.org/3";
    private static final String TMDB_IMAGE_BASE_URL = "https://image.tmdb.org/t/p/w500";

    // Cache for popular and top rated shows
    private static final Map<String, CachedShow> showCache = new ConcurrentHashMap<>();
    private static final long CACHE_DURATION = TimeUnit.HOURS.toMillis(1); // Cache for 1 hour
    
    private static class CachedShow {
        final Show show;
        final long timestamp;
        
        CachedShow(Show show) {
            this.show = show;
            this.timestamp = System.currentTimeMillis();
        }
        
        boolean isExpired() {
            return System.currentTimeMillis() - timestamp > CACHE_DURATION;
        }
    }
    
    // Popular shows of the month (manually curated list)
    private static final List<String> POPULAR_SHOW_IDS = Arrays.asList(
    "tt11280740",  
        "tt6741278", // Monarch: Legacy of Monsters
        "tt11041332", // The Curse 
        "tt13406094",
        "tt14688458"
    );
    
    // Top rated shows of all time
    private static final List<String> TOP_RATED_SHOW_IDS = Arrays.asList(
        "tt0903747", // Breaking Bad
        "tt0185906", // Band of Brothers
         // Planet Earth
        "tt0306414", // The Wire
        "tt0417299", // Avatar: The Last Airbender
        "tt0141842"  // The Sopranos
    );

    public List<Show> searchShows(String query) {
        if (query == null || query.trim().isEmpty()) {
            return new ArrayList<>();
        }

        try {
            String searchUrl = String.format("%s?apikey=%s&s=%s&type=series",
                    BASE_URL, OMDB_API_KEY, query.replace(" ", "+"));

            String response = fetchData(searchUrl);
            JsonObject jsonResponse = com.google.gson.JsonParser.parseString(response).getAsJsonObject();
            
            if (jsonResponse.has("Error")) {
                System.err.println("OMDB API Error: " + jsonResponse.get("Error").getAsString());
                return new ArrayList<>();
            }
            
            JsonArray shows = jsonResponse.getAsJsonArray("Search");
            List<Show> showList = new ArrayList<>();

            if (shows != null) {
                for (int i = 0; i < shows.size(); i++) {
                    try {
                        JsonObject show = shows.get(i).getAsJsonObject();
                        showList.add(new Show(
                            show.get("imdbID").getAsString(),
                            show.get("Title").getAsString(),
                            show.get("Year").getAsString(),
                            show.has("Poster") ? show.get("Poster").getAsString() : null
                        ));
                    } catch (Exception e) {
                        System.err.println("Error parsing show: " + e.getMessage());
                    }
                }
            }

            return showList;
        } catch (Exception e) {
            System.err.println("Error searching shows: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public Show getShowDetails(String id) {
        // Check cache first
        CachedShow cachedShow = showCache.get(id);
        if (cachedShow != null && !cachedShow.isExpired()) {
            return cachedShow.show;
        }

        try {
            String showUrl = String.format("%s?apikey=%s&i=%s",
                    BASE_URL, OMDB_API_KEY, id);

            String response = fetchData(showUrl);
            JsonObject show = com.google.gson.JsonParser.parseString(response).getAsJsonObject();

            if (show.has("Error")) {
                throw new RuntimeException(show.get("Error").getAsString());
            }

            Show showDetails = new Show(
                show.get("imdbID").getAsString(),
                show.get("Title").getAsString(),
                show.get("Year").getAsString(),
                show.has("Poster") ? show.get("Poster").getAsString() : null,
                show.get("Plot").getAsString(),
                show.get("Genre").getAsString(),
                show.get("Director").getAsString(),
                show.get("Actors").getAsString(),
                show.get("Runtime").getAsString(),
                show.get("imdbRating").getAsString()
            );

            // Fetch actor images from TMDB
            List<String> actorImages = fetchActorImagesFromTMDB(showDetails.getTitle(), showDetails.getActors());
            showDetails.setActorImages(actorImages);

            // Cache the show
            showCache.put(id, new CachedShow(showDetails));
            return showDetails;
        } catch (Exception e) {
            System.err.println("Error fetching show details for ID " + id + ": " + e.getMessage());
            throw new RuntimeException("Failed to fetch show details: " + e.getMessage());
        }
    }

    private List<String> fetchActorImagesFromTMDB(String showTitle, String actorsString) {
        List<String> actorImages = new ArrayList<>();
        String[] actors = actorsString.split(", ");
        
        try {
            // First, search for the TV show in TMDB
            String searchUrl = String.format("%s/search/tv?api_key=%s&query=%s", 
                    TMDB_BASE_URL, TMDB_API_KEY, showTitle.replace(" ", "+"));
            
            String searchResponse = fetchData(searchUrl);
            JsonObject searchResult = com.google.gson.JsonParser.parseString(searchResponse).getAsJsonObject();
            
            if (searchResult.has("results") && searchResult.getAsJsonArray("results").size() > 0) {
                int showId = searchResult.getAsJsonArray("results").get(0).getAsJsonObject().get("id").getAsInt();
                
                // Get credits for the show
                String creditsUrl = String.format("%s/tv/%d/credits?api_key=%s", 
                        TMDB_BASE_URL, showId, TMDB_API_KEY);
                
                String creditsResponse = fetchData(creditsUrl);
                JsonObject credits = com.google.gson.JsonParser.parseString(creditsResponse).getAsJsonObject();
                
                if (credits.has("cast")) {
                    JsonArray cast = credits.getAsJsonArray("cast");
                    
                    // Create a map of TMDB cast members
                    Map<String, String> castProfiles = new ConcurrentHashMap<>();
                    for (JsonElement element : cast) {
                        JsonObject castMember = element.getAsJsonObject();
                        String name = castMember.get("name").getAsString();
                        String profilePath = castMember.has("profile_path") && !castMember.get("profile_path").isJsonNull() 
                                ? TMDB_IMAGE_BASE_URL + castMember.get("profile_path").getAsString() 
                                : "";
                        castProfiles.put(name.toLowerCase(), profilePath);
                    }
                    
                    // Match our actors with TMDB cast
                    for (String actor : actors) {
                        boolean found = false;
                        // Try to find an exact match first
                        if (castProfiles.containsKey(actor.toLowerCase())) {
                            actorImages.add(castProfiles.get(actor.toLowerCase()));
                            found = true;
                        } else {
                            // Try to find a partial match
                            for (Map.Entry<String, String> entry : castProfiles.entrySet()) {
                                if (entry.getKey().contains(actor.toLowerCase()) || 
                                    actor.toLowerCase().contains(entry.getKey())) {
                                    actorImages.add(entry.getValue());
                                    found = true;
                                    break;
                                }
                            }
                        }
                        
                        if (!found) {
                            // If no match found, add empty string for fallback avatar
                            actorImages.add("");
                        }
                    }
                }
            }
            
            // If we couldn't find images for all actors, fill the rest with empty strings
            while (actorImages.size() < actors.length) {
                actorImages.add("");
            }
            
            return actorImages;
        } catch (Exception e) {
            System.err.println("Error fetching actor images from TMDB: " + e.getMessage());
            // Return empty strings for all actors if TMDB fetch fails
            for (int i = 0; i < actors.length; i++) {
                actorImages.add("");
            }
            return actorImages;
        }
    }

    private String fetchData(String url) {
        try {
            java.net.URL apiUrl = new java.net.URL(url);
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) apiUrl.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            if (conn.getResponseCode() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
            }

            java.io.BufferedReader br = new java.io.BufferedReader(
                    new java.io.InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;

            while ((line = br.readLine()) != null) {
                response.append(line);
            }

            br.close();
            conn.disconnect();
            return response.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching data: " + e.getMessage());
        }
    }

    public List<Show> getPopularShows() {
        List<Show> popularShows = new ArrayList<>();
        for (String id : POPULAR_SHOW_IDS) {
            try {
                Show show = getShowDetails(id);
                popularShows.add(show);
            } catch (Exception e) {
                System.err.println("Error fetching popular show with ID " + id + ": " + e.getMessage());
            }
        }
        return popularShows;
    }

    public List<Show> getTopRatedShows() {
        List<Show> topRatedShows = new ArrayList<>();
        for (String id : TOP_RATED_SHOW_IDS) {
            try {
                Show show = getShowDetails(id);
                topRatedShows.add(show);
            } catch (Exception e) {
                System.err.println("Error fetching top rated show with ID " + id + ": " + e.getMessage());
            }
        }
        return topRatedShows;
    }
} 