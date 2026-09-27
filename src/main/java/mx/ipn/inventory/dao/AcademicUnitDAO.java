package mx.ipn.inventory.dao;

import mx.ipn.inventory.config.DatabaseConnection;
import mx.ipn.inventory.model.AcademicUnit;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AcademicUnitDAO {

    public List<AcademicUnit> findActive()
            throws Exception {

        String sql = """
                SELECT id, name, active
                FROM academic_units
                WHERE active = TRUE
                ORDER BY id
                """;

        List<AcademicUnit> academicUnits =
                new ArrayList<>();

        try (
                Connection connection =
                        DatabaseConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql);

                ResultSet resultSet =
                        statement.executeQuery()
        ) {

            while (resultSet.next()) {

                academicUnits.add(
                        new AcademicUnit(
                                resultSet.getInt("id"),
                                resultSet.getString("name"),
                                resultSet.getBoolean("active")
                        )
                );
            }
        }

        return academicUnits;
    }

    public AcademicUnit findById(int id)
            throws Exception {

        String sql = """
                SELECT id, name, active
                FROM academic_units
                WHERE id = ?
                """;

        try (
                Connection connection =
                        DatabaseConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(1, id);

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return new AcademicUnit(
                            resultSet.getInt("id"),
                            resultSet.getString("name"),
                            resultSet.getBoolean("active")
                    );
                }
            }
        }

        return null;
    }
}