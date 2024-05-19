/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
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
@WebServlet(name = "ListSingleProductServlet", urlPatterns = {"/ListSingleProductServlet"})
public class ListSingleProductServlet extends HttpServlet {

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
        out.println("<title>Servlet ListSingleProductServlet</title>");
        out.println("</head>");
        out.println("<body>");
        try {
            /* TODO output your page here. You may use following sample code. */

            String service = request.getParameter("service");

            ProductDAO pd = new ProductDAO();
            ProductDetailDAO pdd = new ProductDetailDAO();
            CategoryDAO cd = new CategoryDAO();

            if (service.equals("listInforProduct")) {
                // lấy ra mã của sản phẩm đang chọn.
                String productCode_string = request.getParameter("productCode");
                int productCode = Integer.parseInt(productCode_string);
                
                // lấy ra sản phẩm có mã sản phẩm tương ứng
                Product product = pd.getAllProductFromSQL("select * from Product where ProductCode = " + productCode).firstElement();
                
                // lấy size và color đã chọn từ page.
                String sizeSelected = request.getParameter("size");
                String colorSelected = request.getParameter("color");              

                // lấy ra danh sách các chi tiết của mặt hàng.
                Vector<ProductDetail> listProductDetail = pdd.getAllProductDetailFromSQL("select * from ProductDetail where ProductCode = " + productCode);
                // lấy ra sản chi tiết của mặt hàng đầu tiên.
                ProductDetail firstProductDetail = listProductDetail.firstElement();

                Vector<String> allColorProduct = new Vector<String>();
                Vector<String> allSizeProduct = new Vector<String>();

                // lấy tất cả màu của sản phẩm đang chọn.
                listProductDetail.forEach(pDetail -> {
                    if(!allColorProduct.contains(pDetail.getColor())){
                        allColorProduct.add(pDetail.getColor());
                    }
                });

                // lấy tất cả size của sản phẩm đang chọn.
                listProductDetail.forEach(pDetail -> {
                    if(!allSizeProduct.contains(pDetail.getSize())){
                        allSizeProduct.add(pDetail.getSize());
                    }
                });

                // lấy số lượng sản phẩm đang chọn.
                int quantityProduct;
                
                // sizeSelected = null && colorSelected = null khi bấm xem detail sản phẩm lần đầu
                if (sizeSelected == null && colorSelected == null) {
                    quantityProduct = firstProductDetail.getQuantity();      
                    sizeSelected = firstProductDetail.getSize();
                    colorSelected = firstProductDetail.getColor();
                }else{        
                    // lấy ra sản phẩm có size và color tương ứng
                    Vector<ProductDetail> vectorPD = pdd.getAllProductDetailFromSQL("select * from ProductDetail where Size = '" + sizeSelected + "'"
                            + " and Color = '" + colorSelected + "' and ProductCode = " + productCode);
                    
                    // nếu có sản phẩm với size và color tương ứng thì sẽ lấy số lượng sp đấy ra
                    if(!vectorPD.isEmpty()) {
                        ProductDetail p = vectorPD.firstElement();
                        quantityProduct = p.getQuantity();
                    }
                    // nếu không có sản phẩm với size và color tương ứng thì số lượng sẽ = 0
                    else{
                        quantityProduct = 0;
                    }    
                }
                
                /*lấy ra những sản phẩm thuộc category khác*/
                
                // categoryID của sản phẩm đang chọn để xem
                int categoryID = product.getCategoryID();
                // lấy ra tất cả categoryID
                Vector<Integer> listCategoryID = cd.getCategoryID("select CategoryID from Category");
                // lấy ra các sản phẩm của các category tương ứng nhưng khác category với sản phẩm đang chọn để xem
                Vector<Product> listOtherProductCategory = new Vector<Product>();
                
                for(int i = 0; i <= listCategoryID.size() - 1; ++i) {
                    // lấy ra các sản phẩm của các category tương ứng nhưng khác category với sản phẩm đang chọn để xem
                    if(listCategoryID.get(i) != categoryID) {
                        Product p = pd.getAllProductFromSQL("select top 1 * from Product where categoryID = "
                                + listCategoryID.get(i)).firstElement();
                        listOtherProductCategory.add(p);
                    }
                }

                String msInsertProductCart = (String)request.getAttribute("msInsertProductCart");
                if(msInsertProductCart != null) {
                    request.setAttribute("msInsertProductCart", msInsertProductCart);
                }
                
                String msOutOfProductInStock = (String)request.getAttribute("msOutOfProductInStock");
                if(msOutOfProductInStock != null) {
                    request.setAttribute("msOutOfProductInStock", msOutOfProductInStock);
                }
                
                request.setAttribute("sizeSelected", sizeSelected);
                request.setAttribute("colorSelected", colorSelected);
                request.setAttribute("quantityProduct", quantityProduct);
                request.setAttribute("allSizeProduct", allSizeProduct);
                request.setAttribute("allColorProduct", allColorProduct);
                request.setAttribute("listOtherProductCategory", listOtherProductCategory);
                request.setAttribute("inforProduct", product);
                request.getRequestDispatcher("single-product.jsp").forward(request, response);
            }

            out.print("<h1>hahah</h1>");

        } catch (Exception ex) {
            out.print("<h1>error</h1>");
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
