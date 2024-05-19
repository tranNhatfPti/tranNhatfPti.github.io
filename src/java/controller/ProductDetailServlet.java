/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ProductDAO;
import dal.ProductDetailDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Vector;
import model.Product;
import model.ProductDetail;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/ProductDetailServlet"})
public class ProductDetailServlet extends HttpServlet {

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
        out.println("<title>Servlet ProductDetailServlet</title>");
        out.println("</head>");
        out.println("<body>");
        try {
            /* TODO output your page here. You may use following sample code. */

            String service = request.getParameter("service");

            ProductDAO pd = new ProductDAO();
            ProductDetailDAO pdd = new ProductDetailDAO();

            Vector<Product> vectorProduct = new Vector<>();
            Vector<ProductDetail> vectorProductDetail = new Vector<>();

            if (service.equals("sendRequestToInsert")) {
                vectorProduct = pd.getAllProductFromSQL("select * from Product");

                request.setAttribute("listCodeAndName", vectorProduct);
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/form-insert-product-detail.jsp").forward(request, response);
            }

            if (service.equals("insertProductDetail")) {
                vectorProduct = pd.getAllProductFromSQL("select * from Product");

                String productCode_string = request.getParameter("productCode");
                String quantity_string = request.getParameter("quantity");
                String size = request.getParameter("size");
                String color = request.getParameter("color");

                int productCode = Integer.parseInt(productCode_string);
                int quantity = Integer.parseInt(quantity_string);

                ProductDetail productDetail = new ProductDetail(productCode, quantity, size, color);

                if (pdd.insertProductDetail(productDetail) != 0) {
                    request.setAttribute("msInsertProductDetail", "Insert Product Detail succesfully!");
                } else {
                    request.setAttribute("msInsertProductDetail", "Insert Product Detail fail!");
                }

                if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                    request.setAttribute("listCodeAndName", vectorProduct);
                    request.setAttribute("fromServlet", "fromServlet");
                    request.getRequestDispatcher("admin/doc/form-insert-product-detail.jsp").forward(request, response);
                }
            }

            if (service.equals("searchProductDetail")) {
                String searchProductDetail = request.getParameter("searchProductDetail");
                String sql;

                if (searchProductDetail == null) {
                    sql = "select * from ProductDetail";
                } else {
                    sql = "select * from ProductDetail pd join Product p on pd.ProductCode = p.ProductCode"
                            + " where p.ProductName like '%" + searchProductDetail + "%' or"
                            + " pd.Size like '%" + searchProductDetail + "%' or"
                            + " pd.Color like '%" + searchProductDetail + "%'";
                }
                vectorProductDetail = pdd.getAllProductDetailFromSQL(sql);

                request.setAttribute("listProductDetail", vectorProductDetail);
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/product-detail-manage.jsp").forward(request, response);
            }
            
            if (service.equals("sendUpdateProductDetail")) {
                String productCode_string = request.getParameter("productCode");
                String size = request.getParameter("size");
                String color = request.getParameter("color");
             
                vectorProductDetail = pdd.getAllProductDetailFromSQL("select * from ProductDetail where "
                        + "ProductCode = " + productCode_string + " and Size = '" + size + "' and Color = '" + color + "'");

                if (vectorProductDetail != null) {
                    request.setAttribute("productdetailNeedUpdate", vectorProductDetail.elementAt(0));
                    if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                        request.setAttribute("fromServlet", "fromServlet");
                        request.getRequestDispatcher("admin/doc/form-update-product-detail.jsp").forward(request, response);
                    }
                }
            }

            if (service.equals("updateProductDetail")) {
                String productCode_string = request.getParameter("productCode");
                String quantity_string = request.getParameter("quantity");
                String size = request.getParameter("size");
                String color = request.getParameter("color");
                
                int productCode = Integer.parseInt(productCode_string);
                int quantity = Integer.parseInt(quantity_string);

                ProductDetail productDetail = new ProductDetail(productCode, quantity, size, color);

                if (pdd.updateProductDetail(productDetail) != 0) {
                    request.setAttribute("msUpdateProductDetail", "Update Product Detail succesfully!");
                } else {
                    request.setAttribute("msUpdateProductDetail", "Update Product Detail succesfully!");
                }

                request.setAttribute("productdetailNeedUpdate", productDetail);
                if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                    request.setAttribute("fromServlet", "fromServlet");
                    request.getRequestDispatcher("admin/doc/form-update-product-detail.jsp").forward(request, response);
                }
            }
            
            if(service.equals("delete")){
                String productCode_string = request.getParameter("productCode");
                String size = request.getParameter("size");
                String color = request.getParameter("color");
                int productCode = Integer.parseInt(productCode_string);
                
                if(pdd.deleteProductDetail(productCode, size, color) == 0){
                    request.setAttribute("msDeleteProductDetail", "Không thể xoá chi tiết sản phẩm này!");
                } else {
                    request.setAttribute("msDeleteProductDetail", "Xoá chi tiết sản phẩm thành công!");
                }
                
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/product-detail-manage.jsp").forward(request, response);
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
