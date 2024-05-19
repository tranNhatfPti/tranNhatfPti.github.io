package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import model.ProductDetail;

public class ProductDetailDAO extends DBConnect{
    public Vector<ProductDetail> getAllProductDetailFromSQL(String sql) {
        Vector<ProductDetail> vector = new Vector<ProductDetail>();
        
        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            
            ResultSet rs = st.executeQuery(sql);
            
            while (rs.next()) {                
                  ProductDetail productDetail = new ProductDetail(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4));
                  vector.add(productDetail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return vector;
    }
    
    public int insertProductDetail(ProductDetail obj) {
        int n = 0;
        
        String sql = "INSERT INTO [dbo].[ProductDetail]\n"
                + "           ([ProductCode]\n"
                + "           ,[Quantity]\n"
                + "           ,[Size]\n"
                + "           ,[Color]\n)"
                + "     VALUES(?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, obj.getProductCode());
            ps.setInt(2, obj.getQuantity());
            ps.setString(3, obj.getSize());
            ps.setString(4, obj.getColor());

            // executeUpdate will return the correct number of rows updated
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int updateProductDetail(ProductDetail obj) {
        int n = 0;

        String sql = "UPDATE [dbo].[ProductDetail]\n"
                + "   SET [Quantity] = " + obj.getQuantity() + "\n"
                + " WHERE [ProductCode] = " + obj.getProductCode() + " and "
                + "       [Size] = '" + obj.getSize() + "' and "
                + "       [Color] = '" + obj.getColor() + "'";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int deleteProductDetail(int productCode, String size, String color){
        int n = 0;

        String sql = "delete from ProductDetail where ProductCode = " + productCode + " and Size = '" + size + "' and Color = '" + color + "'"; 

        try {
            Statement st = connection.createStatement();
            n = st.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return n;
    }
    
}
