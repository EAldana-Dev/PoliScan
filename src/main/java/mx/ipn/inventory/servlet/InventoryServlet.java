package mx.ipn.inventory.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.ipn.inventory.dao.AcademicUnitDAO;
import mx.ipn.inventory.dao.ResourceDAO;

import java.io.IOException;

@WebServlet("/inventory")
public class InventoryServlet
        extends HttpServlet {

    private final ResourceDAO resourceDAO =
            new ResourceDAO();

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

            String area =
                    request.getParameter("area");

            String search =
                    request.getParameter("search");

            if (search == null) {
                search = "";
            }

            var academicUnit =
                    academicUnitDAO.findById(
                            academicUnitId
                    );

            if (
                    academicUnit == null
                            || area == null
                            || area.isBlank()
            ) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                return;
            }

            request.setAttribute(
                    "academicUnit",
                    academicUnit
            );

            request.setAttribute(
                    "area",
                    area
            );

            request.setAttribute(
                    "search",
                    search
            );

            request.setAttribute(
                    "resources",
                    resourceDAO
                            .findByAcademicUnitAndArea(
                                    academicUnitId,
                                    area,
                                    search
                            )
            );

            request
                    .getRequestDispatcher(
                            "/WEB-INF/views/inventory.jsp"
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
                    "Error al consultar el inventario",
                    exception
            );
        }
    }
}