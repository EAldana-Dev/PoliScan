package mx.ipn.inventory.dao;

import mx.ipn.inventory.config.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class ReportDAO {

    public long save(
            int resourceId,
            String reportedStatus,
            String description,
            String photoPath
    ) throws Exception {

        String insertSql = """
                INSERT INTO reports(
                    resource_id,
                    reported_status,
                    description,
                    photo_path
                )
                VALUES (?, ?, ?, ?)
                """;

        String updateSql = """
                UPDATE resources
                SET condition_status = ?
                WHERE id = ?
                """;

        try (
                Connection connection =
                        DatabaseConnection.getConnection()
        ) {

            connection.setAutoCommit(false);

            try (
                    PreparedStatement insertStatement =
                            connection.prepareStatement(
                                    insertSql,
                                    Statement.RETURN_GENERATED_KEYS
                            );

                    PreparedStatement updateStatement =
                            connection.prepareStatement(
                                    updateSql
                            )
            ) {

                insertStatement.setInt(
                        1,
                        resourceId
                );

                insertStatement.setString(
                        2,
                        reportedStatus
                );

                insertStatement.setString(
                        3,
                        description
                );

                insertStatement.setString(
                        4,
                        photoPath
                );

                insertStatement.executeUpdate();

                long reportId = 0;

                try (
                        ResultSet keys =
                                insertStatement
                                        .getGeneratedKeys()
                ) {

                    if (keys.next()) {
                        reportId =
                                keys.getLong(1);
                    }
                }

                updateStatement.setString(
                        1,
                        reportedStatus
                );

                updateStatement.setInt(
                        2,
                        resourceId
                );

                updateStatement.executeUpdate();

                connection.commit();

                return reportId;

            } catch (Exception exception) {

                connection.rollback();

                throw exception;
            }
        }
    }
}