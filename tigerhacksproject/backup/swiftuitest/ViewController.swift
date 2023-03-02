//
//  ViewController.swift
//  tigerhacks
//
//  Created by Andy on 11/5/22.
//

import UIKit
import UserNotifications
import Darwin
import BackgroundTasks
import Foundation

class ViewController: UIViewController, UITableViewDataSource {

    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    var items = [String]()
    var sundayImportantHours = [Int]()
    var mondayImportantHours = [Int]()
    var tuesdayImportantHours = [Int]()
    var wednesdayImportantHours = [Int]()
    var thursdayImportantHours = [Int]()
    var fridayImportantHours = [Int]()
    var saturdayImportantHours = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter1 = NotificationCenter.default
        notificationCenter1.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        self.sundayImportantHours = UserDefaults.standard.array(forKey: "sundayImportantHours") as? [Int] ?? []
        
        self.mondayImportantHours = UserDefaults.standard.array(forKey: "mondayImportantHours") as? [Int] ?? []
        
        self.tuesdayImportantHours = UserDefaults.standard.array(forKey: "tuesdayImportantHours") as? [Int] ?? []
        
        self.wednesdayImportantHours = UserDefaults.standard.array(forKey: "wednesdayImportantHours") as? [Int] ?? []
        
        self.thursdayImportantHours = UserDefaults.standard.array(forKey: "thursdayImportantHours") as? [Int] ?? []
        
        self.fridayImportantHours = UserDefaults.standard.array(forKey: "fridayImportantHours") as? [Int] ?? []
        
