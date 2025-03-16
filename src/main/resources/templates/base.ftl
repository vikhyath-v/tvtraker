<#macro main>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TV Show Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #DC143C;  /* Crimson Red */
            --primary-dark: #B01030;   /* Darker Crimson */
            --primary-light: #FF4D6A;  /* Lighter Crimson */
            --background-color-dark: #000000; /* Dark Mode Background */
            --background-color-light: #E5E5E5; /* Light Mode Background - Light Gray */
            --text-color: #FFFFFF; /* White text for everything */
            --text-color-dark: #000000; /* Black text for specific elements */
            --input-bg-dark: #FFFFFF;  /* Light input background */
            --input-bg-light: #FFFFFF; /* Light input background */
            --card-shadow: 0 4px 8px rgba(220, 20, 60, 0.3);
            --transition-speed: 0.3s;
            --footer-bg: #1a1a1a;
        }

        body {
            font-family: "Century Gothic", CenturyGothic, AppleGothic, sans-serif;
            background-color: var(--background-color-dark);
            color: var(--text-color);
            line-height: 1.6;
            transition: background-color var(--transition-speed);
        }

        body.light-mode {
            background-color: var(--background-color-light);
        }

        h1, h2, h3, h4, h5, h6, .card-title {
            font-weight: 700;
            color: var(--text-color);
        }

        /* Welcome message styles */
        .welcome-text h1 {
            color: var(--text-color-dark);
        }

        .welcome-text .lead {
            color: var(--text-color-dark);
        }

        .navbar {
            background-color: var(--primary-color) !important;
            box-shadow: none;
            padding: 1rem 0;
        }

        .navbar-brand, .nav-link {
            color: var(--text-color) !important;
            font-weight: 600;
        }

        .navbar-brand {
            font-size: 1.5rem;
        }

        .nav-link {
            font-weight: 500;
        }

        .form-control {
            border: none;
            border-radius: 5px;
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
            background-color: var(--input-bg-light);
            color: var(--text-color-dark);
        }

        body.light-mode .form-control {
            background-color: var(--input-bg-light);
            color: var(--text-color-dark);
        }

        .form-control::placeholder {
            color: var(--text-color-dark);
            opacity: 0.8;
        }

        .text-muted {
            color: var(--text-color) !important;
            opacity: 0.8;
        }

        /* Search styles */
        .search-container {
            display: flex;
            gap: 1rem;
            max-width: 800px;
            margin: 2rem auto;
        }

        .search-input {
            flex: 1;
            padding: 1rem;
            border: none;
            border-radius: 25px;
            font-size: 1.1rem;
            background: var(--input-bg-light);
            color: var(--text-color-dark);
        }

        .search-input::placeholder {
            color: var(--text-color-dark);
            opacity: 0.8;
        }

        .search-button {
            padding: 1rem 2rem;
            border: none;
            border-radius: 25px;
            background: var(--primary-color);
            color: var(--text-color);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-speed);
        }

        .search-button:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        /* Theme toggle button */
        .theme-toggle {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: var(--primary-color);
            color: #FFFFFF;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            cursor: pointer;
            box-shadow: var(--card-shadow);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            z-index: 1000;
            transition: all var(--transition-speed);
        }

        .theme-toggle:hover {
            transform: scale(1.1);
        }

        .btn-primary {
            background-color: #FFFFFF;
            color: var(--text-color-dark);
            border: none;
        }

        .btn-primary:hover {
            background-color: #F0F0F0;
            color: var(--text-color-dark);
        }

        .btn-primary:active, .btn-primary:focus {
            background-color: var(--primary-dark) !important;
            border-color: var(--primary-dark) !important;
            color: var(--text-color) !important;
            box-shadow: none !important;
            transform: none !important;
        }

        .card {
            border: none;
            box-shadow: var(--card-shadow);
            transition: transform var(--transition-speed);
            background-color: var(--primary-color);
            border-radius: 15px;
            color: #FFFFFF;
        }

        .card-body {
            color: #FFFFFF;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .container {
            padding: 2rem 1rem;
        }

        /* Custom Styles */
        .show-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 2rem;
            padding: 1rem 0;
        }

        .show-card {
            height: 100%;
            display: flex;
            flex-direction: column;
            background-color: var(--primary-color);
        }

        .show-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 15px 15px 0 0;
        }

        .pagination {
            margin-top: 2rem;
        }

        .pagination .page-link {
            color: var(--text-color);
            background-color: var(--primary-color);
            border-color: var(--primary-dark);
            border-radius: 8px;
            margin: 0 2px;
            font-weight: 600;
        }

        .pagination .page-link:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            color: var(--text-color);
        }

        .pagination .active .page-link {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            color: var(--text-color);
        }

        /* Alert styles */
        .alert {
            border: none;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            font-weight: 600;
        }

        .alert-success {
            background-color: var(--primary-light);
            color: var(--text-color);
        }

        .alert-danger {
            background-color: #FFE4E4;
            color: var(--text-color-dark);
        }

        /* Profile section styles */
        .profile-section {
            background-color: var(--primary-color);
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
        }

        .profile-info {
            background-color: var(--primary-light);
            padding: 2rem;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
        }

        /* Discussion board styles */
        .discussion-board {
            background-color: var(--primary-color);
            padding: 2rem;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
        }

        .discussion-board * {
            color: #FFFFFF !important;
        }

        .comment-card {
            background-color: var(--primary-light);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-radius: 10px;
            border: 2px solid #FFFFFF;
            box-shadow: var(--card-shadow);
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .comment-username {
            font-weight: 600;
            color: #FFFFFF !important;
        }

        .comment-timestamp {
            font-size: 0.9rem;
            color: #FFFFFF !important;
            opacity: 0.8;
        }

        .comment-content {
            color: #FFFFFF !important;
            line-height: 1.6;
        }

        .comment-form textarea {
            background-color: var(--primary-light);
            border-radius: 10px;
            color: #FFFFFF !important;
            width: 100%;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 2px solid #FFFFFF;
            resize: vertical;
        }

        .comment-form textarea::placeholder {
            color: rgba(255, 255, 255, 0.7) !important;
        }

        .comment-form .btn-submit {
            background-color: transparent;
            color: #FFFFFF !important;
            border: 2px solid #FFFFFF;
            padding: 0.75rem 1.5rem;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: all var(--transition-speed);
        }

        .comment-form .btn-submit:hover {
            background-color: #FFFFFF;
            color: var(--primary-color) !important;
            transform: translateY(-2px);
        }

        /* Watchlist styles */
        .watchlist-container {
            background-color: var(--primary-color);
            padding: 2rem;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
        }

        .watchlist-item {
            background-color: var(--primary-light);
            margin-bottom: 1rem;
            padding: 1rem;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
        }

        /* Stats display */
        .stats {
            display: flex;
            gap: 1rem;
            margin-top: 0.5rem;
            font-size: 0.9rem;
            color: var(--text-color);
            font-weight: 600;
        }

        .stats-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Login/Signup Form Styles */
        .auth-container {
            max-width: 400px;
            margin: 2rem auto;
            background-color: var(--primary-color);
            padding: 2rem;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            color: #FFFFFF;
        }

        .auth-container h2 {
            color: #FFFFFF;
            text-align: center;
            margin-bottom: 2rem;
        }

        .btn-submit {
            width: 100%;
            padding: 0.75rem;
            background-color: #FFFFFF;
            color: var(--text-color-dark);
            border: none;
            border-radius: 5px;
            font-weight: 600;
            margin-top: 1rem;
            cursor: pointer;
            transition: all var(--transition-speed);
        }

        .btn-submit:hover {
            background-color: #F0F0F0;
            color: var(--text-color-dark);
            transform: translateY(-2px);
        }

        .auth-link {
            display: block;
            text-align: center;
            color: #FFFFFF;
            margin-top: 1rem;
            text-decoration: none;
        }

        .auth-link:hover {
            text-decoration: underline;
            color: #FFFFFF;
        }

        /* Search icon and bar styles */
        .search-icon {
            color: var(--text-color);
            cursor: pointer;
            font-size: 1.2rem;
            margin-right: 1rem;
            transition: transform 0.3s ease;
        }

        .search-icon:hover {
            transform: scale(1.1);
        }

        .nav-search-container {
            position: relative;
            display: none;
        }

        .nav-search-container.active {
            display: flex;
            align-items: center;
            margin-right: 1rem;
        }

        .nav-search-input {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 20px;
            background: var(--input-bg-light);
            color: var(--text-color-dark);
            width: 250px;
            transition: width 0.3s ease;
        }

        .nav-search-input::placeholder {
            color: var(--text-color-dark);
            opacity: 0.8;
        }

        .nav-search-button {
            background: none;
            border: none;
            color: var(--text-color);
            cursor: pointer;
            padding: 0.5rem;
            margin-left: -40px;
        }

        /* Footer Styles */
        .footer {
            background-color: var(--footer-bg);
            color: var(--text-color);
            padding: 4rem 0 2rem;
            margin-top: 4rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .footer-section h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }

        .footer-section ul {
            list-style: none;
            padding: 0;
        }

        .footer-section ul li {
            margin-bottom: 0.5rem;
        }

        .footer-section a {
            color: var(--text-color);
            text-decoration: none;
            transition: color var(--transition-speed) ease;
        }

        .footer-section a:hover {
            color: var(--primary-color);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 2rem;
            border-top: 1px solid #333333;
        }

        @media (max-width: 768px) {
            .footer-content {
                grid-template-columns: 1fr;
                text-align: center;
            }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/main.js" defer></script>
    
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="/">TV Show Tracker</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item d-flex align-items-center">
                        <span class="search-icon">🔍</span>
                        <div class="nav-search-container">
                            <form action="/search" method="GET" class="d-flex">
                                <input type="text" name="q" class="nav-search-input" placeholder="Search shows..." required>
                                <button type="submit" class="nav-search-button">→</button>
                            </form>
                        </div>
                    </li>
                   
                    <#if Session?? && Session.token??>
                        <li class="nav-item">
                            <a class="nav-link" href="/watchlist">My Watchlist</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/profile">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/logout">Logout</a>
                        </li>
                    <#else>
                        <li class="nav-item">
                            <a class="nav-link" href="/login">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/signup">Sign Up</a>
                        </li>
                    </#if>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <#if error??>
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </#if>
        <#if success??>
            <div class="alert alert-success" role="alert">
                ${success}
            </div>
        </#if>
        <#nested>
    </div>

    <!-- Theme toggle button -->
    <button class="theme-toggle">
        <span class="theme-icon">🌙</span>
    </button>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>TV Show Tracker</h3>
                    <p>Your personal TV show tracking companion</p>
                </div>
                <div class="footer-section">
                    <h3>Quick Links</h3>
                    <ul>
                        <li><a href="/">Home</a></li>
                        <#if Session?? && Session.token??>
                            <li><a href="/watchlist">My Watchlist</a></li>
                            <li><a href="/profile">Profile</a></li>
                        <#else>
                            <li><a href="/login">Login</a></li>
                            <li><a href="/signup">Sign Up</a></li>
                        </#if>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Contact</h3>
                 <p><a href="gmailto:support@tvshowtracker.com">Email: support@tvshowtracker.com</a></p>

                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 TV Show Tracker. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Simple jQuery search toggle -->
    <script>
        $(document).ready(function() {
            // Toggle search on icon click
            $('.search-icon').click(function() {
                $('.nav-search-container').toggleClass('active');
                if ($('.nav-search-container').hasClass('active')) {
                    $('.nav-search-input').focus();
                }
            });
            
            // Close search when clicking outside
            $(document).click(function(e) {
                if (!$(e.target).closest('.search-icon').length && 
                    !$(e.target).closest('.nav-search-container').length && 
                    $('.nav-search-container').hasClass('active')) {
                    $('.nav-search-container').removeClass('active');
                }
            });
        });
    </script>
</body>
</html>
</#macro> 