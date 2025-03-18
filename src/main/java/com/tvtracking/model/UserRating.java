package com.tvtracking.model;

public class UserRating {
    private int id;
    private int userId;
    private String username;
    private String showId;
    private int rating;
    private String comment;
    private String timestamp;

    public UserRating(int userId, String username, String showId, int rating, String comment) {
        this.userId = userId;
        this.username = username;
        this.showId = showId;
        this.rating = rating;
        this.comment = comment;
        this.timestamp = java.time.LocalDateTime.now().toString();
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getShowId() { return showId; }
    public void setShowId(String showId) { this.showId = showId; }
    
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    
    public String getTimestamp() { return timestamp; }
    public void setTimestamp(String timestamp) { this.timestamp = timestamp; }
} 