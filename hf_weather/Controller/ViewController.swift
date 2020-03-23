//
//  ViewController.swift
//  hf_weather
//
//  Created by xc on 2019/12/16.
//  Copyright © 2019 xc. All rights reserved.
//


/*
https://developer.apple.com/documentation/corelocation/cllocationmanager
*/

import UIKit
import CoreLocation  // 这就是用于获取用户位置信息的库
import Alamofire  // 导入网络请求功能模块 用于接收API返回的数据
import SwiftyJSON
import RealmSwift
// CLLocationManagerDelegate是一个协议。https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate

class ViewController: UIViewController{
    
    let locationManager = CLLocationManager()  // 实例化 CLLocationManager就是用来就收位置等多种信息的委托人
    
    let weather = Weather()  // 创建模型后必须初始化才能使用
    
    @IBOutlet weak var cityname: UILabel!  // 城市名控件
    @IBOutlet weak var tempLable: UILabel!  // 温度控件
    @IBOutlet weak var imageView: UIImageView!  // 图片控件
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        // app每启动一次就会执行一次这里的代码
        super.viewDidAppear(animated)
        
    /*官网文档地址：https://developer.apple.com/documentation/corelocation/cllocationmanager/1620562-requestwheninuseauthorization
        */
        
        locationManager.requestWhenInUseAuthorization()  // 使用应用程序时允许其使用位置服务。请求授权
        
        // 授权后获取位置 设置精度 https://developer.apple.com/documentation/corelocation/cllocationmanager/1423836-desiredaccuracy
        
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer  // 精准到公里
        locationManager.requestLocation()  // 只需要获取位置一次
        
    }
        
        // 既然代码中出现了协议我们就必须要准守一些协议
        // 当用户请求位置后立刻调用这个方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let lat = locations[0].coordinate.latitude
        let lon = locations[0].coordinate.longitude
            
        let new1 = "\(lat):\(lon)"
        
        
        let cityname1 = new1
        
        let paras = ["key":"St0JmzTXOl75av24Q","location":"\(cityname1)","language":"zh-Hans","unit":"c"]
        
        getWeather(paras: paras)
       
            }
    
    // 页面传值：！！！重点！！ 首先我们在创建第二个页面的文件时 有一段预置代码 那么下面这段代码就是负责页面传值的主要代码
    
    // sender 用户按下
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        // 使用segue.destination获取新的视图控制器。那么这个新的视图控制器就是SelectCityController  segue是两个页面之间的连线 同时使用它来判断用户到底要进入哪个页面
        // Get the new view controller using segue.destination.
     
        // 将选择的对象传递给新的视图控制器。就是你将这些值传递给谁的意思
        // Pass the selected object to the new view controller.
        
        // identifier根据页面设置的ID去找到对应的页面
        if segue.identifier == "selectCity"{   //  selectCity来自中间的线 点击两个页面直接的线就能看到id名
            
            //  segue.destination就是等于SelectCityController控制器 这样的话就可以访问第二个页面的属性和方法
            let vc = segue.destination as! SelectCityController
            vc.currentCity = weather.city //  这样就把第一个页面的数据传递给了第二个页面
            print(weather.city)
            
            //  反向传值 第四步 确定使用者是第二个页面
            vc.delegate = self
            
            
        }
        
    }
    

    
    
}

// 反向传值 第五步 遵守SelectCityDelegate协议
extension ViewController:CLLocationManagerDelegate,SelectCityDelegate{  // 将ViewController的功能进行扩展 其实和写在ViewController里 效果一样
    
    //  反向传值 第六步 实现必须要的方法
    func didChangeCity(city:String) {
        let paras = ["key":"St0JmzTXOl75av24Q","location":city,"language":"zh-Hans","unit":"c"]
        getWeather(paras: paras)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error)
    }
    func getWeather(paras:[String:String]){  // 代码中paras是一个字典 通过外界传入 自然就需要接收传入的字典
        // 这这段代码本身是在locationManager函数里 为了优化所以写在这里
         // 这段代码来自于 https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#chained-response-handlers
    // 解释一下parameters 这个可以让你的api扩展性更强 详情见幕布
    Alamofire.request("https://api.seniverse.com/v3/weather/now.json",parameters: paras).responseJSON { response in
        if let json = response.value{ // 或者是 response.result.value
//                    print(json)
            let weatherInfo = JSON(json)
            print(weatherInfo)
            
            // 回调函数中使用其他函数要加self
            self.createWeather(weatherInfo: weatherInfo)
            
            self.updateUI()
                            
        }
    }
}
    func createWeather(weatherInfo:JSON){  // 将给模型赋值的代码封装为函数
        // 这里的控件没有在回调函数中执行 所以不用加self
        weather.city = weatherInfo["results"][0]["location","name"].stringValue // 获取城市名并赋值给模型中的city变量
        weather.temp =  Int(round(weatherInfo["results"][0]["now","temperature"].doubleValue))
        weather.codeinfo = weatherInfo["results"][0]["now","code"].intValue
        weather.errorcode = weatherInfo["status_code"].stringValue
        
        
        
}

    func updateUI(){  // UI界面数据更新
        cityname.text = weather.city  // 我们这里不直接写weatherInfo["results"][0]["location","name"].stringValue是因为MVC模式中最好是通过模型去赋值 找专人做专事
        tempLable.text = "\(weather.temp)˚"
        imageView.image = UIImage(named: weather.icon)  // 这里的文件名来自模型 通过计算属性匹配后的值 named属于UIImage的初始化方法 传入后可以根据图片名从Assets.xcassets给控件添加图片https://developer.apple.com/documentation/uikit/uiimage/1624146-init
        errorcodefun(errorcode: weather.errorcode)
        
        
    }
    func errorcodefun(errorcode:String){
        print(123)
        if errorcode == "AP010010"{
            cityname.text = "你输入的地点有误"
            imageView.image = UIImage(named: "Cloud-Refresh")
            print(456)
        }

        
        
    }

}


