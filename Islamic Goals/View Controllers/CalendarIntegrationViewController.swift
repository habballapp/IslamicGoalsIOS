//
//  CalendarIntegrationViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 31/10/2019.
//  Copyright © 2019 Matz. All rights reserved.
//


import UIKit
import GoogleSignIn
import GTMAppAuth
import GoogleAPIClientForREST


class CalendarIntegrationViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

//    private let kKeychainItemName = "Google Calendar API"
//
//    private let kClientID = "196754706166-qvbin5htgloakp353hemacivun7pjrh7.apps.googleusercontent.com"
//
//    // If modifying these scopes, delete your previously saved credentials by
//    // resetting the iOS simulator or uninstall the app.
////    private let scopes = [kGTLAuthScopeCalendarReadonly]
//
////    private let service = GTLServiceCalendar()
//
//    private let scopes = [kGTLRAuthScopeCalendar]
//
//    fileprivate lazy var calendarService: GTLRCalendarService? = {
//        let service = GTLRCalendarService()
//        service.shouldFetchNextPages = true
//        service.isRetryEnabled = true
//        service.maxRetryInterval = 15
//
//        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
//            let authentication = currentUser.authentication else {
//                return nil
//        }
//
//        service.authorizer = authentication.fetcherAuthorizer()
//        return service
//    }()
//
//    func getEvents(for calendarId: String) {
//        guard let service = self.calendarService else {
//            return
//        }
//
//        // You can pass start and end dates with function parameters
//        let startDateTime = GTLRDateTime(date: Calendar.current.startOfDay(for: Date()))
//        let endDateTime = GTLRDateTime(date: Date().addingTimeInterval(60*60*24))
//
//        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarId)
//        eventsListQuery.timeMin = startDateTime
//        eventsListQuery.timeMax = endDateTime
//
//        _ = service.executeQuery(eventsListQuery, completionHandler: { (ticket, result, error) in
//            guard error == nil, let items = (result as? GTLRCalendar_Events)?.items else {
//                return
//            }
//
//            if items.count > 0 {
//                print(items)
//                // Do stuff with your events
//            } else {
//                // No events
//            }
//        })
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        getEvents(for: "primary")
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
    
        private let scopes = [kGTLRAuthScopeCalendar]
        
        private let service = GTLRCalendarService()
        let signInButton = GIDSignInButton()
        let output = UITextView()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Configure Google Sign-in.
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().scopes = scopes
            
            // Add the sign-in button.
            view.addSubview(signInButton)
            
            // Add a UITextView to display output.
            output.frame = view.bounds
            output.isEditable = false
            output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
            output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            output.isHidden = true
            view.addSubview(output);
        }
        
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                  withError error: Error!) {
            if let error = error {
                showAlert(title: "Authentication Error", message: error.localizedDescription)
                self.service.authorizer = nil
            } else {
                self.signInButton.isHidden = true
                self.output.isHidden = false
                self.service.authorizer = user.authentication.fetcherAuthorizer()
//                fetchEvents()
            }
        }
        
        // Construct a query and get a list of upcoming events from the user calendar
        func fetchEvents() {
            let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
            query.maxResults = 10
//            query.timeMin = GTLRDateTime(date: Date())
            query.singleEvents = true
            query.orderBy = kGTLRCalendarOrderByStartTime
            service.executeQuery(
                query,
                delegate: self,
                didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
        }
        
        // Display the start dates and event summaries in the UITextView
    @objc func displayResultWithTicket(
            ticket: GTLRServiceTicket,
            finishedWithObject response : GTLRCalendar_Events,
            error : NSError?) {
            
            if let error = error {
                showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            var outputText = ""
            if let events = response.items, !events.isEmpty {
                for event in events {
                    let start = event.start!.dateTime ?? event.start!.date!
                    let startString = DateFormatter.localizedString(
                        from: start.date,
                        dateStyle: .short,
                        timeStyle: .short)
                    outputText += "\(startString) - \(event.summary!)\n"
                }
            } else {
                outputText = "No upcoming events found."
            }
            output.text = outputText
        }
        // Create an event to the Google Calendar's user
        func addEventoToGoogleCalendar(summary : String, description :String, startTime : String, endTime : String) {
            let calendarEvent = GTLRCalendar_Event()
            
            calendarEvent.summary = "\(summary)"
            calendarEvent.descriptionProperty = "\(description)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let startDate = dateFormatter.date(from: startTime)
            let endDate = dateFormatter.date(from: endTime)
            
            guard let toBuildDateStart = startDate else {
                print("Error getting start date")
                return
            }
            guard let toBuildDateEnd = endDate else {
                print("Error getting end date")
                return
            }
            calendarEvent.start = buildDate(date: toBuildDateStart)
            calendarEvent.end = buildDate(date: toBuildDateEnd)
            
            let insertQuery = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "primary")
            
            service.executeQuery(insertQuery) { (ticket, object, error) in
                if error == nil {
                    print("Event inserted")
                } else {
                    print(error)
                }
            }
        }
        
        // Helper to build date
        func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
            let datetime = GTLRDateTime(date: date)
            let dateObject = GTLRCalendar_EventDateTime()
            dateObject.dateTime = datetime
            return dateObject
        }
        
        // Helper for showing an alert
        func showAlert(title : String, message: String) {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: UIAlertController.Style.alert
            )
            let ok = UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil
            )
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }

}
