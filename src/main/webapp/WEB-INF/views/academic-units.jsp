<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Unidades académicas | IPN</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
            rel="stylesheet">

    <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/assets/css/app.css">

</head>

<body class="bg-light">

<header class="navbar navbar-ipn">

    <div class="container">

        <a
                class="navbar-brand text-white fw-bold"
                href="${pageContext.request.contextPath}/">

            IPN | Recursos

        </a>

        <a
                class="btn btn-outline-light btn-sm"
                href="${pageContext.request.contextPath}/">

            Inicio

        </a>

    </div>

</header>

<main class="container py-5">

    <div class="text-center mb-5">

        <div class="small text-ipn fw-bold">
            INSTITUTO POLITÉCNICO NACIONAL
        </div>

        <h1 class="display-6 fw-bold text-ipn">
            Selecciona tu unidad académica
        </h1>

        <p class="text-secondary">
            Consulta los recursos disponibles en tu escuela.
        </p>

    </div>

    <div class="row g-3">

        <c:forEach
                var="academicUnit"
                items="${academicUnits}">

            <div class="col-6 col-md-4 col-lg-3 col-xl-2">

                <a
                        class="card academic-unit-card h-100 text-decoration-none"
                        href="${pageContext.request.contextPath}/areas?academicUnitId=${academicUnit.id}">

                    <div class="card-body text-center">

                        <div class="fw-bold fs-5 text-ipn">
                            ${academicUnit.name}
                        </div>

                        <div class="small text-secondary mt-2">
                            Seleccionar
                        </div>

                    </div>

                </a>

            </div>

        </c:forEach>

    </div>

</main>

</body>

</html>