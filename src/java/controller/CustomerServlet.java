/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.Customer;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name = "CustomerServlet", urlPatterns = {"/CustomerServlet"})
public class CustomerServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Servlet CustomerServlet</title>");
        out.println("</head>");
        out.println("<body>");
        try {
            /* TODO output your page here. You may use following sample code. */
            String service = request.getParameter("service");

            CustomerDAO cd = new CustomerDAO();

            if (service.equals("searchCustomer")) {
                String searchCustomer = request.getParameter("searchCustomer");

                String sql = "";
                if (searchCustomer != null) {
                    sql = "select * from Customer where FirstName like N'%" + searchCustomer + "%' or "
                            + "LastName like N'%" + searchCustomer + "%'";
                }
                
                Vector<Customer> listCustomer = cd.getAllCustomerFromSQL(sql);
                
                request.setAttribute("fromServlet", "fromServlet");
                request.setAttribute("listCustomer", listCustomer);
                request.getRequestDispatcher("admin/doc/customer-manage.jsp").forward(request, response);
            }
            
            if(service.equals("delete")){
                String customerID_string = request.getParameter("customerID");
                
                int customerID = Integer.parseInt(customerID_string);
                
                if(cd.deleteCustomer(customerID) == 0){
                    request.setAttribute("msDeleteCustomer", "Không thể xoá khách hàng này!");
                } else {
                    request.setAttribute("msDeleteCustomer", "Xoá khách hàng thành công!");
                }
                
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/customer-manage.jsp").forward(request, response);
            }
        } catch (Exception ex) {
            out.print("<h1>Error!</h1>");
        }
        out.println("</body>");
        out.println("</html>");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
