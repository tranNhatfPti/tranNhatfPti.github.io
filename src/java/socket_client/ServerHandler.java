/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package socket_client;

import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class ServerHandler implements Runnable {

    private Socket socket;
    private InputStream inputStream;
    private BufferedReader getFromServer;

    public ServerHandler() {
    }

    public ServerHandler(Socket socket) {
        this.socket = socket;
        try {
            inputStream = socket.getInputStream();

            // đọc dữ liệu từ client gửi lên
            this.getFromServer = new BufferedReader(new InputStreamReader((inputStream)));
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public void run() {
        try {
//            PrintWriter out = response.getWriter();
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                String message = new String(buffer, 0, bytesRead);
//                out.print("<h1>"+message+"</h1>");
                System.out.println(message);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
