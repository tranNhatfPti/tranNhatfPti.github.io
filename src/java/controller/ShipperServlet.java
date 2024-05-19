/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ShipperDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.Shipper;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name = "ShipperServlet", urlPatterns = {"/ShipperServlet"})
public class ShipperServlet extends HttpServlet {

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
        out.println("<title>Servlet ShipperServlet</title>");
        out.println("</head>");
        out.println("<body>");

        try {
            /* TODO output your page here. You may use following sample code. */
            ShipperDAO sd = new ShipperDAO();

            String service = request.getParameter("service");

            if (service.equals("searchShipper")) {
                String searchShipper = request.getParameter("searchShipper");
                String sql;

                if (searchShipper == null) {
                    sql = "select * from Shipper";
                } else {
                    sql = "select * from Shipper where Phone like '%" + searchShipper + "%' or"
                            + " CompanyName like N'%" + searchShipper + "%' or"
                            + " Country like N'%" + searchShipper + "%'";
                }

                Vector<Shipper> listShipper = sd.getAllShipperFromSQL(sql);

                request.setAttribute("listShipper", listShipper);
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/shipper-manage.jsp").forward(request, response);
            }            

            if (service.equals("sendUpdateShipper")) {
                String shipperID_string = request.getParameter("shipperID");

                Vector<Shipper> vectorShipper = sd.getAllShipperFromSQL("select * from Shipper where ShipperID = " + shipperID_string);

                if (vectorShipper != null) {
                    request.setAttribute("shipperNeedUpdate", vectorShipper.elementAt(0));
                    if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                        request.setAttribute("fromServlet", "fromServlet");
                        request.getRequestDispatcher("admin/doc/form-update-shipper.jsp").forward(request, response);
                    }
                }
            }

            if (service.equals("updateShipper")) {
                String shipperID_string = request.getParameter("shipperID");
                String phone = request.getParameter("phone");
                String companyName = request.getParameter("companyName");
                String country = request.getParameter("country");
                
                int shipperID = Integer.parseInt(shipperID_string);

                Shipper shipper = new Shipper(shipperID, phone, companyName, country);

                if (sd.updateShipper(shipper) != 0) {
                    request.setAttribute("msUpdateShipper", "Update Shipper succesfully!");
                } else {
                    request.setAttribute("msUpdateShipper", "Update Shipper fail!");
                }

                request.setAttribute("shipperNeedUpdate", shipper);
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/form-update-shipper.jsp").forward(request, response);
            }
            
            if (service.equals("insertShipper")) {
                String phone = request.getParameter("phone");
                String companyName = request.getParameter("companyName");
                String country = request.getParameter("country");;

                Shipper shipper = new Shipper(phone, companyName, country);

                if (sd.insertShipper(shipper) != 0) {
                    request.setAttribute("msInsertShipper", "Insert Shipper succesfully!");
                } else {
                    request.setAttribute("msInsertShipper", "Insert Shipper fail!");
                }

                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/form-insert-shipper.jsp").forward(request, response);
            }
            
            if(service.equals("delete")){
                String shipperID_string = request.getParameter("shipperID");
                int shipperID = Integer.parseInt(shipperID_string);
                
                if(sd.deleteShipper(shipperID) == 0){
                    request.setAttribute("msDeleteShipper", "Không thể xoá đơn vị vận chuyển này!");
                } else {
                    request.setAttribute("msDeleteShipper", "Xoá đơn vị vận chuyển thành công!");
                }
                
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/shipper-manage.jsp").forward(request, response);
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
