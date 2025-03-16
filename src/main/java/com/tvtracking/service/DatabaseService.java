package com.tvtracking.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DatabaseService {
    private static final String DB_URL = "jdbc:sqlite:tvtracking.db";
    private static DatabaseService instance;

    private DatabaseService() {
        initializeDatabase();
    }

    public static DatabaseService getInstance() {
        if (instance == null) {
            instance = new DatabaseService();
        }
        return instance;
    }

    private void initializeDatabase() {
        try {
            // Create database and tables if they don't exist
            Class.forName("org.sqlite.JDBC");
            try (Connection conn = DriverManager.getConnection(DB_URL)) {
                // Read and execute schema.sql
                String schema = readSchemaFile();
                try (Statement stmt = conn.createStatement()) {
                    for (String sql : schema.split(";")) {
                        if (!sql.trim().isEmpty()) {
                            stmt.execute(sql);
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error initializing database: " + e.getMessage());
            throw new RuntimeException("Failed to initialize database", e);
        }
    }

    private String readSchemaFile() {
        try {
            StringBuilder schema = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(getClass().getResourceAsStream("/db/schema.sql")))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    schema.append(line).append("\n");
                }
            }
            return schema.toString();
        } catch (Exception e) {
            throw new RuntimeException("Failed to read schema.sql", e);
        }
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL);
    }

    // User operations
    public void createUser(String username, String email, String passwordHash) throws SQLException {
        String sql = "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, passwordHash);
            pstmt.executeUpdate();
        }
    }

    public Map<String, Object> getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("id", rs.getInt("id"));
                    user.put("username", rs.getString("username"));
                    user.put("email", rs.getString("email"));
                    user.put("password_hash", rs.getString("password_hash"));
                    return user;
                }
            }
        }
        return null;
    }

    // Watchlist operations
    public void addToWatchlist(int userId, String showId, String title, String year, 
                             String poster, String plot, String rating, String genre) throws SQLException {
        String sql = "INSERT INTO watchlist (user_id, show_id, title, year, poster, plot, rating, genre) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, showId);
            pstmt.setString(3, title);
            pstmt.setString(4, year);
            pstmt.setString(5, poster);
            pstmt.setString(6, plot);
            pstmt.setString(7, rating);
            pstmt.setString(8, genre);
            pstmt.executeUpdate();
        }
    }

    public void removeFromWatchlist(int userId, String showId) throws SQLException {
        String sql = "DELETE FROM watchlist WHERE user_id = ? AND show_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, showId);
            pstmt.executeUpdate();
        }
    }

    public List<Map<String, Object>> getWatchlist(int userId) throws SQLException {
        String sql = "SELECT * FROM watchlist WHERE user_id = ?";
        List<Map<String, Object>> watchlist = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> show = new HashMap<>();
                    show.put("id", rs.getInt("id"));
                    show.put("show_id", rs.getString("show_id"));
                    show.put("title", rs.getString("title"));
                    show.put("year", rs.getString("year"));
                    show.put("poster", rs.getString("poster"));
                    show.put("plot", rs.getString("plot"));
                    show.put("rating", rs.getString("rating"));
                    show.put("genre", rs.getString("genre"));
                    watchlist.add(show);
                }
            }
        }
        return watchlist;
    }

    public boolean isInWatchlist(int userId, String showId) throws SQLException {
        String sql = "SELECT 1 FROM watchlist WHERE user_id = ? AND show_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, showId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }
} 