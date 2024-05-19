/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package socket_server;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Random;
import java.util.Vector;
import model.Customer;

public class SocketServer{

    // xác định cổng để chờ client kết nối
    private static final int PORT = 7777;
    // lưu tất cả những luồng client kết nối đến server
    Vector<ClientHandler> listClient = new Vector<>();

    public void startSocketServer() {
        try {
            // mở cổng để chờ các client kết nối tới
            ServerSocket serverSocket = new ServerSocket(PORT);

            // liên tục chờ những luồng client khác nhau kết nối tới server
            while (true) {
                // server chấp nhận kết nối từ client
                Socket clientSocket = serverSocket.accept();

                // nếu là 1 client mới thì sẽ tạo ra 1 luồng và lưu vào list client
                // lấy id client được gửi lên từ lần đầu
                Random random = new Random();
                ClientHandler clientHandler = new ClientHandler(random.nextInt(1000), clientSocket, this);
                listClient.add(clientHandler);

                // new Thread(clientHandler: tạo luồng vs client
                // .start(): gửi data đến các client khác
                new Thread(clientHandler).start();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // gửi message tới tất cả client
    public void broadcastMessage(int idClient, String message) {
        try {
            for (ClientHandler client : listClient) {
                if(client.getIdClient() != idClient){
                    client.sendMessageToClient(idClient + ": " + message);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
