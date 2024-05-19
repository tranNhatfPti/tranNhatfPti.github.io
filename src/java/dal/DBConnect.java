package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    protected Connection connection = null;

    public DBConnect(String URL, String userName, String pass) {
        try {
            // Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Connection
            connection = DriverManager.getConnection(URL, userName, pass);

        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public DBConnect() {
        this("jdbc:sqlserver://localhost:1433;databaseName=ClothingStore", "sa", "123456");
    }
}
