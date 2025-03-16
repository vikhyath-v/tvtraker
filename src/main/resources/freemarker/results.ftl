<#import "base.ftl" as layout>
<@layout.base>
    <div class="row">
        <div class="col-12">
            <h2 class="mb-4">Search Results for "${query}"</h2>
            
            <#if shows?? && shows.size() gt 0>
                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <#list shows as show>
                        <div class="col">
                            <div class="card h-100">
                                <#if show.Poster?? && show.Poster != "N/A">
                                    <img src="${show.Poster}" class="card-img-top" alt="${show.Title}">
                                <#else>
                                    <div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height: 300px;">
                                        <span class="text-muted">No image available</span>
                                    </div>
                                </#if>
                                <div class="card-body">
                                    <h5 class="card-title">${show.Title}</h5>
                                    <p class="card-text">Year: ${show.Year}</p>
                                    <a href="/show/${show.imdbID}" class="btn btn-primary">View Details</a>
                                </div>
                            </div>
                        </div>
                    </#list>
                </div>
            <#else>
                <div class="alert alert-info">
                    No TV shows found for "${query}". Please try a different search term.
                </div>
            </#if>
            
            <div class="mt-4">
                <a href="/" class="btn btn-secondary">Back to Search</a>
            </div>
        </div>
    </div>
</@layout.base> 