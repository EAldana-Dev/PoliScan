<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IPN | Sistema de Recursos</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>

<section class="hero d-flex align-items-center justify-content-center text-center">

        <div class="container">

                <img src="${pageContext.request.contextPath}/assets/burro.png"
                     alt="IPN Mascot"
                     class="img-fluid mx-auto mb-4"
                     style="max-height: 260px; filter: drop-shadow(0px 15px 15px rgba(0,0,0,0.15));">
                <div class="ipn-text">
                    IPN
                </div>

                <h1 class="display-2 fw-bold text-ipn">
                    Bienvenido
                </h1>

                <p class="lead text-secondary">
                    Sistema de monitoreo de recursos
                </p>

                <a class="btn btn-ipn btn-lg mt-3 fw-bold px-5 py-2 rounded-3"
                   href="${pageContext.request.contextPath}/academic-units">
                    Comenzar
                </a>
</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>