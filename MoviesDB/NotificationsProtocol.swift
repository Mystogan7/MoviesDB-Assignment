//
//  NotificationsProtocol.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/24/19.
//

import Foundation

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}

enum Notifications: String, NotificationName {
    case didSaveMovie
    case didSelectMyMovie

}
