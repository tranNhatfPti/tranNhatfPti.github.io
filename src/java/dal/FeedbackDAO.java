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
import model.FeedBack;

public class FeedbackDAO extends DBConnect {

    public Vector<FeedBack> getAllFeedBackFromSQL(String sql) {
        Vector<FeedBack> vector = new Vector<FeedBack>();

        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);

            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                FeedBack feedback = new FeedBack(rs.getInt(1), rs.getInt(2), rs.getInt(3), rs.getString(4),
                        rs.getString(5), rs.getString(6), rs.getInt(7));
                vector.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vector;
    }

    public int insertFeedBack(FeedBack obj) {
        int n = 0;

        String sql = "INSERT INTO [dbo].[FeedBack]\n"
                + "           ([CustomerID]\n"
                + "           ,[ProductCode]\n"
                + "           ,[Content]\n"
                + "           ,[AdminResponse]\n"
                + "           ,[FeedbackDate]\n"
                + "           ,[Evaluate])\n"
                + "     VALUES(?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, obj.getCustomerID());
            ps.setInt(2, obj.getProductCode());
            ps.setString(3, obj.getContent());
            ps.setString(4, obj.getAdminResponse());
            ps.setString(5, obj.getFeedbackDate());
            ps.setInt(6, obj.getEvaluate());
            
            // executeUpdate will return the correct number of rows updated
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }
}
