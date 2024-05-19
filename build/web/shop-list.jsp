<%-- 
    Document   : shop-list
    Created on : Jan 25, 2024, 10:49:03 PM
    Author     : ASUS ZenBook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Vector, jakarta.servlet.http.HttpSession, model.Customer, model.ProductCart, dal.ProductCartDAO, model.Product, dal.ProductDAO, model.Brand, dal.BrandDAO, java.text.DecimalFormat, model.Category, dal.CategoryDAO, java.util.ArrayList"%>
﻿<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Coron-shop list</title>
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
            .infor_account {
                display: flex;
                justify-content: flex-end;
                align-items: center;
                margin-bottom: 10px;
            }

            .infor_account p {
                margin: auto;
                color: brown;
                font-weight: bold;
                font-size: 16px;
            }

            .infor_account img {
                width: 40px;
                border-radius: 30px;
                margin-right: 10px;
            }

            .infor_account img:hover{
                cursor: pointer;
                background-color: red;
            }

            .price_range input {
                margin: 10px 0;
                height: 40px;
            }

            #search_price {
                width: 100px;
                border: none;
                margin-top: 5px;
                height: 40px;
                background-color: #00bba6;
                color: white;
                transition: background-color 0.3s;
                font-size: 15px;
            }

            #search_price:hover {
                cursor: pointer;
                background: orange;
            }

            .sidebar_widget.price {
                margin-bottom: 50px;
            }

            .sidebar_widget.price h2 {
                margin-bottom: 10px;
                margin-top: 50px;
            }

            .select_option .nice-select {
                float: none;
                margin-left: 0;
            }

            .select_option label {
                margin-bottom: 5px;
                line-height: 30px;
                font-weight: 700;
                font-size: 20px;
                color: black;
            }

            .sidebar_widget.shop_c {
                margin-left: 5px;
            }


        </style>
    </head>
    <body>
        <!-- Add your site or application content here -->
        <c:set var="account" value="${sessionScope.account}"/>
        <c:set var="listProduct" value="${requestScope.listProduct}"/>
        <%DecimalFormat df = new DecimalFormat("#.0");%>
        <!--check SQL query-->
        <!--<h5 style="margin: 0 20px;">${requestScope.SQL}</h5>-->

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
                                                <c:if test="${account == null}">
                                                <li><a href="login.jsp" title="Login">Login</a></li>
                                                </c:if>

                                            <c:if test="${account != null}">
                                                <li><a href="LoginServlet?service=logout" title="Logout">Logout</a></li>
                                                </c:if>
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
                                    <c:if test="${account != null}">
                                        <div class="infor_account">
                                            <div class="avatar_account">
                                                <a href="my-account.jsp"><img src="${sessionScope.account.getAvatar()}" alt="alt"/></a>
                                            </div>
                                            <div>
                                                <p>${sessionScope.account.getUsername()}</p>
                                            </div>
                                        </div>
                                    </c:if>
                                    <div class="header_right_info">
                                        <div class="search_bar">
                                            <form action="ListProductServlet">
                                                <input style="border-radius: 30px;" type="text" placeholder="Search..." name="searchBar">
                                                <button type="submit"><i class="fa fa-search"></i></button>
                                                <input type="hidden" name="service" value="searchBar">
                                            </form>
                                        </div>
                                        <%
                                            HttpSession s = request.getSession();
                                            Customer customer = (Customer)s.getAttribute("account");
                                            
                                            ProductDAO pd = new ProductDAO();
                                            ProductCartDAO pcd = new ProductCartDAO();
                                            int amountOfProductCart = 0;
                                            int discount;
                                            double priceAfterDiscount;   
                                            double totalPriceAfterDiscount = 0;
                                            Vector<ProductCart> vector = new Vector<>();
                                            
                                            if (customer != null) {
                                                int customerID = customer.getCustomerID();    
                                                
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
                                                    <li><a href="index.jsp">Home</a>

                                                    </li>
                                                    <li class="active"><a href="ListProductServlet">Shop</a>

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
                                                    <li><a href="index.jsp">Home</a>

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
                                        <li>shop</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--breadcrumbs area end-->

                    <!--pos home section-->
                    <div class=" pos_home_section">
                        <div class="row pos_home">
                            <div class="col-lg-3 col-md-12">
                                <form action="ListProductServlet" id="search_product">
                                    <!--sort product"-->
                                    <div class="select_option" style="margin-bottom: 60px;
                                         margin-top: 25px;">
                                        <label>Sort By</label><br>
                                        <%
                                            Integer searchOrderby = (Integer) request.getAttribute("searchOrderby"); 
                                        %>
                                        <select name="orderBy" id="short">
                                            <option value="1" <%=searchOrderby!=null&&searchOrderby==1?"selected":""%>>Relevant</option>
                                            <option value="2" <%=searchOrderby!=null&&searchOrderby==2?"selected":""%>>Price: Low to High</option>
                                            <option value="3" <%=searchOrderby!=null&&searchOrderby==3?"selected":""%>>Price: High to Low</option>
                                            <option value="4" <%=searchOrderby!=null&&searchOrderby==4?"selected":""%>>Latest</option>
                                            <option value="5" <%=searchOrderby!=null&&searchOrderby==5?"selected":""%>>Bestseller</option>
                                            <option value="6" <%=searchOrderby!=null&&searchOrderby==6?"selected":""%>>In stock</option>
                                        </select>
                                    </div>

                                    <!--select men and women-->
                                    <div class="sidebar_widget shop_c" style="margin-bottom: 30px;">
                                        <div class="categorie__titile">
                                            <h4>Gender</h4>
                                        </div>
                                        <div class="layere_categorie">
                                            <%
                                                String searchGender = (String) request.getAttribute("searchGender");                                             
                                            %>
                                            <ul>                                          
                                                <li>
                                                    <input id="tops" type="checkbox" name="genderSearch" value="MALE" <%=searchGender!=null&&searchGender.equals("MALE")?"checked":""%>>
                                                    <label for="tops">Men<span></span></label>
                                                </li>
                                                <li>
                                                    <input id="bag" type="checkbox" name="genderSearch" value="FEMALE" <%=searchGender!=null&&searchGender.equals("FEMALE")?"checked":""%>>
                                                    <label for="bag">Women<span></span></label>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>

                                    <!--layere categorie"-->
                                    <div class="search_gender sidebar_widget shop_c">
                                        <div class="categorie__titile">
                                            <h4>Categories</h4>
                                        </div>
                                        <div class="layere_categorie">
                                            <%
                                                ArrayList<String> listSearchCategory = (ArrayList<String>) request.getAttribute("listSearchCategory");
                                            %>
                                            <ul>
                                                <%
                                                   Vector<Category> listCategory = (Vector<Category>)request.getAttribute("listCategory");
                                                   for(Category category : listCategory){%>
                                                <li>
                                                    <input id="acces" type="checkbox" name="categorySearch" value="<%=category.getName()%>" <%=listSearchCategory!=null&&listSearchCategory.contains(category.getName())?"checked":""%>>
                                                    <label for="acces"><%=category.getName()%></label>
                                                </li>
                                                <%}%>                                     
                                            </ul>
                                        </div>
                                    </div>
                                    <!--layere categorie end-->

                                    <!--color area start-->  
                                    <!--                                <div class="sidebar_widget color">
                                                                        <h2>Color</h2>
                                                                        <div class="widget_color">
                                                                            <ul>
                                    
                                                                                <li><a href="#">Black <span>(10)</span></a></li>
                                    
                                                                                <li><a href="#">Orange <span>(12)</span></a></li>
                                    
                                                                                <li> <a href="#">Blue <span>(14)</span></a></li>
                                    
                                                                                <li><a href="#">Yellow <span>(15)</span></a></li>
                                    
                                                                                <li><a href="#">pink <span>(16)</span></a></li>
                                    
                                                                                <li><a href="#">green <span>(11)</span></a></li>
                                    
                                                                            </ul>
                                                                        </div>
                                                                    </div>                 -->
                                    <!--color area end--> 

                                    <!--price slider start-->                                     
                                    <div class="sidebar_widget price">
                                        <h2>Price range</h2>
                                        <div class="price_range">
                                            <input type="number" name="priceFrom" placeholder="VND From" value="<%=(Double) request.getAttribute("priceFrom")!=null?(Double) request.getAttribute("priceFrom"):"0"%>">
                                            <input type="number" name="priceTo" placeholder="VND To" value="<%=(Double) request.getAttribute("priceTo")!=null?(Double) request.getAttribute("priceTo"):""%>">
                                        </div>
                                    </div>                                                       
                                    <!--price slider end-->

                                    <!--select brand-->
                                    <div class="sidebar_widget shop_c" style="margin-bottom: 30px;">
                                        <div class="categorie__titile">
                                            <h4>Brand</h4>
                                        </div>
                                        <div class="layere_categorie">
                                            <%
                                                ArrayList<String> listSearchBrand = (ArrayList<String>) request.getAttribute("listSearchBrand");
                                            %>
                                            <ul>                                          
                                                <%
                                                   Vector<Brand> listBrand = (Vector<Brand>)request.getAttribute("listBrand");
                                                   for(Brand brand : listBrand){%>
                                                <li>
                                                    <input id="tops" type="checkbox" name="brandSearch" value="<%=brand.getBrandName()%>" <%=listSearchBrand!=null&&listSearchBrand.contains(brand.getBrandName())?"checked":""%>>
                                                    <label for="tops"><%=brand.getBrandName()%></label>
                                                </li>
                                                <%}%>
                                            </ul>
                                        </div>
                                    </div>

                                    <!--wishlist block start-->
                                    <!--                                                                <div class="sidebar_widget wishlist mb-30">
                                                                                                        <div class="block_title">
                                                                                                            <h3><a href="#">Wishlist</a></h3>
                                                                                                        </div>
                                                                                                        <div class="block_content">
                                                                                                            <p>2  products</p>
                                                                                                            <a href="#">» My wishlists</a>
                                                                                                        </div>
                                                                                                    </div>-->
                                    <!--wishlist block end-->

                                    <!--popular tags area-->
                                    <!--                                <div class="sidebar_widget tags  mb-30">
                                                                        <div class="block_title">
                                                                            <h3>popular tags</h3>
                                                                        </div>
                                                                        <div class="block_tags">
                                                                            <a href="#">ipod</a>
                                                                            <a href="#">sam sung</a>
                                                                            <a href="#">apple</a>
                                                                            <a href="#">iphone 5s</a>
                                                                            <a href="#">superdrive</a>
                                                                            <a href="#">shuffle</a>
                                                                            <a href="#">nano</a>
                                                                            <a href="#">iphone 4s</a>
                                                                            <a href="#">canon</a>
                                                                        </div>
                                                                    </div>-->
                                    <!--popular tags end-->

                                    <!--newsletter block start-->
                                    <!--                                <div class="sidebar_widget newsletter mb-30">
                                                                        <div class="block_title">
                                                                            <h3>newsletter</h3>
                                                                        </div> 
                                                                        <form action="#">
                                                                            <p>Sign up for your newsletter</p>
                                                                            <input placeholder="Your email address" type="text">
                                                                            <button type="submit">Subscribe</button>
                                                                        </form>   
                                                                    </div>-->
                                    <!--newsletter block end--> 

                                    <!--special product start-->
                                    <!--                                <div class="sidebar_widget special">
                                                                        <div class="block_title">
                                                                            <h3>Special Products</h3>
                                                                        </div>
                                                                        <div class="special_product_inner mb-20">
                                                                            <div class="special_p_thumb">
                                                                                <a href="#"><img src="assets\img\cart\cart3.jpg" alt=""></a>
                                                                            </div>
                                                                            <div class="small_p_desc">
                                                                                <div class="product_ratting">
                                                                                    <ul>
                                                                                        <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                                        <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                                        <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                                        <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                                        <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                                    </ul>
                                                                                </div>
                                                                                <h3><a href="#">Lorem ipsum dolor</a></h3>
                                                                                <div class="special_product_proce">
                                                                                    <span class="old_price">$124.58</span>
                                                                                    <span class="new_price">$118.35</span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="special_product_inner">
                                                                            <div class="special_p_thumb">
                                                                                <a href="#"><img src="assets\img\cart\cart18.jpg" alt=""></a>
                                                                            </div>
                                                                            <div class="small_p_desc">
                                                                                <div class="product_ratting">
                                                                                    <ul>
                                                                                        <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                                        <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                                        <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                                        <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                                        <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                                    </ul>
                                                                                </div>
                                                                                <h3><a href="#">Printed Summer</a></h3>
                                                                                <div class="special_product_proce">
                                                                                    <span class="old_price">$124.58</span>
                                                                                    <span class="new_price">$118.35</span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>-->
                                    <!--special product end-->

                                    <div style="display: flex;
                                         justify-content: center;">
                                        <button type="submit" id="search_price">Search</button>
                                        <input type="hidden" name="service" value="searchProduct">
                                        <input id="page" type="hidden" name="page" value="">
                                    </div>
                                </form>
                            </div>
                            <div class="col-lg-9 col-md-12">
                                <!--banner slider start-->
                                <div class="banner_slider mb-35">
                                    <img src="assets\img\banner\bannner10.jpg" alt="">
                                </div> 
                                <!--banner slider start-->

                                <!--shop toolbar start-->
                                <div class="shop_toolbar list_toolbar mb-35" style="justify-content: center;">

                                    <div class="page_amount">
                                        <p>Showing ${listProduct.size()} of ${listProduct.size()} results</p>
                                    </div>

                                </div>
                                <!--shop toolbar end-->

                                <!--shop tab product-->
                                <div class="shop_tab_product">   
                                    <div class="tab-content" id="myTabContent">
                                        <div class="tab-pane fade show active" id="large" role="tabpanel">
                                            <div class="row">
                                                <c:forEach items="${requestScope.listProduct}" var="product">
                                                    <div class="col-lg-4 col-md-6">
                                                        <div class="single_product">
                                                            <div class="product_thumb">
                                                                <a href="ListSingleProductServlet?service=listInforProduct&productCode=${product.getProductCode()}"><img src="${product.getPicture()}" alt=""></a> 
                                                                <div class="img_icone">
                                                                    <img src="assets\img\cart\span-new.png" alt="">
                                                                </div>
                                                                <div class="product_action">
                                                                    <a href="ListSingleProductServlet?service=listInforProduct&productCode=${product.getProductCode()}"> <i class="fa fa-shopping-cart"></i> Add to cart</a>
                                                                </div>
                                                            </div>
                                                            <div class="product_content">
                                                                <span class="product_price" style="display: inline-flex; align-items: center; margin-left: 60px">$${(product.getPrice() * (100 - product.getDiscount())) / 100}<span style="font-size: 10px; margin-left: 10px; color: red">${product.getDiscount()}% OFF</span></span>
                                                                <h3 class="product_title"><a href="ListSingleProductServlet?service=listInforProduct&productCode=${product.getProductCode()}">${product.getProductName()}</a></h3>
                                                            </div>
                                                            <div class="product_info">
                                                                <ul>
                                                                    <li><a href="#" title=" Add to Wishlist ">Add to Wishlist</a></li>
                                                                    <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view">View Detail</a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>                
                                                </c:forEach>                            
                                            </div>  
                                        </div>
                                        <div class="tab-pane fade" id="list" role="tabpanel">
                                            <div class="product_list_item mb-35">
                                                <div class="row align-items-center">
                                                    <div class="col-lg-4 col-md-6 col-sm-6">
                                                        <div class="product_thumb">
                                                            <a href="single-product.html"><img src="assets\img\product\product2.jpg" alt=""></a> 
                                                            <div class="hot_img">
                                                                <img src="assets\img\cart\span-hot.png" alt="">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-8 col-md-6 col-sm-6">
                                                        <div class="list_product_content">
                                                            <div class="product_ratting">
                                                                <ul>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                </ul>
                                                            </div>
                                                            <div class="list_title">
                                                                <h3><a href="single-product.html">Lorem ipsum dolor</a></h3>
                                                            </div>
                                                            <p class="design"> in quibusdam accusantium qui nostrum consequuntur, officia, quidem ut placeat. Officiis, incidunt eos recusandae! Facilis aliquam vitae blanditiis quae perferendis minus eligendi</p>

                                                            <p class="compare">
                                                                <input id="select" type="checkbox">
                                                                <label for="select">Select to compare</label>
                                                            </p>
                                                            <div class="content_price">
                                                                <span>$118.00</span>
                                                                <span class="old-price">$130.00</span>
                                                            </div>
                                                            <div class="add_links">
                                                                <ul>
                                                                    <li><a href="#" title="add to cart"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a></li>
                                                                    <li><a href="#" title="add to wishlist"><i class="fa fa-heart" aria-hidden="true"></i></a></li>

                                                                    <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view"><i class="fa fa-eye" aria-hidden="true"></i></a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div> 
                                            </div>
                                            <div class="product_list_item mb-35">
                                                <div class="row align-items-center">
                                                    <div class="col-lg-4 col-md-6 col-sm-6">
                                                        <div class="product_thumb">
                                                            <a href="single-product.html"><img src="assets\img\product\product3.jpg" alt=""></a> 
                                                            <div class="img_icone">
                                                                <img src="assets\img\cart\span-new.png" alt="">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-8 col-md-6 col-sm-6">
                                                        <div class="list_product_content">
                                                            <div class="product_ratting">
                                                                <ul>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                </ul>
                                                            </div>
                                                            <div class="list_title">
                                                                <h3><a href="single-product.html">Quisque ornare dui</a></h3>
                                                            </div>
                                                            <p class="design"> in quibusdam accusantium qui nostrum consequuntur, officia, quidem ut placeat. Officiis, incidunt eos recusandae! Facilis aliquam vitae blanditiis quae perferendis minus eligendi</p>

                                                            <p class="compare">
                                                                <input id="select1" type="checkbox">
                                                                <label for="select1">Select to compare</label>
                                                            </p>
                                                            <div class="content_price">
                                                                <span>$118.00</span>
                                                                <span class="old-price">$130.00</span>
                                                            </div>
                                                            <div class="add_links">
                                                                <ul>
                                                                    <li><a href="#" title="add to cart"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a></li>
                                                                    <li><a href="#" title="add to wishlist"><i class="fa fa-heart" aria-hidden="true"></i></a></li>

                                                                    <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view"><i class="fa fa-eye" aria-hidden="true"></i></a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div> 
                                            </div>
                                            <div class="product_list_item mb-35">
                                                <div class="row align-items-center">
                                                    <div class="col-lg-4 col-md-6 col-sm-6">
                                                        <div class="product_thumb">
                                                            <a href="single-product.html"><img src="assets\img\product\product4.jpg" alt=""></a> 
                                                            <div class="img_icone">
                                                                <img src="assets\img\cart\span-new.png" alt="">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-8 col-md-6 col-sm-6">
                                                        <div class="list_product_content">
                                                            <div class="product_ratting">
                                                                <ul>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                </ul>
                                                            </div>
                                                            <div class="list_title">
                                                                <h3><a href="single-product.html">Maecenas sit amet</a></h3>
                                                            </div>
                                                            <p class="design"> in quibusdam accusantium qui nostrum consequuntur, officia, quidem ut placeat. Officiis, incidunt eos recusandae! Facilis aliquam vitae blanditiis quae perferendis minus eligendi</p>

                                                            <p class="compare">
                                                                <input id="select2" type="checkbox">
                                                                <label for="select2">Select to compare</label>
                                                            </p>
                                                            <div class="content_price">
                                                                <span>$118.00</span>
                                                                <span class="old-price">$130.00</span>
                                                            </div>
                                                            <div class="add_links">
                                                                <ul>
                                                                    <li><a href="#" title="add to cart"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a></li>
                                                                    <li><a href="#" title="add to wishlist"><i class="fa fa-heart" aria-hidden="true"></i></a></li>

                                                                    <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view"><i class="fa fa-eye" aria-hidden="true"></i></a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div> 
                                            </div> 
                                            <div class="product_list_item mb-35">
                                                <div class="row align-items-center">
                                                    <div class="col-lg-4 col-md-6 col-sm-6">
                                                        <div class="product_thumb">
                                                            <a href="single-product.html"><img src="assets\img\product\product5.jpg" alt=""></a> 
                                                            <div class="img_icone">
                                                                <img src="assets\img\cart\span-new.png" alt="">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-8 col-md-6 col-sm-6">
                                                        <div class="list_product_content">
                                                            <div class="product_ratting">
                                                                <ul>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                </ul>
                                                            </div>
                                                            <div class="list_title">
                                                                <h3><a href="single-product.html">Sed non luctus turpis</a></h3>
                                                            </div>
                                                            <p class="design"> in quibusdam accusantium qui nostrum consequuntur, officia, quidem ut placeat. Officiis, incidunt eos recusandae! Facilis aliquam vitae blanditiis quae perferendis minus eligendi</p>

                                                            <p class="compare">
                                                                <input id="select3" type="checkbox">
                                                                <label for="select3">Select to compare</label>
                                                            </p>
                                                            <div class="content_price">
                                                                <span>$118.00</span>
                                                                <span class="old-price">$130.00</span>
                                                            </div>
                                                            <div class="add_links">
                                                                <ul>
                                                                    <li><a href="#" title="add to cart"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a></li>
                                                                    <li><a href="#" title="add to wishlist"><i class="fa fa-heart" aria-hidden="true"></i></a></li>

                                                                    <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view"><i class="fa fa-eye" aria-hidden="true"></i></a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div> 
                                            </div> 
                                            <div class="product_list_item mb-35">
                                                <div class="row align-items-center">
                                                    <div class="col-lg-4 col-md-6 col-sm-6">
                                                        <div class="product_thumb">
                                                            <a href="single-product.html"><img src="assets\img\product\product6.jpg" alt=""></a> 
                                                            <div class="hot_img">
                                                                <img src="assets\img\cart\span-hot.png" alt="">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-8 col-md-6 col-sm-6">
                                                        <div class="list_product_content">
                                                            <div class="product_ratting">
                                                                <ul>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                </ul>
                                                            </div>
                                                            <div class="list_title">
                                                                <h3><a href="single-product.html">Donec dignissim eget</a></h3>
                                                            </div>
                                                            <p class="design"> in quibusdam accusantium qui nostrum consequuntur, officia, quidem ut placeat. Officiis, incidunt eos recusandae! Facilis aliquam vitae blanditiis quae perferendis minus eligendi</p>

                                                            <p class="compare">
                                                                <input id="select4" type="checkbox">
                                                                <label for="select4">Select to compare</label>
                                                            </p>
                                                            <div class="content_price">
                                                                <span>$118.00</span>
                                                                <span class="old-price">$130.00</span>
                                                            </div>
                                                            <div class="add_links">
                                                                <ul>
                                                                    <li><a href="#" title="add to cart"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a></li>
                                                                    <li><a href="#" title="add to wishlist"><i class="fa fa-heart" aria-hidden="true"></i></a></li>

                                                                    <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view"><i class="fa fa-eye" aria-hidden="true"></i></a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div> 
                                            </div> 
                                            <div class="product_list_item mb-35">
                                                <div class="row align-items-center">
                                                    <div class="col-lg-4 col-md-6 col-sm-6">
                                                        <div class="product_thumb">
                                                            <a href="single-product.html"><img src="assets\img\product\product7.jpg" alt=""></a> 
                                                            <div class="img_icone">
                                                                <img src="assets\img\cart\span-new.png" alt="">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-8 col-md-6 col-sm-6">
                                                        <div class="list_product_content">
                                                            <div class="product_ratting">
                                                                <ul>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                </ul>
                                                            </div>
                                                            <div class="list_title">
                                                                <h3><a href="single-product.html">Lorem ipsum dolor</a></h3>
                                                            </div>
                                                            <p class="design"> in quibusdam accusantium qui nostrum consequuntur, officia, quidem ut placeat. Officiis, incidunt eos recusandae! Facilis aliquam vitae blanditiis quae perferendis minus eligendi</p>

                                                            <p class="compare">
                                                                <input id="select5" type="checkbox">
                                                                <label for="select5">Select to compare</label>
                                                            </p>
                                                            <div class="content_price">
                                                                <span>$118.00</span>
                                                                <span class="old-price">$130.00</span>
                                                            </div>
                                                            <div class="add_links">
                                                                <ul>
                                                                    <li><a href="#" title="add to cart"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a></li>
                                                                    <li><a href="#" title="add to wishlist"><i class="fa fa-heart" aria-hidden="true"></i></a></li>

                                                                    <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view"><i class="fa fa-eye" aria-hidden="true"></i></a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div> 
                                            </div> 
                                            <div class="product_list_item mb-35">
                                                <div class="row align-items-center">
                                                    <div class="col-lg-4 col-md-6 col-sm-6">
                                                        <div class="product_thumb">
                                                            <a href="single-product.html"><img src="assets\img\product\product8.jpg" alt=""></a> 
                                                            <div class="img_icone">
                                                                <img src="assets\img\cart\span-new.png" alt="">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-8 col-md-6 col-sm-6">
                                                        <div class="list_product_content">
                                                            <div class="product_ratting">
                                                                <ul>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                </ul>
                                                            </div>
                                                            <div class="list_title">
                                                                <h3><a href="single-product.html">Donec ac congue</a></h3>
                                                            </div>
                                                            <p class="design"> in quibusdam accusantium qui nostrum consequuntur, officia, quidem ut placeat. Officiis, incidunt eos recusandae! Facilis aliquam vitae blanditiis quae perferendis minus eligendi</p>

                                                            <p class="compare">
                                                                <input id="select6" type="checkbox">
                                                                <label for="select6">Select to compare</label>
                                                            </p>
                                                            <div class="content_price">
                                                                <span>$118.00</span>
                                                                <span class="old-price">$130.00</span>
                                                            </div>
                                                            <div class="add_links">
                                                                <ul>
                                                                    <li><a href="#" title="add to cart"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a></li>
                                                                    <li><a href="#" title="add to wishlist"><i class="fa fa-heart" aria-hidden="true"></i></a></li>

                                                                    <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view"><i class="fa fa-eye" aria-hidden="true"></i></a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div> 
                                            </div> 
                                            <div class="product_list_item mb-35">
                                                <div class="row align-items-center">
                                                    <div class="col-lg-4 col-md-6 col-sm-6">
                                                        <div class="product_thumb">
                                                            <a href="single-product.html"><img src="assets\img\product\product9.jpg" alt=""></a> 
                                                            <div class="hot_img">
                                                                <img src="assets\img\cart\span-hot.png" alt="">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-8 col-md-6 col-sm-6">
                                                        <div class="list_product_content">
                                                            <div class="product_ratting">
                                                                <ul>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                </ul>
                                                            </div>
                                                            <div class="list_title">
                                                                <h3><a href="single-product.html">Curabitur sodales</a></h3>
                                                            </div>
                                                            <p class="design"> in quibusdam accusantium qui nostrum consequuntur, officia, quidem ut placeat. Officiis, incidunt eos recusandae! Facilis aliquam vitae blanditiis quae perferendis minus eligendi</p>

                                                            <p class="compare">
                                                                <input id="select7" type="checkbox">
                                                                <label for="select7">Select to compare</label>
                                                            </p>
                                                            <div class="content_price">
                                                                <span>$118.00</span>
                                                                <span class="old-price">$130.00</span>
                                                            </div>
                                                            <div class="add_links">
                                                                <ul>
                                                                    <li><a href="#" title="add to cart"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a></li>
                                                                    <li><a href="#" title="add to wishlist"><i class="fa fa-heart" aria-hidden="true"></i></a></li>

                                                                    <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view"><i class="fa fa-eye" aria-hidden="true"></i></a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div> 
                                            </div> 
                                            <div class="product_list_item mb-35">
                                                <div class="row align-items-center">
                                                    <div class="col-lg-4 col-md-6 col-sm-6">
                                                        <div class="product_thumb">
                                                            <a href="single-product.html"><img src="assets\img\product\product1.jpg" alt=""></a> 
                                                            <div class="img_icone">
                                                                <img src="assets\img\cart\span-new.png" alt="">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-8 col-md-6 col-sm-6">
                                                        <div class="list_product_content">
                                                            <div class="product_ratting">
                                                                <ul>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                    <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                                </ul>
                                                            </div>
                                                            <div class="list_title">
                                                                <h3><a href="single-product.html">Lorem ipsum dolor</a></h3>
                                                            </div>
                                                            <p class="design"> in quibusdam accusantium qui nostrum consequuntur, officia, quidem ut placeat. Officiis, incidunt eos recusandae! Facilis aliquam vitae blanditiis quae perferendis minus eligendi</p>

                                                            <p class="compare">
                                                                <input id="select8" type="checkbox">
                                                                <label for="select8">Select to compare</label>
                                                            </p>
                                                            <div class="content_price">
                                                                <span>$118.00</span>
                                                                <span class="old-price">$130.00</span>
                                                            </div>
                                                            <div class="add_links">
                                                                <ul>
                                                                    <li><a href="#" title="add to cart"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a></li>
                                                                    <li><a href="#" title="add to wishlist"><i class="fa fa-heart" aria-hidden="true"></i></a></li>

                                                                    <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view"><i class="fa fa-eye" aria-hidden="true"></i></a></li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div> 
                                            </div>                        
                                        </div>

                                    </div>
                                </div>    
                                <!--shop tab product end-->

                                <!--pagination style start--> 
                                <div class="pagination_style" style="display: flex; justify-content: center;">                               
                                    <div class="page_number">   
                                        <ul>
                                            <li>«</li>
                                                <%
                                                int pageIn = (Integer)request.getAttribute("page");   
                                                int numberOfPage = (Integer)request.getAttribute("numberOfPage");
                                                for(int i = 1; i <= numberOfPage; i++){
                                                    if(pageIn == i){
                                                %>
                                            <!-- đưa dữ liệu vectorProduct lên session -->
                                            <li><a style="color: red" href="ListProductServlet?page=<%=i%>"><%=i%></a></li>
                                                <%} else {%>
                                            <li><a href="ListProductServlet?page=<%=i%>"><%=i%></a></li>
                                            <%}}%>
                                            <li>»</li>
                                        </ul>    
                                    </div>
                                </div>
                                <!--pagination style end--> 
                            </div>
                        </div>  
                    </div>
                    <!--pos home section end-->
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
                                <p>Korona - ứng dụng mua sắm trực tuyến thú vị, tin cậy, an toàn và miễn phí! 
                                    Bạn sẽ mua hàng trực tuyến an tâm và nhanh chóng hơn bao giờ hết!</p>
                                <div class="footer_widget_contect">
                                    <p><i class="fa fa-map-marker" aria-hidden="true"></i> Thạch Hoà, Thạch Thất, Hà Nội</p>

                                    <p><i class="fa fa-mobile" aria-hidden="true"></i> (+84) 389596357</p>
                                    <a href="#"><i class="fa fa-envelope-o" aria-hidden="true"></i> anhnhatlop8ab@gmail.com </a>
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

        <!-- modal area start --> 
        <div class="modal fade" id="modal_box" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <div class="modal_body">
                        <div class="container">
                            <div class="row">
                                <div class="col-lg-5 col-md-5 col-sm-12">
                                    <div class="modal_tab">  
                                        <div class="tab-content" id="pills-tabContent">
                                            <div class="tab-pane fade show active" id="tab1" role="tabpanel">
                                                <div class="modal_tab_img">
                                                    <a href="#"><img src="assets\img\product\product13.jpg" alt=""></a>    
                                                </div>
                                            </div>
                                            <div class="tab-pane fade" id="tab2" role="tabpanel">
                                                <div class="modal_tab_img">
                                                    <a href="#"><img src="assets\img\product\product14.jpg" alt=""></a>    
                                                </div>
                                            </div>
                                            <div class="tab-pane fade" id="tab3" role="tabpanel">
                                                <div class="modal_tab_img">
                                                    <a href="#"><img src="assets\img\product\product15.jpg" alt=""></a>    
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal_tab_button">    
                                            <ul class="nav product_navactive" role="tablist">
                                                <li>
                                                    <a class="nav-link active" data-toggle="tab" href="#tab1" role="tab" aria-controls="tab1" aria-selected="false"><img src="assets\img\cart\cart17.jpg" alt=""></a>
                                                </li>
                                                <li>
                                                    <a class="nav-link" data-toggle="tab" href="#tab2" role="tab" aria-controls="tab2" aria-selected="false"><img src="assets\img\cart\cart18.jpg" alt=""></a>
                                                </li>
                                                <li>
                                                    <a class="nav-link button_three" data-toggle="tab" href="#tab3" role="tab" aria-controls="tab3" aria-selected="false"><img src="assets\img\cart\cart19.jpg" alt=""></a>
                                                </li>
                                            </ul>
                                        </div>    
                                    </div>  
                                </div> 
                                <div class="col-lg-7 col-md-7 col-sm-12">
                                    <div class="modal_right">
                                        <div class="modal_title mb-10">
                                            <h2>Handbag feugiat</h2> 
                                        </div>
                                        <div class="modal_price mb-10">
                                            <span class="new_price">$64.99</span>    
                                            <span class="old_price">$78.99</span>    
                                        </div>
                                        <div class="modal_content mb-10">
                                            <p>Short-sleeved blouse with feminine draped sleeve detail.</p>    
                                        </div>
                                        <div class="modal_size mb-15">
                                            <h2>size</h2>
                                            <ul>
                                                <li><a href="#">s</a></li>
                                                <li><a href="#">m</a></li>
                                                <li><a href="#">l</a></li>
                                                <li><a href="#">xl</a></li>
                                                <li><a href="#">xxl</a></li>
                                            </ul>
                                        </div>
                                        <div class="modal_add_to_cart mb-15">
                                            <form action="#">
                                                <input min="0" max="100" step="2" value="1" type="number">
                                                <button type="submit">add to cart</button>
                                            </form>
                                        </div>   
                                        <div class="modal_description mb-15">
                                            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,</p>    
                                        </div> 
                                        <div class="modal_social">
                                            <h2>Share this product</h2>
                                            <ul>
                                                <li><a href="#"><i class="fa fa-facebook"></i></a></li>
                                                <li><a href="#"><i class="fa fa-twitter"></i></a></li>
                                                <li><a href="#"><i class="fa fa-pinterest"></i></a></li>
                                                <li><a href="#"><i class="fa fa-google-plus"></i></a></li>
                                                <li><a href="#"><i class="fa fa-linkedin"></i></a></li>
                                            </ul>    
                                        </div>      
                                    </div>    
                                </div>    
                            </div>     
                        </div>
                    </div>    
                </div>
            </div>
        </div> 

        <!-- modal area end --> 



        <!-- all js here -->
        <script src="assets\js\vendor\jquery-1.12.0.min.js"></script>
        <script src="assets\js\popper.js"></script>
        <script src="assets\js\bootstrap.min.js"></script>
        <script src="assets\js\ajax-mail.js"></script>
        <script src="assets\js\plugins.js"></script>
        <script src="assets\js\main.js"></script>
    </body>
</html>

