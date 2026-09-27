package mx.ipn.inventory.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.ipn.inventory.config.DatabaseConnection;
import mx.ipn.inventory.dao.ResourceDAO;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/qr")
public class QrServlet
        extends HttpServlet {

    private final ResourceDAO resourceDAO =
            new ResourceDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String qrCode =
                request.getParameter("code");

        if (
                qrCode == null
                        || qrCode.isBlank()
        ) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST
            );

            return;
        }

        try {

            var resource =
                    resourceDAO.findByQrCode(
                            qrCode
                    );

            if (resource != null) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/report?resourceId="
                                + resource.getId()
                );

                return;
            }

            String sql = """
                    SELECT
                        z.academic_unit_id,
                        a.name AS area_name
                    FROM zones z
                    INNER JOIN areas a
                        ON a.id = z.area_id
                    WHERE z.qr_code = ?
                    """;

            try (
                    Connection connection =
                            DatabaseConnection
                                    .getConnection();

                    PreparedStatement statement =
                            connection
                                    .prepareStatement(
                                            sql
                                    )
            ) {

                statement.setString(
                        1,
                        qrCode
                );

                try (
                        ResultSet resultSet =
                                statement
                                        .executeQuery()
                ) {

                    if (resultSet.next()) {

                        int academicUnitId =
                                resultSet.getInt(
                                        "academic_unit_id"
                                );

                        String area =
                                URLEncoder.encode(
                                        resultSet
                                                .getString(
                                                        "area_name"
                                                ),
                                        StandardCharsets.UTF_8
                                );

                        response.sendRedirect(
                                request.getContextPath()
                                        + "/inventory"
                                        + "?academicUnitId="
                                        + academicUnitId
                                        + "&area="
                                        + area
                        );

                        return;
                    }
                }
            }

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "El código QR no está registrado"
            );

        } catch (Exception exception) {

            throw new ServletException(
                    "Error al procesar el código QR",
                    exception
            );
        }
    }
}