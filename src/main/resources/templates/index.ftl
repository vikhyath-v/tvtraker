<#import "base.ftl" as base>
<@base.main>
    <!-- Welcome Section -->
    <div class="hero-section">
        <div class="row justify-content-center">
            <div class="col-md-8 text-center welcome-text">
                <#if Session?? && Session.username??>
                    <h1 class="mb-4">Welcome ${Session.username} !</h1>
                <#else>
                    <h1 class="mb-4">Welcome to TV Show Tracker</h1>
                </#if>
            </div>
        </div>
    </div>

    <!-- Popular This Month Section -->
    <section class="shows-section popular-section">
        <div class="container">
            <h2 class="section-title">Popular This Month</h2>
            <div class="shows-grid">
                <#list popularShows as show>
                    <div class="show-card">
                        <div class="show-poster">
                            <img src="${show.poster}" alt="${show.title}">
                            <div class="show-overlay">
                                <a href="/show/${show.imdbID}" class="btn btn-view">View Details</a>
                            </div>
                        </div>
                        <div class="show-info">
                            <h3 class="show-title">${show.title}</h3>
                            <div class="show-meta">
                                <span class="year">${show.year}</span>
                                <span class="rating">⭐ ${show.imdbRating}</span>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        </div>
    </section>

    <!-- Top Rated Shows Section -->
    <section class="shows-section top-rated-section">
        <div class="container">
            <h2 class="section-title">Top Rated Shows of All Time</h2>
            <div class="shows-grid">
                <#list topRatedShows as show>
                    <div class="show-card">
                        <div class="show-poster">
                            <img src="${show.poster}" alt="${show.title}">
                            <div class="show-overlay">
                                <a href="/show/${show.imdbID}" class="btn btn-view">View Details</a>
                            </div>
                        </div>
                        <div class="show-info">
                            <h3 class="show-title">${show.title}</h3>
                            <div class="show-meta">
                                <span class="year">${show.year}</span>
                                <span class="rating">⭐ ${show.imdbRating}</span>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        </div>
    </section>

    

    <style>
    /* Hero Section */
    .hero-section {
        padding: 4rem 0;
        background-color: #000000;
        text-align: center;
    }

    .hero-section h1 {
        color: #ffffff;
        font-size: 3rem;
        margin-bottom: 2rem;
    }

    /* Shows Sections */
    .shows-section {
        padding: 4rem 0;
        background-color: #000000;
    }

    .section-title {
        color: #ffffff;
        font-size: 2rem;
        margin-bottom: 2rem;
        padding-left: 1rem;
        border-left: 4px solid #e0143c;
    }

    .shows-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 2rem;
        padding: 1rem;
    }

    .show-card {
        background-color: #1a1a1a;
        border-radius: 12px;
        overflow: hidden;
        transition: transform 0.3s ease;
    }

    .show-card:hover {
        transform: translateY(-5px);
    }

    .show-poster {
        position: relative;
        width: 100%;
        height: 300px;
    }

    .show-poster img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .show-overlay {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.7);
        display: flex;
        justify-content: center;
        align-items: center;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .show-card:hover .show-overlay {
        opacity: 1;
    }

    .show-info {
        padding: 1rem;
        background-color: #e0143c;
    }

    .show-title {
        color: #ffffff;
        font-size: 1rem;
        margin-bottom: 0.5rem;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .show-meta {
        display: flex;
        justify-content: space-between;
        color: #ffffff;
        font-size: 0.9rem;
    }

    .btn-view {
        background-color: #e0143c;
        color: #ffffff;
        padding: 0.5rem 1rem;
        border-radius: 20px;
        text-decoration: none;
        transition: background-color 0.3s ease;
    }

    .btn-view:hover {
        background-color: #c4004e;
    }

    /* Footer */
    .footer {
        background-color: #1a1a1a;
        color: #ffffff;
        padding: 4rem 0 2rem;
    }

    .footer-content {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 2rem;
        margin-bottom: 2rem;
    }

    .footer-section h3 {
        color: #e0143c;
        margin-bottom: 1rem;
    }

    .footer-section ul {
        list-style: none;
        padding: 0;
    }

    .footer-section ul li {
        margin-bottom: 0.5rem;
    }

    .footer-section a {
        color: #ffffff;
        text-decoration: none;
        transition: color 0.3s ease;
    }

    .footer-section a:hover {
        color: #e0143c;
    }

    .footer-bottom {
        text-align: center;
        padding-top: 2rem;
        border-top: 1px solid #333333;
    }

    @media (max-width: 768px) {
        .shows-grid {
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        }

        .footer-content {
            grid-template-columns: 1fr;
            text-align: center;
        }
    }
    </style>
</@base.main> 