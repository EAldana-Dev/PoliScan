package mx.ipn.inventory.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mx.ipn.inventory.dao.AcademicUnitDAO;

import java.io.IOException;

@WebServlet("/academic-units")
public class AcademicUnitServlet
        extends HttpServlet {

    private final AcademicUnitDAO academicUnitDAO =
            new AcademicUnitDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            request.setAttribute(
                    "academicUnits",
                    academicUnitDAO.findActive()
            );

            request
                    .getRequestDispatcher(
                            "/WEB-INF/views/academic-units.jsp"
                    )
                    .forward(
                            request,
                            response
                    );

        } catch (Exception exception) {

            throw new ServletException(
                    "Error al consultar las unidades académicas",
                    exception
            );
        }
    }
}