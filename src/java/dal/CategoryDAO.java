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
import model.Category;

public class CategoryDAO extends DBConnect {

    public Vector<Category> getAllCategoryFromSQL(String sql) {
        Vector<Category> vector = new Vector<Category>();

        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);

            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                Category category = new Category(rs.getInt(1), rs.getString(2), rs.getString(3));
                vector.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vector;
    }

    public Vector<Integer> getCategoryID(String sql) {
        Vector<Integer> vector = new Vector<Integer>();

        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);

            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                vector.add(rs.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return vector;
    }

    public int insertCategory(Category obj) {
        int n = 0;

        String sql = "INSERT INTO [dbo].[Category]\n"
                + "           ([Name]\n"
                + "           ,[Description])\n"
                + "     VALUES(?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, obj.getName());
            ps.setString(2, obj.getDescription());

            // executeUpdate will return the correct number of rows updated
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int updateCategory(Category obj) {
        int n = 0;

        String sql = "UPDATE [dbo].[Category]\n"
                + "   SET [Name] = '" + obj.getName() + "'\n"
                + "      ,[Description] = '" + obj.getDescription() + "'\n"
                + " WHERE [CategoryID] = " + obj.getCategoryID();

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int deleteCategory(int categoryID){
        int n = 0;

        String sql = "delete from Category where CategoryID = " + categoryID + " and \n"
                + "(" + categoryID + " not in (select distinct CategoryID from Product))";

        try {
            Statement st = connection.createStatement();
            n = st.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return n;
    }
}
