/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.Category;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name = "CategoryServlet", urlPatterns = {"/CategoryServlet"})
public class CategoryServlet extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CategoryServlet</title>");
            out.println("</head>");
            out.println("<body>");

            CategoryDAO cd = new CategoryDAO();

            String service = request.getParameter("service");

            Vector<Category> vectorCategory = new Vector<>();

            if (service.equals("listAllCategoryAdmin")) {
                vectorCategory = cd.getAllCategoryFromSQL("select * from Category");

                request.setAttribute("capListCategory", "List Category");
                request.setAttribute("listCategory", vectorCategory);
                request.getRequestDispatcher("CategoryManage.jsp").forward(request, response);
            }

            if (service.equals("insertCategory")) {
                String categoryName = request.getParameter("categoryName");
                String description = request.getParameter("description");

                Category category = new Category(categoryName, description);

                if (cd.insertCategory(category) != 0) {
                    request.setAttribute("msInsertCategory", "Insert Category succesfully!");
                } else {
                    request.setAttribute("msInsertCategory", "Insert Category fail!");
                }

                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/form-insert-category.jsp").forward(request, response);
            }

            if (service.equals("searchCategory")) {
                String searchCategory = request.getParameter("searchCategory");
                String sql;

                if (searchCategory == null) {
                    sql = "select * from Category";
                } else {
                    sql = "select * from Category where Name like '%" + searchCategory + "%' or "
                            + "Description like '%" + searchCategory + "%'";
                }
                vectorCategory = cd.getAllCategoryFromSQL(sql);

                request.setAttribute("listCategory", vectorCategory);
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/category-manage.jsp").forward(request, response);
            }

            if (service.equals("sendUpdateCategory")) {
                String categoryID_string = request.getParameter("categoryID");

                vectorCategory = cd.getAllCategoryFromSQL("select * from Category "
                        + "where CategoryID = " + categoryID_string);

                if (vectorCategory != null) {
                    request.setAttribute("categoryNeedUpdate", vectorCategory.elementAt(0));
                    if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                        request.setAttribute("fromServlet", "fromServlet");
                        request.getRequestDispatcher("admin/doc/form-update-category.jsp").forward(request, response);
                    }
                }
            }

            if (service.equals("updateCategory")) {
                String categoryID_String = request.getParameter("categoryID");
                String name = request.getParameter("name");
                String description = request.getParameter("description");

                int categoryID = Integer.parseInt(categoryID_String);

                Category category = new Category(categoryID, name, description);

                if (cd.updateCategory(category) != 0) {
                    request.setAttribute("msUpdateCategory", "Update Category succesfully!");
                } else {
                    request.setAttribute("msUpdateCategory", "Update Category fail!");
                }

                request.setAttribute("categoryNeedUpdate", category);
                if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                    request.setAttribute("fromServlet", "fromServlet");
                    request.getRequestDispatcher("admin/doc/form-update-category.jsp").forward(request, response);
                }
            }

            if (service.equals("delete")) {
                String categoryID_string = request.getParameter("categoryID");
                int categoryID = Integer.parseInt(categoryID_string);
                
                if(cd.deleteCategory(categoryID) == 0){
                    request.setAttribute("msDeleteCategory", "Không thể xoá danh mục này!");
                } else {
                    request.setAttribute("msDeleteCategory", "Xoá danh mục thành công!");
                }
                
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/category-manage.jsp").forward(request, response);
            }

            out.println("</body>");
            out.println("</html>");
        }
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
