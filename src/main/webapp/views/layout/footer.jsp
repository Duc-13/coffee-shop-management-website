<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* ===== SECTION (TOP BANNER) ===== */
    .section h2 {
        font-weight: 500;
        font-size: 2rem;
        color: #f1f1f1;
    }

    .section p {
        font-weight: 300;
        font-size: 1.05rem;
        letter-spacing: 0.5px;
        color: #cfcfcf;
    }

    /* ===== FOOTER ===== */
    footer {
        font-size: 15px;
    }

    footer h5 {
        font-weight: 500;
        font-size: 1.15rem;
        letter-spacing: 0.5px;
    }

    /* Main text */
    footer p {
        color: #bfbfbf;
        font-weight: 300;
        line-height: 1.6;
    }

    /* Links */
    footer a {
        color: #bfbfbf;
        font-weight: 300;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    footer a:hover {
        color: #ffc107;
        padding-left: 3px; /* subtle move effect */
    }

    /* Icons */
    footer i {
        opacity: 0.8;
    }

    /* Divider */
    footer hr {
        border-color: #444;
    }

    /* Bottom copyright */
    .footer-bottom {
        color: #888;
        font-weight: 300;
        font-size: 0.9rem;
    }
</style>

<!-- ===== TOP SECTION ===== -->
<div class="bg-dark text-center section border-bottom border-secondary py-4">
    <h2>Best Coffee Experience</h2>
    <p class="lead">Fresh • Quality • Fast Delivery</p>
</div>

<!-- ===== FOOTER ===== -->
<footer class="bg-dark pt-5 pb-3">
    <div class="container">
        <div class="row">

            <!-- LEFT -->
            <div class="col-md-4 mb-4">
                <h5 class="text-warning">PolyCoffee</h5>
                <p>
                    Bringing you the finest beans from local highlands directly to your cup.
                    Quality is our priority since 2024.
                </p>
                <div class="d-flex gap-3">
                    <a href="#"><i class="bi bi-facebook fs-5"></i></a>
                    <a href="#"><i class="bi bi-instagram fs-5"></i></a>
                    <a href="#"><i class="bi bi-twitter-x fs-5"></i></a>
                </div>
            </div>

            <!-- CENTER -->
            <div class="col-md-4 mb-4">
                <h5 class="text-warning">Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms of Service</a></li>
                    <li><a href="#">Shipping Info</a></li>
                </ul>
            </div>

            <!-- RIGHT -->
            <div class="col-md-4 mb-4">
                <h5 class="text-warning">Contact Us</h5>
                <p class="mb-1">
                    <i class="bi bi-geo-alt-fill me-2"></i> 123 Coffee St, Da Nang, VN
                </p>
                <p class="mb-1">
                    <i class="bi bi-telephone-fill me-2"></i> +84 123 456 789
                </p>
                <p>
                    <i class="bi bi-envelope-fill me-2"></i> support@polycoffee.com
                </p>
            </div>

        </div>

        <hr>

        <div class="text-center footer-bottom">
            &copy; 2026 PolyCoffee. All rights reserved.
        </div>
    </div>
</footer>