<#import "base.ftl" as layout>
<@layout.main>
    <div class="error-container">
        <div class="error-content">
            <h1>Oops! Something went wrong</h1>
            <p>${error!"An unexpected error occurred."}</p>
            <a href="/" class="btn btn-primary">Go Back Home</a>
        </div>
    </div>

    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #0a0a0a;
            padding: 2rem;
        }

        .error-content {
            text-align: center;
            color: #ffffff;
            max-width: 600px;
        }

        .error-content h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: #e0143c;
        }

        .error-content p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.8;
        }

        .btn-primary {
            background-color: #e0143c;
            color: #ffffff;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            background-color: #f0244c;
        }
    </style>
</@layout.main> 