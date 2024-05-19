/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package socket_server;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

public class ClientHandler implements Runnable {

    private int idClient;
    private Socket socketClient;
    private SocketServer socketServer;
    private InputStream inputStream;
    private OutputStream outputStream;

    public ClientHandler() {
    }

    public ClientHandler(int idClient, Socket socketClient, SocketServer socketServer) {
        this.idClient = idClient;
        this.socketClient = socketClient;
        this.socketServer = socketServer;
        try {
            this.inputStream = socketClient.getInputStream();
            this.outputStream = socketClient.getOutputStream();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getIdClient() {
        return idClient;
    }

    public void setIdClient(int idClient) {
        this.idClient = idClient;
    }

    public Socket getSocketClient() {
        return socketClient;
    }

    public void setSocketClient(Socket socketClient) {
        this.socketClient = socketClient;
    }

    public SocketServer getSocketServer() {
        return socketServer;
    }

    public void setSocketServer(SocketServer socketServer) {
        this.socketServer = socketServer;
    }

    public InputStream getInputStream() {
        return inputStream;
    }

    public void setInputStream(InputStream inputStream) {
        this.inputStream = inputStream;
    }

    public OutputStream getOutputStream() {
        return outputStream;
    }

    public void setOutputStream(OutputStream outputStream) {
        this.outputStream = outputStream;
    }

    @Override
    public void run() {
        try {
            byte[] buffer = new byte[2048];
            int bytesRead;
            // khi gọi đến hàm read(byte[]) thì các phần tử của buffer sẽ được gán với các phần tử mảng byte[] của dữ liệu gửi từ client
            // liên tục đọc dữ liệu từ client
            // = -1 khi không có dữ liệu từ client gửi đến
            // lấy dữ liệu từ luồng this 
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                String message = new String(buffer, 0, bytesRead);
                socketServer.broadcastMessage(this.idClient, message);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
  
    public void sendMessageToClient(String message) {
        try {
            // getBytes: mỗi kí tự trong message sẽ được chuyển thành mã ASCII(0-255) và lưu vào mảng byte[]
            outputStream.write(message.getBytes());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
