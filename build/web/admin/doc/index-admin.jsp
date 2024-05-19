<%-- 
    Document   : index-admin
    Created on : Feb 28, 2024, 3:21:30 PM
    Author     : ASUS ZenBook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector, jakarta.servlet.http.HttpSession, model.Customer, dal.CustomerDAO, model.ProductCart, dal.ProductCartDAO, model.Product, dal.ProductDAO, model.Brand, dal.BrandDAO, java.text.DecimalFormat, model.Orders, dal.OrdersDAO, model.ProductDetail, dal.ProductDetailDAO, model.OrderDetails, dal.OrderDetailsDAO"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Danh sách nhân viên | Quản trị Admin</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Main CSS-->
        <link rel="stylesheet" type="text/css" href="css/main.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
        <!-- or -->
        <link rel="stylesheet" href="https://unpkg.com/boxicons@latest/css/boxicons.min.css">
        <!-- Font-icon css-->
        <link rel="stylesheet" type="text/css"
              href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">

    </head>

    <body onload="time()" class="app sidebar-mini rtl">
        <!-- Declare variable -->
        <%     
            DecimalFormat df = new DecimalFormat("#.0");
            CustomerDAO cd = new CustomerDAO();
            ProductDAO pd = new ProductDAO();
            HttpSession s = request.getSession();
            Customer admin = (Customer)s.getAttribute("account");
            String fromServlet = (String)request.getAttribute("fromServlet");
            
            if(admin == null) {
                response.sendRedirect("login.jsp");
            }
        %>
        <!-- Navbar-->
        <header class="app-header">
            <!-- Sidebar toggle button--><a class="app-sidebar__toggle" href="#" data-toggle="sidebar"
                                            aria-label="Hide Sidebar"></a>
            <!-- Navbar Right Menu-->
            <ul class="app-nav">
                <!-- User Menu-->
                <li><a class="app-nav__item" href="/Project/LoginServlet?service=logout&status=admin"><i class='bx bx-log-out bx-rotate-180'></i> </a>

                </li>
            </ul>
        </header>
        <!-- Sidebar menu-->
        <div class="app-sidebar__overlay" data-toggle="sidebar"></div>
        <aside class="app-sidebar">
            <div class="app-sidebar__user">
                <div>
                    <p class="app-sidebar__user-name"><b><%=admin.getFirstName() + " " + admin.getLastName()%></b></p>
                    <p class="app-sidebar__user-designation">Chào mừng bạn trở lại</p>
                </div>
            </div>
            <hr>
            <ul class="app-menu">
                <li><a class="app-menu__item haha" href="phan-mem-ban-hang.html"><i class='app-menu__icon bx bx-cart-alt'></i>
                        <span class="app-menu__label">POS Bán Hàng</span></a></li>

                <li><a class="app-menu__item active" href=<%=fromServlet==null?"index-admin.jsp":"admin/doc/index-admin.jsp"%>><i class='app-menu__icon bx bx-tachometer'></i><span
                            class="app-menu__label">Bảng điều khiển</span></a></li>

                <li><a class="app-menu__item " href=<%=fromServlet==null?"customer-manage.jsp":"admin/doc/customer-manage.jsp"%>><i class='app-menu__icon bx bx-id-card'></i> <span
                            class="app-menu__label">Quản lý khách hàng</span></a></li>

                <li><a class="app-menu__item" href=<%=fromServlet==null?"product-manage.jsp":"admin/doc/product-manage.jsp"%>><i
                            class='app-menu__icon bx bx-purchase-tag-alt'></i><span class="app-menu__label">Quản lý sản phẩm</span></a>
                </li>

                <li><a class="app-menu__item" href=<%=fromServlet==null?"product-detail-manage.jsp":"admin/doc/product-detail-manage.jsp"%>><i
                            class='app-menu__icon bx bx-purchase-tag-alt'></i><span class="app-menu__label">Chi tiết sản phẩm</span></a>
                </li>

                <li><a class="app-menu__item" href=<%=fromServlet==null?"brand-manage.jsp":"admin/doc/brand-manage.jsp"%>><i
                            class='app-menu__icon bx bx-purchase-tag-alt'></i><span class="app-menu__label">Thương hiệu</span></a>
                </li>

                <li><a class="app-menu__item" href=<%=fromServlet==null?"category-manage.jsp":"admin/doc/category-manage.jsp"%>><i
                            class='app-menu__icon bx bx-purchase-tag-alt'></i><span class="app-menu__label">Danh mục</span></a>
                </li>    

                <li><a class="app-menu__item" href=<%=fromServlet==null?"shipper-manage.jsp":"admin/doc/shipper-manage.jsp"%>><i
                            class='app-menu__icon bx bx-purchase-tag-alt'></i><span class="app-menu__label">Đơn vị vận chuyển</span></a>
                </li>

                <li><a class="app-menu__item" href=<%=fromServlet==null?"orders-manage.jsp":"admin/doc/orders-manage.jsp"%>><i class='app-menu__icon bx bx-task'></i><span
                            class="app-menu__label">Quản lý đơn hàng</span></a></li>

                <li><a class="app-menu__item" href=<%=fromServlet==null?"order-detail-manage.jsp":"admin/doc/order-detail-manage.jsp"%>><i class='app-menu__icon bx bx-task'></i><span
                            class="app-menu__label">Chi tiết đơn hàng</span></a></li>

                <li><a class="app-menu__item" href=<%=fromServlet==null?"chat.jsp":"admin/doc/chat.jsp"%>><i
                            class='app-menu__icon bx bx-purchase-tag-alt'></i><span class="app-menu__label">Tin nhắn khách hàng</span></a>
                </li>

                <li><a class="app-menu__item" href="quan-ly-bao-cao.html"><i
                            class='app-menu__icon bx bx-pie-chart-alt-2'></i><span class="app-menu__label">Báo cáo doanh thu</span></a>
                </li>
            </ul>
        </aside>
        <main class="app-content">
            <div class="row">
                <div class="col-md-12">
                    <div class="app-title">
                        <ul class="app-breadcrumb breadcrumb">
                            <li class="breadcrumb-item"><a href="#"><b>Bảng điều khiển</b></a></li>
                        </ul>
                        <div id="clock"></div>
                    </div>
                </div>
            </div>
            <div class="row">
                <!--Left-->
                <div class="col-md-12 col-lg-6">
                    <div class="row">
                        <!-- col-6 -->
                        <div class="col-md-6">
                            <div class="widget-small primary coloured-icon"><i class='icon bx bxs-user-account fa-3x'></i>
                                <div class="info">
                                    <h4>Tổng khách hàng</h4>
                                    <%                                       
                                        Vector<Customer> allCustomer = cd.getAllCustomerFromSQL("select * from Customer");
                                    %>
                                    <p><b><%=allCustomer.size() - 1%> khách hàng</b></p>
                                    <p class="info-tong">Tổng số khách hàng được quản lý.</p>
                                </div>
                            </div>
                        </div>
                        <!-- col-6 -->
                        <div class="col-md-6">
                            <div class="widget-small info coloured-icon"><i class='icon bx bxs-data fa-3x'></i>
                                <div class="info">
                                    <h4>Tổng sản phẩm</h4>
                                    <%                                   
                                        Vector<Product> allProduct = pd.getAllProductFromSQL("select * from Product");
                                    %>
                                    <p><b><%=allProduct.size()%> sản phẩm</b></p>
                                    <p class="info-tong">Tổng số sản phẩm được quản lý.</p>
                                </div>
                            </div>
                        </div>
                        <!-- col-6 -->
                        <div class="col-md-6">
                            <div class="widget-small warning coloured-icon"><i class='icon bx bxs-shopping-bags fa-3x'></i>
                                <div class="info">
                                    <h4>Tổng đơn hàng</h4>
                                    <%
                                        OrdersDAO od = new OrdersDAO();
                                        Vector<Orders> allOrder = od.getAllOrdersFromSQL("select * from Orders");
                                    %>
                                    <p><b><%=allOrder.size()%> đơn hàng</b></p>
                                    <p class="info-tong">Tổng số hóa đơn bán hàng.</p>
                                </div>
                            </div>
                        </div>
                        <!-- col-6 -->
                        <div class="col-md-6">
                            <div class="widget-small danger coloured-icon"><i class='icon bx bxs-error-alt fa-3x'></i>
                                <div class="info">
                                    <h4>Sắp hết hàng</h4>
                                    <%
                                        int outOfStock = 0;  
                                        int quantityOfProduct;
                                        ProductDetailDAO pdd = new ProductDetailDAO();
                                        Vector<ProductDetail> listPD = new Vector<>();
                                        
                                        for(Product p : allProduct){
                                            listPD = pdd.getAllProductDetailFromSQL("select * from ProductDetail where "
                                            + "ProductCode = " + p.getProductCode());
                                            quantityOfProduct = 0;
                                            for(ProductDetail pDetail : listPD){
                                                quantityOfProduct += pDetail.getQuantity();
                                            }
                                            
                                            if(quantityOfProduct <= 10) {
                                                ++outOfStock;
                                            }
                                        }
                                    %>
                                    <p><b><%=outOfStock%> sản phẩm</b></p>
                                    <p class="info-tong">Số sản phẩm cảnh báo hết cần nhập thêm.</p>
                                </div>
                            </div>
                        </div>
                        <!-- col-12 -->
                        <div class="col-md-12">
                            <div class="tile">
                                <h3 class="tile-title">Tình trạng đơn hàng</h3>
                                <div>
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>ID đơn hàng</th>
                                                <th>Tên khách hàng</th>
                                                <th>Tổng tiền</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                OrderDetailsDAO odd = new OrderDetailsDAO();
                                                Vector<Orders> top8Order = od.getAllOrdersFromSQL("select top 8 * from Orders");
                                                int totalAmount = 0;
                                                for(Orders order : top8Order){                                       
                                            %>
                                            <tr>
                                                <td><%=order.getOrderID()%></td>
                                                <%Customer cOrder = cd.getAllCustomerFromSQL("select * from Customer where CustomerID = " + order.getCustomerID()).firstElement();%>
                                                <td><%=cOrder.getFirstName() + " " + cOrder.getLastName()%></td>
                                                <%
                                                    Vector<OrderDetails> listOD = odd.getAllOrderDetailsFromSQL("select * from OrderDetails where OrderID = " + order.getOrderID());
                                                    for(OrderDetails oDetail : listOD){
                                                        Product pOrder = pd.getAllProductFromSQL("select * from Product where ProductCode = " + oDetail.getProductCode()).firstElement();
                                                        totalAmount += (((pOrder.getPrice() * (100 - pOrder.getDiscount())) / 100) * oDetail.getQuantityOrder() + 5);
                                                    }
                                                %>
                                                <td>
                                                    $<%=df.format(totalAmount)%>
                                                </td>
                                                <td>
                                                    <%
                                                    if(order.getStatus() == 1){
                                                    %>
                                                    <span class="badge bg-info">Đang chờ xử lý</span>
                                                    <% } else if(order.getStatus() == 2) {%>
                                                    <span class="badge bg-success">Đã xác nhận đơn hàng</span>
                                                    <% } else if(order.getStatus() == 3) {%>
                                                    <span class="badge bg-warning">Đang vận chuyển</span>
                                                    <% } else if(order.getStatus() == 4) {%>
                                                    <span class="badge bg-success">Đã nhận hàng</span>
                                                    <%} else if (order.getStatus() == 5) {%>
                                                    <span class="badge bg-danger">Đã hủy đơn hàng</span>
                                                    <%}%>
                                                </td>
                                            </tr>  
                                            <%
                                                totalAmount = 0;
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                                <!-- / div trống-->
                            </div>
                        </div>
                        <!-- / col-12 -->
                        <!-- col-12 -->
                        <div class="col-md-12">
                            <div class="tile">
                                <h3 class="tile-title">Khách hàng mới</h3>
                                <div>
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên khách hàng</th>
                                                <th>Ngày sinh</th>
                                                <th>Số điện thoại</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                Vector<Customer> newCustomer = cd.getAllCustomerFromSQL("select top 5 * from Customer order by CustomerID desc");
                                                for(Customer c : newCustomer){
                                            %>
                                            <tr>
                                                <td>#<%=c.getCustomerID()%></td>
                                                <td><%=c.getFirstName() + " " + c.getLastName()%></td>
                                                <td><%=(c.getBirthOfDate()!=null?c.getBirthOfDate():"")%></td>
                                                <%
                                                    String phoneEncode = "";
                                                    if(c.getPhone() != null){
                                                        phoneEncode = c.getPhone().substring(0, 6);
                                                        phoneEncode += "****";
                                                    }
                                                %>
                                                <td><span class="tag tag-success"><%=phoneEncode%></span></td>
                                            </tr>                           
                                            <%}%>
                                        </tbody>
                                    </table>
                                </div>

                            </div>
                        </div>
                        <!-- / col-12 -->
                    </div>
                </div>
                <!--END left-->
                <!--Right-->
                <div class="col-md-12 col-lg-6">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="tile">
                                <h3 class="tile-title">Dữ liệu 6 tháng đầu vào</h3>
                                <div class="embed-responsive embed-responsive-16by9">
                                    <canvas class="embed-responsive-item" id="lineChartDemo"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="tile">
                                <h3 class="tile-title">Thống kê 6 tháng doanh thu</h3>
                                <div class="embed-responsive embed-responsive-16by9">
                                    <canvas class="embed-responsive-item" id="barChartDemo"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
                <!--END right-->
            </div>
        </main>
        <script src="js/jquery-3.2.1.min.js"></script>
        <!--===============================================================================================-->
        <script src="js/popper.min.js"></script>
        <script src="https://unpkg.com/boxicons@latest/dist/boxicons.js"></script>
        <!--===============================================================================================-->
        <script src="js/bootstrap.min.js"></script>
        <!--===============================================================================================-->
        <script src="js/main.js"></script>
        <!--===============================================================================================-->
        <script src="js/plugins/pace.min.js"></script>
        <!--===============================================================================================-->
        <script type="text/javascript" src="js/plugins/chart.js"></script>
        <!--===============================================================================================-->
        <script type="text/javascript">
        var data = {
            labels: ["Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6"],
            datasets: [{
                    label: "Dữ liệu đầu tiên",
                    fillColor: "rgba(255, 213, 59, 0.767), 212, 59)",
                    strokeColor: "rgb(255, 212, 59)",
                    pointColor: "rgb(255, 212, 59)",
                    pointStrokeColor: "rgb(255, 212, 59)",
                    pointHighlightFill: "rgb(255, 212, 59)",
                    pointHighlightStroke: "rgb(255, 212, 59)",
                    data: [20, 59, 90, 51, 56, 100]
                },
                {
                    label: "Dữ liệu kế tiếp",
                    fillColor: "rgba(9, 109, 239, 0.651)  ",
                    pointColor: "rgb(9, 109, 239)",
                    strokeColor: "rgb(9, 109, 239)",
                    pointStrokeColor: "rgb(9, 109, 239)",
                    pointHighlightFill: "rgb(9, 109, 239)",
                    pointHighlightStroke: "rgb(9, 109, 239)",
                    data: [48, 48, 49, 39, 86, 10]
                }
            ]
        };
        var ctxl = $("#lineChartDemo").get(0).getContext("2d");
        var lineChart = new Chart(ctxl).Line(data);

        var ctxb = $("#barChartDemo").get(0).getContext("2d");
        var barChart = new Chart(ctxb).Bar(data);
        </script>
        <script type="text/javascript">
            //Thời Gian
            function time() {
                var today = new Date();
                var weekday = new Array(7);
                weekday[0] = "Chủ Nhật";
                weekday[1] = "Thứ Hai";
                weekday[2] = "Thứ Ba";
                weekday[3] = "Thứ Tư";
                weekday[4] = "Thứ Năm";
                weekday[5] = "Thứ Sáu";
                weekday[6] = "Thứ Bảy";
                var day = weekday[today.getDay()];
                var dd = today.getDate();
                var mm = today.getMonth() + 1;
                var yyyy = today.getFullYear();
                var h = today.getHours();
                var m = today.getMinutes();
                var s = today.getSeconds();
                m = checkTime(m);
                s = checkTime(s);
                nowTime = h + " giờ " + m + " phút " + s + " giây";
                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                today = day + ', ' + dd + '/' + mm + '/' + yyyy;
                tmp = '<span class="date"> ' + today + ' - ' + nowTime +
                        '</span>';
                document.getElementById("clock").innerHTML = tmp;
                clocktime = setTimeout("time()", "1000", "Javascript");

                function checkTime(i) {
                    if (i < 10) {
                        i = "0" + i;
                    }
                    return i;
                }
            }
        </script>
    </body>

</html>
