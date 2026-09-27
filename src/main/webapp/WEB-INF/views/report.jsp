<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportar | IPN</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
    <style>
        /* MERGED: Custom CSS to style radio buttons as clickable pills */
        .status-radio:checked + .status-label {
            border-color: var(--ipn);
            background-color: #fcf4f5;
            font-weight: bold;
        }
    </style>
</head>
<body class="bg-light">

<!-- MERGED: Navbar -->
<nav class="navbar navbar-ipn d-flex align-items-center justify-content-between px-4">
    <span class="text-white fw-bold">IPN <span class="fw-normal ms-2">| Sistema de Recursos</span></span>
    <a href="${pageContext.request.contextPath}/" class="btn btn-light btn-sm fw-bold">Inicio</a>
</nav>

<div class="container py-5 max-w-lg mx-auto" style="max-width: 700px;">

    <!-- MERGED: Dynamic back button using history to avoid losing params -->
    <a href="javascript:history.back()" class="text-decoration-none text-ipn mb-4 d-inline-block">
        &larr; Regresar
    </a>

    <!-- MERGED: Form container with centered header -->
    <div class="card form-card border-0 rounded-4 p-5">
        <div class="text-center mb-4">
            <p class="text-secondary fw-bold text-uppercase mb-1" style="letter-spacing: 2px;">REPORTE DE CONDICIÓN</p>
            <h2 class="display-6 fw-bold text-ipn">Reportar un problema</h2>
            <p class="text-secondary">Ayuda a mantener actualizado el estado de los recursos.</p>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/report" enctype="multipart/form-data">

            <input type="hidden" name="resourceId" value="${resource.id}">

            <!-- MERGED: Read-only resource info block mapping your EL variables -->
            <div class="bg-light p-3 rounded-3 mb-4 border">
                <h6 class="fw-bold mb-1">${resource.name}</h6>
                <p class="text-secondary small mb-0">
                    Inventario: ${resource.inventoryNumber}<br>
                    Ubicación: ${empty resource.zoneName ? 'No especificada' : resource.zoneName}
                </p>
            </div>

            <div class="mb-4">
                <label class="form-label fw-bold">Estado del recurso</label>

                <!-- MERGED: 2x2 Grid for status selection using radio buttons mapping to your logic -->
                <div class="row g-3">
                    <div class="col-6">
                        <input type="radio" class="btn-check status-radio" name="status" id="good" value="GOOD" checked>
                        <label class="btn btn-outline-secondary w-100 status-label border text-dark" for="good">
                            <span class="text-success me-2">●</span> Bueno
                        </label>
                    </div>
                    <div class="col-6">
                        <input type="radio" class="btn-check status-radio" name="status" id="minorDamage" value="MINOR_DAMAGE">
                        <label class="btn btn-outline-secondary w-100 status-label border text-dark" for="minorDamage">
                            <span class="text-warning me-2">●</span> Daño menor
                        </label>
                    </div>
                    <div class="col-6">
                        <input type="radio" class="btn-check status-radio" name="status" id="maintenance" value="REQUIRES_MAINTENANCE">
                        <label class="btn btn-outline-secondary w-100 status-label border text-dark" for="maintenance">
                            <span class="text-orange me-2" style="color: #fd7e14;">●</span> Requiere mantenimiento
                        </label>
                    </div>
                    <div class="col-6">
                        <input type="radio" class="btn-check status-radio" name="status" id="outOfService" value="OUT_OF_SERVICE">
                        <label class="btn btn-outline-secondary w-100 status-label border text-dark" for="outOfService">
                            <span class="text-danger me-2">●</span> Fuera de servicio
                        </label>
                    </div>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-bold" for="description">Descripción del problema</label>
                <textarea class="form-control rounded-3" id="description" name="description" rows="4" placeholder="Describe lo que encontraste." required></textarea>
            </div>

            <div class="mb-4">
                <label class="form-label fw-bold" for="photo">Fotografía (opcional)</label>
                <input class="form-control" id="photo" type="file" name="photo" accept="image/*">
            </div>

            <button type="submit" class="btn btn-ipn w-100 py-3 rounded-3 fw-bold mt-2">
                Enviar reporte
            </button>

        </form>
    </div>
</div>

</body>
</html>