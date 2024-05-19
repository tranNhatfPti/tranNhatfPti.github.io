package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import model.ProductCart;

public class ProductCartDAO extends DBConnect {

    public Vector<ProductCart> getAllProductCartFromSQL(String sql) {
        Vector<ProductCart> vector = new Vector<ProductCart>();

        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);

            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                ProductCart productCart = new ProductCart(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4), rs.getString(5),
                        rs.getDouble(6), rs.getInt(7), rs.getString(8));
                vector.add(productCart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vector;
    }

    public int insertProductCart(ProductCart obj) {
        int n = 0;

        String sql = "INSERT INTO [dbo].[ProductCart]\n"
                + "           ([CustomerID]\n"
                + "           ,[ProductCode]\n"
                + "           ,[ProductName]\n"
                + "           ,[Size]\n"
                + "           ,[Color]\n"
                + "           ,[Price]\n"
                + "           ,[Quantity]\n"
                + "           ,[Picture])\n"
                + "     VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, obj.getCustomerID());
            ps.setInt(2, obj.getProductCode());
            ps.setString(3, obj.getProductName());
            ps.setString(4, obj.getSize());
            ps.setString(5, obj.getColor());
            ps.setDouble(6, obj.getPrice());
            ps.setInt(7, obj.getQuantity());
            ps.setString(8, obj.getImage());

            // executeUpdate will return the correct number of rows updated
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }

    public int updateProductCart(ProductCart obj) {
        int n = 0;

        String sql = "UPDATE [dbo].[ProductCart]\n"
                + "   SET [ProductName] = '" + obj.getProductName() + "'\n"
                + "      ,[Price] = " + obj.getPrice() + "\n"
                + "      ,[Quantity] = '" + obj.getQuantity() + "'\n"
                + "      ,[Picture] = '" + obj.getImage() + "'\n"
                + " WHERE [CustomerID] = " + obj.getCustomerID() + " and [ProductCode] = " + obj.getProductCode() + " and Size = '"
                + obj.getSize() + "' and Color = '" + obj.getColor() + "'";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int removeProductCart(int customerID, int productCode, String size, String color) {
        int n = 0;

        String sql = "delete from ProductCart WHERE [CustomerID] = " + customerID + " and [ProductCode] = " + productCode
                + " and Size = '"+ size + "' and Color = '" + color + "'"; 

        try {
            Statement st = connection.createStatement();
            n = st.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return n;
    }
}
