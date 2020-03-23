//
//  Weather.swift
//  hf_weather
//
//  Created by xc on 2019/12/27.
//  Copyright © 2019 xc. All rights reserved.
//

import Foundation


class Weather{
    
    var temp = 0  // 温度
    var city = "" // 城市
    var codeinfo = 0 // 天气代码
    var errorcode = "" // 错误代码
    
    var icon:String{  // 匹配图片。这里定义的计算属性 我们显示的图片是根据 天气代码 去匹配的
        switch (codeinfo) {
        case 0...3:  // 心知文档中的匹配值
            return "sunny"
        case 4...8:
            return "cloudy2"
        case 9:
            return "overcast"
        case 10:
            return "light_rain"
        case 11...18:
            return "shower3"
        case 19...22:
            return "sonw4"
        case 23...25:
            return "sonw5"
        case 26...38,99:
            return "tstorm1"
        default:
            return "tstorm1"
        }
        
        
    }
    
    
}
