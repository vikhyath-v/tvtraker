<#import "base.ftl" as layout>
<@layout.base>
    <div class="row">
        <div class="col-md-4">
            <#if show.Poster?? && show.Poster != "N/A">
                <img src="${show.Poster}" class="img-fluid rounded" alt="${show.Title}">
            <#else>
                <div class="bg-light d-flex align-items-center justify-content-center rounded" style="height: 400px;">
                    <span class="text-muted">No image available</span>
                </div>
            </#if>
        </div>
        <div class="col-md-8">
            <h2>${show.Title}</h2>
            <p class="lead">${show.Year} • ${show.Rated} • ${show.Runtime}</p>
            
            <div class="mb-4">
                <h5>Plot</h5>
                <p>${show.Plot}</p>
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <h5>Details</h5>
                    <ul class="list-unstyled">
                        <li><strong>Genre:</strong> ${show.Genre}</li>
                        <li><strong>Director:</strong> ${show.Director}</li>
                        <li><strong>Writers:</strong> ${show.Writer}</li>
                        <li><strong>Cast:</strong> ${show.Actors}</li>
                    </ul>
                </div>
                <div class="col-md-6">
                    <h5>Additional Info</h5>
                    <ul class="list-unstyled">
                        <li><strong>Language:</strong> ${show.Language}</li>
                        <li><strong>Country:</strong> ${show.Country}</li>
                        <li><strong>Awards:</strong> ${show.Awards}</li>
                        <li><strong>IMDb Rating:</strong> ${show.imdbRating}/10</li>
                    </ul>
                </div>
            </div>
            
            <div class="mt-4">
                <a href="/" class="btn btn-secondary">Back to Search</a>
            </div>
        </div>
    </div>
</@layout.base> 