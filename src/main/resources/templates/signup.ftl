<#import "base.ftl" as base>
<@base.main>
<div class="auth-container">
    <h2>SIGN UP</h2>
    <form action="/signup" method="POST">
        <input type="text" class="form-control" name="username" placeholder="Username" required>
        <input type="email" class="form-control" name="email" placeholder="Email" required>
        <input type="password" class="form-control" name="password" placeholder="Password" required>
        <input type="password" class="form-control" name="confirmPassword" placeholder="Confirm Password" required>
        <button type="submit" class="btn-submit">SUBMIT</button>
    </form>
    <a href="/login" class="auth-link">Already Have An Account? Click Here</a>
</div>
</@base.main> 