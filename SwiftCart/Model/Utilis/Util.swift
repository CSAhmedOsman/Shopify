//
//  Utilites.swift
//  SwiftCart
//
//  Created by Elham on 03/06/2024.
//
  
import UIKit
    
public struct Utils {
    
    static func convertTo<T: Decodable>(from data: Data)-> T?{
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let result = try decoder.decode(T.self, from: data)
            return result
            
        } catch let error{
            print(error)
            return nil
        }
    }
    
    static func showAlert(title: String?,
                          message: String?,
                          preferredStyle: UIAlertController.Style,
                          from viewController: UIViewController,
                          actions: [UIAlertAction]? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if let actions {
            for action in actions {
                alertController.addAction(action)
            }
        } else {
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func extractDate(from isoDateString: String) -> String? {
        let isoDateFormatter = ISO8601DateFormatter()
          
          guard let date = isoDateFormatter.date(from: isoDateString) else {
              return "Invalid date"
          }
          
          let now = Date()
          let calendar = Calendar.current
          
          let components = calendar.dateComponents([.day], from: now, to: date)
          
          guard let dayDifference = components.day else {
              return "Invalid date"
          }
          
          if dayDifference == 0 {
              return "today"
          } else if dayDifference == 1 {
              return "1 day from now"
          } else if dayDifference == -1 {
              return "1 day ago"
          } else if dayDifference > 0 {
              if dayDifference < 7 {
                  return "\(dayDifference) days from now"
              } else if dayDifference < 30 {
                  let weekDifference = dayDifference / 7
                  return "\(weekDifference) week\(weekDifference > 1 ? "s" : "") from now"
              } else if dayDifference < 365 {
                  let monthDifference = dayDifference / 30
                  return "\(monthDifference) month\(monthDifference > 1 ? "s" : "") from now"
              } else {
                  let yearDifference = dayDifference / 365
                  return "\(yearDifference) year\(yearDifference > 1 ? "s" : "") from now"
              }
          } else {
              let positiveDayDifference = abs(dayDifference)
              if positiveDayDifference < 7 {
                  return "\(positiveDayDifference) days ago"
              } else if positiveDayDifference < 30 {
                  let weekDifference = positiveDayDifference / 7
                  return "\(weekDifference) week\(weekDifference > 1 ? "s" : "") ago"
              } else if positiveDayDifference < 365 {
                  let monthDifference = positiveDayDifference / 30
                  return "\(monthDifference) month\(monthDifference > 1 ? "s" : "") ago"
              } else {
                  let yearDifference = positiveDayDifference / 365
                  return "\(yearDifference) year\(yearDifference > 1 ? "s" : "") ago"
              }
          }
          
          return isoDateString
    }
    static func getDayOfWeek(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            return "Invalid date"
        }
        let now = Date()
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "today"
        }
        if let dayDifference = calendar.dateComponents([.day], from: date, to: now).day {
            if dayDifference == 1 {
                return "1 day ago"
            } else if dayDifference < 7 {
                return "\(dayDifference) days ago"
            } else if dayDifference < 30 {
                let weekDifference = dayDifference / 7
                return "\(weekDifference) week\(weekDifference > 1 ? "s" : "") ago"
            } else if dayDifference < 365 {
                let monthDifference = dayDifference / 30
                return "\(monthDifference) month\(monthDifference > 1 ? "s" : "") ago"
            } else {
                let yearDifference = dayDifference / 365
                return "\(yearDifference) year\(yearDifference > 1 ? "s" : "") ago"
            }
        }
        return dateString
    }
//  static func getDayOfWeek(from dateString: String) -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        if dateString == dateFormatter.string(from: Date()) {
//            return "Today"
//        }
//        
//        guard let date = dateFormatter.date(from: dateString) else {
//            print("Failed to parse date from string: \(dateString)")
//            return nil
//        }
//        
//        let calendar = Calendar.current
//        let dayOfWeek = calendar.component(.weekday, from: date)
//        
//        switch dayOfWeek {
//        case 1: return "Sunday"
//        case 2: return "Monday"
//        case 3: return "Tuesday"
//        case 4: return "Wednesday"
//        case 5: return "Thursday"
//        case 6: return "Friday"
//        case 7: return "Saturday"
//        default:
//            return nil
//        }
//    }
}
    // MARK: here how to use showAlert
/*
    func showMyAlert() {
        // Define actions
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
             
        // Show alert
        AlertManager.showAlert(title: "Alert",
            message: "SkipBtn is tapped",
            preferredStyle: .alert,
            actions: [defaultAction, cancelAction],
            from: self)
         }
        
/////////////////// OR \\\\\\\\\\\\\\\\\\\\
     
    @IBAction func btnTapped(_ sender: Any) {
        let defaultAction = UIAlertAction(title: "Save", style: .default, handler: { _ in print("Logic here")})
        let destructiveAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        AlertManager.showAlert(title: "Alert",
            message: "SkipBtn is tapped",
            preferredStyle: .alert,
            actions: [defaultAction, destructiveAction, cancelAction],
            from: self)
        }
 
 /////////////////// OR \\\\\\\\\\\\\\\\\\\\
 AlertManager.showAlert(title: "Error!", message: "Pleas enter both email and password", preferredStyle: .alert, actions: [], from: self)
*/
