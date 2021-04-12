//
//  NotificationViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 09/02/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import UIKit
import SQLite
import ExpandableLabel

class NotificationViewController: UIViewController,UITextViewDelegate{
 
    let concurrentQueue = DispatchQueue(label: "notification Queue", attributes: .concurrent)
    
    var list : [NotificationModal] = []
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    var fromclick=false
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
       
    }
    
    
    //MARK: Setup
    func setup () {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.allowsSelection=true
        concurrentQueue.async {
            self.getform()
        }
    }

    @IBAction func finish(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    
    
    func getform()  {
        
            let Stringtoencode = "https://aduro.prevas-dev.pw/api/gateway/" + ControllerconnectionImpl.getInstance().getController().getSerial() + "/" +
                ControllerconnectionImpl.getInstance().getController().getPassword() + "/messages"
            if let encoded = Stringtoencode.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            {
                let url = URL(string: encoded)
                      var request = URLRequest(url: url!)
                      request.httpMethod = "GET"
                      NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main)
                      {(response, data, error) in
                        guard let data = data else { return }
                        print(String(data: data, encoding: .utf8)!)
//                        let value = String(data: data, encoding: .utf8)!
                        let decoder = JSONDecoder()
                        do {
                            self.list = try decoder.decode([NotificationModal].self,from: data)
                            self.list.reverse()
                            self.tableView.reloadData()
                            self.DbWork()
                        } catch let DecodingError.dataCorrupted(context) {
                            print(context)
                        } catch let DecodingError.keyNotFound(key, context) {
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.valueNotFound(value, context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.typeMismatch(type, context)  {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch {
                            print("error: ", error)
                        }
                        
                       
//                        print(list.count)
                      
                        
                      }
                
            }

        
      
    }
    func DbWork()  {
        
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            do {
                let db = try Connection("\(path)/db.sqlite3")
                if db.userVersion == 0 {
                    // handle first migration
                    db.userVersion = 1
                }
                let notification = Table("notification")
                let id = Expression<Int64>("id")
                let epoch = Expression<String>("epoch")
                let serial = Expression<String?>("serial")
                let isRead = Expression<Bool>("isRead")
                let message = Expression<String>("message")
                let isReadFromApp = Expression<Bool>("isReadFromApp")
                let alice = notification.filter(serial == ControllerconnectionImpl.getInstance().getController().getSerial())
                try db.run(alice.update(isReadFromApp <- true))
            }catch let error
            {
                print(error)
            }
    }

    func detectString(string:String,textField : UITextView)   {
        let input = string
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let url = input[range]
//            print(url)
            let attributedString = NSMutableAttributedString(string: string,attributes: [NSAttributedString.Key.font:textField.font?.withSize(20)])
            attributedString.addAttribute(.link, value: url, range: NSRange(location: match.range.location, length: match.range.length))
            textField.attributedText = attributedString
            textField.textColor=UIColor.white
            textField.isUserInteractionEnabled = true
        }
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        print(URL)
        UIApplication.shared.open(URL)
        return false
    }

    
}

//MARK: - notification struct
struct NotificationModal: Decodable {
    let epoch: Int
    let message: String
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(NotificationTableViewCell.self, indexPath: indexPath)
        cell.message.text = list[indexPath.row].message
        cell.message.delegate=self
//        if let timeResult = (TimeInterval(list[indexPath.row].epoch)) {
            let date = Date(timeIntervalSince1970: TimeInterval(list[indexPath.row].epoch))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
            cell.dateTime.text = localDate
        if(!fromclick)
        {
            
            if(list[indexPath.row].message.count>200)
            {
                let string = list[indexPath.row].message
                let index = string.index(string.startIndex, offsetBy: 200)
                let mySubstring = string[..<index]
                cell.message.text = String(mySubstring)+"..."

//                detectString(string: String(mySubstring)+" ...",textField: cell.message)
            }else
            {
                cell.message.text = list[indexPath.row].message

//                detectString(string: list[indexPath.row].message,textField: cell.message)
            }
        }else
        {
            cell.message.text = list[indexPath.row].message

//                detectString(string: list[indexPath.row].message,textField: cell.message)

        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell = tableView.cellForRow(at: indexPath) as? NotificationTableViewCell
        fromclick=true
        tableView.reloadData()
    }
}
