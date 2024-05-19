/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.BrandDAO;
import dal.CategoryDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Vector;
import model.Brand;
import model.Category;
import model.Product;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name = "ListProductServlet", urlPatterns = {"/ListProductServlet"})
public class ListProductServlet extends HttpServlet {

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
        out.println("<title>Servlet AddServlet</title>");
        out.println("</head>");
        out.println("<body>");

        try {
            /* TODO output your page here. You may use following sample code. */

            HttpSession session = request.getSession();
            ProductDAO pd = new ProductDAO();
            BrandDAO bd = new BrandDAO();
            CategoryDAO cd = new CategoryDAO();

            Vector<Brand> vectorBrand = bd.getAllBrandFromSQL("select * from Brand");
            Vector<Category> vectorCategory = cd.getAllCategoryFromSQL("select * from Category");
            Vector<Product> vectorProduct = (Vector<Product>) session.getAttribute("listProductSession");

            String service = request.getParameter("service");
            String page_string = request.getParameter("page");

            int page;           
            if (service == null && (page_string == null || page_string.isBlank())) {
                service = "listAllProduct";
            }
            if (page_string == null || page_string.isBlank()) {
                page_string = "1";
            }  
            if(service == null){
                service = "";
            }
            page = Integer.parseInt(page_string);

            if (service.equals("searchProduct")) {
                String[] gender = request.getParameterValues("genderSearch"); // trả về kiểu dữ liệu String[]
                String[] category = request.getParameterValues("categorySearch");
                String priceFromString = request.getParameter("priceFrom");
                String priceToString = request.getParameter("priceTo");
                String[] brand = request.getParameterValues("brandSearch"); // brand[0] = GUCCI
                //luôn luôn = "1" vì để selected
                String status = request.getParameter("status");
                if (status != null && status.equals("searchFromIndex")) {
                    priceToString = "";
                }

                String orderbyString = request.getParameter("orderBy");

                if (gender == null && category == null && priceToString.isBlank() && brand == null && orderbyString == null) {
                    service = "listAllProduct";
                } else {
                    // phải gán = 1 mảng vì nếu = null thì sẽ không chạy
                    if (gender == null) {
                        gender = new String[0];
                    }

                    String sql = "select * from ";

                    if (category != null || brand != null) {
                        sql += "Product p ";
                    } else {
                        sql += "Product ";
                    }

                    if (category != null) {
                        sql += "join Category c on p.CategoryID = c.CategoryID ";
                    }

                    if (brand != null) {
                        sql += "join Brand b on b.BrandName = p.BrandName ";
                    }

                    sql += "where ";

                    if (category != null) {
                        boolean checkCate = true;
                        sql += "(";
                        for (String cName : category) {
                            if (checkCate) {
                                sql += "c.Name = '" + cName + "' ";
                            } else {
                                sql += "or c.Name = '" + cName + "'";
                            }
                            checkCate = false;

                            // chuyển mảng string thành ArrayList
                            List<String> listSearchCategory = new ArrayList<>(Arrays.asList(category));
                            request.setAttribute("listSearchCategory", listSearchCategory);
                        }
                        sql += ") ";

                        if (brand != null || gender.length == 1 || !priceToString.isBlank()) {
                            sql += "and ";
                        }
                    }

                    if (brand != null) {
                        boolean checkBrand = true;
                        sql += "(";
                        for (String bName : brand) {
                            if (checkBrand) {
                                sql += "b.BrandName like '%" + bName + "%' ";
                            } else {
                                sql += "or b.BrandName like '%" + bName + "%' ";
                            }
                            checkBrand = false;

                            // chuyển mảng string thành ArrayList
                            List<String> listSearchBrand = new ArrayList<>(Arrays.asList(brand));
                            request.setAttribute("listSearchBrand", listSearchBrand);
                        }
                        sql += ") ";

                        if (gender.length == 1 || !priceToString.isBlank()) {
                            sql += "and ";
                        }
                    }

                    if (gender.length == 1) { // == 2 đồng nghĩa với không chọn cái gì
                        sql += "(Gender = '" + gender[0] + "' or Gender = 'ALL') ";
                        request.setAttribute("searchGender", gender[0]);

                        if (!priceToString.isBlank()) {
                            sql += "and ";
                        }
                    }

                    if (priceToString != null && !priceToString.isBlank()) {
                        double priceFrom = Double.parseDouble(priceFromString);
                        double priceTo = Double.parseDouble(priceToString);

                        if (priceFrom < 0 || (priceTo < priceFrom)) {
                            request.setAttribute("msPriceRange", "Please fill in the appropriate price range!");
                        } else {
                            sql += "(Price >= " + priceFrom + " and " + "Price <= " + priceTo + ") ";
                            request.setAttribute("priceFrom", priceFrom);
                            request.setAttribute("priceTo", priceTo);
                        }
                    }

                    if (orderbyString != null) {
                        int orderby = Integer.parseInt(orderbyString);

                        String checkWhere = sql.substring(sql.length() - 6);
                        if (checkWhere.equals("where ")) {
                            sql += "1=1 ";
                        }

                        switch (orderby) {
                            case 2:
                                sql += "order by price asc";
                                break;
                            case 3:
                                sql += "order by price desc";
                                break;
                            case 4:
                                //.....(latest)
                                break;
                            case 5:
                                //.....(bestseller)
                                break;
                            case 6:
                                sql += "and Quantity >= 1";
                                break;
                            default:
                                break;
                        }

                        request.setAttribute("searchOrderby", orderby);
                    }

                    // gửi sang jsp để check SQL query    
//                    out.println("<h1>" + sql + "</h1>");
                    request.setAttribute("SQL", sql);
                    vectorProduct = pd.getAllProductFromSQL(sql);
                }

            }

            if (service.equals("searchBar")) {
                String textSearchBar = request.getParameter("searchBar");

                if (textSearchBar == null) {
                    service = "listAllProduct";
                } else {
                    String sql = "select * from Product p join Category c on p.CategoryID = c.CategoryID where "
                            + "c.Name LIKE N'%" + textSearchBar + "%' or "
                            + "p.ProductName LIKE N'%" + textSearchBar + "%' or "
                            + "p.BrandName LIKE N'%" + textSearchBar + "%' or "
                            + "p.Description LIKE N'%" + textSearchBar + "%'";

                    vectorProduct = pd.getAllProductFromSQL(sql);
                }

            }

            if (service.equals("searchDiscount")) {
                String discount_string = request.getParameter("discount");

                vectorProduct = pd.getAllProductFromSQL("select * from Product where Discount = " + discount_string);
            }

            if (service.equals("listAllProduct")) {
                String sql = "select * from Product";

                vectorProduct = pd.getAllProductFromSQL(sql);
            }

            if (service.equals("listAllProductAdmin")) {
                String sql = "select * from Product";

                vectorProduct = pd.getAllProductFromSQL(sql);

                request.setAttribute("capListProduct", "List Product");
                request.setAttribute("listProduct", vectorProduct);
                request.getRequestDispatcher("ProductManage.jsp").forward(request, response);
            }                  

            // 1 trang sẽ hiển thị tối đa 36 sản phẩm
            int numberOfPage = (vectorProduct.size() / 36) + 1;
            Vector<Product> vectorProductPagination = null;
            if (page == numberOfPage) {
                vectorProductPagination = new Vector<>(vectorProduct.subList(36 * (page - 1), vectorProduct.size()));
            } else {
                vectorProductPagination = new Vector<>(vectorProduct.subList(36 * (page - 1), 36 * page));
            }

            request.setAttribute("numberOfPage", numberOfPage);
            request.setAttribute("page", page);
            request.setAttribute("fromServlet", "fromServlet");
            request.setAttribute("listCategory", vectorCategory);
            request.setAttribute("listBrand", vectorBrand);
            request.setAttribute("listProduct", vectorProductPagination);
            session.setAttribute("listProductSession", vectorProduct);
            if (request.getParameter("status") != null) {
                if (request.getParameter("status").equals("searchProductAdmin")) {
                    request.getRequestDispatcher("admin/doc/product-manage.jsp").forward(request, response);
                }
            }
            request.getRequestDispatcher("shop-list.jsp").forward(request, response);

        } catch (NumberFormatException ex) {
            out.println("<h3>" + "Please re-enter the correct value!" + "</h3>");
            out.println("<p><a href=\"InsertProduct.jsp\">Insert Product</a></p>");
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
