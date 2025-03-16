<#import "base.ftl" as base>
<@base.main>
<div class="auth-container">
    <h2>LOGIN</h2>
    <form action="/login" method="POST">
        <input type="email" class="form-control" name="email" placeholder="Email" required>
        <input type="password" class="form-control" name="password" placeholder="Password" required>
        <button type="submit" class="btn-submit">SUBMIT</button>
    </form>
    <a href="/signup" class="auth-link">Don't Have An Account? Click Here</a>
</div>
</@base.main> 