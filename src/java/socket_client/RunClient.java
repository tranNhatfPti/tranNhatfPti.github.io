/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package socket_client;

import java.io.IOException;

public class RunClient {
    public static void main(String[] args) throws IOException {
        SocketClient socketCient = new SocketClient();
        socketCient.startSocketClient("");
    }
}
