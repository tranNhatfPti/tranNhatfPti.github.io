package controller;

import dal.ProductCartDAO;
import dal.ProductDAO;
import dal.ProductDetailDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Vector;
import model.Customer;
import model.Product;
import model.ProductCart;
import model.ProductDetail;

@WebServlet(name = "ShoppingCartServlet", urlPatterns = {"/ShoppingCartServlet"})
public class ShoppingCartServlet extends HttpServlet {

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
        out.println("<title>Servlet ShoppingCartServlet</title>");
        out.println("</head>");
        out.println("<body>");
        try {
            /* TODO output your page here. You may use following sample code. */
            ProductDAO pd = new ProductDAO();
            ProductDetailDAO pdd = new ProductDetailDAO();
            ProductCartDAO pcd = new ProductCartDAO();
            HttpSession session = request.getSession();
            boolean checkDispatcher = true;

            // kiểm tra đăng nhập
            Customer customer = new Customer();
            if ((Customer) session.getAttribute("account") != null) {
                customer = (Customer) session.getAttribute("account");
            } else {
                response.sendRedirect("login.jsp");
            }

            int customerID = customer.getCustomerID();

            String service = request.getParameter("service");

            // thêm vào giỏ hàng và thêm dữ liệu giỏ hàng vào DB
            if (service.equals("addToCart")) {
                // lấy dữ liệu thêm vào cart từ page
                String productCode_string = request.getParameter("productCode");
                String quantityOrder_string = request.getParameter("quantity");
                String size = request.getParameter("size");
                String color = request.getParameter("color");

                int productCode = Integer.parseInt(productCode_string);
                int quantityOrder = Integer.parseInt(quantityOrder_string);

                // sản phẩm được mua ngay chứ không cho vào giỏ hàng
                if (request.getParameter("buyNow") != null && request.getParameter("buyNow").equals("buyNow")) {
                    ProductDetail pBuyNowInStock = pdd.getAllProductDetailFromSQL("select * from ProductDetail where ProductCode = "
                            + productCode + " and Size = '" + size + "' and Color = '" + color + "'").firstElement();
                    // kiểm tra số lượng sp trong kho có đủ với số lượng order hay không khi buy now
                    if (pBuyNowInStock.getQuantity() < quantityOrder) {
                        request.setAttribute("msOutOfProductInStock", "You have reached the maximum quantity available for this item");
                        request.getRequestDispatcher("ListSingleProductServlet?service=listInforProduct&"
                                + "productCode=" + productCode + "&size=" + size + "&color=" + color).forward(request, response);
                    } else {
                        ProductDetail pBuyNow = new ProductDetail(productCode, quantityOrder, size, color);
                        request.setAttribute("productBuyNow", pBuyNow);
                        // khi dùng getRequestDispatcher thì sẽ chuyển hướng sang các trang khác và sau khi thực hiện hết các trang khác đó
                        // thì sẽ quay về trang hiện tại và tiếp tục thực hiện những câu lệnh ở phía dưới của getRequestDispatcher.
                        // còn response.sendRedirect sẽ không quay lại trang hiện tại sau khi thực hiện hết những trang khác
                        request.getRequestDispatcher("checkout.jsp").forward(request, response);
                    }
                    checkDispatcher = false;
                }

                // lấy ra sản phẩm được cho vào cart
                if (checkDispatcher) {
                    ProductDetail pAddToCartInStock = pdd.getAllProductDetailFromSQL("select * from ProductDetail where ProductCode = "
                            + productCode + " and Size = '" + size + "' and Color = '" + color + "'").firstElement();
                    
                    // kiểm tra số lượng sp trong kho có đủ với số lượng order hay không khi add to cart
                    if (pAddToCartInStock.getQuantity() < quantityOrder) {
                        request.setAttribute("msOutOfProductInStock", "You have reached the maximum quantity available for this item");
                    } else { // pAddToCartInStock.getQuantity() >= quantityOrder
                        Product productInCart = pd.getAllProductFromSQL("select * from Product where ProductCode = " + productCode).firstElement();

                        String productCartName = productInCart.getProductName();
                        double price = productInCart.getPrice();
                        String image = productInCart.getPicture();

                        ProductCart productCart = new ProductCart(customerID, productCode, productCartName, size, color, price, quantityOrder, image);

                        Vector<ProductCart> vectorProductCart = pcd.getAllProductCartFromSQL("select * from ProductCart where CustomerID = " + customerID
                                + " and ProductCode = " + productCode + " and Size = '" + size + "' and Color = '" + color + "'");

                        if (!vectorProductCart.isEmpty()) {
                            productCart.setQuantity(vectorProductCart.firstElement().getQuantity() + quantityOrder);
                            pcd.updateProductCart(productCart);
                            request.setAttribute("msInsertProductCart", "Add Product to Cart succesfully!");
                        } else {
                            if (pcd.insertProductCart(productCart) != 0) {
                                request.setAttribute("msInsertProductCart", "Add Product to Cart succesfully!");
                            } else {
                                request.setAttribute("msInsertProductCart", "Add Product to Cart fail!");
                            }
                        }
                    }
                    request.getRequestDispatcher("ListSingleProductServlet?service=listInforProduct&"
                            + "productCode=" + productCode + "&size=" + size + "&color=" + color).forward(request, response);
                }
            }

            // cập nhật số lượng order trong cart
            if (service.equals("updateCart")) {
                // có thể update số lượng của nhiều sản phẩm
                String[] quantityUpdate_string = request.getParameterValues("quantityUpdate");

                Vector<ProductCart> allProductCart = pcd.getAllProductCartFromSQL("select * from ProductCart where CustomerID = " + customerID);

                String listOutOfInStock = "";
                boolean checkProductFirst = true;
                for (int i = 0; i <= quantityUpdate_string.length - 1; ++i) {
                    int quantityUpdate = Integer.parseInt(quantityUpdate_string[i]);
                    ProductCart productCartUpdate = allProductCart.get(i);

                    ProductDetail pUpdateQuantity = pdd.getAllProductDetailFromSQL("select * from ProductDetail where ProductCode = "
                            + productCartUpdate.getProductCode() + " and Size = '" + productCartUpdate.getSize() + "' and Color = '"
                            + productCartUpdate.getColor() + "'").firstElement();
                    
                    // kiểm tra số lượng sp trong kho có đủ với số lượng update hay không trong cart
                    if (pUpdateQuantity.getQuantity() < quantityUpdate) {
                        if(checkProductFirst){
                            listOutOfInStock += productCartUpdate.getProductName();
                            checkProductFirst = false;
                        } else {
                            listOutOfInStock += ", " + productCartUpdate.getProductName();
                        }                                      
                    } else {
                        productCartUpdate.setQuantity(quantityUpdate);
                        pcd.updateProductCart(productCartUpdate);
                    }
                }

                if(!checkProductFirst){
                    request.setAttribute("listOutOfInStock", listOutOfInStock);
                    request.setAttribute("msOutOfProductInStock", "These products have reached the maximum quantity available for this item");
                }       
                request.getRequestDispatcher("cart.jsp").forward(request, response);
            }

            // xoá sản phẩm trong cart
            if (service.equals("remove")) {
                String customerID_string = request.getParameter("customerID");
                String productCode_string = request.getParameter("productCode");
                String size = request.getParameter("size");
                String color = request.getParameter("color");

                int customerId = Integer.parseInt(customerID_string);
                int productCode = Integer.parseInt(productCode_string);

                pcd.removeProductCart(customerId, productCode, size, color);

                String namePage = request.getParameter("namePage");
                response.sendRedirect(namePage);
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
