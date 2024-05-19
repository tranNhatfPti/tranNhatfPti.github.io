/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.util.Vector;
import model.Product;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProductDAO extends DBConnect {
    
    // lấy ra tất cả sản phẩm với câu lệnh sql tương ứng nhưng có lặp lại sản phẩm cùng tên(khác size, color)
    public Vector<Product> getAllProductFromSQL(String sql) {
        Vector<Product> vector = new Vector<Product>();

        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);

            ResultSet rs = st.executeQuery(sql);

            boolean checkProductDuplicate;
            while (rs.next()) {             
                Product product = new Product(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4), rs.getDouble(5),
                        rs.getString(6), rs.getString(7), rs.getString(8), rs.getInt(9), rs.getInt(10));
                vector.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vector;
    }

    public int insertProduct(Product obj) {
        int n = 0;

        String sql = "INSERT INTO [dbo].[Product]\n"
                + "           ([CategoryID]\n"
                + "           ,[ProductName]\n"
                + "           ,[BrandName]\n"
                + "           ,[Price]\n"
                + "           ,[Picture]\n"
                + "           ,[Description]\n"
                + "           ,[Gender]\n"
                + "           ,[Discount]\n"
                + "           ,[QuantitySold]\n)"
                + "     VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, obj.getCategoryID());
            ps.setString(2, obj.getProductName());
            ps.setString(3, obj.getBrandName());
            ps.setDouble(4, obj.getPrice());
            ps.setString(5, obj.getPicture());
            ps.setString(6, obj.getDescription());
            ps.setString(7, obj.getGender());
            ps.setInt(8, obj.getDiscount());
            ps.setInt(9, obj.getQuantitySold());

            // executeUpdate will return the correct number of rows updated
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }

    public int updateProduct(Product obj) {
        int n = 0;

        String sql = "UPDATE [dbo].[Product]\n"
                + "   SET [CategoryID] = " + obj.getCategoryID() + " \n"
                + "      ,[ProductName] = '" + obj.getProductName() + "'\n"
                + "      ,[BrandName] = '" + obj.getBrandName() + "'\n"
                + "      ,[Price] = " + obj.getPrice() + "\n"
                + "      ,[Picture] = '" + obj.getPicture() + "'\n"
                + "      ,[Description] = '" + obj.getDescription() + "'\n"
                + "      ,[Gender] = '" + obj.getGender() + "'\n"
                + "      ,[Discount] = " + obj.getDiscount() + "\n"
                + "      ,[QuantitySold] = " + obj.getQuantitySold() + "\n"
                + " WHERE [ProductCode] = " + obj.getProductCode();

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int updateQuantitySold(int productCode, int quantitySold) {
        int n = 0;

        String sql = "UPDATE [dbo].[Product]\n"
                + "   SET [QuantitySold] = " + quantitySold + "\n"
                + " WHERE [ProductCode] = " + productCode;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }

    
    public int deleteProduct(int productCode){
        int n = 0;

        String sql = "delete from Product where ProductCode = " + productCode + " and \n"
                + "(\n"
                + productCode + " not in (select distinct ProductCode from FeedBack) and \n"
                + productCode + " not in (select distinct ProductCode from OrderDetails) and \n"
                + productCode + " not in (select distinct ProductCode from ProductCart) and \n"
                + productCode + " not in (select distinct ProductCode from ProductDetail)\n"
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
