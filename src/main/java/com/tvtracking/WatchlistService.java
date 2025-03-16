package com.tvtracking;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

import com.google.gson.JsonObject;

public class WatchlistService {
    private static final ConcurrentHashMap<String, List<JsonObject>> userWatchlists = new ConcurrentHashMap<>();
    
    public static void addToWatchlist(String userId, JsonObject show) {
        userWatchlists.computeIfAbsent(userId, k -> new ArrayList<>()).add(show);
    }
    
    public static void removeFromWatchlist(String userId, String imdbId) {
        List<JsonObject> watchlist = userWatchlists.get(userId);
        if (watchlist != null) {
            watchlist.removeIf(show -> show.get("imdbID").getAsString().equals(imdbId));
        }
    }
    
    public static List<JsonObject> getWatchlist(String userId) {
        return userWatchlists.getOrDefault(userId, new ArrayList<>());
    }
    
    public static boolean isInWatchlist(String userId, String imdbId) {
        List<JsonObject> watchlist = userWatchlists.get(userId);
        if (watchlist != null) {
            return watchlist.stream()
                .anyMatch(show -> show.get("imdbID").getAsString().equals(imdbId));
        }
        return false;
    }
} 