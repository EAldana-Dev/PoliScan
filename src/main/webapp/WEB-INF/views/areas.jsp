<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Áreas | IPN</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-ipn d-flex align-items-center px-4">
    <span class="text-white fw-bold">IPN <span class="fw-normal ms-2">| Sistema de Recursos</span></span>
    <span class="text-white ms-auto">${academicUnit.name}</span>
</nav>

<div class="container py-5">

    <div class="mb-5 text-center position-relative">
        <a href="${pageContext.request.contextPath}/academic-units" class="text-decoration-none text-ipn position-absolute start-0 top-0 mt-2">
            &larr; Regresar
        </a>
        <p class="text-secondary fw-bold text-uppercase mb-1" style="letter-spacing: 2px;">
            ${academicUnit.name}
        </p>
        <h1 class="display-5 fw-bold text-ipn">Selecciona un área</h1>
    </div>

    <div class="row g-4 mt-3 justify-content-center">

        <c:forEach var="area" items="${areas}">
            <div class="col-12 col-md-6 col-lg-3">
                <a href="${pageContext.request.contextPath}/inventory?academicUnitId=${academicUnit.id}&area=${area}" class="text-decoration-none text-dark">
                    <div class="card area-card h-100 p-4 border-0 rounded-4 text-center">
                        <div class="fs-1 mb-3">
                            ${area == 'Aulas' ? '🏫' :
                              area == 'Talleres' ? '🔧' :
                              area == 'Laboratorios' ? '🧪' :
                              area == 'Deportes' ? '⚽' : '🏢'}
                        </div>
                        <h5 class="fw-bold text-ipn">${area}</h5>
                        <p class="text-secondary small mb-0">Consulta y reporta el estado de los recursos.</p>
                    </div>
                </a>
            </div>
        </c:forEach>

    </div>
</div>

</body>
</html>