package com.tvtracking;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.tvtracking.config.Config;
import com.tvtracking.model.Discussion;
import com.tvtracking.model.Show;
import com.tvtracking.model.UserRating;
import com.tvtracking.service.AuthService;
import com.tvtracking.service.DiscussionService;
import com.tvtracking.service.OmdbService;
import com.tvtracking.service.UserRatingService;
import com.tvtracking.service.WatchlistService;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateExceptionHandler;
import static spark.Spark.before;
import static spark.Spark.get;
import static spark.Spark.port;
import static spark.Spark.post;
import static spark.Spark.staticFiles;

public class App {
    private static final String OMDB_API_KEY = Config.getInstance().getOmdbApiKey();
    private static final Gson gson = new Gson();
    private static final String DEFAULT_USER_ID = "default_user"; // For demo purposes
    private static final OmdbService omdbService = new OmdbService();
    private static final WatchlistService watchlistService = new WatchlistService();
    private static final DiscussionService discussionService = new DiscussionService();
    private static final AuthService authService = new AuthService();
    private static final UserRatingService userRatingService = new UserRatingService();
    private static final Configuration freemarkerConfig = new Configuration(Configuration.VERSION_2_3_32);

    public static void main(String[] args) {
        port(4569);
        staticFiles.location("/public");
        
        // Initialize services
        AuthService authService = new AuthService();
        OmdbService omdbService = new OmdbService();
        DiscussionService discussionService = new DiscussionService();
        WatchlistService watchlistService = new WatchlistService();
        UserRatingService userRatingService = new UserRatingService();
        
        // Configure FreeMarker
        try {
            freemarkerConfig.setDirectoryForTemplateLoading(new File("src/main/resources/templates"));
            freemarkerConfig.setDefaultEncoding("UTF-8");
            freemarkerConfig.setTemplateExceptionHandler(TemplateExceptionHandler.HTML_DEBUG_HANDLER);
            freemarkerConfig.setLogTemplateExceptions(false);
        } catch (IOException e) {
            System.err.println("Error configuring FreeMarker: " + e.getMessage());
            e.printStackTrace();
        }

        // Authentication middleware
        before((request, response) -> {
            String path = request.pathInfo();
            if (!path.equals("/login") && !path.equals("/signup") && !path.startsWith("/public")) {
                String token = request.session().attribute("token");
                if (token == null) {
                    response.redirect("/login");
                }
            }
        });

        // Authentication routes
        get("/login", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            Map<String, Object> sessionData = new HashMap<>();
            sessionData.put("token", req.session().attribute("token"));
            model.put("Session", sessionData);
            return renderTemplate("login.ftl", model);
        });

        post("/login", (req, res) -> {
            try {
                String email = req.queryParams("email");
                String password = req.queryParams("password");
                String token = authService.signIn(email, password);
                Map<String, Object> userInfo = authService.getUserInfo(token);
                req.session(true).attribute("token", token);
                req.session().attribute("username", userInfo.get("username"));
                res.redirect("/");
                return null;
            } catch (Exception e) {
                Map<String, Object> model = new HashMap<>();
                Map<String, Object> sessionData = new HashMap<>();
                sessionData.put("token", req.session().attribute("token"));
                model.put("Session", sessionData);
                // Provide a user-friendly error message
                String errorMessage = e.getMessage();
                if (errorMessage.contains("Invalid login credentials")) {
                    errorMessage = "Invalid email or password. Please try again.";
                } else if (errorMessage.contains("Email not confirmed")) {
                    errorMessage = "Please verify your email address before logging in.";
                } else {
                    errorMessage = "An error occurred during login. Please try again.";
                }
                model.put("error", errorMessage);
                return renderTemplate("login.ftl", model);
            }
        });

