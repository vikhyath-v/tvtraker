<#import "base.ftl" as layout>
<@layout.main>
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-4">
                <img src="${show.poster}" class="img-fluid rounded" alt="${show.title} Poster">
            </div>
            <div class="col-md-8">
                <h1>${show.title} (${show.year})</h1>
                <div class="mb-3">
                    <span class="badge bg-primary">IMDB: ${show.imdbRating}/10</span>
                    <#if averageRating gt 0>
                        <span class="badge bg-success">User Rating: ${averageRating?string("0.0")}/5</span>
                    </#if>
                    
                    <#if Session?? && Session.token??>
                        <#if isInWatchlist?? && isInWatchlist>
                            <button class="btn btn-secondary ms-2" disabled>
                                <i class="fas fa-check"></i> Added to Watchlist
                            </button>
                        <#else>
                            <form action="/watchlist" method="POST" class="d-inline-block ms-2">
                                <input type="hidden" name="showId" value="${show.imdbID}">
                                <button type="submit" class="btn btn-danger">
                                    <i class="fas fa-plus"></i> Add to Watchlist
                                </button>
                            </form>
                        </#if>
                    </#if>
                </div>
                <p class="lead">${show.plot}</p>
                <p><strong>Genre:</strong> ${show.genre}</p>
                <p><strong>Director:</strong> ${show.director}</p>
                <p><strong>Runtime:</strong> ${show.runtime}</p>
                
                <!-- Rating Section -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h3>Rate this Show</h3>
                    </div>
                    <div class="card-body">
                        <form action="/show/${show.imdbID}/rate" method="POST">
                            <div class="mb-3">
                                <label class="form-label">Your Rating:</label>
                                <div class="rating">
                                    <#list 5..1 as i>
                                        <input type="radio" name="rating" value="${i}" id="star${i}"
                                            <#if userRating?? && userRating.rating == i>checked</#if>>
                                        <label for="star${i}">☆</label>
                                    </#list>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="comment" class="form-label">Your Review (optional):</label>
                                <textarea class="form-control" id="comment" name="comment" rows="3">${(userRating.comment)!""}</textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">Submit Rating</button>
                        </form>
                    </div>
                </div>

                <!-- User Ratings Section -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h3>User Reviews</h3>
                    </div>
                    <div class="card-body">
                        <#if allRatings?size gt 0>
                            <#list allRatings as rating>
                                <div class="border-bottom mb-3 pb-3">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <div class="d-flex align-items-center mb-2">
                                                <strong class="me-2">${rating.username}</strong>
                                                <div class="rating-display">
                                                    <#list 1..5 as i>
                                                        <span class="star ${(i <= rating.rating)?string('filled', '')}">★</span>
                                                    </#list>
                                                </div>
                                            </div>
                                            <#if rating.comment?? && rating.comment != "">
                                                <p class="mt-2 mb-0">${rating.comment}</p>
                                            </#if>
                                        </div>
                                        <small class="text-muted">${rating.timestamp?datetime("yyyy-MM-dd'T'HH:mm:ss")?string("MMM dd, yyyy")}</small>
                                    </div>
                                </div>
                            </#list>
                        <#else>
                            <p class="text-muted">No ratings yet. Be the first to rate this show!</p>
                        </#if>
                    </div>
                </div>

                <!-- Cast Section -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h3>Cast</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <#list show.actors?split(", ") as actor>
                                <div class="cast-member">
                                        <div class="actor-avatar">
                                            <img src="${show.actorImages[actor_index]!''}" 
                                                 alt="${actor}"
                                                 onerror="this.src='https://ui-avatars.com/api/?name=${actor?replace(' ', '+')}&background=000000&color=e0143c'"
                                                 class="actor-image">
                                        </div>
                                        <span class="actor-name">${actor}</span>
                                    </div>
                            </#list>
                        </div>
                    </div>
                </div>

                <!-- Discussion Section -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h3>Discussions</h3>
                    </div>
                    <div class="card-body">
                        <form action="/show/${show.imdbID}/discussion" method="POST" class="mb-4">
                            <div class="mb-3">
                                <label for="comment" class="form-label">Add a comment:</label>
                                <textarea class="form-control" id="comment" name="comment" rows="3" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">Post Comment</button>
                        </form>

                        <#if discussions?? && discussions?size gt 0>
                            <#list discussions as discussion>
                                <div class="border-bottom mb-3 pb-3">
                                    <div class="d-flex justify-content-between">
                                        <strong>${discussion.username}</strong>
                                        <small class="text-muted">${discussion.timestamp}</small>
                                    </div>
                                    <p class="mt-2">${discussion.comment}</p>
                                </div>
                            </#list>
                        <#else>
                            <p class="text-muted">No discussions yet. Start the conversation!</p>
                        </#if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
    .rating {
        display: flex;
        flex-direction: row-reverse;
        justify-content: flex-end;
    }

    .rating input {
        display: none;
    }

    .rating label {
        cursor: pointer;
        font-size: 30px;
        color: #ddd;
        margin: 0 2px;
    }

    .rating input:checked ~ label,
    .rating label:hover,
    .rating label:hover ~ label {
        color: #ffd700;
    }

    .rating-display .star {
        color: #ddd;
        font-size: 20px;
    }

    .rating-display .star.filled {
        color: #ffd700;
    }

    .btn-danger {
        background-color: #e0143c;
        border-color: #e0143c;
        transition: all 0.3s ease;
    }

    .btn-danger:hover {
        background-color: #c01134;
        border-color: #c01134;
        transform: translateY(-2px);
    }

    .btn-danger i {
        margin-right: 5px;
    }

    .btn-secondary {
        background-color: #6c757d;
        border-color: #6c757d;
        cursor: not-allowed;
    }

    .btn-secondary i {
        margin-right: 5px;
        color: #28a745;
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
        flex-direction: row;
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