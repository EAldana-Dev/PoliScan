<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${area} | IPN</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body class="bg-light">

<!-- MERGED: Navbar with 'Inicio' button -->
<nav class="navbar navbar-ipn d-flex align-items-center justify-content-between px-4">
    <span class="text-white fw-bold">IPN <span class="fw-normal ms-2">| Sistema de Recursos</span></span>
    <div>
        <span class="text-white me-3">${academicUnit.name}</span>
        <a href="${pageContext.request.contextPath}/" class="btn btn-light btn-sm fw-bold">Inicio</a>
    </div>
</nav>

<div class="container py-5 max-w-lg mx-auto" style="max-width: 900px;">

    <a href="${pageContext.request.contextPath}/areas?academicUnitId=${academicUnit.id}" class="text-decoration-none text-ipn mb-4 d-inline-block">
        &larr; Regresar
    </a>

    <!-- MERGED: Header layout grouping the title and the QR button -->
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <p class="text-secondary fw-bold text-uppercase mb-1" style="letter-spacing: 2px;">
                ${academicUnit.name}
            </p>
            <h1 class="display-5 fw-bold text-ipn mb-0">${area}</h1>
            <p class="text-secondary mt-2">Recursos registrados en esta área.</p>
        </div>
        <button class="btn btn-ipn px-4 py-2 rounded-3" type="button" data-bs-toggle="modal" data-bs-target="#qrModal">
            ▣ Escanear QR
        </button>
    </div>

    <!-- MERGED: Success message styling -->
    <c:if test="${param.report == 'success'}">
        <div class="alert alert-success border-0 shadow-sm rounded-3">
            El reporte fue registrado correctamente.
        </div>
    </c:if>

    <!-- MERGED: Search input styling mapped to your form -->
    <form class="mb-4 d-flex gap-2" method="get" action="${pageContext.request.contextPath}/inventory">
        <input type="hidden" name="academicUnitId" value="${academicUnit.id}">
        <input type="hidden" name="area" value="${area}">
        <input type="text" class="form-control form-control-lg border-0 shadow-sm rounded-3" name="search" value="${search}" placeholder="Buscar por nombre o número de inventario...">
        <button class="btn btn-ipn rounded-3 px-4" type="submit">Buscar</button>
    </form>

    <!-- MERGED: Resource list styling (Horizontal cards) with your c:forEach -->
    <div class="d-flex flex-column gap-3">
        <c:forEach var="resource" items="${resources}">
            <div class="card resource-card border-0 rounded-3 p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="fw-bold text-ipn mb-1">${resource.name}</h5>
                        <p class="text-secondary small mb-0">
                            Inventario: ${resource.inventoryNumber}<br>
                            Ubicación: ${empty resource.zoneName ? 'No especificada' : resource.zoneName}<br>
                            Estado:
                            <span class="badge status-${resource.conditionStatus}">
                                ${resource.conditionStatus == 'GOOD' ? 'Bueno' :
                                  resource.conditionStatus == 'MINOR_DAMAGE' ? 'Daño menor' :
                                  resource.conditionStatus == 'REQUIRES_MAINTENANCE' ? 'Requiere mantenimiento' : 'Fuera de servicio'}
                            </span>
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/report?resourceId=${resource.id}" class="btn btn-light border fw-bold text-secondary">Reportar problema</a>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- MERGED: Empty state logic -->
    <c:if test="${empty resources}">
        <div class="text-center py-5">
            <h2 class="h5">No se encontraron recursos.</h2>
            <p class="text-secondary">Prueba otra búsqueda.</p>
        </div>
    </c:if>

</div>

<!-- QR Modal -->
<div class="modal fade" id="qrModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <h2 class="modal-title h5 text-ipn fw-bold">Escanear código QR</h2>
                <button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body text-center pb-4">
                <p class="text-secondary">El lector con cámara se integrará en la siguiente etapa.</p>
                <div class="qr-demo"></div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>