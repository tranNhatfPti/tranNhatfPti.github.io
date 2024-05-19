<%-- 
    Document   : cart.jsp
    Created on : Jan 26, 2024, 4:18:56 PM
    Author     : ASUS ZenBook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Vector, jakarta.servlet.http.HttpSession, model.Customer, model.ProductCart, dal.ProductCartDAO, model.Product, dal.ProductDAO, java.text.DecimalFormat"%>
﻿<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Coron-cart</title>
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
        </style>
    </head>
    <body>
        <!-- Add your site or application content here -->
        <%DecimalFormat df = new DecimalFormat("#.0");%>
        <c:set var="account" value="${sessionScope.account}"/>
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
                                            <form action="#">
                                                <input style="border-radius: 30px" placeholder="Search..." type="text">
                                                <button type="submit"><i class="fa fa-search"></i></button>
                                            </form>
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
                                        <li>Shopping Cart</li>
                                    </ul>

                                </div>
                            </div>
                        </div>
                    </div>
                    <!--breadcrumbs area end-->



                    <!--shopping cart area start -->
                    <div class="shopping_cart_area">
                        <form action="ShoppingCartServlet"> 
                            <div class="row">
                                <div class="col-12">
                                    <div class="table_desc">
                                        <div class="cart_page table-responsive">
                                            <table>
                                                <thead>
                                                    <tr>
                                                        <th class="product_remove" style="min-width: 98px;">Delete</th>
                                                        <th class="product_thumb" style="min-width: 250px">Image</th>
                                                        <th class="product_name" style="min-width: 300px">Product Name</th>
                                                        <th style="min-width: 150px">Variations</th>
                                                        <th class="product-price" style="min-width: 220px">Price</th>
                                                        <th class="product_quantity" style="min-width: 130px">Quantity</th>
                                                        <th class="product_total" style="min-width: 170px">Total</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%   
                                                        HttpSession s = request.getSession();
                                                        Customer customer = (Customer)s.getAttribute("account");
                                                        ProductCartDAO pcd = new ProductCartDAO();
                                                        ProductDAO pd = new ProductDAO();
                                                                                                              
                                                        double totalPriceOfProductCart = 0;
                                                        int customerID = 0;
                                                        int discount;
                                                        double totalPriceAfterDiscount = 0;
                                                        double priceAfterDiscount;
                                                        Vector<ProductCart> vector = new Vector<>();
                                                        
                                                        if (customer != null) {
                                                            customerID = customer.getCustomerID();                                                                                  
                                                            vector = pcd.getAllProductCartFromSQL("select * from ProductCart where CustomerID = " + customerID);
                                               
                                                            for(ProductCart pc : vector) {
                                                                totalPriceOfProductCart += (pc.getPrice() * pc.getQuantity());
                                                                discount = pd.getAllProductFromSQL("select * from Product where ProductCode = " + pc.getProductCode()).firstElement().getDiscount();
                                                                priceAfterDiscount = ((pc.getPrice() * (100 - discount)) / 100) * pc.getQuantity();
                                                                totalPriceAfterDiscount += priceAfterDiscount;                      
                                                    %>
                                                    <tr>
                                                        <td class="product_remove"><a href="ShoppingCartServlet?service=remove&customerID=<%=pc.getCustomerID()%>&productCode=<%=pc.getProductCode()%>&size=<%=pc.getSize()%>&color=<%=pc.getColor()%>&namePage=cart.jsp"><i class="fa fa-trash-o"></i></a></td>
                                                        <td class="product_thumb"><a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=pc.getProductCode()%>"><img style="height: 100px" src="<%=pc.getImage()%>" alt=""></a></td>
                                                        <td class="product_name"><a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=pc.getProductCode()%>"><%=pc.getProductName()%></a></td>
                                                        <td><%=pc.getSize()%>, <%=pc.getColor()%></td>
                                                        <td class="product-price" style=" color: #495057;">$<%=df.format((pc.getPrice() * (100 - discount)) / 100)%> <span style="text-decoration: line-through; font-size: 12px; margin-left: 3px">$<%=pc.getPrice()%></span></td>
                                                        <td class="product_quantity"><input min="0" max="1000" value="<%=pc.getQuantity()%>" type="number" name="quantityUpdate"></td>
                                                        <td class="product_total" style="color: orange">$<%=df.format(priceAfterDiscount)%></td>
                                                    </tr>  
                                                    <%}}%>
                                                </tbody>
                                            </table>   
                                        </div>  
                                        <div class="cart_submit" style="display: flex; justify-content: space-between">                  
                                            <div>
                                                <button type="submit">update cart</button>
                                                <input type="hidden" name="service" value="updateCart">
                                            </div>       
                                            <%
                                                String listOutOfInStock = (String)request.getAttribute("listOutOfInStock");
                                                String msOutOfProductInStock = (String)request.getAttribute("msOutOfProductInStock");
                                                if(msOutOfProductInStock != null && listOutOfInStock!= null) {
                                            %>
                                            <div>
                                                <h6 style="color: gray;  margin: 0; text-align: left;"><%=listOutOfInStock%></h6><br>
                                                <h6 style="color: red; font-style: italic; margin: 0"><%=msOutOfProductInStock%></h6>
                                            </div>
                                            <%}%>
                                        </div>      
                                    </div>
                                </div>
                            </div>
                            <!--coupon code area start-->
                            <div class="coupon_area">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6">
                                        <div class="coupon_code">
                                            <h3>Voucher</h3>
                                            <div class="coupon_inner">   
                                                <p>Enter your voucher code if you have one.</p>                                
                                                <input placeholder="Voucher code" type="text">
                                                <button type="submit">Apply Voucher</button>
                                            </div>    
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6">
                                        <div class="coupon_code">
                                            <h3>Cart Totals</h3>
                                            <div class="coupon_inner">
                                                <div class="cart_subtotal">
                                                    <p>Subtotal</p>
                                                    <p class="cart_amount">$<%=totalPriceOfProductCart%></p>
                                                </div>
                                                <div class="cart_subtotal">
                                                    <p>Voucher</p>
                                                    <p class="cart_amount">$0</p>
                                                </div>
                                                <div class="cart_subtotal">
                                                    <p>Product Discount</p>
                                                    <%
                                                        double productDiscount = totalPriceOfProductCart - totalPriceAfterDiscount;
                                                    %>
                                                    <p class="cart_amount">$<%=df.format(productDiscount)%></p>
                                                </div>
                                                <div class="cart_subtotal ">
                                                    <p>Shipping</p>
                                                    <p class="cart_amount">5$</p>
                                                </div>
                                                <div class="cart_subtotal">
                                                    <p>Total Amount</p>
                                                    <%
                                                        if(totalPriceAfterDiscount != 0){
                                                            totalPriceAfterDiscount += 5;
                                                        }
                                                    %>
                                                    <p class="cart_amount">$<%=df.format(totalPriceAfterDiscount)%></p>
                                                </div>
                                                <div class="checkout_btn">
                                                    <a href="checkout.jsp">Proceed to Checkout</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!--coupon code area end-->
                        </form> 
                    </div>
                    <!--shopping cart area end -->

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
    </body>
</html>

