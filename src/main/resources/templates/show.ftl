<#import "base.ftl" as layout>
<@layout.main>
    <div class="show-details">
        <div class="show-header">
            <div class="show-content">
                <div class="back-button">
                    <a href="javascript:history.back()" class="btn btn-link">
                        <i class="fas fa-arrow-left"></i>
                    </a>
                </div>
                <div class="content-wrapper">
                    <div class="poster-section">
                        <img src="${show.poster}" alt="${show.title} Poster" class="show-poster">
                    </div>
                    <div class="info-section">
                        <h1 class="show-title">${show.title}</h1>
                        <div class="show-meta">
                            <span class="release-date">${show.year}</span>
                            <span class="rating">⭐ ${show.imdbRating}</span>
                            <span class="duration">${show.runtime}</span>
                        </div>
                        <div class="genre-tags">
                            <#list show.genre?split(", ") as genre>
                                <span class="genre-tag">${genre}</span>
                            </#list>
                        </div>
                        <p class="show-plot">${show.plot}</p>
                        
                        <!-- Cast Section -->
                        <div class="cast-section">
                            <h3>Cast</h3>
                            <div class="cast-list">
                                <#list show.actors?split(", ") as actor>
                                    <div class="cast-member">
                                        <div class="actor-avatar">
                                            <img src="${show.actorImages[actor_index]!''}" 
                                                 alt="${actor}"
                                                 onerror="this.src='https://ui-avatars.com/api/?name=${actor?replace(' ', '+')}&background=e0143c&color=fff'"
                                                 class="actor-image">
                                        </div>
                                        <span class="actor-name">${actor}</span>
                                    </div>
                                </#list>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <#if Session?? && Session.token??>
                                <form action="/watchlist" method="post">
                                    <input type="hidden" name="showId" value="${show.imdbID}">
                                    <button type="submit" class="btn btn-watchlist">
                                        <i class="fas fa-plus"></i> Add to watchlist
                                    </button>
                                </form>
                            </#if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="discussion-section">
            <div class="container">
                <#if Session?? && Session.token??>
                    <div class="comment-form">
                        <h3>Add a Comment</h3>
                        <form action="/show/${show.imdbID}/discussion" method="post">
                            <div class="form-group">
                                <textarea class="form-control" name="comment" rows="3" 
                                    placeholder="Share your thoughts about this show..." required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">Post Comment</button>
                        </form>
                    </div>
                </#if>

                <div class="discussion-list">
                    <h3>Discussion</h3>
                    <#if discussions?? && discussions?size gt 0>
                        <#list discussions as discussion>
                            <div class="comment-card">
                                <div class="comment-header">
                                    <h6 class="comment-author">${discussion.username}</h6>
                                    <small class="comment-time">${(discussion.timestamp)!''}</small>
                                </div>
                                <p class="comment-text">${discussion.comment}</p>
                            </div>
                        </#list>
                    <#else>
                        <p class="no-comments">No comments yet. Be the first to start the discussion!</p>
                    </#if>
                </div>
            </div>
        </div>
    </div>

    <style>
    .show-details {
        min-height: 100vh;
        background-color: #0a0a0a;
    }

    .show-header {
        position: relative;
        height: 100vh;
        background-color: #0a0a0a;
        display: flex;
        align-items: center;
    }

    .show-content {
        width: 100%;
        padding: 2rem;
    }

    .content-wrapper {
        display: flex;
        gap: 3rem;
        max-width: 1400px;
        margin: 0 auto;
    }

    .back-button {
        position: absolute;
        top: 20px;
        left: 20px;
    }

    .back-button .btn-link {
        font-size: 24px;
        padding: 10px;
        color: #ffffff;
    }

    .poster-section {
        flex: 0 0 400px;
    }

    .show-poster {
        width: 100%;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.3);
    }

    .info-section {
        flex: 1;
        padding: 2rem 0;
    }

    .show-title {
        font-size: 48px;
        font-weight: bold;
        margin-bottom: 20px;
        color: #ffffff;
    }

    .show-meta {
        margin-bottom: 20px;
        font-size: 18px;
        color: #ffffff;
    }

    .show-meta span {
        margin-right: 20px;
    }

    .genre-tags {
        margin-bottom: 20px;
    }

    .genre-tag {
        display: inline-block;
        padding: 8px 16px;
        margin-right: 10px;
        margin-bottom: 10px;
        background-color: rgba(255,255,255,0.1);
        color: #ffffff;
        border-radius: 20px;
        font-size: 14px;
    }

    .show-plot {
        font-size: 16px;
        line-height: 1.6;
        margin-bottom: 30px;
        color: #ffffff;
        opacity: 0.9;
    }

    .btn-watchlist {
        padding: 12px 24px;
        background-color: #e0143c;
        color: #ffffff;
        border: none;
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .btn-watchlist:hover {
        background-color: #e0143c;
        transform: translateY(-2px);
    }

    /* Discussion Section */
    .discussion-section {
        padding: 4rem 0;
        background-color: #1a1a1a;
    }

    .comment-form {
        margin-bottom: 3rem;
    }

    .comment-form h3 {
        color: #ffffff;
        margin-bottom: 1.5rem;
    }

    .form-control {
        background-color: #2a2a2a;
        border: 1px solid #3a3a3a;
        color: #ffffff;
        border-radius: 8px;
        padding: 1rem;
    }

    .form-control:focus {
        border-color: #e0143c;
        box-shadow: 0 0 0 2px rgba(229, 30, 50, 0.1);
        background-color: #2a2a2a;
        color: #ffffff;
    }

    .discussion-list h3 {
        color: #ffffff;
        margin-bottom: 1.5rem;
    }

    .comment-card {
        background-color: #2a2a2a;
        border: 1px solid #3a3a3a;
        border-radius: 12px;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
    }

    .comment-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
    }

    .comment-author {
        color: #ffffff;
        font-weight: 600;
        margin: 0;
    }

    .comment-time {
        color: #888888;
    }

    .comment-text {
        color: #cccccc;
        margin: 0;
        line-height: 1.6;
    }

    .no-comments {
        text-align: center;
        color: #888888;
        padding: 2rem;
    }

    .btn-primary {
        background-color: #e0143c;
        color: #ffffff;
        border: none;
        padding: 12px 24px;
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .btn-primary:hover {
        background-color:#e0143c;
        transform: translateY(-2px);
    }

    /* Cast Section Styles */
    .cast-section {
        margin: 2rem 0;
    }

    .cast-section h3 {
        color: #ffffff;
        margin-bottom: 1.5rem;
        font-size: 1.5rem;
    }

    .cast-list {
        display: flex;
        flex-wrap: wrap;
        gap: 1.5rem;
    }

    .cast-member {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.5rem;
    }

    .actor-avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        overflow: hidden;
        border: 2px solid var(--primary-color);
        transition: transform 0.3s ease;
    }

    .actor-avatar:hover {
        transform: scale(1.1);
    }

    .actor-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .actor-name {
        color: #ffffff;
        font-size: 0.9rem;
        text-align: center;
        max-width: 100px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    </style>
</@layout.main> 