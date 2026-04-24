<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.polycoffee.Entity.User" %>
<%
    User user = (User) session.getAttribute("user");
%>

<head>
    <title>PolyCoffee | Premium Brewing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --coffee-dark: #2c1b18;
            --coffee-accent: #c08261;
            --coffee-cream: #f8f1e9;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #fff;
        }

        /* --- HERO SECTION --- */
        .hero {
            height: 90vh;
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
                        url('${pageContext.request.contextPath}/images/banner.png') center/cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            clip-path: ellipse(150% 100% at 50% 0%); /* Subtle curved bottom */
        }

        .hero-content h1 {
            font-family: 'Playfair Display', serif;
            font-size: 4.5rem;
            letter-spacing: 2px;
            margin-bottom: 1rem;
            animation: fadeInUp 1s ease;
        }

        .hero-content p {
            font-size: 1.25rem;
            font-weight: 300;
            letter-spacing: 1px;
            opacity: 0.9;
        }

        /* --- CARDS & FEATURES --- */
        .section-title {
            font-family: 'Playfair Display', serif;
            color: var(--coffee-dark);
            margin-bottom: 3rem;
            position: relative;
        }

        .section-title::after {
            content: '';
            width: 60px;
            height: 3px;
            background: var(--coffee-accent);
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
        }

        .feature-card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background: var(--coffee-cream);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }

        .card-img-container {
            height: 250px;
            overflow: hidden;
        }

        .card-img-top {
            height: 100%;
            width: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .feature-card:hover .card-img-top {
            transform: scale(1.1);
        }

        .btn-coffee {
            background-color: var(--coffee-dark);
            color: white;
            padding: 10px 25px;
            border-radius: 50px;
            text-transform: uppercase;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-coffee:hover {
            background-color: var(--coffee-accent);
            color: white;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>

<body>

<jsp:include page="/views/layout/navbar.jsp" />

<section class="hero text-white">
    <div class="hero-content text-center px-4">
        <h1 class="display-1">PolyCoffee</h1>

        <% if (user != null) { %>
            <p class="mb-4">Chào mừng trở lại, <span class="text-warning fw-bold"><%= user.getFullName() %></span></p>
        <% } else { %>
            <p class="mb-4">Crafted Passion in Every Sip</p>
        <% } %>

        <a href="${pageContext.request.contextPath}/drink" class="btn btn-outline-light btn-lg px-5 py-3 rounded-pill">
            Explore Menu
        </a>
    </div>
</section>

<main class="container my-5 py-5">
    <div class="text-center">
        <h2 class="section-title">Your Coffee Journey</h2>
    </div>

    <div class="row g-5 mt-2">
        <div class="col-md-4">
            <div class="card feature-card h-100 shadow-sm">
                <div class="card-img-container">
                    <img src="${pageContext.request.contextPath}/images/menu.png" class="card-img-top" alt="Menu">
                </div>
                <div class="card-body text-center p-4">
                    <h5 class="fw-bold">Our Signature Menu</h5>
                    <p class="text-muted small">Từ Espresso đậm đà đến Cold Brew thanh mát.</p>
                    <a href="${pageContext.request.contextPath}/drink" class="btn btn-coffee">View Menu</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card feature-card h-100 shadow-sm">
                <div class="card-img-container">
                    <img src="${pageContext.request.contextPath}/images/cart.png" class="card-img-top" alt="Cart">
                </div>
                <div class="card-body text-center p-4">
                    <h5 class="fw-bold">Your Selection</h5>
                    <p class="fs-4 text-accent mb-1">
                        <%= session.getAttribute("cartCount") == null ? 0 : session.getAttribute("cartCount") %>
                        <small class="fs-6 text-muted">Items</small>
                    </p>
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-coffee">Review Cart</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card feature-card h-100 shadow-sm">
                <div class="card-img-container">
                    <img src="${pageContext.request.contextPath}/images/order.png" class="card-img-top" alt="Orders">
                </div>
                <div class="card-body text-center p-4">
                    <h5 class="fw-bold">Track Orders</h5>
                    <p class="text-muted small">Theo dõi trạng thái đơn hàng của bạn.</p>
                    <a href="${pageContext.request.contextPath}/bill" class="btn btn-coffee">View Bills</a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/views/layout/footer.jsp" />

</body>