package com.tvtracking.model;

public class Discussion {
    private int id;
    private String showId;
    private String username;
    private String comment;
    private String timestamp;

    public Discussion(String showId, String username, String comment) {
        this.showId = showId;
        this.username = username;
        this.comment = comment;
        this.timestamp = java.time.LocalDateTime.now().toString();
    }

    public Discussion(int id, String showId, String username, String comment, String timestamp) {
        this.id = id;
        this.showId = showId;
        this.username = username;
        this.comment = comment;
        this.timestamp = timestamp;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getShowId() {
        return showId;
    }

    public void setShowId(String showId) {
        this.showId = showId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }
} 