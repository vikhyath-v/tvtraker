<div class="discussion-board mt-5" style="background-color: #DC143C; padding: 2rem; border-radius: 15px; box-shadow: 0 4px 8px rgba(220, 20, 60, 0.3);">
    <h3 class="mb-4" style="color: #FFFFFF; font-weight: 700;">Discussion Board</h3>
    
    <!-- Comment Form -->
    <div class="card mb-4" style="background-color: #FF4D6A; border: none; border-radius: 10px;">
        <div class="card-body">
            <form action="/show/${show.imdbID}/discussion" method="post" class="comment-form">
                <div class="mb-3">
                    <textarea class="form-control" name="comment" rows="3" placeholder="Share your thoughts..." required 
                        style="background-color: #FF4D6A; color: #FFFFFF; border: 2px solid #FFFFFF; border-radius: 10px;"></textarea>
                </div>
                <button type="submit" class="btn btn-primary" 
                    style="background-color: transparent; color: #FFFFFF; border: 2px solid #FFFFFF; padding: 0.75rem 1.5rem; font-weight: 600; transition: all 0.3s;">Post Comment</button>
            </form>
        </div>
    </div>

    <!-- Comments List -->
    <div class="comments-list">
        <#if discussions?? && discussions?size gt 0>
            <#list discussions as discussion>
                <div class="card mb-3" style="background-color: #FF4D6A; border: 2px solid #FFFFFF; border-radius: 10px;">
                    <div class="card-body">
                        <h6 class="card-subtitle mb-2" style="color: #FFFFFF; font-weight: 600;">${discussion.username}</h6>
                        <p class="card-text" style="color: #FFFFFF;">${discussion.comment}</p>
                        <small style="color: #FFFFFF; opacity: 0.8;">${(discussion.timestamp)!''}</small>
                    </div>
                </div>
            </#list>
        <#else>
            <div class="text-center">
                <p style="color: #FFFFFF;">No comments yet. Be the first to start the discussion!</p>
            </div>
        </#if>
    </div>
</div>

<style>
.comments-list {
    max-height: 600px;
    overflow-y: auto;
    padding-right: 10px;
}

.comments-list::-webkit-scrollbar {
    width: 6px;
}

.comments-list::-webkit-scrollbar-track {
    background: #DC143C;
    border-radius: 3px;
}

.comments-list::-webkit-scrollbar-thumb {
    background: #FFFFFF;
    border-radius: 3px;
}

.comments-list::-webkit-scrollbar-thumb:hover {
    background: #F0F0F0;
}

.btn-primary:hover {
    background-color: #FFFFFF !important;
    color: #DC143C !important;
}
</style> 