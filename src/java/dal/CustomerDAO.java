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
import model.Customer;

/**
 *
 * @author ASUS ZenBook
 */
public class CustomerDAO extends DBConnect {
    
    public Vector<Customer> getAllCustomerFromSQL(String sql) {
        Vector<Customer> vector = new Vector<Customer>();
        
        try {
            Statement st = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            
            ResultSet rs = st.executeQuery(sql);
            
            while (rs.next()) {                
                  Customer customer = new Customer(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5),
                   rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10),  rs.getDouble(11), rs.getString(12));
                  vector.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return vector;
    }
    
    public Customer getCustomerByUsername(String username) {      
        String sql = "select * from Customer where UserName = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()){
                return new Customer(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), 
                        rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10), rs.getDouble(11), rs.getString(12));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public int insertCustomer(Customer c) {
        int n = 0;

        String sql = "insert into Customer ([UserName],[PassWord],[FirstName],[LastName],[Email],"
                + "[Phone],[Gender],[Address],[BirthOfDate], [MoneyBalance]) "
                + "values "
                + "(?,?,?,?,?,?,?,?,?,?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, c.getUsername());
            ps.setString(2, c.getPassword());
            ps.setString(3, c.getFirstName());
            ps.setString(4, c.getLastName());
            ps.setString(5, c.getEmail());
            ps.setString(6, c.getPhone());
            ps.setString(7, c.getGender());
            ps.setString(8, c.getAddress());
            ps.setString(9, c.getBirthOfDate());
            ps.setDouble(10, c.getMoneyBalance());

            // nếu như insert 1 customer giống username thì sẽ lỗi.
            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return n;
    }

    public boolean checkUsernameAndPassword(String username, String password) {
        //khi so sánh chuỗi và dùng setString thì không cần dùng dấu ''
        String sql = "select * from Customer where username = ? and password = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public int updateCustomer(Customer c) {
        int n = 0;

        String sql = "UPDATE [dbo].[Customer]\n"
                + "   SET [UserName] = ?"
                + "      ,[PassWord] = ?"
                + "      ,[FirstName] = ?"
                + "      ,[LastName] = ?"
                + "      ,[Email] = ?"
                + "      ,[Phone] = ?"
                + "      ,[Gender] = ?"
                + "      ,[Address] = ?"
                + "      ,[BirthOfDate] = ?"
                + "      ,[MoneyBalance] = ?"
                + "      ,[Avatar] = ?"
                + " WHERE CustomerID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, c.getUsername());
            ps.setString(2, c.getPassword());
            ps.setString(3, c.getFirstName());
            ps.setString(4, c.getLastName());
            ps.setString(5, c.getEmail());
            ps.setString(6, c.getPhone());
            ps.setString(7, c.getGender());
            ps.setString(8, c.getAddress());
            ps.setString(9, c.getBirthOfDate());
            ps.setDouble(10, c.getMoneyBalance());
            ps.setString(11, c.getAvatar());
            ps.setInt(12, c.getCustomerID());

            n = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return n;
    }
    
    public int deleteCustomer(int customerID){
        int n = 0;

        String sql = "delete from Customer where CustomerID = " + customerID + " and \n"
                + "(\n"
                + customerID + " not in (select distinct CustomerID from FeedBack ) and \n"
                + customerID + " not in (select distinct CustomerID from Orders) and \n"
                + customerID + " not in (select distinct CustomerID from ProductCart)\n"
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
