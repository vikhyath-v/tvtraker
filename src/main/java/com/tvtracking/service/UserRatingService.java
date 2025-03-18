package com.tvtracking.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tvtracking.model.UserRating;

public class UserRatingService {
    private static final String DB_URL = "jdbc:sqlite:tv_tracker.db";

    public UserRatingService() {
        initializeDatabase();
    }

    private void initializeDatabase() {
        try (Connection conn = DriverManager.getConnection(DB_URL);
             Statement stmt = conn.createStatement()) {
            
            // Create user_ratings table if it doesn't exist
            String sql = "CREATE TABLE IF NOT EXISTS user_ratings (" +
                        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                        "user_id INTEGER NOT NULL," +
                        "username TEXT NOT NULL," +
                        "show_id TEXT NOT NULL," +
                        "rating INTEGER NOT NULL," +
                        "comment TEXT," +
                        "timestamp TEXT NOT NULL," +
                        "UNIQUE(user_id, show_id)" +
                        ")";
            stmt.execute(sql);
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize database: " + e.getMessage());
        }
    }

    public void addOrUpdateRating(UserRating rating) {
        String sql = "INSERT OR REPLACE INTO user_ratings (user_id, username, show_id, rating, comment, timestamp) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DriverManager.getConnection(DB_URL);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, rating.getUserId());
            pstmt.setString(2, rating.getUsername());
            pstmt.setString(3, rating.getShowId());
            pstmt.setInt(4, rating.getRating());
            pstmt.setString(5, rating.getComment());
            pstmt.setString(6, rating.getTimestamp());
            
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to add/update rating: " + e.getMessage());
        }
    }

    public UserRating getUserRating(int userId, String showId) {
        String sql = "SELECT * FROM user_ratings WHERE user_id = ? AND show_id = ?";
        
        try (Connection conn = DriverManager.getConnection(DB_URL);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setString(2, showId);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                UserRating rating = new UserRating(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("show_id"),
                    rs.getInt("rating"),
                    rs.getString("comment")
                );
                rating.setId(rs.getInt("id"));
                rating.setTimestamp(rs.getString("timestamp"));
                return rating;
            }
            
            return null;
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get user rating: " + e.getMessage());
        }
    }

    public double getAverageRating(String showId) {
        String sql = "SELECT AVG(rating) as avg_rating FROM user_ratings WHERE show_id = ?";
        
        try (Connection conn = DriverManager.getConnection(DB_URL);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, showId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
            
            return 0.0;
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get average rating: " + e.getMessage());
        }
    }

    public List<UserRating> getShowRatings(String showId) {
        String sql = "SELECT * FROM user_ratings WHERE show_id = ? ORDER BY timestamp DESC";
        List<UserRating> ratings = new ArrayList<>();
        
        try (Connection conn = DriverManager.getConnection(DB_URL);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, showId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                UserRating rating = new UserRating(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("show_id"),
                    rs.getInt("rating"),
                    rs.getString("comment")
                );
                rating.setId(rs.getInt("id"));
                rating.setTimestamp(rs.getString("timestamp"));
                ratings.add(rating);
            }
            
            return ratings;
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get show ratings: " + e.getMessage());
        }
    }
} 