//
//  Websocket.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//
import Foundation

class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    static let shared = WebSocketManager()

       // ... existing code ...

       
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
    }

    func connect(userID: String) {
        guard let url = URL(string: "ws://localhost:8080/ws?userID=\(userID)"), let urlSession = urlSession else {
            print("Invalid URL or URLSession not initialized")
            return
        }
        
        self.webSocketTask = urlSession.webSocketTask(with: url)
        self.webSocketTask?.resume()
        receiveMessage()
    }

    func disconnect() {
        self.webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    func sendMessage(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        self.webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
        }
    }

    private func receiveMessage() {
        self.webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receiving error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text: \(text)")
                    self?.notifyReceivedMessage(text: text)
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
                self?.receiveMessage() // Continue receiving messages
            }
        }
    }

    private func notifyReceivedMessage(text: String) {
        NotificationCenter.default.post(name: .didReceiveMessage, object: nil, userInfo: ["message": text])
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket did connect")
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocket did disconnect")
    }
    func checkForMessages(completion: @escaping ([String]) -> Void) {
        // Implement logic to check for new messages without opening a new WebSocket connection
        // This could be done by calling a REST API endpoint that returns any new messages
        // For now, we'll simulate receiving messages
        completion(["New background message"])
    }
}

extension Notification.Name {
    static let didReceiveMessage = Notification.Name("didReceiveMessage")
}
