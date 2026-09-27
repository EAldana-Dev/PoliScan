package mx.ipn.inventory.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.ipn.inventory.dao.AcademicUnitDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/areas")
public class AreaServlet
        extends HttpServlet {

    private final AcademicUnitDAO academicUnitDAO =
            new AcademicUnitDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            int academicUnitId =
                    Integer.parseInt(
                            request.getParameter(
                                    "academicUnitId"
                            )
                    );

            var academicUnit =
                    academicUnitDAO.findById(
                            academicUnitId
                    );

            if (academicUnit == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND
                );

                return;
            }

            request.setAttribute(
                    "academicUnit",
                    academicUnit
            );

            request.setAttribute(
                    "areas",
                    List.of(
                            "Aulas",
                            "Talleres",
                            "Laboratorios",
                            "Deportes",
                            "Áreas comunes"
                    )
            );

            request
                    .getRequestDispatcher(
                            "/WEB-INF/views/areas.jsp"
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
                    "Error al consultar las áreas",
                    exception
            );
        }
    }
}