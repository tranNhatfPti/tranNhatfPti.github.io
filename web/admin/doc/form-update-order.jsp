<%-- 
    Document   : form-update-product
    Created on : Feb 29, 2024, 2:13:53 AM
    Author     : ASUS ZenBook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Vector, jakarta.servlet.http.HttpSession, model.Customer, dal.CustomerDAO, model.ProductCart, dal.ProductCartDAO, model.Product, dal.ProductDAO, model.Brand, dal.BrandDAO, java.text.DecimalFormat, model.Orders, dal.OrdersDAO, model.OrderDetails, dal.OrderDetailsDAO, model.Shipper, dal.ShipperDAO"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Sửa đơn hàng | Quản trị Admin</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Main CSS-->
        <link rel="stylesheet" type="text/css" href="css/main.css">
        <link rel="stylesheet" type="text/css" href="admin/doc/css/main.css">
        <!-- Font-icon css-->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
        <!-- or -->
        <link rel="stylesheet" href="https://unpkg.com/boxicons@latest/css/boxicons.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
        <link rel="stylesheet" type="text/css"
              href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
        <script src="http://code.jquery.com/jquery.min.js" type="text/javascript"></script>
        <script>

            function readURL(input, thumbimage) {
                if (input.files && input.files[0]) { //Sử dụng  cho Firefox - chrome
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $("#thumbimage").attr('src', e.target.result);
                    }
                    reader.readAsDataURL(input.files[0]);
                } else { // Sử dụng cho IE
                    $("#thumbimage").attr('src', input.value);

                }
                $("#thumbimage").show();
                $('.filename').text($("#uploadfile").val());
                $('.Choicefile').css('background', '#14142B');
                $('.Choicefile').css('cursor', 'default');
                $(".removeimg").show();
                $(".Choicefile").unbind('click');

            }
            $(document).ready(function () {
                $(".Choicefile").bind('click', function () {
                    $("#uploadfile").click();

                });
                $(".removeimg").click(function () {
                    $("#thumbimage").attr('src', '').hide();
                    $("#myfileupload").html('<input type="file" id="uploadfile"  onchange="readURL(this);" />');
                    $(".removeimg").hide();
                    $(".Choicefile").bind('click', function () {
                        $("#uploadfile").click();
                    });
                    $('.Choicefile').css('background', '#14142B');
                    $('.Choicefile').css('cursor', 'pointer');
                    $(".filename").text("");
                });
            })
        </script>
    </head>

    <body class="app sidebar-mini rtl">
        <style>
            .Choicefile {
                display: block;
                background: #14142B;
                border: 1px solid #fff;
                color: #fff;
                width: 150px;
                text-align: center;
                text-decoration: none;
                cursor: pointer;
                padding: 5px 0px;
                border-radius: 5px;
                font-weight: 500;
                align-items: center;
                justify-content: center;
            }

            .Choicefile:hover {
                text-decoration: none;
                color: white;
            }

            #uploadfile,
            .removeimg {
                display: none;
            }

            #thumbbox {
                position: relative;
                width: 100%;
                margin-bottom: 20px;
            }

            .removeimg {
                height: 25px;
                position: absolute;
                background-repeat: no-repeat;
                top: 5px;
                left: 5px;
                background-size: 25px;
                width: 25px;
                /* border: 3px solid red; */
                border-radius: 50%;

            }

            .removeimg::before {
                -webkit-box-sizing: border-box;
                box-sizing: border-box;
                content: '';
                border: 1px solid red;
                background: red;
                text-align: center;
                display: block;
                margin-top: 11px;
                transform: rotate(45deg);
            }

            .removeimg::after {
                /* color: #FFF; */
                /* background-color: #DC403B; */
                content: '';
                background: red;
                border: 1px solid red;
                text-align: center;
                display: block;
                transform: rotate(-45deg);
                margin-top: -2px;
            }
        </style>
        <!-- Declare variable -->
        <%
            ShipperDAO sd = new ShipperDAO();
            CustomerDAO cd = new CustomerDAO();
            HttpSession s = request.getSession();
            Customer admin = (Customer)s.getAttribute("account");
            String fromServlet = (String)request.getAttribute("fromServlet");
            Orders orderNeedUpdate = (Orders)request.getAttribute("orderNeedUpdate");
            
            if(admin == null){
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
                <li><a class="app-nav__item" href="/index.html"><i class='bx bx-log-out bx-rotate-180'></i> </a>

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

                <li><a class="app-menu__item" href=<%=fromServlet==null?"index-admin.jsp":"admin/doc/index-admin.jsp"%>><i class='app-menu__icon bx bx-tachometer'></i><span
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

                <li><a class="app-menu__item active" href=<%=fromServlet==null?"orders-manage.jsp":"admin/doc/orders-manage.jsp"%>><i class='app-menu__icon bx bx-task'></i><span
                            class="app-menu__label">Quản lý đơn hàng</span></a></li>

                <li><a class="app-menu__item" href=<%=fromServlet==null?"order-detail-manage.jsp":"admin/doc/order-detail-manage.jsp"%>><i class='app-menu__icon bx bx-task'></i><span
                            class="app-menu__label">Chi tiết đơn hàng</span></a></li>

                <li><a class="app-menu__item" href="quan-ly-bao-cao.html"><i
                            class='app-menu__icon bx bx-pie-chart-alt-2'></i><span class="app-menu__label">Báo cáo doanh thu</span></a>
                </li>
            </ul>
        </aside>
        <main class="app-content">
            <div class="app-title">
                <ul class="app-breadcrumb breadcrumb">
                    <li class="breadcrumb-item"><a href="#">Sửa đơn hàng</a></li>
                </ul>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="tile">
                        <h3 class="tile-title">Sửa đơn hàng</h3>
                        <div class="tile-body">
                            <form class="row" action="/Project/OrderServlet">
                                <div class="form-group col-md-3">
                                    <label class="control-label">Mã đơn hàng </label>
                                    <input class="form-control" type="number" value="<%=orderNeedUpdate.getOrderID()%>" name="orderID" readonly="">
                                </div>
                                <div class="form-group col-md-3">
                                    <label class="control-label">Mã khách hàng</label>
                                    <input class="form-control" type="number" value="<%=orderNeedUpdate.getCustomerID()%>" name="customerID" readonly="">
                                </div>
                                <div class="form-group col-md-3">
                                    <label class="control-label">Mã đơn vị vận chuyển</label>
                                    <select class="form-control" name="shipperID" id="selectShipper">
                                        <%
                                            Vector<Shipper> listShipper = sd.getAllShipperFromSQL("select * from Shipper");
                                            for(Shipper shipper : listShipper) {
                                        %>
                                        <option value="<%=shipper.getShipperID()%>"><%=shipper.getCompanyName()%></option>
                                        <%}%>
                                    </select>
                                </div>     
                                <div class="form-group col-md-3">
                                    <label class="control-label">Ngày đặt hàng</label>
                                    <input class="form-control" type="datetime" value="<%=orderNeedUpdate.getOrderDate()%>" name="orderDate" readonly="">
                                </div>
                                <div class="form-group col-md-3">
                                    <label class="control-label">Ngày nhận hàng</label>
                                    <input class="form-control" type="datetime" value="<%=orderNeedUpdate.getShippedDate()%>" name="shippedDate" readonly="">
                                </div>
                                <div class="form-group col-md-3">
                                    <label class="control-label">Tổng tiền vận chuyển</label>
                                    <input class="form-control" type="number" value="<%=orderNeedUpdate.getShippingTotal()%>" name="shippingTotal">
                                </div>
                                <div class="form-group col-md-3">
                                    <label class="control-label">Địa chỉ</label>
                                    <input class="form-control" type="text" value="<%=orderNeedUpdate.getShipAddress()%>" name="address" readonly="">
                                </div>
                                <div class="form-group col-md-3">
                                    <label class="control-label">Tình trạng đơn hàng</label>
                                    <%
                                        if(orderNeedUpdate.getStatus() == 4 || orderNeedUpdate.getStatus() == 5) {
                                    %>
                                    <select class="form-control" name="status" id="selectStatus">
                                        <option value="1" disabled="">Đang chờ xử lý</option>
                                        <option value="2" disabled="">Đã xác nhận đơn hàng</option>
                                        <option value="3" disabled="">Đang vận chuyển</option>
                                        <option value="4" disabled="">Đã nhận hàng</option>
                                        <option value="5" disabled="">Đã hủy đơn hàng</option>
                                    </select>
                                    <%} else {%>
                                    <select class="form-control" name="status" id="selectStatus">
                                        <option value="1">Đang chờ xử lý</option>
                                        <option value="2">Đã xác nhận đơn hàng</option>
                                        <option value="3">Đang vận chuyển</option>
                                        <option value="4" disabled="">Đã nhận hàng</option>
                                        <option value="5" disabled="">Đã hủy đơn hàng</option>
                                    </select>
                                    <%}%>
                                </div>
                                <div style="margin-left: 15px">
                                    <%
                                        String msUpdateOrder = (String) request.getAttribute("msUpdateOrder");
                                        if(msUpdateOrder != null) {
                                    %>
                                    <h4 style="color: green"><%=msUpdateOrder%></h4>
                                    <%
                                        }
                                    %>
                                </div>
                                <button class="btn btn-save" type="submit">Lưu lại</button>
                                <input type="hidden" name="service" value="updateOrder">
                                <input type="hidden" name="status" value="admin">
                                <a style="margin-left: 10px" class="btn btn-cancel" href="admin/doc/orders-manage.jsp">Hủy bỏ</a>
                            </form>
                        </div>                     
                    </div>
                    </main>


                    <!--
                    MODAL CHỨC VỤ 
                    -->
                    <div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
                         data-backdrop="static" data-keyboard="false">
                        <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content">

                                <div class="modal-body">
                                    <div class="row">
                                        <div class="form-group  col-md-12">
                                            <span class="thong-tin-thanh-toan">
                                                <h5>Thêm mới nhà cung cấp</h5>
                                            </span>
                                        </div>
                                        <div class="form-group col-md-12">
                                            <label class="control-label">Nhập tên chức vụ mới</label>
                                            <input class="form-control" type="text" required>
                                        </div>
                                    </div>
                                    <BR>
                                    <button class="btn btn-save" type="button">Lưu lại</button>
                                    <a class="btn btn-cancel" data-dismiss="modal" href="#">Hủy bỏ</a>
                                    <BR>
                                </div>
                                <div class="modal-footer">
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--
                  MODAL
                    -->



                    <!--
                    MODAL DANH MỤC
                    -->
                    <div class="modal fade" id="adddanhmuc" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
                         data-backdrop="static" data-keyboard="false">
                        <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content">

                                <div class="modal-body">
                                    <div class="row">
                                        <div class="form-group  col-md-12">
                                            <span class="thong-tin-thanh-toan">
                                                <h5>Thêm mới danh mục </h5>
                                            </span>
                                        </div>
                                        <div class="form-group col-md-12">
                                            <label class="control-label">Nhập tên danh mục mới</label>
                                            <input class="form-control" type="text" required>
                                        </div>
                                        <div class="form-group col-md-12">
                                            <label class="control-label">Danh mục sản phẩm hiện đang có</label>
                                            <ul style="padding-left: 20px;">
                                                <li>Bàn ăn</li>
                                                <li>Bàn thông minh</li>
                                                <li>Tủ</li>
                                                <li>Ghế gỗ</li>
                                                <li>Ghế sắt</li>
                                                <li>Giường người lớn</li>
                                                <li>Giường trẻ em</li>
                                                <li>Bàn trang điểm</li>
                                                <li>Giá đỡ</li>
                                            </ul>
                                        </div>
                                    </div>
                                    <BR>
                                    <button class="btn btn-save" type="button">Lưu lại</button>
                                    <a class="btn btn-cancel" data-dismiss="modal" href="#">Hủy bỏ</a>
                                    <BR>
                                </div>
                                <div class="modal-footer">
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--
                  MODAL
                    -->




                    <!--
                    MODAL TÌNH TRẠNG
                    -->
                    <div class="modal fade" id="addtinhtrang" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
                         data-backdrop="static" data-keyboard="false">
                        <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content">

                                <div class="modal-body">
                                    <div class="row">
                                        <div class="form-group  col-md-12">
                                            <span class="thong-tin-thanh-toan">
                                                <h5>Thêm mới tình trạng</h5>
                                            </span>
                                        </div>
                                        <div class="form-group col-md-12">
                                            <label class="control-label">Nhập tình trạng mới</label>
                                            <input class="form-control" type="text" required>
                                        </div>
                                    </div>
                                    <BR>
                                    <button class="btn btn-save" type="button">Lưu lại</button>
                                    <a class="btn btn-cancel" data-dismiss="modal" href="#">Hủy bỏ</a>
                                    <BR>
                                </div>
                                <div class="modal-footer">
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--
                  MODAL
                    -->



                    <script src="js/jquery-3.2.1.min.js"></script>
                    <script src="js/popper.min.js"></script>
                    <script src="js/bootstrap.min.js"></script>
                    <script src="js/main.js"></script>
                    <script src="js/plugins/pace.min.js"></script>
                    <script>
            const inpFile = document.getElementById("inpFile");
            const loadFile = document.getElementById("loadFile");
            const previewContainer = document.getElementById("imagePreview");
            const previewContainer = document.getElementById("imagePreview");
            const previewImage = previewContainer.querySelector(".image-preview__image");
            const previewDefaultText = previewContainer.querySelector(".image-preview__default-text");
            inpFile.addEventListener("change", function () {
                const file = this.files[0];
                if (file) {
                    const reader = new FileReader();
                    previewDefaultText.style.display = "none";
                    previewImage.style.display = "block";
                    reader.addEventListener("load", function () {
                        previewImage.setAttribute("src", this.result);
                    });
                    reader.readAsDataURL(file);
                }
            });

                    </script>
                    <script>
                        document.getElementById("selectStatus").value = "<%=orderNeedUpdate.getStatus()%>";
                        document.getElementById("selectShipper").value = "<%=orderNeedUpdate.getShipperID()%>";
                    </script>
                    </body>

                    </html>
