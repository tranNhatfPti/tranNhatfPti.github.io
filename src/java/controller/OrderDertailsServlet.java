/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDetailsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.OrderDetails;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name = "OrderDertailsServlet", urlPatterns = {"/OrderDertailsServlet"})
public class OrderDertailsServlet extends HttpServlet {

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
        out.println("<title>Servlet OrderDertailsServlet</title>");
        out.println("</head>");
        out.println("<body>");
        try {
            /* TODO output your page here. You may use following sample code. */

            OrderDetailsDAO odd = new OrderDetailsDAO();
            Vector<OrderDetails> listOD = new Vector<>();
            String service = request.getParameter("service");
            
            if (service.equals("searchOD")) {
                String searchOD = request.getParameter("searchOD");
                String sql;

                // kiểm tra searchOD có chứa chữ hay không
                boolean checkDigit = searchOD.matches("\\d+");

                if (searchOD == null || searchOD.isBlank()) {
                    sql = "select * from OrderDetails";
                } else {
                    if (checkDigit) {
                        sql = "select * from OrderDetails where OrderID = " + searchOD + " or ProductCode = " + searchOD
                                + " or QuantityOrder = " + searchOD;
                    } else {
                        sql = "select * from OrderDetails where SizeOrder like '%" + searchOD + "%' or ColorOrder like '%" + searchOD + "%'";
                    }
                }
                listOD = odd.getAllOrderDetailsFromSQL(sql);

                request.setAttribute("listOD", listOD);
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/order-detail-manage.jsp").forward(request, response);
            }
            
            if(service.equals("delete")){
                String orderID_string = request.getParameter("orderID");
                String productCode_string = request.getParameter("productCode");
                int orderID = Integer.parseInt(orderID_string);
                int productCode = Integer.parseInt(productCode_string);
                
                if(odd.deleteOrderDetail(orderID, productCode)== 0){
                    request.setAttribute("msDeleteOrderDetail", "Không thể xoá chi tiết đơn hàng này!");
                } else {
                    request.setAttribute("msDeleteOrderDetail", "Xoá chi tiết đơn hàng thành công!");
                }
                
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/order-detail-manage.jsp").forward(request, response);
            }

        } catch(Exception ex){
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
