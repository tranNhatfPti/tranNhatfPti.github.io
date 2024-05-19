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
import model.Orders;

public class OrdersDAO extends DBConnect {

    public Vector<Orders> getAllOrdersFromSQL(String sql) {
        Vector<Orders> vector = new Vector<Orders>();

        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);

            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                Orders order = new Orders(rs.getInt(1), rs.getInt(2), rs.getInt(3), rs.getString(4), rs.getString(5),
                        rs.getDouble(6), rs.getString(7), rs.getInt(8));
                vector.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vector;
    }

    public int insertOrders(Orders obj) {
        int n = 0;

        String sql = "INSERT INTO [dbo].[Orders]\n"
                + "           ([CustomerID]\n"
                + "           ,[ShipperID]\n"
                + "           ,[OrderDate]\n"
                + "           ,[ShippedDate]\n"
                + "           ,[ShippingTotal]\n"
                + "           ,[ShipAddress]\n"
                + "           ,[Status])\n"
                + "     VALUES(?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, obj.getCustomerID());
            ps.setInt(2, obj.getShipperID());
            ps.setString(3, obj.getOrderDate());
            ps.setString(4, obj.getShippedDate());
            ps.setDouble(5, obj.getShippingTotal());
            ps.setString(6, obj.getShipAddress());
            ps.setInt(7, obj.getStatus());

            // executeUpdate will return the correct number of rows updated
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }

    public int updateOrders(Orders obj) {
        int n = 0;

        String sql = "UPDATE [dbo].[Orders]\n"
                + "   SET [CustomerID] = " + obj.getCustomerID()+ "\n"
                + "      ,[ShipperID] = " + obj.getShipperID()+ "\n"
                + "      ,[OrderDate] = '" + obj.getOrderDate() + "'\n"
                + "      ,[ShippedDate] = '" + obj.getShippedDate()+ "'\n"
                + "      ,[ShippingTotal] = " + obj.getShippingTotal() + "\n"
                + "      ,[ShipAddress] = '" + obj.getShipAddress() + "'\n"
                + "      ,[Status] = " + obj.getStatus() + "\n"
                + " WHERE [OrderID] = " + obj.getOrderID();

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int updateOrderStatus(int orderID, int status, String shippedDate) {
        int n = 0;

        String sql = "UPDATE [dbo].[Orders]\n"
                + "   SET [Status] = " + status + "\n"
                + "      ,[ShippedDate] = '" + shippedDate+ "'\n"
                + " WHERE [OrderID] = " + orderID;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int updateOrderStatusAdmin(int orderID, int status) {
        int n = 0;

        String sql = "UPDATE [dbo].[Orders]\n"
                + "   SET [Status] = " + status + "\n"
                + " WHERE [OrderID] = " + orderID;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
    
    public int deleteOrder(int orderID){
        int n = 0;

        String sql = "delete from Orders where OrderID = " + orderID + " and \n"
                + "(\n"
                + orderID + " not in (select distinct OrderID from OrderDetails )"
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
