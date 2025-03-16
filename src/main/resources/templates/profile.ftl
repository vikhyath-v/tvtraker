<#import "base.ftl" as layout>
<@layout.main>
    <div class="container py-5">
        <div class="row">
            <!-- User Profile Card -->
            <center> 
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-body text-center">
                        <h3 class="card-title mb-3">Profile</h3>
                        <div class="mb-3">
                            <i class="fas fa-user-circle fa-5x text-muted"></i>
                        </div>
                        <img src="https://avatar.iran.liara.run/username?username=${(user.username)}&length=1&background=000000&color=e0143c" 
                                 alt="Profile Picture" 
                                 class="profilepic"
                                 onerror="this.src='https://avatar.iran.liara.run/public/boy'">
                        <h5 class="my-3">${(user.username)!'Anonymous'}</h5>
                        <p class="text-muted mb-1">${(user.email)!'No email provided'}</p>
                        <p class="text-muted mb-4">
                            
                        </p>
                    </div>
                </div>
            </div>
            </center>
</div>
            <!-- Watchlist Section -->
            <div class="col-lg-8">
            
                    
                        <h3 class="card-title mb-4">My Watchlist</h3>
                        <#if shows?? && shows?size gt 0>
                            <div class="row">
                                <#list shows as show>
                                    <div class="col-md-6 mb-4">
                                        <div class="card h-100">
                                            <#if show.poster?? && show.poster != "N/A">
                                                <img src="${show.poster}" class="card-img-top" alt="${(show.title)!'Show'}" onerror="this.src='/images/no-poster.jpg'">
                                            <#else>
                                                <img src="/images/no-poster.jpg" class="card-img-top" alt="${(show.title)!'Show'}">
                                            </#if>
                                            <div class="card-body">
                                                <h5 class="card-title">${(show.title)!'Untitled'}</h5>
                                                <p class="card-text text-muted">${(show.year)!'Year not available'}</p>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <a href="/show/${(show.imdbID)!''}" class="btn btn-primary btn-sm">View Details</a>
                                                  <form action="/watchlist/remove" method="post" class="remove-form">
                                    <input type="hidden" name="showId" value="${show.imdbID}">
                           <button type="submit" class="btn btn-primary btn-sm" style="margin-left:100px;position:absolute; left:250px;top:10px;height:50px;width:50px; border-radius:50% " >X</button>
                            </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </#list>
                            </div>
                        <#else>
                            <div class="text-center py-5">
                                <i class="fas fa-film fa-3x text-muted mb-3"></i>
                                <h5>Your watchlist is empty</h5>
                                <p class="text-muted">Start adding shows to your watchlist!</p>
                                <a href="/" class="btn btn-primary">Browse Shows</a>
                            </div>
                        </#if>
                    
               
            </div>
        
    </div>

    <style>
        .card {
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
        .card-img-top {
            height: 300px;
            object-fit: cover;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .badge {
            font-size: 0.9em;
            padding: 0.5em 1em;
        }
        .profilepic {
    width: 150px; /* Adjust size as needed */
    height: 150px; /* Adjust size as needed */
    border-radius: 50%; /* Makes the image a circle */
    object-fit: cover; /* Ensures the image covers the container without distortion */
    border: 2px solid #ddd; /* Optional: border around the image */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Optional: subtle shadow */
}
    </style>
</@layout.main> 