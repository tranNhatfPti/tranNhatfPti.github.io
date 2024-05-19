<%-- 
    Document   : single-product
    Created on : Feb 19, 2024, 9:51:36 PM
    Author     : ASUS ZenBook
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Vector, jakarta.servlet.http.HttpSession, model.Customer, dal.CustomerDAO, model.ProductCart, dal.ProductCartDAO, model.Product, dal.ProductDAO, model.Brand, dal.BrandDAO, java.text.DecimalFormat, model.FeedBack, dal.FeedbackDAO, model.Orders, dal.OrdersDAO, model.OrderDetails, dal.OrderDetailsDAO"%>
<!DOCTYPE html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Coron-single product</title>
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

            .blue-square {
                width: 20px; /* Độ rộng của hình vuông */
                height: 20px; /* Chiều cao của hình vuông */
                background-color: red; /* Màu nền là màu đỏ */
                display: inline-block; /* Hiển thị là một khối nội dung được căn chỉnh theo chiều ngang */
                margin-right: 5px; /* Khoảng cách phía bên phải để tạo khoảng cách giữa hình vuông và văn bản */
            }

            .star-rating {
                direction: ltr; /* Đảo ngược hướng để sao được chọn từ trái sang phải */
                font-size: 30px;
            }
            .star-rating .star {
                cursor: pointer;
                color: #ccc; /* Màu của sao khi chưa được chọn */
            }
            .star-rating .star.selected {
                color: #ffca08; /* Màu của sao khi được chọn */
            }

        </style>      

    </head>
    <body>
        <!-- Add your site or application content here -->
        <%
            DecimalFormat df = new DecimalFormat("#.0");
            CustomerDAO cd = new CustomerDAO();
            Product inforP = (Product)request.getAttribute("inforProduct");
        %>
        <!--pos page start-->
        <c:set var="account" value="${sessionScope.account}"/>
        <c:set var="product" value="${requestScope.inforProduct}"/>
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
                                                <input style="border-radius: 30px;" placeholder="Search..." type="text">
                                                <button type="submit"><i class="fa fa-search"></i></button>
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
                                        <li>single product</li>
                                    </ul>

                                </div>
                            </div>
                        </div>
                    </div>
                    <!--breadcrumbs area end-->


                    <!--product wrapper start-->                    
                    <div class="product_details">
                        <div class="row">
                            <div class="col-lg-5 col-md-6">
                                <div class="product_tab fix"> 
                                    <div class="product_tab_button">    
                                        <ul class="nav" role="tablist">
                                            <li>
                                                <a class="active" data-toggle="tab" href="#p_tab1" role="tab" aria-controls="p_tab1" aria-selected="false"><img src="${product.getPicture()}" alt=""></a>
                                            </li>
                                            <%
                                                Product product = (Product) request.getAttribute("inforProduct");
                                                String imageProduct1 = product.getPicture();
                                                String imageProduct2 = imageProduct1.substring(0, imageProduct1.length() - 4) + " (1).jpg";
                                            %>                       
                                            <li>
                                                <a data-toggle="tab" href="#p_tab2" role="tab" aria-controls="p_tab2" aria-selected="false"><img src="<%=imageProduct2%>" alt=""></a>
                                            </li>
                                            <%
                                                String imageProduct3 = imageProduct1.substring(0, imageProduct1.length() - 4) + " (2).jpg";
                                            %>
                                            <li>
                                                <a data-toggle="tab" href="#p_tab3" role="tab" aria-controls="p_tab3" aria-selected="false"><img src="<%=imageProduct3%>" alt=""></a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="tab-content produc_tab_c">
                                        <div class="tab-pane fade show active" id="p_tab1" role="tabpanel">
                                            <div class="modal_img">
                                                <a href="#"><img src="${product.getPicture()}" alt=""></a>
                                                <div class="img_icone">
                                                    <img src="assets\img\cart\span-new.png" alt="">
                                                </div>
                                                <div class="view_img">
                                                    <a class="large_view" href="${product.getPicture()}"><i class="fa fa-search-plus"></i></a>
                                                </div>    
                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="p_tab2" role="tabpanel">
                                            <div class="modal_img">
                                                <a href="#"><img src="<%=imageProduct2%>" alt=""></a>
                                                <div class="img_icone">
                                                    <img src="assets\img\cart\span-new.png" alt="">
                                                </div>
                                                <div class="view_img">
                                                    <a class="large_view" href="<%=imageProduct2%>"><i class="fa fa-search-plus"></i></a>
                                                </div>     
                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="p_tab3" role="tabpanel">
                                            <div class="modal_img">
                                                <a href="#"><img src="<%=imageProduct3%>" alt=""></a>
                                                <div class="img_icone">
                                                    <img src="assets\img\cart\span-new.png" alt="">
                                                </div>
                                                <div class="view_img">
                                                    <a class="large_view" href="<%=imageProduct3%>"> <i class="fa fa-search-plus"></i></a>
                                                </div>     
                                            </div>
                                        </div>
                                    </div>

                                </div> 
                            </div>
                            <div class="col-lg-7 col-md-6">
                                <div class="product_d_right">
                                    <form action="ShoppingCartServlet">
                                        <h1>${product.getProductName()}</h1>
                                        <div class="product_ratting mb-10">
                                            <ul>
                                                <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                <li><a href="#"><i class="fa fa-star"></i></a></li>
                                                <li style="margin: 0 10px; font-size: 15px">|</li>
                                                <li style="font-size: 15px"> ? EVALUATED </a></li>
                                                <li style="margin: 0 10px; font-size: 15px">|</li>
                                                <li style="font-size: 15px"> <span style="margin-right: 5px; font-weight: bold; color: brown">${product.getQuantitySold()}</span> SOLD </a></li>
                                            </ul>
                                        </div>
                                        <div class="content_price mb-15">
                                            <span>Price: </span>
                                            <span style="color: red">$${(product.getPrice() * (100 - product.getDiscount())) / 100}</span>
                                            <span class="old-price">$${product.getPrice()}</span>
                                        </div>
                                        <div class="box_quantity mb-20">
                                            <label style="margin-top: 5px">Quantity</label>
                                            <input min="1" max="10000" value="1" type="number" name="quantity"> 
                                            <button type="submit"><i class="fa fa-shopping-cart"></i> add to cart</button>
                                            <button type="submit" name="buyNow" value="buyNow">buy now</button>
                                            <input type="hidden" name="service" value="addToCart">
                                            <input type="hidden" name="productCode" value="${product.getProductCode()}">
                                            <a href="#" title="add to wishlist"><i class="fa fa-heart" aria-hidden="true"></i></a>    
                                        </div>

                                        <%
                                            String sizeSelected = (String)request.getAttribute("sizeSelected");
                                            String colorSelected = (String)request.getAttribute("colorSelected");
                                        %>
                                        <div class="product_d_size mb-20">
                                            <label for="size">size</label>
                                            <select id="size" name="size" onchange="sendDataProduct()">
                                                <%
                                                    Vector<String> allSizeProduct = (Vector<String>)request.getAttribute("allSizeProduct");
                                                    for(String size: allSizeProduct) {
                                                        if(size.equals(sizeSelected)){                                                 
                                                %>
                                                <option value="<%=size%>" selected=""><%=size%></option>                                           
                                                <%
                                                    }else{
                                                %>
                                                <option value="<%=size%>"><%=size%></option>
                                                <%
                                                    }
                                                }
                                                %>
                                            </select>
                                        </div>
                                        <div class="sidebar_widget product_d_size">
                                            <label for="color">Color</label>
                                            <select id="color" name="color" onchange="sendDataProduct()">
                                                <%
                                                    Vector<String> allColorProduct = (Vector<String>)request.getAttribute("allColorProduct");
                                                    for(String color: allColorProduct) {
                                                        if(color.equals(colorSelected)){                                                 
                                                %>
                                                <option value="<%=color%>" selected=""><%=color%></option>
                                                <%
                                                    }else{
                                                %>
                                                <option value="<%=color%>"><%=color%></option>
                                                <%
                                                    }
                                                }
                                                %>
                                            </select>
                                        </div>  
                                        <div class="product_stock mb-20">
                                            <p>${requestScope.quantityProduct} items</p>
                                            <span>In stock</span>
                                        </div>     
                                        <div class="ms_add_to_cart" style="margin-bottom: 10px">
                                            <%
                                                String msInsertProductCart = (String)request.getAttribute("msInsertProductCart");
                                                if(msInsertProductCart != null) {
                                            %>
                                            <h5 style="color: green"><%=msInsertProductCart%></h5>
                                            <%}%>
                                        </div>
                                        <div class="ms_add_to_cart" style="margin-bottom: 10px">
                                            <%
                                                String msOutOfProductInStock = (String)request.getAttribute("msOutOfProductInStock");
                                                if(msOutOfProductInStock != null) {
                                            %>
                                            <h6 style="color: red; font-style: italic"><%=msOutOfProductInStock%></h6>
                                            <%}%>
                                        </div>
                                        <div class="wishlist-share">
                                            <h4>Share on:</h4>
                                            <ul>
                                                <li><a href="#"><i class="fa fa-rss"></i></a></li>           
                                                <li><a href="#"><i class="fa fa-vimeo"></i></a></li>           
                                                <li><a href="#"><i class="fa fa-tumblr"></i></a></li>           
                                                <li><a href="#"><i class="fa fa-pinterest"></i></a></li>        
                                                <li><a href="#"><i class="fa fa-linkedin"></i></a></li>        
                                            </ul>      
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--product details end-->


                    <!--product info start-->
                    <div class="product_d_info">
                        <div class="row">
                            <div class="col-12">
                                <div class="product_d_inner">   
                                    <div class="product_info_button">    
                                        <ul class="nav" role="tablist">
                                            <li>
                                                <a class="active" data-toggle="tab" href="#info" role="tab" aria-controls="info" aria-selected="false">More info</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#sheet" role="tab" aria-controls="sheet" aria-selected="false">Data sheet</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#reviews" role="tab" aria-controls="reviews" aria-selected="false">Reviews</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="tab-content">
                                        <div class="tab-pane fade show active" id="info" role="tabpanel">
                                            <div class="product_info_content">
                                                <p>${product.getDescription()}</p>
                                            </div>    
                                        </div>

                                        <div class="tab-pane fade" id="sheet" role="tabpanel">
                                            <div class="product_d_table">
                                                <form action="#">
                                                    <table>
                                                        <tbody>
                                                            <tr>
                                                                <td class="first_child">Compositions</td>
                                                                <td>Polyester</td>
                                                            </tr>
                                                            <tr>
                                                                <td class="first_child">Styles</td>
                                                                <td>Girly</td>
                                                            </tr>
                                                            <tr>
                                                                <td class="first_child">Properties</td>
                                                                <td>Short Dress</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </form>
                                            </div>
                                            <div class="product_info_content">
                                                <p>Fashion has been creating well-designed collections since 2010. The brand offers feminine designs delivering stylish separates and statement dresses which have since evolved into a full ready-to-wear collection in which every item is a vital part of a woman's wardrobe. The result? Cool, easy, chic looks with youthful elegance and unmistakable signature style. All the beautiful pieces are made in Italy and manufactured with the greatest attention. Now Fashion extends to a range of accessories including shoes, hats, belts and more!</p>
                                            </div>    
                                        </div>
                                        <div class="tab-pane fade" id="reviews" role="tabpanel">
                                            <div class="product_info_content">
                                                <p style="font-size: 16px; color: red; font-style: italic; margin-bottom: 10px">Thank you for your purchase. You can only send feedback when you buy products at the store. See you in the next orders!</p>
                                            </div>                                       
                                            <%
                                                FeedbackDAO fd = new FeedbackDAO();
                                                Vector<FeedBack> listFB = fd.getAllFeedBackFromSQL("select * from FeedBack where ProductCode = " + inforP.getProductCode());
                                                if(listFB.size() != 0 && listFB != null){
                                                    for(FeedBack fb : listFB){
                                            %>
                                            <div class="product_info_inner" style="margin-bottom: 20px">
                                                <div>
                                                    <!-- hiện thị avt và username ở đây -->
                                                    <%
                                                       Customer cFB = cd.getAllCustomerFromSQL("select * from Customer where CustomerID = " + fb.getCustomerID()).firstElement();
                                                    %>
                                                    <div class="infor_account">
                                                        <div class="avatar_account">
                                                            <a href="my-account.jsp"><img src="<%=cFB.getAvatar()%>" alt="alt"/></a>
                                                        </div>                                                     
                                                    </div>
                                                </div>
                                                <div class="product_ratting mb-10">        
                                                    <p style="margin: 0"><%=cFB.getUsername()%></p>
                                                    <div class="star-rating">
                                                        <%
                                                            for(int i = 1; i <= fb.getEvaluate(); i++){
                                                        %>    
                                                        <span style="color: #ffca08;">&#9733;</span>
                                                        <%
                                                            }
                                                            for(int i = 1; i <= 5 - fb.getEvaluate(); i++){
                                                        %>                                               
                                                        <span class="star">&#9733;</span>
                                                        <%}%>
                                                    </div>                                       
                                                    <p><%=fb.getFeedbackDate()%></p>
                                                </div>
                                                <div class="product_demo">
                                                    <strong style="font-size: 14px">Feedbeck</strong>
                                                    <p><%=fb.getContent()%></p>
                                                </div>
                                            </div> 
                                            <%}}%>
                                            <!-- Chỉnh sửa: chỉ có thể add review khi nhận hàng thành công và chỉ được add 1 lần duy nhất khi nhận hàng thành công -->
                                            <%
                                                //kiểm tra xem customer này đã mua sản phẩm này hay chưa
                                                if(customer != null){
                                                boolean checkPurchased = false;
                                                OrdersDAO od = new OrdersDAO();
                                                OrderDetailsDAO odd = new OrderDetailsDAO();
                                                
                                                Vector<Orders> listOD = od.getAllOrdersFromSQL("select * from Orders where CustomerID = " + customer.getCustomerID());
                                                Vector<OrderDetails> listODD = new Vector<>();
                                                for(Orders o : listOD){
                                                    listODD = odd.getAllOrderDetailsFromSQL("select * from OrderDetails where OrderID = " + o.getOrderID());
                                                    for(OrderDetails oDetail : listODD){
                                                        if(oDetail.getProductCode() == inforP.getProductCode() && o.getStatus() == 4){
                                                            checkPurchased = true;
                                                            break;
                                                        }
                                                    }
                                                    if(checkPurchased){
                                                        break;
                                                    }
                                                }
                                                
                                                if(checkPurchased){
                                            %>
                                            <div class="product_review_form">
                                                <form action="FeedbackServlet">
                                                    <h2 style="color: red">Add a review </h2>
                                                    <p>Your email address will not be published. Required fields are marked </p>
                                                    <div class="star-rating" style="margin-bottom: 5px">
                                                        <span class="star" data-value="1">&#9733;</span>
                                                        <span class="star" data-value="2">&#9733;</span>
                                                        <span class="star" data-value="3">&#9733;</span>
                                                        <span class="star" data-value="4">&#9733;</span>
                                                        <span class="star" data-value="5">&#9733;</span>
                                                    </div>
                                                    <input type="hidden" name="ratingValue" id="ratingValue">
                                                    <div class="row">
                                                        <div class="col-12">
                                                            <label for="review_comment" style="font-weight: bold">Your review </label>                                                   
                                                            <input type="text" id="review_comment" name="comment" value=" ">
                                                        </div>  
                                                    </div>
                                                    <input type="hidden" name="productCode" value="<%=inforP.getProductCode()%>">
                                                    <input type="hidden" name="service" value="insertFB">
                                                    <button type="submit">Submit</button>
                                                </form>   
                                            </div>     
                                            <%}}%>
                                        </div>
                                    </div>
                                </div>     
                            </div>
                        </div>
                    </div>  
                    <!--product info end-->


                    <!--new product area start-->
                    <%
                        int productCategoryID = product.getCategoryID();
                        Vector<Product> productSameCategory = pd.getAllProductFromSQL("select * from Product where CategoryID = " + productCategoryID);
                    %>
                    <div class="new_product_area product_page">
                        <div class="row">
                            <div class="col-12">
                                <div class="block_title">
                                    <h3>  <%=productSameCategory.size()%> Related Products:</h3>
                                </div>
                            </div> 
                        </div>
                        <div class="row">
                            <div class="single_p_active owl-carousel">
                                <%
                                    for(Product p: productSameCategory){
                                %>
                                <div class="col-lg-3">
                                    <div class="single_product">
                                        <div class="product_thumb">
                                            <a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=p.getProductCode()%>"><img src="<%=p.getPicture()%>" alt=""></a> 
                                            <div class="img_icone">
                                                <img src="assets\img\cart\span-new.png" alt="">
                                            </div>
                                            <div class="product_action">
                                                <a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=p.getProductCode()%>"> <i class="fa fa-shopping-cart"></i> Add to cart</a>
                                            </div>
                                        </div>
                                        <div class="product_content">
                                            <span class="product_price">$<%=(p.getPrice() * (100 - p.getDiscount())) / 100%></span>
                                            <h3 class="product_title"><a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=p.getProductCode()%>"><%=p.getProductName()%></a></h3>
                                        </div>
                                        <div class="product_info">
                                            <ul>
                                                <li><a href="#" title=" Add to Wishlist ">Add to Wishlist</a></li>
                                                <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view">View Detail</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>     
                                <%            
                                    }
                                %>                 
                            </div> 
                        </div>      
                    </div> 
                    <!--new product area start-->  


                    <!--new product area start-->
                    <div class="new_product_area product_page">
                        <div class="row">
                            <div class="col-12">
                                <div class="block_title">
                                    <h3>Other products category:</h3>
                                </div>
                            </div> 
                        </div>
                        <div class="row">
                            <div class="single_p_active owl-carousel">
                                <%
                                    Vector<Product> listOtherProductCategory = (Vector<Product>)request.getAttribute("listOtherProductCategory");
                                    if(listOtherProductCategory.size() != 0) {
                                        for(Product p : listOtherProductCategory) {
                                %>
                                <div class="col-lg-3">
                                    <div class="single_product">
                                        <div class="product_thumb">
                                            <a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=p.getProductCode()%>"><img src="<%=p.getPicture()%>" alt=""></a> 
                                            <div class="img_icone">
                                                <img src="assets\img\cart\span-new.png" alt="">
                                            </div>
                                            <div class="product_action">
                                                <a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=p.getProductCode()%>"> <i class="fa fa-shopping-cart"></i> Add to cart</a>
                                            </div>
                                        </div>
                                        <div class="product_content">
                                            <span class="product_price">$<%=(p.getPrice() * (100 - p.getDiscount())) / 100%></span>
                                            <h3 class="product_title"><a href="ListSingleProductServlet?service=listInforProduct&productCode=<%=p.getProductCode()%>"><%=p.getProductName()%></a></h3>
                                        </div>
                                        <div class="product_info">
                                            <ul>
                                                <li><a href="#" title=" Add to Wishlist ">Add to Wishlist</a></li>
                                                <li><a href="#" data-toggle="modal" data-target="#modal_box" title="Quick view">View Detail</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>   
                                <%}}%>
                            </div> 
                        </div>      
                    </div> 
                    <!--new product area start-->  

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
        <script>
            document.querySelectorAll('.star').forEach(function (star) {
                star.addEventListener('click', function () {
                    var rating = this.getAttribute('data-value');
                    document.getElementById('ratingValue').value = rating;
                });
            });
        </script>
        <script>
            // Lấy tất cả các sao và lặp qua từng sao
            const stars = document.querySelectorAll('.star-rating .star');
            stars.forEach((star, index) => {
                star.addEventListener('click', function () {
                    // Xóa class 'selected' khỏi tất cả các sao
                    stars.forEach(s => s.classList.remove('selected'));
                    // Thêm class 'selected' vào sao đang được click và tất cả các sao trước đó
                    for (let i = 0; i <= index; i++) {
                        stars[i].classList.add('selected');
                    }

                    // Tùy chỉnh thêm code ở đây để gửi giá trị đánh giá sang server nếu cần
                });
            });
        </script>

        <script>
            function sendDataProduct() {
                var size = document.getElementById('size').value;
                var color = document.getElementById('color').value;
                window.location.href = 'ListSingleProductServlet?service=listInforProduct&productCode=${product.getProductCode()}' + '&size=' + size + "&color=" + color;
            }
        </script>

        <!-- all js here -->
        <script src="assets\js\vendor\jquery-1.12.0.min.js"></script>
        <script src="assets\js\popper.js"></script>
        <script src="assets\js\bootstrap.min.js"></script>
        <script src="assets\js\ajax-mail.js"></script>
        <script src="assets\js\plugins.js"></script>
        <script src="assets\js\main.js"></script>
    </body>
</html>

