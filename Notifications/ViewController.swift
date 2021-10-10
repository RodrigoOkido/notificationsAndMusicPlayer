//
//  ViewController.swift
//  Notifications
//
//  Created by Rodrigo Yukio Okido on 26/08/21.
//

import UIKit
import UserNotifications



class ViewController: UIViewController, ObservableObject {


    @Published var defineTimeToggle: Bool = false
    
    @IBOutlet weak var notificationTitle: UITextField!
    @IBOutlet weak var notificationContent: UITextField!
    @IBOutlet weak var notificationTime: UIDatePicker!
    @IBOutlet weak var notifyButton: UIButton!
    @IBOutlet weak var deliverAtStackView: UIStackView!
    @IBAction func defineTime(_ sender: Any) {
        if defineTimeToggle {
            defineTimeToggle = false
            deliverAtStackView.isHidden = false
        } else {
            defineTimeToggle = true
            deliverAtStackView.isHidden = true

        }
    }
    
    /**
     Sends the notification to the notification center. Checks if title and content notification contains text. If ok, it will ask user permission to deliver notifications (first time only), and once authorized, will call deliverNotification function. Otherwise notification will not work if user do not allow to it, or do not typed anything on title or body.
     */
    @IBAction func sendRequest(_ sender: Any) {
        if notificationTitle.hasText && notificationContent.hasText {
            let current = UNUserNotificationCenter.current()
                    current.getNotificationSettings(completionHandler: { permission in
                        switch permission.authorizationStatus  {
                        case .authorized:
                            DispatchQueue.main.async {
                                self.deliverNotification(title: self.notificationTitle.text!, body: self.notificationContent.text!, at: self.notificationTime)
                            }
                            print("User granted permission for notification")
                        case .denied:
                            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                            DispatchQueue.main.async {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        case .notDetermined:
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    print("User granted notifications!")
                                } else if let error = error {
                                    print(error.localizedDescription)
                                    UserDefaults.standard.set(false, forKey: "notifications_permissions")

                                }
                            }
                        case .provisional:
                            print("Provisional Status NOT USED")

                        case .ephemeral:
                            print("Ephemeral Status NOT USED")

                        @unknown default:
                            print("Unknow Status NOT USED")
                                   
                        }
                    })
            
        } else {
            print("Both fields are mandatory")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defineTimeToggle = false
        notifyButton.layer.cornerRadius = 10
    }
    
    
    /**
     Prepares notification and dispatch to notification center. If time is defined, the notification will
     only appear to you on the time specified. Otherwise it will notify you in 10 seconds after you clicked.
     */
    func deliverNotification(title: String, body: String, at: UIDatePicker) {
        
        // Defines the datePicker component to set the time if user
        // defined.
        at.datePickerMode = .time
        let actualTime = at.date
        var getTime = DateComponents()
        getTime.hour = at.calendar.component(.hour, from: actualTime)
        getTime.minute = at.calendar.component(.minute, from: actualTime)
        
        // Create the notification content
        let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default
                
        
        // Check timeToggle status.
        if !defineTimeToggle {
            print("Sending in the time specified...")
            let trigger = UNCalendarNotificationTrigger(dateMatching: getTime, repeats: false)
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            print("Sending in few seconds...")
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}

