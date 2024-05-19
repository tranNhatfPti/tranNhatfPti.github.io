/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDetailsDAO;
import dal.OrdersDAO;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Vector;
import model.Customer;
import model.OrderDetails;
import model.Orders;
import model.Product;
import model.ProductCart;
import model.ProductDetail;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/OrderServlet"})
public class OrderServlet extends HttpServlet {

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
        out.println("<title>Servlet OrderServlet</title>");
        out.println("</head>");
        out.println("<body>");
        try {
            /* TODO output your page here. You may use following sample code. */
            ProductDAO pd = new ProductDAO();
            ProductCartDAO pcd = new ProductCartDAO();
            OrdersDAO od = new OrdersDAO();
            OrderDetailsDAO odd = new OrderDetailsDAO();
            ProductDetailDAO pdd = new ProductDetailDAO();
            HttpSession session = request.getSession();
            Vector<Orders> listOrder = new Vector<>();
            String service = request.getParameter("service");

            Customer customer = (Customer) session.getAttribute("account");

            if (service.equals("sendUpdateOrder")) {
                String orderID = request.getParameter("orderID");

                Orders orderNeedUpdate = od.getAllOrdersFromSQL("select * from Orders where OrderID = " + orderID).firstElement();

                if (orderNeedUpdate != null) {
                    request.setAttribute("orderNeedUpdate", orderNeedUpdate);
                    request.setAttribute("fromServlet", "fromServlet");
                    request.getRequestDispatcher("admin/doc/form-update-order.jsp").forward(request, response);
                }
            }
            
            if(service.equals("test")){
                String orderId_string = request.getParameter("orderID");
                String statuss = request.getParameter("status");
                int status = Integer.parseInt(statuss);
                
                od.updateOrderStatusAdmin(Integer.parseInt(orderId_string), status);
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/orders-manage.jsp").forward(request, response);
            }

            if (service.equals("updateOrder")) {
                String orderId_string = request.getParameter("orderID");
                String customerID_string = request.getParameter("customerID");
                String shipperID_string = request.getParameter("shipperID");
                String orderDate = request.getParameter("orderDate");
                String shippedDate = request.getParameter("shippedDate");
                String shippingTotal_string = request.getParameter("shippingTotal");
                String address = request.getParameter("address");
                String status_string = request.getParameter("status");

                int orderID = Integer.parseInt(orderId_string);
                int customerId = Integer.parseInt(customerID_string);
                int shipperID = Integer.parseInt(shipperID_string);
                double shippingTotal = Double.parseDouble(shippingTotal_string);
                int status = Integer.parseInt(status_string);

                Orders order = new Orders(orderID, customerId, shipperID, orderDate, shippedDate, shippingTotal, address, status);

                if (od.updateOrders(order) != 0) {
                    request.setAttribute("msUpdateOrder", "Update Order succesfully!");
                } else {
                    request.setAttribute("msUpdateOrder", "Update Order fail!");
                }

                request.setAttribute("orderNeedUpdate", order);
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/form-update-order.jsp").forward(request, response);
            }

            if (service.equals("updateOrderStatus")) {
                String orderId_string = request.getParameter("orderID");

                if (request.getParameter("status").equals("received")) {
                    // update status và thời gian nhận được hàng
                    // khai báo đối tượng current thuộc class LocalDateTime
                    LocalDateTime current = LocalDateTime.now();
                    // sử dụng class DateTimeFormatter để định dạng ngày giờ theo kiểu pattern
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
                    // sử dụng phương thức format() để định dạng ngày giờ hiện tại rồi gán cho chuỗi
                    // formatted
                    String shippedDate = current.format(formatter);
                    od.updateOrderStatus(Integer.parseInt(orderId_string), 4, shippedDate);

                    Vector<OrderDetails> listProductReceived = odd.getAllOrderDetailsFromSQL("select * from OrderDetails where OrderID = " + orderId_string);

                    int quantitySoldProductReceived;
                    int quantityRemainProductReceived;
                    for (OrderDetails orderDetail : listProductReceived) {
                        // cập nhật số lượng đã bán của sản phẩm
                        Product productReceived = pd.getAllProductFromSQL("select * from Product where ProductCode = " + orderDetail.getProductCode()).firstElement();

                        quantitySoldProductReceived = productReceived.getQuantitySold();
                        quantitySoldProductReceived += orderDetail.getQuantityOrder();

                        pd.updateQuantitySold(orderDetail.getProductCode(), quantitySoldProductReceived);

                        // cập nhật số lượng sản phẩm còn lại sau khi bán
                        ProductDetail productDetailReceived = pdd.getAllProductDetailFromSQL("select * from ProductDetail where "
                                + "ProductCode = " + orderDetail.getProductCode() + " and Size = '" + orderDetail.getSizeOrder() + "' and Color = '"
                                + orderDetail.getColorOrder() + "'").firstElement();
                        quantityRemainProductReceived = productDetailReceived.getQuantity();
                        quantityRemainProductReceived -= orderDetail.getQuantityOrder();

                        productDetailReceived.setQuantity(quantityRemainProductReceived);
                        pdd.updateProductDetail(productDetailReceived);
                    }
                }

                if (request.getParameter("status").equals("cancelled")) {
                    od.updateOrderStatus(Integer.parseInt(orderId_string), 5, "");
                }

                response.sendRedirect("my-account.jsp");
            }

            if (service.equals("orderProduct")) {
                // khai báo đối tượng current thuộc class LocalDateTime
                LocalDateTime current = LocalDateTime.now();
                // sử dụng class DateTimeFormatter để định dạng ngày giờ theo kiểu pattern
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
                // sử dụng phương thức format() để định dạng ngày giờ hiện tại rồi gán cho chuỗi
                // formatted
                String formatted = current.format(formatter);

                if (request.getParameter("orderFrom").equals("singleProduct")) {
                    String productCodeOrder_string = request.getParameter("productCodeOrder");
                    String sizeOrder = request.getParameter("sizeOrder");
                    String colorOrder = request.getParameter("colorOrder");
                    String quantityOrder_string = request.getParameter("quantityOrder");

                    Orders order = new Orders(customer.getCustomerID(), 1, formatted, "", 5, customer.getAddress(), 1);

                    if (od.insertOrders(order) != 0) {
                        int orderID = od.getAllOrdersFromSQL("select top 1 * from Orders where CustomerID = " + customer.getCustomerID()
                                + " order by OrderID desc").firstElement().getOrderID();
                        OrderDetails orderDetail = new OrderDetails(orderID, Integer.parseInt(productCodeOrder_string), sizeOrder, colorOrder,
                                Integer.parseInt(quantityOrder_string), 0);

                        if (odd.insertOrderDetails(orderDetail) != 0) {
                            request.setAttribute("msInsertOrders", "Order succesfully!");
                        } else {
                            request.setAttribute("msInsertOrders", "Order fail!");
                        }
                    } else {
                        request.setAttribute("msInsertOrders", "Order fail!");
                    }
                }

                if (request.getParameter("orderFrom").equals("cart")) {
                    int countOrderCart = 0;
                    Vector<ProductCart> listPC = pcd.getAllProductCartFromSQL("select * from ProductCart where CustomerID = " + customer.getCustomerID());
                    Orders order = new Orders(customer.getCustomerID(), 1, formatted, "", 5, customer.getAddress(), 1);
                    int orderID;

                    if (od.insertOrders(order) != 0) {
                        for (ProductCart pc : listPC) {
                            orderID = od.getAllOrdersFromSQL("select top 1 * from Orders where CustomerID = " + customer.getCustomerID()
                                    + " order by OrderID desc").firstElement().getOrderID();
                            OrderDetails orderDetail = new OrderDetails(orderID, pc.getProductCode(), pc.getSize(), pc.getColor(), pc.getQuantity(), 0);
                            if (odd.insertOrderDetails(orderDetail) != 0) {
                                pcd.removeProductCart(customer.getCustomerID(), pc.getProductCode(), pc.getSize(), pc.getColor());
                                ++countOrderCart;
                            }
                        }

                        if (countOrderCart == listPC.size()) {
                            request.setAttribute("msInsertOrders", "Order succesfully!");
                        } else {
                            request.setAttribute("msInsertOrders", "Order fail!");
                        }
                    } else {
                        request.setAttribute("msInsertOrders", "Order fail!");
                    }
                }

                request.getRequestDispatcher("checkout.jsp").forward(request, response);
            }           
            
            if(service.equals("delete")){
                String orderID_string = request.getParameter("orderID");
                int orderID = Integer.parseInt(orderID_string);
                
                if(od.deleteOrder(orderID) == 0){
                    request.setAttribute("msDeleteOrder", "Không thể xoá đơn hàng này!");
                } else {
                    request.setAttribute("msDeleteOrder", "Xoá đơn hàng thành công!");
                }
                
                request.setAttribute("fromServlet", "fromServlet");
                request.getRequestDispatcher("admin/doc/orders-manage.jsp").forward(request, response);
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
