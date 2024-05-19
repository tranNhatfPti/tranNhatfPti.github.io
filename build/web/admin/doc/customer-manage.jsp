<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector, jakarta.servlet.http.HttpSession, model.Customer, dal.CustomerDAO, model.ProductCart, dal.ProductCartDAO, model.Product, dal.ProductDAO, model.Brand, dal.BrandDAO, java.text.DecimalFormat"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Danh sách khách hàng | Quản trị Admin</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Main CSS-->
        <link rel="stylesheet" type="text/css" href="css/main.css">
        <link rel="stylesheet" type="text/css" href="admin/doc/css/main.css">
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
            ProductDAO pd = new ProductDAO();
            CustomerDAO cd = new CustomerDAO();
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
                <li><a class="app-nav__item" href="/index.html"><i class='bx bx-log-out bx-rotate-180'></i> </a>
                </li>
            </ul>
        </header>
        <!-- Sidebar menu-->
        <div class="app-sidebar__overlay" data-toggle="sidebar"></div>
        <aside class="app-sidebar">
            <div class="app-sidebar__user">
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

            <li><a class="app-menu__item active" href=<%=fromServlet==null?"customer-manage.jsp":"admin/doc/customer-manage.jsp"%>><i class='app-menu__icon bx bx-id-card'></i> <span
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

            <li><a class="app-menu__item" href=<%=fromServlet==null?"report-manage.jsp":"admin/doc/report-manage.jsp"%>><i
                        class='app-menu__icon bx bx-pie-chart-alt-2'></i><span class="app-menu__label">Báo cáo doanh thu</span></a>
            </li>
        </ul>
    </aside>
    <main class="app-content">
        <div class="app-title">
            <ul class="app-breadcrumb breadcrumb side">
                <li class="breadcrumb-item active"><a href="#"><b>Danh sách khách hàng</b></a></li>
            </ul>
            <div id="clock"></div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="tile-body">

                        <div class="row element-button">
                            <div class="col-sm-2">
                                <a class="btn btn-delete btn-sm nhap-tu-file" type="button" title="Nhập" onclick="myFunction(this)"><i
                                        class="fas fa-file-upload"></i> Tải từ file</a>
                            </div>

                            <div class="col-sm-2">
                                <a class="btn btn-delete btn-sm print-file" type="button" title="In" onclick="myApp.printTable()"><i
                                        class="fas fa-print"></i> In dữ liệu</a>
                            </div>
                            <div class="col-sm-2">
                                <a class="btn btn-delete btn-sm print-file js-textareacopybtn" type="button" title="Sao chép"><i
                                        class="fas fa-copy"></i> Sao chép</a>
                            </div>

                            <div class="col-sm-2">
                                <a class="btn btn-excel btn-sm" href="" title="In"><i class="fas fa-file-excel"></i> Xuất Excel</a>
                            </div>
                            <div class="col-sm-2">
                                <a class="btn btn-delete btn-sm pdf-file" type="button" title="In" onclick="myFunction(this)"><i
                                        class="fas fa-file-pdf"></i> Xuất PDF</a>
                            </div>
                            <div class="col-sm-2">
                                <a class="btn btn-delete btn-sm" type="button" title="Xóa" onclick="myFunction(this)"><i
                                        class="fas fa-trash-alt"></i> Xóa tất cả </a>
                            </div>
                        </div>
                        <div style="
                             display: inline-flex;
                             align-items: center;
                             border: solid;
                             padding: 6px 20px 0 18px;
                             border-color: #F0F0F0;
                             border-radius: 10px;">
                            <p style="font-weight: bold; margin-top: 10px">Tìm kiếm: </p>
                            <div class="search_bar" style="margin-left: 8px">
                                <form action="/Project/CustomerServlet">
                                    <input style="border-radius: 5px; border-color: #F0F0F0" placeholder="Search..." type="text" name="searchCustomer">
                                    <button style="border-radius: 30px" type="submit"><i class="fa fa-search"></i></button>
                                    <input type="hidden" name="service" value="searchCustomer">
                                </form>
                            </div>
                        </div>
                        <div>                          
                            <%
                                String msDeleteCustomer = (String)request.getAttribute("msDeleteCustomer");
                                if(msDeleteCustomer != null){
                            %>
                            <script>
                                alert("<%=msDeleteCustomer%>")
                            </script>
                            <%}%>
                        </div>
                        <table style="margin-top: 20px" class="table table-hover table-bordered js-copytextarea" cellpadding="0" cellspacing="0" border="0">
                            <thead>
                                <tr>
                                    <th width="120">ID nhân viên</th>
                                    <th width="20">Ảnh đại diện</th>
                                    <th width="180">Họ và tên</th>    
                                    <th width="150">Email</th>
                                    <th width="200">Địa chỉ</th>
                                    <th>Ngày sinh</th>
                                    <th>Giới tính</th>
                                    <th>SĐT</th>
                                    <th>Chức vụ</th>
                                    <th width="100">Tính năng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    Vector<Customer> listCustomer = new Vector<>();
                                    
                                    if((Vector<Customer>)request.getAttribute("listCustomer") != null){
                                        listCustomer = (Vector<Customer>)request.getAttribute("listCustomer");
                                    }else {
                                        listCustomer = cd.getAllCustomerFromSQL("select * from Customer");
                                    }
                                    
                                    for(Customer c : listCustomer){
                                %>
                                <tr>
                                    <td>#<%=c.getCustomerID()%></td>
                                    <td><img class="img-card-person" src="/Project/assets/img/avt/avatarDefault.jpg" alt=""></td>
                                    <td><%=c.getFirstName() + " " + c.getLastName()%></td>     
                                    <td><%=c.getEmail()!=null?c.getEmail():""%></td>
                                    <td><%=c.getAddress()!=null?c.getAddress():""%></td>
                                    <td><%=c.getBirthOfDate()!=null?c.getBirthOfDate():""%></td>
                                    <%
                                        String gender = "";
                                        if(c.getGender() != null){
                                            gender = c.getGender().equalsIgnoreCase("male")?"Nam":"Nữ";
                                        }
                                    %>
                                    <td><%=gender%></td>
                                    <td><%=c.getPhone()!=null?c.getPhone():""%></td>
                                    <td><%=c.getUsername().equalsIgnoreCase("admin")?"Quản trị viên":"Khách hàng"%></td>
                                    <td class="table-td-center">
                                        <button class="btn btn-primary btn-sm trash" type="button" title="Xóa"
                                                onclick="confirmDelete('<%=c.getCustomerID()%>')"><i class="fas fa-trash-alt"></i>
                                        </button>
                                    </td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!--
    MODAL
    -->
    <div class="modal fade" id="ModalUP" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static"
         data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">

                <div class="modal-body">
                    <div class="row">
                        <div class="form-group  col-md-12">
                            <span class="thong-tin-thanh-toan">
                                <h5>Chỉnh sửa thông tin nhân viên cơ bản</h5>
                            </span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-md-6">
                            <label class="control-label">ID nhân viên</label>
                            <input class="form-control" type="text" required value="#CD2187" disabled>
                        </div>
                        <div class="form-group col-md-6">
                            <label class="control-label">Họ và tên</label>
                            <input class="form-control" type="text" required value="Võ Trường">
                        </div>
                        <div class="form-group  col-md-6">
                            <label class="control-label">Số điện thoại</label>
                            <input class="form-control" type="number" required value="09267312388">
                        </div>
                        <div class="form-group col-md-6">
                            <label class="control-label">Địa chỉ email</label>
                            <input class="form-control" type="text" required value="truong.vd2000@gmail.com">
                        </div>
                        <div class="form-group col-md-6">
                            <label class="control-label">Ngày sinh</label>
                            <input class="form-control" type="date" value="15/03/2000">
                        </div>
                        <div class="form-group  col-md-6">
                            <label for="exampleSelect1" class="control-label">Chức vụ</label>
                            <select class="form-control" id="exampleSelect1">
                                <option>Bán hàng</option>
                                <option>Tư vấn</option>
                                <option>Dịch vụ</option>
                                <option>Thu Ngân</option>
                                <option>Quản kho</option>
                                <option>Bảo trì</option>
                                <option>Kiểm hàng</option>
                                <option>Bảo vệ</option>
                                <option>Tạp vụ</option>
                            </select>
                        </div>
                    </div>
                    <BR>
                    <a href="#" style="    float: right;
                       font-weight: 600;
                       color: #ea0000;">Chỉnh sửa nâng cao</a>
                    <BR>
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

    <!-- Essential javascripts for application to work-->
    <script src="js/jquery-3.2.1.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="src/jquery.table2excel.js"></script>
    <script src="js/main.js"></script>
    <!-- The javascript plugin to display page loading on top-->
    <script src="js/plugins/pace.min.js"></script>
    <!-- Page specific javascripts-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>
    <!-- Data table plugin-->
    <script type="text/javascript" src="js/plugins/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="js/plugins/dataTables.bootstrap.min.js"></script>
    <script type="text/javascript">$('#sampleTable').DataTable();</script>
    <script>
        function confirmDelete(customerID) {
            jQuery(function () {
                jQuery(".trash").append(function () {
                    swal({
                        title: "Cảnh báo",
                        text: "Bạn có chắc chắn là muốn xóa khách hàng này không?",
                        buttons: ["Hủy bỏ", "Đồng ý"]
                    })
                            .then((willDelete) => {
                                if (willDelete) {
                                    window.location.href = '/Project/CustomerServlet?service=delete&customerID=' + customerID;
                                }
                            });
                });
            });
            oTable = $('#sampleTable').dataTable();
            $('#all').click(function (e) {
                $('#sampleTable tbody :checkbox').prop('checked', $(this).is(':checked'));
                e.stopImmediatePropagation();
            });
        }


        //EXCEL
        // $(document).ready(function () {
        //   $('#').DataTable({

        //     dom: 'Bfrtip',
        //     "buttons": [
        //       'excel'
        //     ]
        //   });
        // });


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
        //In dữ liệu
        var myApp = new function () {
            this.printTable = function () {
                var tab = document.getElementById('sampleTable');
                var win = window.open('', '', 'height=700,width=700');
                win.document.write(tab.outerHTML);
                win.document.close();
                win.print();
            }
        }

        //Modal
        $("#show-emp").on("click", function () {
            $("#ModalUP").modal({backdrop: false, keyboard: false})
        });
    </script>
</body>

</html>
