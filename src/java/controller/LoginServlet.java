/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import socket_client.SocketClient;

/**
 *
 * @author ASUS ZenBook
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

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
            
            CustomerDAO cd = new CustomerDAO();
            HttpSession session = request.getSession();                    
            String service = request.getParameter("service");

            if (service.equals("login")) {
                String getUsername = request.getParameter("username");
                String getPassword = request.getParameter("password");
                String rememberMe = request.getParameter("rememberMe");

                if (cd.checkUsernameAndPassword(getUsername, getPassword)) {
                    // nhớ tài khoản và mật khẩu
                    if (rememberMe != null) {
                        // tạo cookie
                        Cookie cUsername = new Cookie("cUsername", getUsername);
                        Cookie cPassword = new Cookie("cPassword", getPassword);

                        // set tuổi cho cookie 6 tháng(2 key sẽ tồn tại ở browser 6 tháng)
                        cUsername.setMaxAge(60 * 60 * 24 * 30 * 6);
                        cPassword.setMaxAge(60 * 60 * 24 * 30 * 6);

                        // thêm cookie
                        response.addCookie(cUsername);
                        response.addCookie(cPassword);
                    }

                    // check client hay là admin
                    if (getUsername.equals("admin") && getPassword.equals("123456")) {
                        session.setAttribute("account", cd.getCustomerByUsername(getUsername));
                        response.sendRedirect("admin/doc/index-admin.jsp");
                    } else {
                        session.setAttribute("account", cd.getCustomerByUsername(getUsername));     
                        response.sendRedirect("index.jsp");
                    }

                } else {
                    String msFailLogin = "Username or Password is invalid!";
                    request.setAttribute("msFailLogin", msFailLogin);
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            }

            if (service.equals("register")) {
                String getUsername = request.getParameter("username");
                String getPassword = request.getParameter("password");

                // để check username được đăng kí là duy nhất(không có username nào trùng)
                Customer customer = cd.getCustomerByUsername(getUsername);

                if (customer != null) {
                    request.setAttribute("msFailRegister", "Username is exist! Please register again!");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }

                cd.insertCustomer(new Customer(getUsername, getPassword));
                response.sendRedirect("login.jsp");
            }

            if (service.equals("logout")) {
                session.removeAttribute("account");

                if (request.getParameter("status") != null && request.getParameter("status").equals("admin")) {
                    response.sendRedirect("login.jsp");
                } else {
                    response.sendRedirect("index.jsp");
                }
            }

            if (service.equals("lostPassword")) {
                String username = request.getParameter("username");
                String phone = request.getParameter("phone");
                String newPassword = request.getParameter("newPassword");
                String reNewPassword = request.getParameter("reNewPassword");

                // check có tồn tại account của username nhập vào không
                Customer customerLostPassword = cd.getCustomerByUsername(username);
                
                if (customerLostPassword == null) {
                    request.setAttribute("msUsername", "Username is wrong or does not exist!");
                } else {
                    if (!customerLostPassword.getPhone().equals(phone)) {
                        request.setAttribute("msPhone", "Phone number registered to account is wrong!");
                    } else {
                        if (!newPassword.equals(reNewPassword)) {
                            request.setAttribute("msPassword", "Passwords do not match!");     
                        }else{
                            customerLostPassword.setPassword(newPassword);
                            if(cd.updateCustomer(customerLostPassword) != 0){
                                request.setAttribute("msChangePassword", "Change password succesfully!");
                            }else{
                                request.setAttribute("msChangePassword", "Change password fail!");
                            }                   
                        }                
                    }
                }
                request.getRequestDispatcher("lost-password.jsp").forward(request, response);
            }

            if (service.equals("updateInfor")) {
                Customer cSession = (Customer) session.getAttribute("account");

                int idCustomer = cSession.getCustomerID();
                String username = cSession.getUsername();
                String password = cSession.getPassword();
                String firstName = request.getParameter("first-name");
                String lastName = request.getParameter("last-name");
                String email = request.getParameter("email-name");
                String phone = request.getParameter("phone");
                String birthOfDate = request.getParameter("birthday");
                String gender = request.getParameter("id_gender");
                String address = request.getParameter("address");
                double moneyBalance = cSession.getMoneyBalance();
                String avatar = cSession.getAvatar();

                // nếu = null thì sẽ lỗi vì không thể so sánh null với string hoặc số
                if (gender != null) {
                    if (gender.equals("1")) {
                        gender = "Male";
                    } else {
                        gender = "Female";
                    }
                }

                Customer customer = new Customer(idCustomer, username, password, firstName, lastName,
                        email, phone, gender, address, birthOfDate, moneyBalance, avatar);

                if (cd.updateCustomer(customer) != 0) {
                    session.setAttribute("account", cd.getCustomerByUsername(username));
                    request.setAttribute("msUpdateInfor", "Update your information succesfully!");
                    request.getRequestDispatcher("my-account.jsp").forward(request, response);
                } else {
                    response.sendRedirect("404.jsp");
                }
            }
        } catch (Exception ex){
            
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
