package mx.ipn.inventory.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import mx.ipn.inventory.dao.ReportDAO;
import mx.ipn.inventory.dao.ResourceDAO;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

@WebServlet("/report")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 8 * 1024 * 1024
)
public class ReportServlet
        extends HttpServlet {

    private final ResourceDAO resourceDAO =
            new ResourceDAO();

    private final ReportDAO reportDAO =
            new ReportDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            int resourceId =
                    Integer.parseInt(
                            request.getParameter(
                                    "resourceId"
                            )
                    );

            var resource =
                    resourceDAO.findById(
                            resourceId
                    );

            if (resource == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND
                );

                return;
            }

            request.setAttribute(
                    "resource",
                    resource
            );

            request
                    .getRequestDispatcher(
                            "/WEB-INF/views/report.jsp"
                    )
                    .forward(
                            request,
                            response
                    );

        } catch (NumberFormatException exception) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST
            );

        } catch (Exception exception) {

            throw new ServletException(
                    "Error al cargar el recurso",
                    exception
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            int resourceId =
                    Integer.parseInt(
                            request.getParameter(
                                    "resourceId"
                            )
                    );

            String status =
                    request.getParameter("status");

            String description =
                    request.getParameter(
                            "description"
                    );

            Part photo =
                    request.getPart("photo");

            if (
                    !isValidStatus(status)
                            || description == null
                            || description.isBlank()
            ) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                return;
            }

            String photoPath =
                    savePhoto(photo);

            reportDAO.save(
                    resourceId,
                    status,
                    description.trim(),
                    photoPath
            );

            var resource =
                    resourceDAO.findById(
                            resourceId
                    );

            String area =
                    URLEncoder.encode(
                            resource.getAreaName(),
                            StandardCharsets.UTF_8
                    );

            response.sendRedirect(
                    request.getContextPath()
                            + "/inventory"
                            + "?academicUnitId="
                            + resource
                            .getAcademicUnitId()
                            + "&area="
                            + area
                            + "&report=success"
            );

        } catch (Exception exception) {

            throw new ServletException(
                    "No fue posible guardar el reporte",
                    exception
            );
        }
    }

    private boolean isValidStatus(
            String status
    ) {

        return "GOOD".equals(status)
                || "MINOR_DAMAGE".equals(status)
                || "REQUIRES_MAINTENANCE"
                .equals(status)
                || "OUT_OF_SERVICE"
                .equals(status);
    }

    private String savePhoto(
            Part photo
    ) throws IOException {

        if (
                photo == null
                        || photo.getSize() == 0
                        || photo.getSubmittedFileName() == null
        ) {

            return null;
        }

        String contentType =
                photo.getContentType();

        if (
                contentType == null
                        || !contentType
                        .startsWith("image/")
        ) {

            throw new IOException(
                    "El archivo debe ser una imagen"
            );
        }

        String originalName =
                Path.of(
                        photo.getSubmittedFileName()
                ).getFileName().toString();

        String extension = "";

        int dotIndex =
                originalName.lastIndexOf('.');

        if (dotIndex >= 0) {

            extension =
                    originalName
                            .substring(dotIndex)
                            .toLowerCase();
        }

        String fileName =
                UUID.randomUUID()
                        + extension;

        String uploadDirectory =
                getServletContext()
                        .getRealPath("/uploads");

        Files.createDirectories(
                Path.of(uploadDirectory)
        );

        Path destination =
                Path.of(
                        uploadDirectory,
                        fileName
                );

        photo.write(
                destination.toString()
        );

        return "/uploads/" + fileName;
    }
}