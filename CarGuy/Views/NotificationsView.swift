//
//  NotificationsView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 18/05/22.
//

import SwiftUI

struct Notification: Identifiable {
let id = UUID()
let text: String
}

private var notifs = [
    Notification(text: "Nuova recensione da @maurizio"),
    Notification(text: "Notification #2"),
    Notification(text: "Nuova recensione da @alessia"),
    Notification(text: "Notification #4"),
    Notification(text: "Nuova recensione da @franco"),
    Notification(text: "Notification #6"),
    Notification(text: "Notification #7"),
]

struct NotificationsView: View {
    var body: some View {
        List(notifs) { notif in
            Text(notif.text)
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
