/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package socket_client;

import controller.SocketServlet;
import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;
import java.util.Scanner;

public class SocketClient {

    // xác định cổng để kết nối tới server
    private static final int PORT = 7777;
    // xác định ID Address của server muốn kết nối tới
    private static final String URL = "localhost";

    public void startSocketClient(String message) throws IOException {
        try {
            // kết nối tới server
            Socket socket = new Socket(URL, PORT);

            // liên tục đọc dữ liệu từ server
            ServerHandler serverHandler = new ServerHandler(socket);
            new Thread(serverHandler).start();
            
            //Tạo OutputStream nối với Socket
            OutputStream outputStream = socket.getOutputStream();
            //PrintWriter writer = new PrintWriter(socket.getOutputStream());

            // liên tục đọc dữ liệu từ scanner để đưa dữ liệu lên server
            //Scanner sc = new Scanner(System.in);
            while (true) {
                if(!message.isBlank() && message != null){
                    outputStream.write(message.getBytes());
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
