package mx.ipn.inventory.dao;

import mx.ipn.inventory.config.DatabaseConnection;
import mx.ipn.inventory.model.Resource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ResourceDAO {

    public List<Resource> findByAcademicUnitAndArea(
            int academicUnitId,
            String areaName,
            String search
    ) throws Exception {

        String sql = """
                SELECT
                    r.id,
                    r.academic_unit_id,
                    r.area_id,
                    r.zone_id,
                    au.name AS academic_unit_name,
                    a.name AS area_name,
                    z.name AS zone_name,
                    r.name,
                    r.inventory_number,
                    r.qr_code,
                    r.identification_type,
                    r.description,
                    r.condition_status,
                    r.active
                FROM resources r
                INNER JOIN academic_units au
                    ON au.id = r.academic_unit_id
                INNER JOIN areas a
                    ON a.id = r.area_id
                LEFT JOIN zones z
                    ON z.id = r.zone_id
                WHERE r.academic_unit_id = ?
                  AND a.name = ?
                  AND r.active = TRUE
                  AND (
                      ? = ''
                      OR LOWER(r.name)
                         LIKE LOWER(CONCAT('%', ?, '%'))
                      OR LOWER(r.inventory_number)
                         LIKE LOWER(CONCAT('%', ?, '%'))
                  )
                ORDER BY r.id DESC
                """;

        List<Resource> resources =
                new ArrayList<>();

        try (
                Connection connection =
                        DatabaseConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(1, academicUnitId);
            statement.setString(2, areaName);
            statement.setString(3, search);
            statement.setString(4, search);
            statement.setString(5, search);

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                while (resultSet.next()) {
                    resources.add(
                            map(resultSet)
                    );
                }
            }
        }

        return resources;
    }

    public Resource findById(int id)
            throws Exception {

        String sql = """
                SELECT
                    r.id,
                    r.academic_unit_id,
                    r.area_id,
                    r.zone_id,
                    au.name AS academic_unit_name,
                    a.name AS area_name,
                    z.name AS zone_name,
                    r.name,
                    r.inventory_number,
                    r.qr_code,
                    r.identification_type,
                    r.description,
                    r.condition_status,
                    r.active
                FROM resources r
                INNER JOIN academic_units au
                    ON au.id = r.academic_unit_id
                INNER JOIN areas a
                    ON a.id = r.area_id
                LEFT JOIN zones z
                    ON z.id = r.zone_id
                WHERE r.id = ?
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
                    return map(resultSet);
                }
            }
        }

        return null;
    }

    public Resource findByQrCode(
            String qrCode
    ) throws Exception {

        String sql = """
                SELECT
                    r.id,
                    r.academic_unit_id,
                    r.area_id,
                    r.zone_id,
                    au.name AS academic_unit_name,
                    a.name AS area_name,
                    z.name AS zone_name,
                    r.name,
                    r.inventory_number,
                    r.qr_code,
                    r.identification_type,
                    r.description,
                    r.condition_status,
                    r.active
                FROM resources r
                INNER JOIN academic_units au
                    ON au.id = r.academic_unit_id
                INNER JOIN areas a
                    ON a.id = r.area_id
                LEFT JOIN zones z
                    ON z.id = r.zone_id
                WHERE r.qr_code = ?
                  AND r.active = TRUE
                """;

        try (
                Connection connection =
                        DatabaseConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(1, qrCode);

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {
                    return map(resultSet);
                }
            }
        }

        return null;
    }

    private Resource map(
            ResultSet resultSet
    ) throws Exception {

        Resource resource =
                new Resource();

        resource.setId(
                resultSet.getInt("id")
        );

        resource.setAcademicUnitId(
                resultSet.getInt(
                        "academic_unit_id"
                )
        );

        resource.setAreaId(
                resultSet.getInt("area_id")
        );

        int zoneId =
                resultSet.getInt("zone_id");

        resource.setZoneId(
                resultSet.wasNull()
                        ? null
                        : zoneId
        );

        resource.setAcademicUnitName(
                resultSet.getString(
                        "academic_unit_name"
                )
        );

        resource.setAreaName(
                resultSet.getString(
                        "area_name"
                )
        );

        resource.setZoneName(
                resultSet.getString(
                        "zone_name"
                )
        );

        resource.setName(
                resultSet.getString("name")
        );

        resource.setInventoryNumber(
                resultSet.getString(
                        "inventory_number"
                )
        );

        resource.setQrCode(
                resultSet.getString("qr_code")
        );

        resource.setIdentificationType(
                resultSet.getString(
                        "identification_type"
                )
        );

        resource.setDescription(
                resultSet.getString(
                        "description"
                )
        );

        resource.setConditionStatus(
                resultSet.getString(
                        "condition_status"
                )
        );

        resource.setActive(
                resultSet.getBoolean("active")
        );

        return resource;
    }
}