/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.FeedbackDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import model.Customer;
import model.FeedBack;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name = "FeedbackServlet", urlPatterns = {"/FeedbackServlet"})
public class FeedbackServlet extends HttpServlet {

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
        out.println("<title>Servlet FeedbackServlet</title>");
        out.println("</head>");
        out.println("<body>");
        try {
            /* TODO output your page here. You may use following sample code. */
            HttpSession session = request.getSession();
            FeedbackDAO fd = new FeedbackDAO();
            String service = request.getParameter("service");
            
            if (service.equals("insertFB")) {
                Customer customer = (Customer) session.getAttribute("account");
                
                if (customer != null) {
                    String comment = request.getParameter("comment");
                    String productCode_string = request.getParameter("productCode");
                    String ratingValue_string = request.getParameter("ratingValue");

                    // khai báo đối tượng current thuộc class LocalDateTime
                    LocalDateTime current = LocalDateTime.now();
                    // sử dụng class DateTimeFormatter để định dạng ngày giờ theo kiểu pattern
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    // sử dụng phương thức format() để định dạng ngày giờ hiện tại rồi gán cho chuỗi
                    // formatted
                    String feedbackDate = current.format(formatter);
                    
                    FeedBack fb = new FeedBack(customer.getCustomerID(), Integer.parseInt(productCode_string), comment, "",
                            feedbackDate, Integer.parseInt(ratingValue_string));
                    
                    fd.insertFeedBack(fb);
                    request.getRequestDispatcher("ListSingleProductServlet?service=listInforProduct&productCode=" + productCode_string).forward(request, response);
                }
            }
        } catch (Exception ex) {
            out.print("<h1>Error</h1>");
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
