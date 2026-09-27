package mx.ipn.inventory.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DatabaseConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/ipn_inventory" +
                    "?useSSL=false" +
                    "&serverTimezone=America/Mexico_City" +
                    "&allowPublicKeyRetrieval=true";

    private static final String USER = "ealdana";
    private static final String PASSWORD = "3m1l14n0_V_A";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException exception) {
            throw new IllegalStateException(
                    "No se encontró el driver de MySQL",
                    exception
            );
        }
    }

    private DatabaseConnection() {
    }

    public static Connection getConnection()
            throws SQLException {

        return DriverManager.getConnection(
                URL,
                USER,
                PASSWORD
        );
    }
}