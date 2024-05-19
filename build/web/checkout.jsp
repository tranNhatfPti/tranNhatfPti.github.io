<%-- 
    Document   : checkout
    Created on : Feb 25, 2024, 4:37:23 PM
    Author     : ASUS ZenBook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Vector, jakarta.servlet.http.HttpSession, model.Customer, model.ProductCart, dal.ProductCartDAO, model.ProductDetail, dal.ProductDetailDAO, model.Product, dal.ProductDAO, java.text.DecimalFormat"%>
<!DOCTYPE html>
﻿<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Coron-checkout</title>
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
        <%
            HttpSession s = request.getSession();
            DecimalFormat df = new DecimalFormat("#.0");  
            ProductDAO pd = new ProductDAO();
            ProductCartDAO pcd = new ProductCartDAO();
            Customer customer = (Customer)s.getAttribute("account");
        %>
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
                                                <%
                                                    if(customer == null){
                                                %>
                                            <li><a href="login.jsp" title="Login">Login</a></li>
                                                <%}%>
                                                <%
                                                    if(customer != null){
                                                %>
                                            <li><a href="LoginServlet?service=logout" title="Logout">Logout</a></li>
                                                <%}%>
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
                                        <%                                           
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
                                        <li><a href="index.html">home</a></li>
                                        <li><i class="fa fa-angle-right"></i></li>
                                        <li>checkout</li>
                                    </ul>

                                </div>
                            </div>
                        </div>
                    </div>
                    <!--breadcrumbs area end-->


                    <!--Checkout page section-->
                    <div class="Checkout_section">
                        <div class="checkout_form">
                            <div class="row">
                                <div class="col-lg-6 col-md-6">
                                    <form action="#">
                                        <h3>Billing Details</h3>
                                        <div class="row">
                                            <div class="col-lg-6 mb-30">
                                                <label style="font-weight: bold">First Name <span>*</span></label>
                                                <input type="text" value="<%=customer.getFirstName()!=null?customer.getFirstName():""%>" readonly="">    
                                            </div>
                                            <div class="col-lg-6 mb-30">
                                                <label style="font-weight: bold">Last Name  <span>*</span></label>
                                                <input type="text" value="<%=customer.getLastName()!=null?customer.getLastName():""%>" readonly=""> 
                                            </div>                                           
                                            <div class="col-12 mb-30">
                                                <label style="font-weight: bold">Addresses<label style="color: red">(The following addresses will be used on the checkout page by default)</label></label>
                                                <input type="text" value="<%=customer.getAddress()!=null?customer.getAddress():""%>" readonly="">     
                                            </div>
                                            <div class="col-12 mb-30">
                                                <input placeholder="Apartment, suite, unit etc. (optional)" type="text">     
                                            </div>
                                            <div class="col-12 mb-30">
                                                <a href="my-account.jsp"><label class="righ_0" style="font-size: 12px">Ship to a different address?</label></a>                                              
                                            </div>
                                            <div class="col-12 mb-30">
                                                <label style="font-weight: bold">Email <span>*</span></label>
                                                <input type="text" value="<%=customer.getEmail()!=null?customer.getEmail():""%>" readonly="">    
                                            </div> 
                                            <div class="col-12 mb-30">
                                                <label style="font-weight: bold">Money balance <span>*</span></label>
                                                <input type="text" value="<%=customer.getMoneyBalance()%>" readonly="">    
                                            </div> 
                                            <div class="col-12 mb-30">
                                                <a href="#"><label class="righ_0" style="font-size: 12px">TO DEPOSIT MORE MONEY</label></a>                                              
                                            </div>
                                            <div class="col-lg-12 mb-30">
                                                <label style="font-weight: bold">Phone<span>*</span></label>
                                                <input type="text" value="<%=customer.getPhone()!=null?customer.getPhone():""%>" readonly=""> 
                                            </div>                                               
                                            <div class="col-12">
                                                <div class="order-notes">
                                                    <label for="order_note" style="font-weight: bold">Order Notes</label>
                                                    <textarea id="order_note" placeholder="Notes about your order, e.g. special notes for delivery."></textarea>
                                                </div>    
                                            </div>     	    	    	    	    	    	    
                                        </div>
                                    </form>    
                                </div>
                                <div class="col-lg-6 col-md-6">
                                    <%
                                        if(request.getAttribute("msInsertOrders") != null){                                           
                                    %>
                                    <div style="display: flex; justify-content: center;">
                                        <%
                                            String msInsertOrders = (String) request.getAttribute("msInsertOrders");
                                            if(msInsertOrders != null) {
                                        %>
                                        <h4 style="color: green"><%=msInsertOrders%></h4>
                                        <%
                                            }
                                        %>
                                    </div>
                                    <div class="payment_method" style="display: flex; justify-content: center">                                                 
                                        <div class="order_button">
                                            <button><a href="index.jsp" style="color: white">Home</a></button> 
                                        </div>    
                                    </div> 
                                    <%} else {%>
                                    <form action="OrderServlet">    
                                        <h3>Your order</h3> 
                                        <div class="order_table table-responsive mb-30">
                                            <table>
                                                <thead>
                                                    <tr>
                                                        <th>Product</th>
                                                        <th>Price</th>
                                                        <th>Total</th>
                                                    </tr>
                                                </thead>
                                                <%
                                                    if((ProductDetail)request.getAttribute("productBuyNow") != null){                                              
                                                        ProductDetail pDetail = (ProductDetail)request.getAttribute("productBuyNow");
                                                        Product p = pd.getAllProductFromSQL("select * from Product where ProductCode = " + pDetail.getProductCode()).firstElement();                                                 
                                                %>
                                                <tbody>
                                                    <tr>
                                                        <td> <%=p.getProductName()%> <strong> × <%=pDetail.getQuantity()%></strong> (<%=pDetail.getSize() + ", " + pDetail.getColor()%>)</td>
                                                        <td>$<%=(p.getPrice() * (100 - p.getDiscount())) / 100%>    <label style="text-decoration: line-through; font-size: 10px; color: red">$<%=p.getPrice()%></label></td>
                                                        <td>$<%=((p.getPrice() * (100 - p.getDiscount())) / 100) * pDetail.getQuantity()%></td>
                                                    </tr>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <th>Cart Subtotal</th>
                                                        <td>$<%=((p.getPrice() * (100 - p.getDiscount())) / 100) * pDetail.getQuantity()%></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Shipping</th>
                                                        <td><strong>$5.00</strong></td>
                                                    </tr>
                                                    <tr class="order_total">
                                                        <th>Order Total</th>
                                                        <td><strong>$<%=(((p.getPrice() * (100 - p.getDiscount())) / 100) * pDetail.getQuantity()) + 5%></strong></td>
                                                    </tr>
                                                </tfoot>
                                                <input type="hidden" name="orderFrom" value="singleProduct">
                                                <input type="hidden" name="productCodeOrder" value="<%=pDetail.getProductCode()%>">
                                                <input type="hidden" name="sizeOrder" value="<%=pDetail.getSize()%>">
                                                <input type="hidden" name="colorOrder" value="<%=pDetail.getColor()%>">
                                                <input type="hidden" name="quantityOrder" value="<%=pDetail.getQuantity()%>">
                                                <%
                                                    } else {
                                                    double cartSubtotal = 0;
                                                    Vector<ProductCart> listPC = pcd.getAllProductCartFromSQL("select * from ProductCart where CustomerID = " + customer.getCustomerID());
                                                    for(ProductCart pc : listPC){
                                                        Product p = pd.getAllProductFromSQL("select * from Product where ProductCode = " + pc.getProductCode()).firstElement();    
                                                        cartSubtotal += ((p.getPrice() * (100 - p.getDiscount())) / 100) * pc.getQuantity();
                                                %>
                                                <tbody>
                                                    <tr>
                                                        <td> <%=p.getProductName()%> <strong> × <%=pc.getQuantity()%></strong> (<%=pc.getSize() + ", " + pc.getColor()%>)</td>
                                                        <td>$<%=(p.getPrice() * (100 - p.getDiscount())) / 100%>    <label style="text-decoration: line-through; font-size: 10px; color: red">$<%=p.getPrice()%></label></td>
                                                        <td>$<%=((p.getPrice() * (100 - p.getDiscount())) / 100) * pc.getQuantity()%></td>
                                                    </tr>
                                                </tbody>
                                                <%}%>
                                                <tfoot>
                                                    <tr>
                                                        <th>Cart Subtotal</th>
                                                        <td>$<%=cartSubtotal%></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Shipping</th>
                                                        <td><strong>$5.00</strong></td>
                                                    </tr>
                                                    <tr class="order_total">
                                                        <th>Order Total</th>
                                                        <%cartSubtotal += 5;%>
                                                        <td><strong>$<%=df.format(cartSubtotal)%></strong></td>
                                                    </tr>
                                                </tfoot>
                                                <input type="hidden" name="orderFrom" value="cart">
                                                <%}%>
                                            </table>     
                                        </div>                                       
                                        <div class="payment_method" style="display: flex; justify-content: center">                                                 
                                            <div class="order_button">
                                                <%
                                                    if(customer.getAddress() == null){%>
                                                    <h3 style="background: #00bba6; font-size: 13px">Please fill in your delivery address information before ordering -> <a href="my-account.jsp"><button type="button">Update Address</button></a></h3>                                             
                                                    <%}else {%>
                                                <button type="submit">Place order</button> 
                                                <%}%>
                                                <input type="hidden" name="service" value="orderProduct">
                                            </div>    
                                        </div> 
                                    </form>         
                                    <%}%>
                                </div>
                            </div> 
                        </div>        
                    </div>
                    <!--Checkout page section end-->

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
