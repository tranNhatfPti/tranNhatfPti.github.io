<%-- 
    Document   : my-account
    Created on : Jan 25, 2024, 11:44:03 PM
    Author     : ASUS ZenBook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Vector, jakarta.servlet.http.HttpSession, model.Customer, model.ProductCart, dal.ProductCartDAO, model.Orders, dal.OrdersDAO, model.OrderDetails, dal.OrderDetailsDAO, model.Product, dal.ProductDAO, java.text.DecimalFormat"%>
﻿<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Coron-my account</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Favicon -->
        <link rel="shortcut icon" type="image/x-icon" href="assets\img\sixmfight.jpg">

        <!-- all css here -->
        <link rel="stylesheet" href="assets\css\bootstrap.min.css">
        <link rel="stylesheet" href="assets\css\plugin.css">
        <link rel="stylesheet" href="assets\css\bundle.css">
        <link rel="stylesheet" href="assets\css\style.css">
        <link rel="stylesheet" href="assets\css\responsive.css">
        <script src="assets\js\vendor\modernizr-2.8.3.min.js"></script>

        <style>
            .infor_account img {
                width: 38px;
                margin-left: 15px;
                border-radius: 30px;
            }

            .infor_account img:hover{
                cursor: pointer;
                background-color: red;
            }

            .save_button_infor button{
                background-color: #00bba6;
                color: white;
                height: 35px;
                width: 70px;
                margin-top: 15px;
            }

            .save_button_infor button:hover {
                cursor: pointer;
            }

            .account-details img {
                width: 15%;
                border-radius: 100px;
            }

            .account-details .avatar {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .account-details .avatar h2 {
                color: #00bba6;
            }

            .table thead th {
                text-align: center;
            }

            .info_order .info_first {
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 10px 0;
            }

            .info_order td {
                vertical-align: middle;
            }

            .info_order .info_first img {
                max-width: 30%;
            }

            .badge {
                display: inline-block;
                padding: 7px;
                font-size: 12px;
                font-weight: 500;
                line-height: 1;
                text-align: center;
                white-space: nowrap;
                vertical-align: baseline;
                border-radius: 0.25rem;
                color: white;
            }

            .bg-success {
                background-color: #bfefc4 !important;
                color: #02790c !important;
            }

            .bg-info {
                background-color: #b6bef5 !important;
                color: #0f2094 !important;
            }

            .bg-warning {
                background-color: #f2f98a !important;
                color: #8b9400 !important;
            }

            .bg-danger {
                background-color: #f9c9cd !important;
                color: #a90312 !important;
            }

            .received_order{
                margin-top: 12px;
            }

            .cancelled_order {
                margin-top: 15px;
            }

            .cancelled_order,.received_order {
                width: 100%;
                background: #00bba6;
                font-size: 12px;
                padding: 3px 14px;
                line-height: 30px;
                font-weight: 700;
                display: inline-block;
                text-transform: uppercase;
                margin-bottom: 0;
            }

            .cancelled_order:hover,.received_order:hover {
                transition: background-color 0.3s;
                cursor: pointer;
                background: orange;
            }

        </style>
    </head>
    <body>
        <!-- Add your site or application content here -->
        <c:set var="account" value="${sessionScope.account}"/>
        <%
            DecimalFormat df = new DecimalFormat("#.0");
            HttpSession s = request.getSession();
            ProductDAO pd = new ProductDAO();
            OrdersDAO od = new OrdersDAO();
            OrderDetailsDAO odd = new OrderDetailsDAO();
            ProductCartDAO pcd = new ProductCartDAO();
            Vector<ProductCart> vector = new Vector<>();
            Customer account = (Customer)s.getAttribute("account");
        %>
        <!--pos page start-->
        <div class="pos_page">
            <div class="container">  
                <!--pos page inner-->
                <div class="pos_page_inner">  
                    <!--header area -->
                    <div class="header_area">
                        <!--header top--> 
                        <div class="header_top">
                            <div class="row align-items-center">
                                <div class="col-lg-6 col-md-6">

                                </div>
                                <div class="col-lg-6 col-md-6">
                                    <div class="header_links">
                                        <ul>
                                            <li><a href="contact.jsp" title="Contact">Contact</a></li>
                                            <li><a href="wishlist.jsp" title="wishlist">My wishlist</a></li>
                                            <li><a href="my-account.jsp" title="My account">My account</a></li>
                                            <li><a href="cart.jsp" title="My cart">My cart</a></li>
                                        </ul>
                                    </div>   
                                </div>
                            </div> 
                        </div> 
                        <!--header top end-->

                        <!--header middel--> 
                        <div class="header_middel">
                            <div class="row align-items-center">
                                <div class="col-lg-3 col-md-3">
                                    <div class="logo">
                                        <a href="index.jsp"><img src="assets\img\logo\logo.jpg.png" alt=""></a>
                                    </div>
                                </div>
                                <div class="col-lg-9 col-md-9">
                                    <div class="header_right_info">
                                        <div class="search_bar">
                                            <form action="#">
                                                <input style="border-radius: 30px" placeholder="Search..." type="text">
                                                <button type="submit"><i class="fa fa-search"></i></button>
                                            </form>
                                        </div>
                                        <%                                           
                                            int amountOfProductCart = 0;
                                            int discount;
                                            double priceAfterDiscount;   
                                            double totalPriceAfterDiscount = 0;
                                            
                                            if (account != null) {
                                                int customerID = account.getCustomerID();    
                                                
                                                vector = pcd.getAllProductCartFromSQL("select * from ProductCart where CustomerID = " + customerID);
                                                amountOfProductCart = vector.size();
                                                
                                                for(ProductCart productCart : vector) {
                                                    discount = pd.getAllProductFromSQL("select * from Product where ProductCode = " + productCart.getProductCode()).firstElement().getDiscount();
                                                    priceAfterDiscount = ((productCart.getPrice() * (100 - discount)) / 100) * productCart.getQuantity();
                                                    totalPriceAfterDiscount += priceAfterDiscount;
                                                }
                                            }
                                        %>
                                        <div class="shopping_cart">
                                            <c:if test="${account != null}">
                                                <a href="#" style="font-weight: bold; color: #491217"><i style="color: red" class="fa fa-shopping-cart"></i> <span style="color: red"><%=amountOfProductCart%></span> Items - $<%=df.format(totalPriceAfterDiscount)%> <i class="fa fa-angle-down"></i></a>
                                                </c:if>
                                            <!--mini cart-->

                                            <div class="mini_cart">
                                                <%
                                                    for(ProductCart productCart : vector) {
                                                    discount = pd.getAllProductFromSQL("select * from Product where ProductCode = " + productCart.getProductCode()).firstElement().getDiscount();
                                                %>
                                                <div class="cart_item">
                                                    <div class="cart_img">
                                                        <a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=productCart.getProductCode()%>"><img src="<%=productCart.getImage()%>" alt=""></a>
                                                    </div>
                                                    <div class="cart_info">
                                                        <a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=productCart.getProductCode()%>"><%=productCart.getProductName()%></a>
                                                        <span class="cart_price">$<%=df.format((productCart.getPrice() * (100 - discount)) / 100)%><span style="text-decoration: line-through; font-size: 12px; margin-left: 5px; color: black">$<%=productCart.getPrice()%></span></span>
                                                        <span class="quantity">Quantity: <%=productCart.getQuantity()%></span>
                                                    </div>
                                                    <div class="cart_remove">
                                                        <a title="Remove this item" href="ShoppingCartServlet?service=remove&customerID=<%=productCart.getCustomerID()%>&productCode=<%=productCart.getProductCode()%>&size=<%=productCart.getSize()%>&color=<%=productCart.getColor()%>&namePage=index.jsp"><i class="fa fa-times-circle"></i></a>
                                                    </div>
                                                </div>
                                                <%}%>
                                                <div class="shipping_price">
                                                    <span> Shipping </span>
                                                    <span>  $0.00  </span>
                                                </div>
                                                <div class="total_price">
                                                    <span> Total </span>
                                                    <span class="prices">  <%=df.format(totalPriceAfterDiscount)%>  </span>
                                                </div>
                                                <div class="cart_button">
                                                    <a href="cart.jsp">My cart</a>
                                                </div>
                                            </div>
                                            <!--mini cart end-->
                                        </div>                                                 
                                        <c:if test="${account != null}">
                                            <div class="infor_account">
                                                <div class="avatar_account">
                                                    <a href="my-account.jsp"><img src="${sessionScope.account.getAvatar()}" alt="alt"/></a>
                                                </div>
                                            </div>
                                        </c:if>

                                    </div>
                                </div>
                            </div>
                        </div>     
                        <!--header middel end-->      
                        <div class="header_bottom">
                            <div class="row">
                                <div class="col-12">
                                    <div class="main_menu_inner">
                                        <div class="main_menu d-none d-lg-block">
                                            <nav>
                                                <ul>
                                                    <li class="active"><a href="index.jsp">Home</a>

                                                    </li>
                                                    <li><a href="ListProductServlet">shop</a>

                                                    </li>
                                                    <li><a href="#">women</a>
                                                        <div class="mega_menu">
                                                            <div class="mega_top fix">
                                                                <div class="mega_items">
                                                                    <h3><a href="#">Accessories</a></h3>
                                                                    <ul>
                                                                        <li><a href="#">Cocktai</a></li>
                                                                        <li><a href="#">day</a></li>
                                                                        <li><a href="#">Evening</a></li>
                                                                        <li><a href="#">Sundresses</a></li>
                                                                        <li><a href="#">Belts</a></li>
                                                                        <li><a href="#">Sweets</a></li>
                                                                    </ul>
                                                                </div>
                                                                <div class="mega_items">
                                                                    <h3><a href="#">HandBags</a></h3>
                                                                    <ul>
                                                                        <li><a href="#">Accessories</a></li>
                                                                        <li><a href="#">Hats and Gloves</a></li>
                                                                        <li><a href="#">Lifestyle</a></li>
                                                                        <li><a href="#">Bras</a></li>
                                                                        <li><a href="#">Scarves</a></li>
                                                                        <li><a href="#">Small Leathers</a></li>
                                                                    </ul>
                                                                </div>
                                                                <div class="mega_items">
                                                                    <h3><a href="#">Tops</a></h3>
                                                                    <ul>
                                                                        <li><a href="#">Evening</a></li>
                                                                        <li><a href="#">Long Sleeved</a></li>
                                                                        <li><a href="#">Shrot Sleeved</a></li>
                                                                        <li><a href="#">Tanks and Camis</a></li>
                                                                        <li><a href="#">Sleeveless</a></li>
                                                                        <li><a href="#">Sleeveless</a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div class="mega_bottom fix">
                                                                <div class="mega_thumb">
                                                                    <a href="#"><img src="assets\img\banner\banner1.jpg" alt=""></a>
                                                                </div>
                                                                <div class="mega_thumb">
                                                                    <a href="#"><img src="assets\img\banner\banner2.jpg" alt=""></a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li><a href="#">men</a>
                                                        <div class="mega_menu">
                                                            <div class="mega_top fix">
                                                                <div class="mega_items">
                                                                    <h3><a href="#">Rings</a></h3>
                                                                    <ul>
                                                                        <li><a href="#">Platinum Rings</a></li>
                                                                        <li><a href="#">Gold Ring</a></li>
                                                                        <li><a href="#">Silver Ring</a></li>
                                                                        <li><a href="#">Tungsten Ring</a></li>
                                                                        <li><a href="#">Sweets</a></li>
                                                                    </ul>
                                                                </div>
                                                                <div class="mega_items">
                                                                    <h3><a href="#">Bands</a></h3>
                                                                    <ul>
                                                                        <li><a href="#">Platinum Bands</a></li>
                                                                        <li><a href="#">Gold Bands</a></li>
                                                                        <li><a href="#">Silver Bands</a></li>
                                                                        <li><a href="#">Silver Bands</a></li>
                                                                        <li><a href="#">Sweets</a></li>
                                                                    </ul>
                                                                </div>
                                                                <div class="mega_items">
                                                                    <a href="#"><img src="assets\img\banner\banner3.jpg" alt=""></a>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </li>
                                                    <li><a href="#">pages</a>
                                                        <div class="mega_menu">
                                                            <div class="mega_top fix">
                                                                <div class="mega_items">
                                                                    <h3><a href="#">Column1</a></h3>
                                                                    <ul>
                                                                        <li><a href="portfolio.html">Portfolio</a></li>
                                                                        <li><a href="portfolio-details.html">single portfolio </a></li>
                                                                        <li><a href="about.html">About Us </a></li>
                                                                        <li><a href="about-2.html">About Us 2</a></li>
                                                                        <li><a href="services.html">Service </a></li>
                                                                        <li><a href="my-account.html">my account </a></li>
                                                                    </ul>
                                                                </div>
                                                                <div class="mega_items">
                                                                    <h3><a href="#">Column2</a></h3>
                                                                    <ul>
                                                                        <li><a href="blog.html">Blog </a></li>
                                                                        <li><a href="blog-details.html">Blog  Details </a></li>
                                                                        <li><a href="blog-fullwidth.html">Blog FullWidth</a></li>
                                                                        <li><a href="blog-sidebar.html">Blog  Sidebar</a></li>
                                                                        <li><a href="faq.html">Frequently Questions</a></li>
                                                                        <li><a href="404.html">404</a></li>
                                                                    </ul>
                                                                </div>
                                                                <div class="mega_items">
                                                                    <h3><a href="#">Column3</a></h3>
                                                                    <ul>
                                                                        <li><a href="contact.html">Contact</a></li>
                                                                        <li><a href="cart.html">cart</a></li>
                                                                        <li><a href="checkout.html">Checkout  </a></li>
                                                                        <li><a href="wishlist.html">Wishlist</a></li>
                                                                        <li><a href="login.html">Login</a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>

                                                    <li><a href="blog.html">blog</a>
                                                        <div class="mega_menu jewelry">
                                                            <div class="mega_items jewelry">
                                                                <ul>
                                                                    <li><a href="blog-details.html">blog details</a></li>
                                                                    <li><a href="blog-fullwidth.html">blog fullwidth</a></li>
                                                                    <li><a href="blog-sidebar.html">blog sidebar</a></li>
                                                                </ul>
                                                            </div>
                                                        </div>  
                                                    </li>
                                                    <li><a href="contact.html">contact us</a></li>

                                                </ul>
                                            </nav>
                                        </div>
                                        <div class="mobile-menu d-lg-none">
                                            <nav>
                                                <ul>
                                                    <li><a href="index.html">Home</a>
                                                        <div>
                                                            <div>
                                                                <ul>
                                                                    <li><a href="index.html">Home 1</a></li>
                                                                    <li><a href="index.html">Home 2</a></li>
                                                                </ul>
                                                            </div>
                                                        </div> 
                                                    </li>
                                                    <li><a href="shop.html">shop</a>
                                                        <div>
                                                            <div>
                                                                <ul>
                                                                    <li><a href="shop-list.html">shop list</a></li>
                                                                    <li><a href="shop-fullwidth.html">shop Full Width Grid</a></li>
                                                                    <li><a href="shop-fullwidth-list.html">shop Full Width list</a></li>
                                                                    <li><a href="shop-sidebar.html">shop Right Sidebar</a></li>
                                                                    <li><a href="shop-sidebar-list.html">shop list Right Sidebar</a></li>
                                                                    <li><a href="single-product.html">Product Details</a></li>
                                                                    <li><a href="single-product-sidebar.html">Product sidebar</a></li>
                                                                    <li><a href="single-product-video.html">Product Details video</a></li>
                                                                    <li><a href="single-product-gallery.html">Product Details Gallery</a></li>
                                                                </ul>
                                                            </div>
                                                        </div>  
                                                    </li>
                                                    <li><a href="#">women</a>
                                                        <div>
                                                            <div>
                                                                <div>
                                                                    <h3><a href="#">Accessories</a></h3>
                                                                    <ul>
                                                                        <li><a href="#">Cocktai</a></li>
                                                                        <li><a href="#">day</a></li>
                                                                        <li><a href="#">Evening</a></li>
                                                                        <li><a href="#">Sundresses</a></li>
                                                                        <li><a href="#">Belts</a></li>
                                                                        <li><a href="#">Sweets</a></li>
                                                                    </ul>
                                                                </div>
                                                                <div>
                                                                    <h3><a href="#">HandBags</a></h3>
                                                                    <ul>
                                                                        <li><a href="#">Accessories</a></li>
                                                                        <li><a href="#">Hats and Gloves</a></li>
                                                                        <li><a href="#">Lifestyle</a></li>
                                                                        <li><a href="#">Bras</a></li>
                                                                        <li><a href="#">Scarves</a></li>
                                                                        <li><a href="#">Small Leathers</a></li>
                                                                    </ul>
                                                                </div>
                                                                <div>
                                                                    <h3><a href="#">Tops</a></h3>
                                                                    <ul>
                                                                        <li><a href="#">Evening</a></li>
                                                                        <li><a href="#">Long Sleeved</a></li>
                                                                        <li><a href="#">Shrot Sleeved</a></li>
                                                                        <li><a href="#">Tanks and Camis</a></li>
                                                                        <li><a href="#">Sleeveless</a></li>
                                                                        <li><a href="#">Sleeveless</a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <div>
                                                                <div>
                                                                    <a href="#"><img src="assets\img\banner\banner1.jpg" alt=""></a>
                                                                </div>
                                                                <div>
                                                                    <a href="#"><img src="assets\img\banner\banner2.jpg" alt=""></a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li><a href="#">men</a>
                                                        <div>
                                                            <div>
                                                                <div>
                                                                    <h3><a href="#">Rings</a></h3>
                                                                    <ul>
                                                                        <li><a href="#">Platinum Rings</a></li>
                                                                        <li><a href="#">Gold Ring</a></li>
                                                                        <li><a href="#">Silver Ring</a></li>
                                                                        <li><a href="#">Tungsten Ring</a></li>
                                                                        <li><a href="#">Sweets</a></li>
                                                                    </ul>
                                                                </div>
                                                                <div>
                                                                    <h3><a href="#">Bands</a></h3>
                                                                    <ul>
                                                                        <li><a href="#">Platinum Bands</a></li>
                                                                        <li><a href="#">Gold Bands</a></li>
                                                                        <li><a href="#">Silver Bands</a></li>
                                                                        <li><a href="#">Silver Bands</a></li>
                                                                        <li><a href="#">Sweets</a></li>
                                                                    </ul>
                                                                </div>
                                                                <div>
                                                                    <a href="#"><img src="assets\img\banner\banner3.jpg" alt=""></a>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </li>
                                                    <li><a href="#">pages</a>
                                                        <div>
                                                            <div>
                                                                <div>
                                                                    <h3><a href="#">Column1</a></h3>
                                                                    <ul>
                                                                        <li><a href="portfolio.html">Portfolio</a></li>
                                                                        <li><a href="portfolio-details.html">single portfolio </a></li>
                                                                        <li><a href="about.html">About Us </a></li>
                                                                        <li><a href="about-2.html">About Us 2</a></li>
                                                                        <li><a href="services.html">Service </a></li>
                                                                        <li><a href="my-account.html">my account </a></li>
                                                                    </ul>
                                                                </div>
                                                                <div>
                                                                    <h3><a href="#">Column2</a></h3>
                                                                    <ul>
                                                                        <li><a href="blog.html">Blog </a></li>
                                                                        <li><a href="blog-details.html">Blog  Details </a></li>
                                                                        <li><a href="blog-fullwidth.html">Blog FullWidth</a></li>
                                                                        <li><a href="blog-sidebar.html">Blog  Sidebar</a></li>
                                                                        <li><a href="faq.html">Frequently Questions</a></li>
                                                                        <li><a href="404.html">404</a></li>
                                                                    </ul>
                                                                </div>
                                                                <div>
                                                                    <h3><a href="#">Column3</a></h3>
                                                                    <ul>
                                                                        <li><a href="contact.html">Contact</a></li>
                                                                        <li><a href="cart.html">cart</a></li>
                                                                        <li><a href="checkout.html">Checkout  </a></li>
                                                                        <li><a href="wishlist.html">Wishlist</a></li>
                                                                        <li><a href="login.html">Login</a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>

                                                    <li><a href="blog.html">blog</a>
                                                        <div>
                                                            <div>
                                                                <ul>
                                                                    <li><a href="blog-details.html">blog details</a></li>
                                                                    <li><a href="blog-fullwidth.html">blog fullwidth</a></li>
                                                                    <li><a href="blog-sidebar.html">blog sidebar</a></li>
                                                                </ul>
                                                            </div>
                                                        </div>  
                                                    </li>
                                                    <li><a href="contact.html">contact us</a></li>

                                                </ul>
                                            </nav>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--header end -->

                    <!--breadcrumbs area start-->
                    <div class="breadcrumbs_area">
                        <div class="row">
                            <div class="col-12">
                                <div class="breadcrumb_content">
                                    <ul>
                                        <li><a href="index.jsp">home</a></li>
                                        <li><i class="fa fa-angle-right"></i></li>
                                        <li>my account</li>
                                    </ul>

                                </div>
                            </div>
                        </div>
                    </div>
                    <!--breadcrumbs area end-->

                    <!-- Start Maincontent  -->
                    <section class="main_content_area">
                        <div class="account_dashboard">
                            <div class="row">
                                <div class="col-sm-12 col-md-2 col-lg-2">
                                    <!-- Nav tabs -->
                                    <div class="dashboard_tab_button">
                                        <ul role="tablist" class="nav flex-column dashboard-list">
                                            <li><a href="#dashboard" data-toggle="tab" class="nav-link">Dashboard</a></li>
                                            <li><a href="#orders" data-toggle="tab" class="nav-link">My Orders</a></li>
                                            <li><a href="#account-details" data-toggle="tab" class="nav-link active">Account details</a></li>
                                            <li><a href="LoginServlet?service=logout" class="nav-link">logout</a></li>
                                        </ul>
                                    </div>    
                                </div>
                                <div class="col-sm-12 col-md-10 col-lg-10">
                                    <!-- Tab panes -->
                                    <div class="tab-content dashboard_content">                                       
                                        <div class="tab-pane fade" id="dashboard">
                                            <h3>Dashboard </h3>
                                            <p>From your account dashboard. you can easily check &amp; view your <a href="#">recent orders</a>, manage your <a href="#">shipping and billing addresses</a> and <a href="#">Edit your password and account details.</a></p>
                                        </div>
                                        <div class="tab-pane fade" id="orders">
                                            <h3>My Orders</h3>
                                            <div class="coron_table table-responsive">
                                                <table class="table">
                                                    <thead>
                                                        <tr>
                                                            <th>Product</th>
                                                            <th>Price</th>
                                                            <th>Order Total</th>
                                                            <th>Delivery Address</th>
                                                            <th>Status</th>
                                                            <th width="200">Confirm Order</th>                                                            
                                                        </tr>
                                                    </thead>                                                   
                                                    <tbody>
                                                        <%
                                                            Product p = new Product();
                                                            Vector<OrderDetails> listOrderDetail = new Vector<>();
                                                            Vector<Orders> listOrder = od.getAllOrdersFromSQL("select * from Orders where CustomerID = " + account.getCustomerID());
                                                            for(Orders order : listOrder){
                                                                listOrderDetail = odd.getAllOrderDetailsFromSQL("select * from OrderDetails where OrderID = " + order.getOrderID());
                                                                if(listOrderDetail.size() == 1) {
                                                                    OrderDetails orderDetail = listOrderDetail.firstElement();
                                                        %>
                                                        <tr class="info_order">
                                                            <td>
                                                                <div class="info_first">
                                                                    <%
                                                                        p = pd.getAllProductFromSQL("select * from Product where ProductCode = " + orderDetail.getProductCode()).firstElement();
                                                                    %>
                                                                    <img src="<%=p.getPicture()%>" alt=""/>
                                                                    <div>
                                                                        <label style="font-weight: bold; margin-left: 12px"><%=p.getProductName()%></label><br>
                                                                        <label><%=orderDetail.getSizeOrder() + ", " + orderDetail.getColorOrder()%></label><br>
                                                                        <label style="font-weight: bold;">× <%=orderDetail.getQuantityOrder()%></label>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td style="font-size: 15px; color: orange">$<%=(p.getPrice() * (100 - p.getDiscount())) / 100%><label style="margin: auto; text-decoration: line-through; color: red; font-size: 12px;">$<%=p.getPrice()%></label></td>
                                                            <td><span class="success" style="color: orange; font-size: 15px">$<%=df.format((((p.getPrice() * (100 - p.getDiscount())) / 100) * (orderDetail.getQuantityOrder())) + 5)%></span></td>
                                                            <td><%=account.getAddress()!=null?account.getAddress():""%></td>
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
                                                            <td>
                                                                <%
                                                                    if(order.getStatus() == 1 || order.getStatus() == 2 || order.getStatus() == 3){
                                                                %>
                                                                <div class="received_order" id="confirm_received" onclick="confirmReceived(<%=order.getOrderID()%>)">
                                                                    <a href="#" style="color: white">Đã nhận được hàng</a>
                                                                </div>
                                                                <div class="cancelled_order" id="confirm_cancelled" onclick="confirmCancelled(<%=order.getOrderID()%>)">
                                                                    <a href="#" style="color: white">Huỷ đơn hàng</a>
                                                                </div>
                                                                <%}
                                                                if(order.getStatus() == 4){
                                                                %>
                                                                <div class="received_order">
                                                                    <a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=orderDetail.getProductCode()%>" style="color: white">Send Feedback</a>
                                                                </div>
                                                                <%}
                                                                if(order.getStatus() == 5){
                                                                %>
                                                                <div class="received_order">
                                                                    <a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=orderDetail.getProductCode()%>" style="color: white">Buy Again</a>
                                                                </div>
                                                                <%}%>
                                                            </td>
                                                        </tr>
                                                        <%
                                                            }else {
                                                        %>
                                                        <tr class="info_order">
                                                            <td>
                                                                <%
                                                                    for(OrderDetails orderDetail : listOrderDetail){
                                                                %>
                                                                <div class="info_first">
                                                                    <%
                                                                        p = pd.getAllProductFromSQL("select * from Product where ProductCode = " + orderDetail.getProductCode()).firstElement();
                                                                    %>
                                                                    <img src="<%=p.getPicture()%>" alt=""/>
                                                                    <div>
                                                                        <label style="font-weight: bold; margin-left: 12px"><%=p.getProductName()%></label><br>
                                                                        <label><%=orderDetail.getSizeOrder() + ", " + orderDetail.getColorOrder()%></label><br>
                                                                        <label style="font-weight: bold;">× <%=orderDetail.getQuantityOrder()%></label>
                                                                    </div>
                                                                </div>
                                                                <%}%>
                                                            </td>
                                                            <td style="font-size: 15px; color: orange">
                                                                <%
                                                                    for(OrderDetails orderDetail : listOrderDetail){
                                                                        p = pd.getAllProductFromSQL("select * from Product where ProductCode = " + orderDetail.getProductCode()).firstElement();
                                                                %>
                                                                <div style="height: 100px; margin-top: 50px">
                                                                    $<%=(p.getPrice() * (100 - p.getDiscount())) / 100%>
                                                                    <label style="margin: auto; text-decoration: line-through; color: red; font-size: 12px;">$<%=p.getPrice()%></label>
                                                                </div>
                                                                <%}%>
                                                            </td>
                                                            <td class="align-center">
                                                                <%
                                                                    int totalAmount = 0;
                                                                    for(OrderDetails orderDetail : listOrderDetail){
                                                                        p = pd.getAllProductFromSQL("select * from Product where ProductCode = " + orderDetail.getProductCode()).firstElement();
                                                                        totalAmount += (((p.getPrice() * (100 - p.getDiscount())) / 100) * orderDetail.getQuantityOrder());
                                                                    }    
                                                                    totalAmount += 5;
                                                                %>
                                                                <span class="success" style="color: orange; font-size: 15px">$<%=df.format(totalAmount)%></span>
                                                            </td>
                                                            <td><%=account.getAddress()!=null?account.getAddress():""%></td>
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
                                                            <td>
                                                                <%
                                                                    if(order.getStatus() == 1 || order.getStatus() == 2 || order.getStatus() == 3){
                                                                %>
                                                                <div class="received_order" id="confirm_received" onclick="confirmReceived(<%=order.getOrderID()%>)">
                                                                    <a href="#" style="color: white">Đã nhận được hàng</a>
                                                                </div>
                                                                <div class="cancelled_order" id="confirm_cancelled" onclick="confirmCancelled(<%=order.getOrderID()%>)">
                                                                    <a href="#" style="color: white">Huỷ đơn hàng</a>
                                                                </div>
                                                                <%}
                                                                    if(order.getStatus() == 4){
                                                                        for(OrderDetails orderDetail : listOrderDetail){
                                                                %>
                                                                <div class="received_order" style="margin: 60px 0">
                                                                    <a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=orderDetail.getProductCode()%>" style="color: white">Send Feedback</a>
                                                                </div>                       
                                                                <%
                                                                }}
                                                                %>
                                                            </td>
                                                        </tr>
                                                        <%}}%>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>         
                                        <div class="tab-pane fade show active" id="account-details">     
                                            <div class="avatar" style="display: flex;
                                                 justify-content: space-between;
                                                 align-items: center;">
                                                <h2 style="color: #00bba6;">Account details </h2>
                                                <img style="width: 15%;
                                                     border-radius: 100px;" 
                                                     src="${sessionScope.account.getAvatar()}" alt="alt"/>
                                            </div>

                                            <div class="login">
                                                <div class="login_form_container">
                                                    <div class="account_login_form">
                                                        <form action="LoginServlet">
                                                            <div class="input-radio">
                                                                <c:set var="checkGenderMale" value="${account.getGender()!=null&&account.getGender().equals('Male')}"/>
                                                                <c:set var="checkGenderFemale" value="${account.getGender()!=null&&account.getGender().equals('Female')}"/>
                                                                <span class="custom-radio"><input type="radio" value="1" name="id_gender" ${checkGenderMale?'checked':''}> Mr.</span>
                                                                <span class="custom-radio"><input type="radio" value="2" name="id_gender" ${checkGenderFemale?'checked':''}> Mrs.</span>
                                                            </div> <br>
                                                            <label style="font-weight: bold">First Name</label>
                                                            <input type="text" name="first-name" value="${account.getFirstName()}">
                                                            <label style="font-weight: bold">Last Name</label>
                                                            <input type="text" name="last-name" value="${account.getLastName()}">
                                                            <label style="font-weight: bold">Email</label>
                                                            <input type="email" name="email-name" value="${account.getEmail()}">
                                                            <label style="font-weight: bold">Phone</label>
                                                            <input type="phone" name="phone" value="${account.getPhone()}">
                                                            <label style="font-weight: bold">Addresses<label style="color: red">(The following addresses will be used on the checkout page by default)</label></label>
                                                            <input type="text" name="address" value="${account.getAddress()}">
                                                            <label style="font-weight: bold">Birthdate</label>
                                                            <input type="date" placeholder="MM-DD-YYYY" value="${account.getBirthOfDate()}" name="birthday">
                                                            <span class="example">
                                                                (E.g.: 05-31-1970)
                                                            </span>
                                                            <br>
                                                            <div class="save_button_infor">
                                                                <button type="submit">Save</button>
                                                                <input type="hidden" name="service" value="updateInfor">
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>      	
                    </section>			
                    <!-- End Maincontent  --> 
                </div>
                <!--pos page inner end-->
            </div>
        </div>
        <!--pos page end-->

        <!--footer area start-->
        <div class="footer_area">
            <div class="footer_top">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-3 col-md-6 col-sm-6">
                            <div class="footer_widget">
                                <h3>About us</h3>
                                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
                                <div class="footer_widget_contect">
                                    <p><i class="fa fa-map-marker" aria-hidden="true"></i>  19 Interpro Road Madison, AL 35758, USA</p>

                                    <p><i class="fa fa-mobile" aria-hidden="true"></i> (012) 234 432 3568</p>
                                    <a href="#"><i class="fa fa-envelope-o" aria-hidden="true"></i> Contact@plazathemes.com </a>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-sm-6">
                            <div class="footer_widget">
                                <h3>My Account</h3>
                                <ul>
                                    <li><a href="#">Your Account</a></li>
                                    <li><a href="#">My orders</a></li>
                                    <li><a href="#">My credit slips</a></li>
                                    <li><a href="#">My addresses</a></li>
                                    <li><a href="#">Login</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-sm-6">
                            <div class="footer_widget">
                                <h3>Informations</h3>
                                <ul>
                                    <li><a href="#">Specials</a></li>
                                    <li><a href="#">Our store(s)!</a></li>
                                    <li><a href="#">My credit slips</a></li>
                                    <li><a href="#">Terms and conditions</a></li>
                                    <li><a href="#">About us</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-sm-6">
                            <div class="footer_widget">
                                <h3>extras</h3>
                                <ul>
                                    <li><a href="#"> Brands</a></li>
                                    <li><a href="#"> Gift Vouchers </a></li>
                                    <li><a href="#"> Affiliates </a></li>
                                    <li><a href="#"> Specials </a></li>
                                    <li><a href="#"> Privacy policy </a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="footer_bottom">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-lg-6 col-md-6">
                            <div class="copyright_area">
                                <ul>
                                    <li><a href="#"> about us </a></li>
                                    <li><a href="#">  Customer Service  </a></li>
                                    <li><a href="#">  Privacy Policy  </a></li>
                                </ul>
                                <p>Copyright &copy; 2018 <a href="#">Pos Coron</a>. All rights reserved. </p>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6">
                            <div class="footer_social text-right">
                                <ul>
                                    <li><a href="#"><i class="fa fa-facebook"></i></a></li>
                                    <li><a href="#"><i class="fa fa-twitter"></i></a></li>
                                    <li><a href="#"><i class="fa fa-google-plus" aria-hidden="true"></i></a></li>
                                    <li><a class="pinterest" href="#"><i class="fa fa-pinterest-p" aria-hidden="true"></i></a></li>

                                    <li><a href="#"><i class="fa fa-wifi" aria-hidden="true"></i></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--footer area end-->






        <!-- all js here -->
        <script src="assets\js\vendor\jquery-1.12.0.min.js"></script>
        <script src="assets\js\popper.js"></script>
        <script src="assets\js\bootstrap.min.js"></script>
        <script src="assets\js\ajax-mail.js"></script>
        <script src="assets\js\plugins.js"></script>
        <script src="assets\js\main.js"></script>

        <script>
                                                                    function confirmReceived(orderID) {
                                                                        var confirmed = confirm("Xác nhận đã nhận được hàng!");
                                                                        if (confirmed) {
                                                                            alert("Xác nhận đã nhận đơn hàng thành công!"); // Thực hiện hành động xoá ở đây
                                                                            window.location.href = '/Project/OrderServlet?service=updateOrderStatus&status=received&orderID=' + orderID;
                                                                        }
                                                                    }

                                                                    function confirmCancelled(orderID) {
                                                                        var confirmed = confirm("Xác nhận huỷ đơn hàng!");
                                                                        if (confirmed) {
                                                                            alert("Xác nhận huỷ đơn hàng thành công!"); // Thực hiện hành động xoá ở đây
                                                                            window.location.href = '/Project/OrderServlet?service=updateOrderStatus&status=cancelled&orderID=' + orderID;
                                                                        }
                                                                    }
        </script>
    </body>
</html>

