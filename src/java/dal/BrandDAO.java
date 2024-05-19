/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import model.Brand;

public class BrandDAO extends DBConnect{
    
    public Vector<Brand> getAllBrandFromSQL(String sql) {
        Vector<Brand> vector = new Vector<Brand>();
        
        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            
            ResultSet rs = st.executeQuery(sql);
            
            while (rs.next()) {                
                  Brand brand = new Brand(rs.getString(1), rs.getString(2));
                  vector.add(brand);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return vector;
    }
    
    public int insertBrand(Brand obj) {
        int n = 0;
        
        String sql = "INSERT INTO [dbo].[Brand]\n"
                + "           ([BrandName]\n"
                + "           ,[Picture])\n"
                + "     VALUES(?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, obj.getBrandName());
            ps.setString(2, obj.getPicture());

            // executeUpdate will return the correct number of rows updated
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int updateBrand(Brand obj) {
        int n = 0;

        String sql = "UPDATE [dbo].[Brand]\n"
                + "   SET [Picture] = '" + obj.getPicture() + "'\n"
                + " WHERE [BrandName] like '%" + obj.getBrandName() + "%'";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int deleteBrand(String brandName){
        int n = 0;

        String sql = "delete from Brand where BrandName LIKE '%" + brandName + "%' and \n"
                + "(\n"
                + "'" + brandName + "' not in (select distinct BrandName from Product)"
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
