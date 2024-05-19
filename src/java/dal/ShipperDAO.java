package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import model.Shipper;

public class ShipperDAO extends DBConnect{
    public Vector<Shipper> getAllShipperFromSQL(String sql) {
        Vector<Shipper> vector = new Vector<Shipper>();
        
        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            
            ResultSet rs = st.executeQuery(sql);
            
            while (rs.next()) {                
                  Shipper shipper = new Shipper(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4));
                  vector.add(shipper);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return vector;
    }
    
    public int insertShipper(Shipper obj) {
        int n = 0;
        
        String sql = "INSERT INTO [dbo].[Shipper]\n"
                + "           ([Phone]\n"
                + "           ,[CompanyName]\n"
                + "           ,[Country])\n"
                + "     VALUES(?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, obj.getPhone());
            ps.setString(2, obj.getCompanyName());
            ps.setString(3, obj.getCountry());

            // executeUpdate will return the correct number of rows updated
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int updateShipper (Shipper obj) {
        int n = 0;

        String sql = "UPDATE [dbo].[Shipper]\n"
                + "   SET [Phone] = '" + obj.getPhone()+ "'\n"
                + "      ,[CompanyName] = '" + obj.getCompanyName()+ "'\n"
                + "      ,[Country] = '" + obj.getCountry()+ "'\n"
                + " WHERE [ShipperID] = " + obj.getShipperID();

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int deleteShipper(int shipperID){
        int n = 0;

        String sql = "delete from Shipper where ShipperID = " + shipperID + " and \n"
                + "(\n"
                + shipperID + " not in (select distinct ShipperID from Orders)\n"
                + ")";

        try {
            Statement st = connection.createStatement();
            n = st.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return n;
    }
}
