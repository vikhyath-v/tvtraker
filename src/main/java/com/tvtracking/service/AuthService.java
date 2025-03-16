package com.tvtracking.service;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class AuthService {
    private final DatabaseService db;
    private static final int ITERATIONS = 10000;
    private static final int KEY_LENGTH = 256;

    public AuthService() {
        this.db = DatabaseService.getInstance();
    }

    public String signUp(String email, String password, String username) throws Exception {
        // Check if user already exists
        String checkSql = "SELECT COUNT(*) FROM users WHERE email = ? OR username = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
            pstmt.setString(1, email);
            pstmt.setString(2, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    throw new Exception("User with this email or username already exists");
                }
            }
        }

        // Hash the password
        String[] hashParts = hashPassword(password);
        String salt = hashParts[0];
        String passwordHash = hashParts[1];
        String combinedHash = salt + ":" + passwordHash;

        // Insert new user
        String insertSql = "INSERT INTO users (email, username, password_hash) VALUES (?, ?, ?)";
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
            pstmt.setString(1, email);
            pstmt.setString(2, username);
            pstmt.setString(3, combinedHash);
            pstmt.executeUpdate();
        }

        // Return session token (using user ID and timestamp)
        return generateSessionToken(email);
    }

    public String signIn(String email, String password) throws Exception {
        String sql = "SELECT id, password_hash FROM users WHERE email = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) {
                    throw new Exception("Invalid login credentials");
                }

                String storedHash = rs.getString("password_hash");
                String[] parts = storedHash.split(":");
                String salt = parts[0];
                String passwordHash = parts[1];

                // Verify password
                if (!verifyPassword(password, salt, passwordHash)) {
                    throw new Exception("Invalid login credentials");
                }

                // Return session token
                return generateSessionToken(email);
            }
        }
    }

    public void signOut(String token) {
        // In a more complete implementation, you might want to invalidate the token
        // For now, we'll just let the session expire naturally
    }

    public Map<String, Object> getUserInfo(String token) throws Exception {
        if (token == null) {
            throw new Exception("Invalid token");
        }

        String email = validateSessionToken(token);
        String sql = "SELECT id, email, username FROM users WHERE email = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) {
                    throw new Exception("User not found");
                }

                Map<String, Object> userInfo = new HashMap<>();
                userInfo.put("id", rs.getInt("id"));
                userInfo.put("email", rs.getString("email"));
                userInfo.put("username", rs.getString("username"));
                return userInfo;
            }
        }
    }

    private String[] hashPassword(String password) throws Exception {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
        SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        byte[] hash = skf.generateSecret(spec).getEncoded();
        
        String saltStr = Base64.getEncoder().encodeToString(salt);
        String hashStr = Base64.getEncoder().encodeToString(hash);
        
        return new String[]{saltStr, hashStr};
    }

    private boolean verifyPassword(String password, String saltStr, String hashStr) throws Exception {
        byte[] salt = Base64.getDecoder().decode(saltStr);
        byte[] expectedHash = Base64.getDecoder().decode(hashStr);
        
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
        SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        byte[] hash = skf.generateSecret(spec).getEncoded();
        
        return MessageDigest.isEqual(expectedHash, hash);
    }

    private String generateSessionToken(String email) {
        // Simple token generation - in production, use a more secure method
        return Base64.getEncoder().encodeToString((email + ":" + System.currentTimeMillis()).getBytes());
    }

    private String validateSessionToken(String token) throws Exception {
        try {
            String decoded = new String(Base64.getDecoder().decode(token));
            return decoded.split(":")[0];
        } catch (Exception e) {
            throw new Exception("Invalid token");
        }
    }
} 