        get("/signup", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            Map<String, Object> sessionData = new HashMap<>();
            sessionData.put("token", req.session().attribute("token"));
            model.put("Session", sessionData);
            return renderTemplate("signup.ftl", model);
        });

        post("/signup", (req, res) -> {
            try {
                String email = req.queryParams("email");
                String password = req.queryParams("password");
                String confirmPassword = req.queryParams("confirmPassword");
                String username = req.queryParams("username");

                if (!password.equals(confirmPassword)) {
                    throw new Exception("Passwords do not match");
                }

                if (password.length() < 8) {
                    throw new Exception("Password must be at least 8 characters long");
                }

                String token = authService.signUp(email, password, username);
                req.session(true).attribute("token", token);
                req.session().attribute("username", username);
                res.redirect("/");
                return null;
            } catch (Exception e) {
                Map<String, Object> model = new HashMap<>();
                Map<String, Object> sessionData = new HashMap<>();
                sessionData.put("token", req.session().attribute("token"));
                sessionData.put("username", req.session().attribute("username"));
                model.put("Session", sessionData);
                model.put("error", e.getMessage());
                return renderTemplate("signup.ftl", model);
            }
        });

        get("/logout", (req, res) -> {
            String token = req.session().attribute("token");
            if (token != null) {
                try {
                    authService.signOut(token);
                } catch (Exception e) {
                    // Ignore errors during logout
                }
                req.session().removeAttribute("token");
            }
            res.redirect("/login");
            return null;
        });

        // Routes
        get("/", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            Map<String, Object> sessionData = new HashMap<>();
            sessionData.put("token", req.session().attribute("token"));
            sessionData.put("username", req.session().attribute("username"));
            model.put("Session", sessionData);
            
            // Add popular and top rated shows to the model
            model.put("popularShows", omdbService.getPopularShows());
            model.put("topRatedShows", omdbService.getTopRatedShows());
            
            return renderTemplate("index.ftl", model);
        });

        get("/search", (req, res) -> {
            String query = req.queryParams("q");
            Map<String, Object> model = new HashMap<>();
            Map<String, Object> sessionData = new HashMap<>();
            sessionData.put("token", req.session().attribute("token"));
            model.put("Session", sessionData);
            model.put("query", query);
            model.put("shows", omdbService.searchShows(query));
            return renderTemplate("search.ftl", model);
        });

        get("/show/:id", (req, res) -> {
            String showId = req.params(":id");
            String token = req.session().attribute("token");
            Map<String, Object> model = new HashMap<>();
            Map<String, Object> sessionData = new HashMap<>();
            sessionData.put("token", token);
            model.put("Session", sessionData);

            try {
                Show show = omdbService.getShowDetails(showId);
                model.put("show", show);
                
                // Get user info for the template
                Map<String, Object> userInfo = authService.getUserInfo(token);
                model.put("user", userInfo);
                
                // Get user's rating if it exists
                int userId = (int) userInfo.get("id");
                UserRating userRating = userRatingService.getUserRating(userId, showId);
                model.put("userRating", userRating);
                
                // Get average rating and all ratings
                double averageRating = userRatingService.getAverageRating(showId);
                List<UserRating> allRatings = userRatingService.getShowRatings(showId);
                model.put("averageRating", averageRating);
                model.put("allRatings", allRatings);
                
                // Get discussions
                model.put("discussions", discussionService.getDiscussionsForShow(showId));
                return renderTemplate("show.ftl", model);
            } catch (Exception e) {
                model.put("error", "Failed to load show details: " + e.getMessage());
                return renderTemplate("error.ftl", model);
            }
        });

        get("/watchlist", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            String token = req.session().attribute("token");
            Map<String, Object> sessionData = new HashMap<>();
            sessionData.put("token", token);
            model.put("Session", sessionData);
            
            try {
                Map<String, Object> userInfo = authService.getUserInfo(token);
                int userId = (int) userInfo.get("id");
                model.put("shows", watchlistService.getWatchlist(userId));
                return renderTemplate("watchlist.ftl", model);
            } catch (Exception e) {
                model.put("error", "Failed to load watchlist: " + e.getMessage());
                return renderTemplate("error.ftl", model);
            }
        });

        get("/profile", (req, res) -> {
            String token = req.session().attribute("token");
            Map<String, Object> model = new HashMap<>();
            Map<String, Object> sessionData = new HashMap<>();
            sessionData.put("token", token);
            model.put("Session", sessionData);
            
            try {
                Map<String, Object> userInfo = authService.getUserInfo(token);
                model.put("user", userInfo);
                
                int userId = (int) userInfo.get("id");
                model.put("shows", watchlistService.getWatchlist(userId));
                
                return renderTemplate("profile.ftl", model);
            } catch (Exception e) {
                model.put("error", "Failed to load profile: " + e.getMessage());
                return renderTemplate("error.ftl", model);
            }
        });

        post("/watchlist", (req, res) -> {
            String token = req.session().attribute("token");
            if (token == null) {
                res.redirect("/login");
                return null;
            }
            String showId = req.queryParams("showId");
            try {
                Map<String, Object> userInfo = authService.getUserInfo(token);
                int userId = (int) userInfo.get("id");
                watchlistService.addToWatchlist(userId, showId);
                res.redirect("/show/" + showId);
            } catch (Exception e) {
                // Add error handling
                Map<String, Object> model = new HashMap<>();
                Map<String, Object> sessionData = new HashMap<>();
                sessionData.put("token", token);
                model.put("Session", sessionData);
                model.put("error", "Failed to add show to watchlist: " + e.getMessage());
                return renderTemplate("error.ftl", model);
            }
            return null;
        });

        post("/watchlist/remove", (req, res) -> {
            String token = req.session().attribute("token");
            if (token == null) {
                res.redirect("/login");
                return null;
            }
            String showId = req.queryParams("showId");
            try {
                Map<String, Object> userInfo = authService.getUserInfo(token);
                int userId = (int) userInfo.get("id");
                watchlistService.removeFromWatchlist(userId, showId);
                res.redirect("/watchlist");
            } catch (Exception e) {
                Map<String, Object> model = new HashMap<>();
                Map<String, Object> sessionData = new HashMap<>();
                sessionData.put("token", token);
                model.put("Session", sessionData);
                model.put("error", "Failed to remove show from watchlist: " + e.getMessage());
                return renderTemplate("error.ftl", model);
            }
            return null;
        });

        post("/show/:id/discussion", (request, response) -> {
            String showId = request.params(":id");
            String token = request.session().attribute("token");
            String comment = request.queryParams("comment");
            
            try {
                // Get username from the logged-in user
                Map<String, Object> userInfo = authService.getUserInfo(token);
                String username = (String) userInfo.get("username");
                
                Discussion discussion = new Discussion(showId, username, comment);
                discussionService.addDiscussion(discussion);
                
                response.redirect("/show/" + showId);
                return null;
            } catch (Exception e) {
                Map<String, Object> model = new HashMap<>();
                Map<String, Object> sessionData = new HashMap<>();
                sessionData.put("token", token);
                model.put("Session", sessionData);
                model.put("error", "Failed to add discussion: " + e.getMessage());
                return renderTemplate("error.ftl", model);
            }
        });

        post("/show/:id/discussion/:discussionId", (req, res) -> {
            String showId = req.params(":id");
            String discussionId = req.params(":discussionId");
            
            if ("delete".equals(req.queryParams("_method"))) {
                discussionService.deleteDiscussion(Integer.parseInt(discussionId));
            }
            
            res.redirect("/show/" + showId);
            return null;
        });

        // Add rating route
        post("/show/:id/rate", (req, res) -> {
            String showId = req.params(":id");
            String token = req.session().attribute("token");
            
            try {
                Map<String, Object> userInfo = authService.getUserInfo(token);
                int userId = (int) userInfo.get("id");
                String username = (String) userInfo.get("username");
                int rating = Integer.parseInt(req.queryParams("rating"));
                String comment = req.queryParams("comment");
                
                UserRating userRating = new UserRating(userId, username, showId, rating, comment);
                userRatingService.addOrUpdateRating(userRating);
                
                res.redirect("/show/" + showId);
                return null;
            } catch (Exception e) {
                Map<String, Object> model = new HashMap<>();
                Map<String, Object> sessionData = new HashMap<>();
                sessionData.put("token", token);
                model.put("Session", sessionData);
                model.put("error", "Failed to add rating: " + e.getMessage());
                return renderTemplate("error.ftl", model);
            }
        });

        get("/signout", (req, res) -> {
            req.session().removeAttribute("token");
            req.session().removeAttribute("userId");
            res.redirect("/signin");
            return null;
        });
    }

    private static String renderTemplate(String templateName, Map<String, Object> model) {
        try {
            Template template = freemarkerConfig.getTemplate(templateName);
            StringWriter writer = new StringWriter();
            template.process(model, writer);
            return writer.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error rendering template: " + e.getMessage());
        }
    }

    private static String fetchData(String urlString) {
        try {
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            if (conn.getResponseCode() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;

            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();
            conn.disconnect();

            return response.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "{}";
        }
    }
}