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
import model.OrderDetails;

public class OrderDetailsDAO extends DBConnect {

    public Vector<OrderDetails> getAllOrderDetailsFromSQL(String sql) {
        Vector<OrderDetails> vector = new Vector<OrderDetails>();

        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);

            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                OrderDetails orderDetail = new OrderDetails(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4),
                        rs.getInt(5), rs.getInt(6));
                vector.add(orderDetail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vector;
    }

    public int insertOrderDetails(OrderDetails obj) {
        int n = 0;

        String sql = "INSERT INTO [dbo].[OrderDetails]\n"
                + "           ([OrderID]\n"
                + "           ,[ProductCode]\n"
                + "           ,[SizeOrder]\n"
                + "           ,[ColorOrder]\n"
                + "           ,[QuantityOrder]\n"
                + "           ,[DiscountFromCode])\n"
                + "     VALUES(?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, obj.getOrderID());
            ps.setInt(2, obj.getProductCode());
            ps.setString(3, obj.getSizeOrder());
            ps.setString(4, obj.getColorOrder());
            ps.setInt(5, obj.getQuantityOrder());
            ps.setInt(6, obj.getDiscountFromCode());

            // executeUpdate will return the correct number of rows updated
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }

    public int updateOrderDetails(OrderDetails obj) {
        int n = 0;

        String sql = "UPDATE [dbo].[OrderDetails]\n"
                + "   SET [SizeOrder] = '" + obj.getSizeOrder()+ "'\n"
                + "      ,[ColorOrder] = '" + obj.getColorOrder()+ "'\n"
                + "      ,[QuantityOrder] = " + obj.getQuantityOrder() + "\n"
                + "      ,[DiscountFromCode] = " + obj.getDiscountFromCode()+ "\n"
                + " WHERE [OrderID] = " + obj.getOrderID() + " and [ProductCode] = " + obj.getProductCode();

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int deleteOrderDetail(int orderID, int productCode){
        int n = 0;

        String sql = "delete from OrderDetails where OrderID = " + orderID + " and ProductCode = " + productCode;

        try {
            Statement st = connection.createStatement();
            n = st.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return n;
    }
}
