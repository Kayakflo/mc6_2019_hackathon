//
//  APIController.swift
//  mc6_2019_hackathon
//
//  Created by Florian Kriegel on 04.06.19.
//  Copyright © 2019 Florian Kriegel. All rights reserved.
//

import Foundation
import SceneKit

class APIController {
    
    static let shared = APIController()
    
    private init(){}
    
    func sendWriteCommand(command: WriteCommand, params: Any?, response: (Bool) -> Void) {
        switch command {
        case .COMMAND:
            SocketController.singleton.commandClient.send(string: "command")
        case .TAKEOFF:
            SocketController.singleton.commandClient.send(string: "takoff")
        case .LAND:
            SocketController.singleton.commandClient.send(string: "land")
        case .STREAMON:
            SocketController.singleton.commandClient.send(string: "streamon")
        case .STREAMOFF:
            SocketController.singleton.commandClient.send(string: "streamoff")
        case .EMERGENCY:
            SocketController.singleton.commandClient.send(string: "emergency")
        case .UP:
            guard let distance = params as? Int else {
                response(false)
                return
            }
            if distance >= 20 && distance <= 500{
                SocketController.singleton.commandClient.send(string: "up \(distance)")
            }
            else{
                response(false)
            }
        case .DOWN:
            guard let distance = params as? Int else {
                response(false)
                return
            }
            if distance >= 20 && distance <= 500{
                SocketController.singleton.commandClient.send(string: "down \(distance)")
            }
            else{
                response(false)
            }
        case .LEFT:
            guard let distance = params as? Int else {
                response(false)
                return
            }
            if distance >= 20 && distance <= 500{
                SocketController.singleton.commandClient.send(string: "left \(distance)")
            }
            else{
                response(false)
            }
        case .RIGHT:
            guard let distance = params as? Int else {
                response(false)
                return
            }
            if distance >= 20 && distance <= 500{
               SocketController.singleton.commandClient.send(string: "right \(distance)")
            }
            else{
                response(false)
            }
        case .FORWARD:
            guard let distance = params as? Int else {
                response(false)
                return
            }
            if distance >= 20 && distance <= 500{
                SocketController.singleton.commandClient.send(string: "forward \(distance)")
            }
            else{
                response(false)
            }
        case .BACK:
            guard let distance = params as? Int else {
                response(false)
                return
            }
            if distance >= 20 && distance <= 500{
                SocketController.singleton.commandClient.send(string: "back \(distance)")
            }
            else{
                response(false)
            }
        case .ROTATE_CW:
            guard let degrees = params as? Int else {
                response(false)
                return
            }
            if degrees >= 1 && degrees <= 360{
                SocketController.singleton.commandClient.send(string: "cw \(degrees)")
            }
            else{
                response(false)
            }
        case .ROTATE_CCW:
            guard let degrees = params as? Int else {
                response(false)
                return
            }
            if degrees >= 1 && degrees <= 360{
                SocketController.singleton.commandClient.send(string: "ccw \(degrees)")
            }
            else{
                response(false)
            }
        case .FLIP:
            guard let direction = params as? Character else {
                response(false)
                return
            }
            if direction == "l" || direction == "r" || direction == "f" || direction == "b"{
                SocketController.singleton.commandClient.send(string: "flip \(direction)")
            }
            else{
                response(false)
            }
        case .GO:
            guard let coordinates = params as? SCNVector4 else {
                response(false)
                return
            }
            if coordinates.x > -20 && coordinates.x < 20 || coordinates.y > -20 && coordinates.y < 20 || coordinates.z > -20 && coordinates.z < 20{
                response(false)
                return
            }
            if coordinates.x > 500 && coordinates.x < -500 || coordinates.y > 500 && coordinates.y < -500 || coordinates.z > 500 && coordinates.z < -500{
                response(false)
                return
            }
            if coordinates.w < 10 || coordinates.w > 100 {
                response(false)
                return
            }
            SocketController.singleton.commandClient.send(string: "go \(coordinates.x) \(coordinates.y) \(coordinates.z) \(coordinates.w)")
        case .STOP:
            SocketController.singleton.commandClient.send(string: "stop")
        case .SPEED:
            guard let speed = params as? Int else {
                response(false)
                return
            }
            if speed >= 10 && speed <= 100{
                SocketController.singleton.commandClient.send(string: "speed \(speed)")
            }
            else{
                response(false)
            }
        case .WIFI:
            guard let infos = params as? (String, String) else {
                response(false)
                return
            }
            SocketController.singleton.commandClient.send(string: "wifi \(infos.0) \(infos.1)")
        default:
            response(false)
        }
    }
    
    func sendReadCommand(command: ReadCommand, response: (Any) -> Void) {
        switch command {
            case .SPEED:
                let result = SocketController.singleton.commandClient.send(string: "speed?")
            case .BATTERY:
                let result = SocketController.singleton.commandClient.send(string: "battery?")
            case .TIME:
                let result = SocketController.singleton.commandClient.send(string: "time?")
            case .WIFI:
                let result = SocketController.singleton.commandClient.send(string: "wifi?")
            case .SDK:
                let result = SocketController.singleton.commandClient.send(string: "sdk?")
            case .SN:
                let result = SocketController.singleton.commandClient.send(string: "sn?")
            default:
                response(false)
        }
    }
    
    func stateUpdated(message: ([UInt8]?, String, Int)){
        print(message.0)
        print(message.1)
        print(message.2)
    }
    
}

enum WriteCommand{
    case COMMAND
    case TAKEOFF
    case LAND
    case STREAMON
    case STREAMOFF
    case EMERGENCY
    case UP
    case DOWN
    case LEFT
    case RIGHT
    case FORWARD
    case BACK
    case ROTATE_CW
    case ROTATE_CCW
    case FLIP
    case GO
    case STOP
    case SPEED
    case WIFI
}

enum ReadCommand{
    case SPEED
    case BATTERY
    case TIME
    case WIFI
    case SDK
    case SN
}