        self.saturdayImportantHours = UserDefaults.standard.array(forKey: "saturdayImportantHours") as? [Int] ?? []
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        title = "To Do List"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(saveSchedule))
    
    }
    
    @objc func appMovedToBackground() {
        scheduleBGTask(calledByBackgroundTask: false)
        //schedule background tasks
        //schedule call to weather api passing or viewing recorded times in schedule
        //schedule send notification immediately
        //schedule another background task
        //report success value of background tasks
    }
    @objc func saveSchedule()
    {
        let dateComponents = DateComponents()
        let dayOfWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1
        let importantHours = getImportantHours(dayOfWeek:dayOfWeek)
        buildNotification(importantHours: importantHours, instant: true)
    }

    
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        print("I made it to handleAppRefresh")
        //get important hours of schedule
        let dateComponents = DateComponents()
        let dayOfWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1
        let importantHours = getImportantHours(dayOfWeek:dayOfWeek)
        //get weather at those hours
        buildNotification(importantHours: importantHours,instant: false)
        //say yay I was successful
        //schedule a background task for tomorrow
        task.setTaskCompleted(success: true)
        scheduleBGTask(calledByBackgroundTask: true)
    }
    
    func getImportantHours(dayOfWeek:Int) -> [Int]
    {
        if(dayOfWeek == 0)
        {
            return sundayImportantHours
        }
        if(dayOfWeek == 1)
        {
            return mondayImportantHours
        }
        if(dayOfWeek == 2)
        {
            return tuesdayImportantHours
        }
        if(dayOfWeek == 3)
        {
            return wednesdayImportantHours
        }
        if(dayOfWeek == 4)
        {
            return thursdayImportantHours
        }
        if(dayOfWeek == 5)
        {
            return fridayImportantHours
        }
        else
        {
            return saturdayImportantHours
        }
        
    }
    
    struct WeatherData: Decodable {
        let resolvedAddress: String
        let days: [WeatherDays]
    }
    
    struct WeatherDays: Decodable {
        let datetime: String
        let cloudcover: Float
        let temp: Float
        let uvindex:Float
        let precipprob:Float
        let hours: [WeatherHours]
    }
    struct WeatherHours: Decodable {
        let datetime: String
        let cloudcover: Float
        let temp: Float
        let uvindex:Float
        let precipprob:Float
        
    }
    
    func buildNotification(importantHours: [Int], instant: Bool)
    {
        let weatherHours = getWeatherHours(importantHours: importantHours)
        let yesterdayAt5 = getWeatherHoursyesterday(importantHours: importantHours)
        //schedule notification for hour = 5
        // Step 2: Create the notification content
         // query apple weather and make comparisons to determine messages we want to send
         // messages = [string]
         // for each string in messages make a request
         // trigger = messages.count > 0; time == 5:00 am

        var defrost = false
        var precipitation = false
        var largeTempChange = false
        var minTemp: Float
        var maxTemp: Float
        let tempYesterday: Float = yesterdayAt5.temp
        var notificationString = ""
        let content = UNMutableNotificationContent()
        if weatherHours.count > 0
        {
            maxTemp = weatherHours[0].temp
            minTemp = maxTemp
            if weatherHours[0].temp < 320.0
            {
                defrost = true
            }
            var maxPrecipChance: Float = 0.0
            for hour in weatherHours
            {
                minTemp = min(minTemp,hour.temp)
                maxTemp = max(maxTemp,hour.temp)
                maxPrecipChance = max(maxPrecipChance,hour.precipprob)
            }
            precipitation = maxPrecipChance > 70.0

            largeTempChange = (maxTemp - minTemp) > 30
            
            if precipitation && minTemp > 32.0
            {
                notificationString += "Looks like it's going to rain, remember to pack an umbrella!"
            }
            if largeTempChange && minTemp < 60
            {
                notificationString += "Uh-oh, it's gonna be chilly. Consider brining an extra layer."
            }
            else if tempYesterday - minTemp > 35
            {
                //these need to be added to conditional notification generation
                notificationString += "It's alot colder than yesterday Bundle up!"
            }
            if largeTempChange && maxTemp > 90
            {
                notificationString += "Wow, it'll get hot. Consider wearing a cool bottom layer."
            }
            else if maxTemp - tempYesterday > 35
            {
                notificationString += "It's alot hotter than yesterday. Dress down a bit."
            }
            if defrost
            {
                notificationString += "It's cold this morning. Do you want to defrost your car?"
            }
            
            content.title = "High of: " + maxTemp.description + " Low of: " + minTemp.description
            content.body = notificationString
        }
        if defrost || precipitation || largeTempChange
        {
            // Step 3: Create the notification trigger
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            let seconds = Calendar.current.component(.second, from: Date())
            if (instant)
            {
                dateComponents.second = seconds + 2
                //overflow?
            }
            else
            {
                dateComponents.hour = 5
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // Step 4: Create the request
            
            let uuidString = UUID().uuidString
            
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            // Step 5: Register the request
            let notificationCenter = UNUserNotificationCenter.current()
            if weatherHours.count > 0
            {
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        print(error.debugDescription)
                    }
                }
            }
        }
    }
    
    
    
    func getWeatherHours(importantHours: [Int]) -> [WeatherHours]
    {
        let session = URLSession.shared
        let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Columbia,MO/2022-11-4T00:00:00?key=&elements=temp,datetime,precipprob,preciptype,uvindex,cloudcover")!
        var weatherHours: [WeatherHours] = []
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
                let weatherTask = session.dataTask(with: url) {
                (data, response, error) in
                guard let data = data else { return }
                
                let weather: WeatherData = try! JSONDecoder().decode(WeatherData.self, from: data)
                for hour in importantHours
                {
                    let weatherDay = weather.days.first!
                    let weatherHour = weatherDay.hours[hour]
                    weatherHours.append(weatherHour)
                }
                group.leave()
            }
            
            weatherTask.resume()
        }
        group.wait()
        
        return weatherHours
    }
    
    
    func getWeatherHoursyesterday(importantHours: [Int]) -> WeatherHours
    {
        let session = URLSession.shared
        let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Columbia,MO/2022-11-3T00:00:00?key=&elements=temp,datetime,precipprob,preciptype,uvindex,cloudcover")!
        var weatherHours: [WeatherHours] = []
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
                let weatherTask = session.dataTask(with: url) {
                (data, response, error) in
                guard let data = data else { return }
                let weather: WeatherData = try! JSONDecoder().decode(WeatherData.self, from: data)
                let weatherDay = weather.days.first!
                let weatherHour = weatherDay.hours[17]
                weatherHours.append(weatherHour)
                group.leave()
            }
            weatherTask.resume()
        }
        group.wait()
        return weatherHours[0]
    }

    
    
    
    func scheduleBGTask(calledByBackgroundTask: Bool) {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.fooBackgroundAppRefreshIdentifier")
        
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        let hours = Calendar.current.component(.hour, from:Date())
        //wait 29 hours minus the current hour minus one
        //if it is 8, then we'll send a notification about the day immediately, and we shouldn't send another until 5 the next day, start processing this at 4, so wait 29 - 8 - 1 = 20 hours to start at 4 the next day
        let hoursToWait = 29 - hours - 1
        let secondsToWait = hoursToWait * 3600
        
        request.earliestBeginDate = Date(timeIntervalSinceNow:Double(secondsToWait))
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule BGTask: \(error)")
        }
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter a new to do list item!",
            preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter item..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text,!text.isEmpty {
                    // Enter new to do list item
                    DispatchQueue.main.async{
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        present(alert,animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    

}

