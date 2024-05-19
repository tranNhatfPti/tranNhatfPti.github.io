/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.Product;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name="ProductServlet", urlPatterns={"/ProductServlet"})
public class ProductServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
        // đưa hết phần sản phẩm ở ListProduct sang
        try {
            /* TODO output your page here. You may use following sample code. */
            ProductDAO pd = new ProductDAO();
            
            String service = request.getParameter("service");
            
            // xoá sản phẩm
            if(service.equals("delete")){
                String productCode_string = request.getParameter("productCode");
                int productCode = Integer.parseInt(productCode_string);
                
                if(pd.deleteProduct(productCode) == 0){
                    request.setAttribute("msDeleteProduct", "Không thể xoá sản phẩm này!");
                } else {
                    request.setAttribute("msDeleteProduct", "Xoá sản phẩm thành công!");
                }
                
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/product-manage.jsp").forward(request, response);
            }
            
            // thêm sản phẩm
            if (service.equals("insertProduct")) {
                String category = request.getParameter("category");
                String productName = request.getParameter("productName");
                String brandName = request.getParameter("brandName");
                String price_string = request.getParameter("price");
                String picture = request.getParameter("picture");
                String description = request.getParameter("description");
                String gender = request.getParameter("gender");
                String discount_string = request.getParameter("discount");
                String quantitySold_string = request.getParameter("quantitySold");

                int categoryID = Integer.parseInt(category);
                double price = Double.parseDouble(price_string);
                int quantitySold = Integer.parseInt(quantitySold_string);
                int discount = Integer.parseInt(discount_string);

                Product product = new Product(categoryID, productName, brandName, price,
                        picture, description, gender, discount, quantitySold);

                if (pd.insertProduct(product) != 0) {
                    request.setAttribute("msInsertProduct", "Insert Product succesfully!");
                } else {
                    request.setAttribute("msInsertProduct", "Insert Product fail!");
                }

                if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                    request.setAttribute("fromServlet", "fromServlet");
                    request.getRequestDispatcher("admin/doc/form-insert-product.jsp").forward(request, response);
                }
            }

            // gửi thông tin sản phẩm muốn update đến trang update sản phẩm
            if (service.equals("sendUpdateProduct")) {
                String productCode_string = request.getParameter("productCode");
                int productCode = Integer.parseInt(productCode_string);

                Vector<Product> vector = pd.getAllProductFromSQL("select * from Product "
                        + "where ProductCode = " + productCode);

                if (vector != null) {
                    request.setAttribute("productNeedUpdate", vector.elementAt(0));

                    if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                        request.setAttribute("fromServlet", "fromServlet");
                        request.getRequestDispatcher("admin/doc/form-update-product.jsp").forward(request, response);
                    }
                    request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
                }
            }

            // cập nhật sản phẩm
            if (service.equals("updateProduct")) {
                String productCode_string = request.getParameter("productCode");
                String category = request.getParameter("category");
                String productName = request.getParameter("productName");
                String brandName = request.getParameter("brandName");
                String price_string = request.getParameter("price");
                String picture = request.getParameter("picture");
                String description = request.getParameter("description");
                String gender = request.getParameter("gender");
                String discount_string = request.getParameter("discount");
                String quantitySold_string = request.getParameter("quantitySold");

                int productCode = Integer.parseInt(productCode_string);
                int categoryID = Integer.parseInt(category);
                double price = Double.parseDouble(price_string);
                int discount = Integer.parseInt(discount_string);
                int quantitySold = Integer.parseInt(quantitySold_string);

                Product product = new Product(productCode, categoryID, productName, brandName, price,
                        picture, description, gender, discount, quantitySold);

                if (pd.updateProduct(product) != 0) {
                    request.setAttribute("msUpdateProduct", "Update Product succesfully!");
                } else {
                    request.setAttribute("msUpdateProduct", "Update Product fail!");
                }

                request.setAttribute("productNeedUpdate", product);
                if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                    request.setAttribute("fromServlet", "fromServlet");
                    request.getRequestDispatcher("admin/doc/form-update-product.jsp").forward(request, response);
                }

                request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
