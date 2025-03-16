package com.tvtracking.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.tvtracking.model.Show;

public class WatchlistService {
    private final DatabaseService db;
    private final OmdbService omdbService;

    public WatchlistService() {
        this.db = DatabaseService.getInstance();
        this.omdbService = new OmdbService();
    }

    public void addToWatchlist(int userId, String showId) throws Exception {
        System.out.println("Adding show " + showId + " to watchlist for user " + userId);
        
        if (!isInWatchlist(userId, showId)) {
            Show show = omdbService.getShowDetails(showId);
            
            try {
                db.addToWatchlist(
                    userId,
                    show.getImdbID(),
                    show.getTitle(),
                    show.getYear(),
                    show.getPoster(),
                    show.getPlot(),
                    show.getImdbRating(),
                    show.getGenre()
                );
            } catch (SQLException e) {
                throw new Exception("Failed to add to watchlist: " + e.getMessage());
            }
        }
    }

    public void removeFromWatchlist(int userId, String showId) throws Exception {
        System.out.println("Removing show " + showId + " from watchlist for user " + userId);
        
        try {
            db.removeFromWatchlist(userId, showId);
        } catch (SQLException e) {
            throw new Exception("Failed to remove from watchlist: " + e.getMessage());
        }
    }

    public List<Show> getWatchlist(int userId) throws Exception {
        System.out.println("Getting watchlist for user " + userId);
        
        try {
            List<Map<String, Object>> watchlistData = db.getWatchlist(userId);
            List<Show> watchlist = new ArrayList<>();
            
            for (Map<String, Object> data : watchlistData) {
                Show show = new Show(
                    (String) data.get("show_id"),
                    (String) data.get("title"),
                    (String) data.get("year"),
                    (String) data.get("poster")
                );
                show.setPlot((String) data.get("plot"));
                show.setImdbRating((String) data.get("rating"));
                show.setGenre((String) data.get("genre"));
                watchlist.add(show);
            }
            
            return watchlist;
        } catch (SQLException e) {
            throw new Exception("Failed to get watchlist: " + e.getMessage());
        }
    }

    public boolean isInWatchlist(int userId, String showId) throws Exception {
        System.out.println("Checking if show " + showId + " is in watchlist for user " + userId);
        
        try {
            return db.isInWatchlist(userId, showId);
        } catch (SQLException e) {
            throw new Exception("Failed to check watchlist: " + e.getMessage());
        }
    }
} 