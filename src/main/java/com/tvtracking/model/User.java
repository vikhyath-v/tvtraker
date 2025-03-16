package com.tvtracking.model;

public class User {
    private String id;
    private String email;
    private String username;
    private String password;

    public User(String email, String username, String password) {
        this.id = java.util.UUID.randomUUID().toString();
        this.email = email;
        this.username = username;
        this.password = password;
    }

    // Getters
    public String getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    // Setters
    public void setEmail(String email) {
        this.email = email;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }
} 