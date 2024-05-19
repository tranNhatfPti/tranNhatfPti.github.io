/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.BrandDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.Brand;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name = "BrandServlet", urlPatterns = {"/BrandServlet"})
public class BrandServlet extends HttpServlet {

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
        out.println("<title>Servlet BrandServlet</title>");
        out.println("</head>");
        out.println("<body>");
        try {
            /* TODO output your page here. You may use following sample code. */
            BrandDAO bd = new BrandDAO();

            String service = request.getParameter("service");
            
            Vector<Brand> vectorBrand = new Vector<>();

            if (service == null) {
                service = "searchBrand";
            }

            if (service.equals("insertBrand")) {
                String brandName = request.getParameter("brandName");
                String picture = request.getParameter("image");

                Brand brand = new Brand(brandName, picture);

                if (bd.insertBrand(brand) != 0) {
                    request.setAttribute("msInsertBrand", "Insert Brand succesfully!");
                } else {
                    request.setAttribute("msInsertBrand", "Insert Brand fail!");
                }

                if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                    request.setAttribute("fromServlet", "fromServlet");
                    request.getRequestDispatcher("admin/doc/form-insert-brand.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("InsertBrand.jsp").forward(request, response);
                }
            }

            if (service.equals("sendUpdateBrand")) {
                String brandName = request.getParameter("brandName");

                vectorBrand = bd.getAllBrandFromSQL("select * from Brand "
                        + "where BrandName like '%" + brandName + "%'");

                if (vectorBrand != null) {
                    request.setAttribute("brandNeedUpdate", vectorBrand.elementAt(0));
                    if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                        request.setAttribute("fromServlet", "fromServlet");
                        request.getRequestDispatcher("admin/doc/form-update-brand.jsp").forward(request, response);
                    }
                }
            }

            if (service.equals("updateBrand")) {
                String brandName = request.getParameter("brandName");
                String picture = request.getParameter("image");

                Brand brand = new Brand(brandName, picture);

                if (bd.updateBrand(brand) != 0) {
                    request.setAttribute("msUpdateBrand", "Update Brand succesfully!");
                } else {
                    request.setAttribute("msUpdateBrand", "Update Brand fail!");
                }

                request.setAttribute("brandNeedUpdate", brand);
                if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                    request.setAttribute("fromServlet", "fromServlet");
                    request.getRequestDispatcher("admin/doc/form-update-brand.jsp").forward(request, response);
                }
            }

            if (service.equals("searchBrand")) {
                String searchBrand = request.getParameter("searchBrand");
                String sql;             
                
                if(searchBrand == null) {
                    sql = "select * from Brand";
                }else {
                    sql = "select * from Brand where BrandName like '%" + searchBrand + "%'";
                }           
                vectorBrand = bd.getAllBrandFromSQL(sql);
                
                request.setAttribute("listBrand", vectorBrand); 
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/brand-manage.jsp").forward(request, response);
            }
            
            if(service.equals("deleteBrand")){
                String brandName = request.getParameter("brandName");
                
                if(bd.deleteBrand(brandName) == 0){
                    request.setAttribute("msDeleteBrand", "Không thể xoá danh mục này!");
                } else {
                    request.setAttribute("msDeleteBrand", "Xoá danh mục thành công!");
                }
                
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/brand-manage.jsp").forward(request, response);
            }
        } catch (IOException e) {
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
