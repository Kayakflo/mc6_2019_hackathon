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
    public var stateUpdate: (([UInt8]?, String, Int) -> Void)!
    public var statsUpdate: (([UInt8]?, String, Int) -> Void)!
    public var movementState = (forward: 0, right: 0, up: 0, rotate: 0)
    
    private init(){
        startCycle()
    }
    
    func startCycle() {
        DispatchQueue.global(qos: .default).async {
            while true {
                if SocketController.singleton.commandClient == nil {
                    sleep(1)
                    continue
                }
                self.sendWriteCommand(command: .RC, params: simd_int4(Int32(self.movementState.forward), Int32(self.movementState.right) * -1, Int32(self.movementState.up), Int32(self.movementState.rotate)), response: { (success) in
                    //
                })
                //sleep(1)
                usleep(200000) // 0.2s Sleep
            }
        }
    }
    
    func sendWriteCommand(command: WriteCommand, params: Any?, response: (Bool) -> Void) {
        switch command {
        case .COMMAND:
            SocketController.singleton.commandClient.send(string: "command")
        case .TAKEOFF:
            SocketController.singleton.commandClient.send(string: "takeoff")
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
            if direction == "l" ||  direction == "r" || direction == "f" || direction == "b"{
                SocketController.singleton.commandClient.send(string: "flip \(direction)")
            }
            else{
                response(false)
            }
        case .GO:
            guard let coordinates = params as? simd_int4 else {
                response(false)
                return
            }
            
            if coordinates.x > -20 && coordinates.x < 20 && coordinates.y > -20 && coordinates.y < 20 && coordinates.z > -20 && coordinates.z < 20 {
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
        case .RC:
            guard let coordinates = params as? simd_int4 else {
                response(false)
                return
            }
            print("rc \(coordinates.y) \(coordinates.x) \(coordinates.z) \(coordinates.w)")
            SocketController.singleton.commandClient.send(string: "rc \(coordinates.y) \(coordinates.x) \(coordinates.z) \(coordinates.w)")
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
        self.stateUpdate(message.0, message.1, message.2)
    }
    
    func statsUpdate(message: ([UInt8]?, String, Int)) {
        self.statsUpdate(message.0, message.1, message.2)
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
    case RC
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
