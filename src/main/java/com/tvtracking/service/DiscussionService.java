package com.tvtracking.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tvtracking.model.Discussion;

public class DiscussionService {
    private final DatabaseService db;

    public DiscussionService() {
        this.db = DatabaseService.getInstance();
    }

    public void addDiscussion(Discussion discussion) throws SQLException {
        String sql = "INSERT INTO discussions (show_id, username, comment, created_at) VALUES (?, ?, ?, datetime('now'))";
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, discussion.getShowId());
            pstmt.setString(2, discussion.getUsername());
            pstmt.setString(3, discussion.getComment());
            pstmt.executeUpdate();
        }
    }

    public void deleteDiscussion(int discussionId) throws SQLException {
        String sql = "DELETE FROM discussions WHERE id = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, discussionId);
            pstmt.executeUpdate();
        }
    }

    public List<Discussion> getDiscussionsForShow(String showId) throws SQLException {
        String sql = "SELECT id, show_id, username, comment, created_at FROM discussions WHERE show_id = ? ORDER BY created_at DESC";
        List<Discussion> discussions = new ArrayList<>();
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, showId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Discussion discussion = new Discussion(
                        rs.getInt("id"),
                        rs.getString("show_id"),
                        rs.getString("username"),
                        rs.getString("comment"),
                        rs.getString("created_at")
                    );
                    discussions.add(discussion);
                }
            }
        }
        return discussions;
    }
} 