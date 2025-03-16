<#import "base.ftl" as layout>
<@layout.base>
    <div class="row justify-content-center">
        <div class="col-md-8 text-center">
            <h1 class="mb-4">Welcome to TV Show Tracker</h1>
            <p class="lead mb-4">Search for your favorite TV shows and track their information</p>
            
            <form action="/search" method="get" class="mb-4">
                <div class="input-group input-group-lg">
                    <input type="text" name="q" class="form-control" placeholder="Enter TV show name..." required>
                    <button class="btn btn-primary" type="submit">Search</button>
                </div>
            </form>
        </div>
    </div>
</@layout.base> 