<#import "base.ftl" as layout>
<@layout.main>
    <div class="page-container">
        <h2 class="section-title">My Watchlist</h2>
        <div class="watchlist-grid">
            <#if shows?? && shows?size gt 0>
                <#list shows as show>
                    <div class="show-card">
                        <div class="show-poster"style="position:relative">
                        <form action="/watchlist/remove" method="post" class="remove-form">
                                    <input type="hidden" name="showId" value="${show.imdbID}">
                           <button type="submit" class="btn btn-primary btn-sm" style="margin-left:100px;position:absolute; left:220px;top:10px;height:50px;width:50px; border-radius:50% " >X</button>
                            </form>
                            <#if show.poster?? && show.poster != "N/A">
                                <img src="${show.poster}" alt="${show.title} Poster">
                            <#else>
                                <div class="no-poster">
                                    <span>No image available</span>
                                </div>
                            </#if>
                        </div>
                        <div class="show-info">
                            <h3 class="show-title">${show.title}</h3>
                            <p class="show-year">${show.year}</p>
                            <div class="show-actions">
                                <a href="/show/${show.imdbID}" class="btn btn-primary btn-sm">View Details</a>
                                
                                 
                                
                            </div>
                        </div>
                    </div>
                </#list>
            <#else>
                <div class="empty-watchlist">
                    <p>Your watchlist is empty. Start adding shows!</p>
                </div>
            </#if>
        </div>

        <div class="back-button-container">
            <a href="/" class="btn btn-back">Back to Search</a>
        </div>
    </div>

    <style>
    .page-container {
        min-height: 100vh;
        background-color: #000000;
        padding: 2rem;
    }

    .section-title {
        color: #ffffff;
        font-size: 2rem;
        margin-bottom: 2rem;
        padding-left: 1rem;
    }

    .watchlist-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
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
        height: 400px;
    }

    .show-poster img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .no-poster {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #2a2a2a;
        color: #888888;
    }

    .show-info {
        padding: 1.5rem;
        background-color: #e0143c;
    }

    .show-title {
        color: #ffffff;
        font-size: 1.25rem;
        margin-bottom: 0.5rem;
    }

    .show-year {
        color: #888888;
        margin-bottom: 1rem;
    }

    .show-actions {
        display: flex;
        gap: 1rem;
    }

    

    .btn-back {
        background-color:rgb(255, 255, 255);
        color:rgb(0, 0, 0);
    }

    .btn-back:hover {
        background-color: #616161;
    }

    .empty-watchlist {
        grid-column: 1 / -1;
        text-align: center;
        color: #888888;
        padding: 3rem;
        background-color: #1a1a1a;
        border-radius: 12px;
    }

    .back-button-container {
        margin-top: 2rem;
        padding-left: 1rem;
    }

    .remove-form {
        flex: 1;
    }
    </style>
</@layout.main> 