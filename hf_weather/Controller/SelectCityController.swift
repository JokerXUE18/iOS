//
//  SelectCityController.swift
//  hf_weather
//
//  Created by xc on 2020/1/4.
//  Copyright © 2020 xc. All rights reserved.
//

import UIKit

// 定义协议用来处理用户点击查询后能跳转到第一个页面 这是第一步
protocol SelectCityDelegate {
    func didChangeCity(city:String)  // 点击按钮后处理的函数 接收用户传入的城市名
    
}


class SelectCityController: UIViewController {

    var currentCity = ""
    // 第二步  告诉别人这个工具是谁在使用
    var delegate:SelectCityDelegate?  // 加问号是因为 用户可能没有点击查询 那么就不用执行这个方法

    
    @IBOutlet weak var currentCityLable: UILabel!
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var cityInput: UITextField!  // 用户输入框
    // 第三步 在哪里触发函数 在哪里使用工具
    @IBAction func changeCity(_ sender: Any) {
        
        delegate?.didChangeCity(city:cityInput.text ?? "北京")  //  cityInput.text用户输入的文字
        dismiss(animated: true, completion: nil)  // dismiss销毁当前页面 animated是否销毁。completion销毁后需要做什么？
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        currentCityLable.text = currentCity

    }

    

    /*
    // MARK: - Navigation  导航

    //在基于storyboard-based的应用程序中，您通常需要在导航之前做一些准备工作
    // In a storyboard-based application, you will often want to do a little preparation before navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        // 使用segue.destination获取新的视图控制器。
        // Get the new view controller using segue.destination.
     
        // 将选择的对象传递给新的视图控制器。
        // Pass the selected object to the new view controller.
    }
    */

}
