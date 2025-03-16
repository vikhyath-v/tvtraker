<#import "base.ftl" as layout>
<@layout.main>
    <h2 class="mb-4">Search Results for "${query}"</h2>

    <#if shows?? && shows?size gt 0>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <#list shows as show>
                <div class="col">
                    <div class="card h-100">
                        <#if show.poster?? && show.poster != "N/A">
                            <img src="${show.poster}" class="card-img-top" alt="${show.title}">
                        <#else>
                            <div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height: 300px;">
                                <span class="text-muted">No image available</span>
                            </div>
                        </#if>
                        <div class="card-body">
                            <h5 class="card-title">${show.title}</h5>
                            <p class="card-text">Year: ${show.year}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <a href="/show/${show.imdbID}" class="btn btn-primary">View Details</a>
                            </div>
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
</@layout.main> 