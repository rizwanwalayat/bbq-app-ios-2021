//
//  ControllerResponseImpl.swift
//  BBQ
//
//  Created by Macbook Pro on 24/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation


class ControllerResponseImpl: ControllerResponse {
    

    var identifiersold = [ "boiler_temp","boiler_ref","content","dhw_temp","dhw_ref","dhw_valve_state","state","substate_sec","substate","ash_clean","compressor_clean","boiler_pump_state","house_valve_state","house_pump_state","house2_pump_state","exhaust_speed","off_on_alarm","chill_out","external_temp" ,"forward_temp" ,"forward_ref" ,"mean_out_temp" ,"distance","pressure" ,"feed_high","feed_low","oxygen","oxygen_ref" ,"photo_level","corr_low" ,"corr_high" ,"power_kw" ,"return_temp","flow1" ,"corr_medium" ,"shaft_temp","power_pct" ,"smoke_temp","internet_uptime","sun_pumpspeed" ,"sun_temp" ,"sun2_temp" ,"sun_power_kw" ,"sun_dhw_temp" ,"city","outdoor_temp" ,"house2_valve_state" ,"clouds" ,"mean2_out_temp" ,"humidity" ,"wind_direction" ,"chill2_out" ,"air_pressure" ,"wind_speed" ,"forward2_temp" ,"forward2_ref" ,"boiler.diff_over","auger.kw_min","auger.kw_max","auger.auger_capacity","hot_water.diff_under","hot_water.output" ,"hot_water.timer" ,"regulation.boiler_gain_i","regulation.boiler_gain_p","hopper.trip1" ,"hopper.trip2" ,"hopper.auger_capacity","wifi.router","cleaning.output_ash","cleaning.output_burner","cleaning.output_boiler1","cleaning.output_boiler2","cleaning.pressure_t7" ,"pump.output","pump.start_temp_run","pump.start_temp_idle","weather.active" ,"weather.output_pump" ,"weather.output_up" ,"weather.output_down" ,"weather2.active" ,"weather2.output_pump" ,"weather2.output_up" ,"weather2.output_down" ,"fan.output_exhaust","fan.exhaust_10","fan.exhaust_50","fan.exhaust_100","sun.output_pump" ,"sun.output_excess" ,"consumption_midnight" ,"consumption_total","consumption_heat_vvb","time","sun_pump_state" ,"sun_surplus_state" ,"state_super","state_sec" ,"regulation.fixed_power","operation_mode","co_yellow","co_red","setup.varmluft_setpunkt","drift.back_pressure" ,"drift.varmeblaeser_pct" ,"drift.t1_temp" ,"drift.wifi_load","drift.co" ,"setup.min_beholdning" ,"compressor_countdown","drift.vacuum_aktiv" ,"vacuum_time" ,"drift.askeskuffekontakt" ,"drift.askeskuffe_minutter" ,"boiler.timer","vacuum_min_distance","vacuum_max_distance","cloud_url" ,"time_auger","time_ignition","run_time_pelletsburning" ,"run_time_woodburning","ignition_count","wireless_sensor_status" ,"wired_roomtemperature_reading","woodburning_active"]
    
      var identifiersold1 = [ "boiler_temp","boiler_ref","content","dhw_temp","dhw_ref","dhw_valve_state","state","substate_sec","substate","ash_clean","compressor_clean","boiler_pump_state","house_valve_state","house_pump_state","house2_pump_state","exhaust_speed","off_on_alarm","chill_out","external_temp","forward_temp","forward_ref","mean_out_temp","distance","pressure","feed_high","feed_low","oxygen","oxygen_ref","photo_level","corr_low","corr_high","power_kw","return_temp","flow1","corr_medium","shaft_temp","power_pct","smoke_temp","internet_uptime","sun_pumpspeed","sun_temp","sun2_temp","sun_power_kw","sun_dhw_temp","city","outdoor_temp","house2_valve_state","clouds","mean2_out_temp","humidity","wind_direction","chill2_out","air_pressure","wind_speed","forward2_temp","forward2_ref","boiler.diff_over","auger.kw_min","auger.kw_max","auger.auger_capacity","hot_water.diff_under","hot_water.output","hot_water.timer","regulation.boiler_gain_i","regulation.boiler_gain_p","hopper.trip1","hopper.trip2","hopper.auger_capacity","wifi.router","cleaning.output_ash","cleaning.output_burner","cleaning.output_boiler1","cleaning.output_boiler2","cleaning.pressure_t7","pump.output","pump.start_temp_run","pump.start_temp_idle","weather.active","weather.output_pump","weather.output_up","weather.output_down","weather2.active","weather2.output_pump","weather2.output_up","weather2.output_down","fan.output_exhaust","fan.exhaust_10","fan.exhaust_50","fan.exhaust_100","sun.output_pump","sun.output_excess","consumption_midnight","consumption_total","consumption_heat_vvb","time","sun_pump_state","sun_surplus_state","state_super","state_sec","regulation.fixed_power","operation_mode","co_yellow","co_red","setup.varmluft_setpunkt","drift.back_pressure","drift.varmeblaeser_pct","drift.t1_temp","drift.wifi_load","drift.co","setup.min_beholdning","compressor_countdown","drift.vacuum_aktiv","vacuum_time","drift.askeskuffekontakt","drift.askeskuffe_minutter","boiler.time","vacuum_min_distance","vacuum_max_distance","cloud_url","time_auger","time_ignition","run_time_pelletsburning","run_time_woodburning","ignition_count","wireless_sensor_status","wired_roomtemperature_reading","woodburning_active"]
    
    var identifiers = [ "bbq_temperature","bbq_temperature_1","bbq_temperature_2","bbq_temperature_3","meat_temperature_1","meat_temperature_2","shaft_temperature","light_level","milli_ampere","milli_ampere_ignition","power_pct","power_pct_p","power_pct_i","state","state_seconds","wifi_load","output","download_progress","flags-sleep","flags-smoke","flags-ignite","program_version","program_build","diffsum","bbq.use_buzzer","bbq.fixed_temperature","bbq.fixed_power","bbq.meat_temp_1","bbq.meat_temp_2","general.feed_low","general.feed_high","general.fan_low","general.fan_high","general.ignition_heat","general.gain_p","general.gain_i","general.rotation_time","general.rotation_active","smoke.level","smoke.feed","smoke.fan","smoke.timer","general.shutdown_time","general.operation_heat","general.shaft_alarm","download.result","smoke.pause", "super_state", "date_time", "buzzer_1_active", "buzzer_2_active", "misc.temp_unit", "general.fan_shutdown"] 
    
    var functionId : String = ""
    var statusCode : String = ""
    var sequenceNumber : String = ""
    var payloadSize : Int = 0
    var payload : String = ""
    
    
    func setfunctionID(id:String)  {
        self.functionId=id
    }
    
    func setstatusCode(code:String) {
        self.statusCode=code
    }
    func getFuncId() -> String {
      return  self.functionId
    }
    func getStatusCode() -> String {
        return self.statusCode
    }
    
    func getPayload() -> String {
        return self.payload
    }
    func setpayload(payload: String) {
        self.payload=payload
    }
    func GetReadValue() -> Dictionary<String,String>
    {
        var emptyDict: [String: String] = [:]
//        print("got payload : " + payload)
        if(payload.contains("nothing"))
        {
            
        }else
        {
            let temp = self.payload
            if(temp != "")
            {
                
                var item = self.payload.split(separator: ";")
                if(item[0] != nil && item[0].contains("networklist") )
                {
//                    print("network list closure")
//                    emptyDict = ["network_list" : String(item[0])]
                    item[0] = String.SubSequence(item[0].replacingOccurrences(of: "networklist=", with: ""))
                    return self.parseNetworkListResponse(data : item)
                }
                
                for value in item
                {
                    let keyValue = value
                    var keyvaluepart = keyValue.split(separator: "=", maxSplits: .max, omittingEmptySubsequences: false)
                     emptyDict[String(keyvaluepart[0])] = String(keyvaluepart[1])
                }
            }
         
        }
      
        return emptyDict
    }
    
    func getMinMaxValue() -> Dictionary<String,String> {
         var emptyDict: [String: String] = [:]
        if(payload.contains("nothing"))
        {
            
        }else
        {
             let temp = self.payload
            if(temp != "")
            {
                var item = self.payload.split(separator: ";")
                for value in item
                {
                    let keyValue = value
                    var keyvaluepart = keyValue.split(separator: "=", maxSplits: .max, omittingEmptySubsequences: false)
                    emptyDict[String(keyvaluepart[0])] = String(keyvaluepart[1])
                }

            }
        }
        return emptyDict

    }
    func GetReadValueForKeyExchange() -> Dictionary<String,String>
    {
        var emptyDict: [String: String] = [:]
        //        print("got payload : " + payload)
        if(payload.contains("nothing"))
        {
            
        }else
        {
            let temp = self.payload
            if(temp != "")
            {
                
                var item = self.payload.split(separator: ";")
                if(item[0] != nil && item[0].contains("networklist") )
                {
                    //                    print("network list closure")
                    //                    emptyDict = ["network_list" : String(item[0])]
                    item[0] = String.SubSequence(item[0].replacingOccurrences(of: "networklist=", with: ""))
                    return self.parseNetworkListResponse(data : item)
                }
                
                for value in item
                {
                    let keyValue = value
                    var keyvaluepart = keyValue.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
                    if(keyvaluepart.count > 1)
                    {
                        emptyDict=[String(keyvaluepart[0]):String(keyvaluepart[1])]
                    }
                }
            }
            
        }
        
        return emptyDict
    }
    
    
    func getDiscoveryValues() -> [String] {
         var values = [String]()
        if(payload.contains("nothing"))
        {
            
        }else
        {
            
            let payloads = self.payload.split(separator: ";")
            if(payloads[0].contains("Illegal"))
            {
                
            }else
            {
                if(payloads.count > 3)
                {

                    var elements = String(payloads[1]).split(separator: "=")
                    values.append( String(elements[1]))
                    elements = String(payloads[0]).split(separator: "=")
                    values.append(String(elements[1]))
                    elements = String(payloads[2]).split(separator: "=")
                    values.append(String(elements[1]))
                    elements = String(payloads[3]).split(separator: "=")
                    values.append(String(elements[1]))
                    elements = String(payloads[4]).split(separator: "=")
                    values.append(String(elements[1]))
                }
            }

            
        }
       
//        index position
//        0=ip,serial=1,type=2,ver=3,build=4
        return values
    }
    func parseNetworkListResponse(data : [String.SubSequence]) -> Dictionary<String,String>
    {
        var map: [String: String] = [:]
        for item in data
        {
            print(item)
            var split = item.split(separator: ",")
            print(split[0])
            print(split[1])
            map.updateValue(String(split[1]), forKey: String(split[0]))
//            map = [String(split[0]):String(split[1])]
        }
        return map
    }
    func setData(response: Data)
    {
        
        let byteArray = [UInt8](response)
        var idx = 18

        if (String(byteArray[idx]) != "2") {
            print("No STX start character")
        }else{
//            print("STX found")
            idx+=1
        }
        var functionIdStr : [UInt8] = [UInt8]()
        functionIdStr.append(byteArray[idx])
        idx+=1
        functionIdStr.append(byteArray[idx])
        functionId=String(bytes:functionIdStr, encoding: String.Encoding.ascii)!
        
        idx+=1
        functionIdStr.removeAll()
        functionIdStr.append(byteArray[idx])
        idx+=1
        functionIdStr.append(byteArray[idx])
        sequenceNumber=String(bytes:functionIdStr, encoding: String.Encoding.ascii)!
        
        
        idx+=1
        functionIdStr.removeAll()
        functionIdStr.append(byteArray[idx])
        statusCode=String(bytes:functionIdStr, encoding: String.Encoding.ascii)!
        
        idx+=1
        functionIdStr.removeAll()
        functionIdStr.append(byteArray[idx])
        idx+=1
        functionIdStr.append(byteArray[idx])
        idx+=1
        functionIdStr.append(byteArray[idx])
        payloadSize=Int(String(bytes:functionIdStr, encoding: String.Encoding.ascii)!)!
        
        idx+=1
        functionIdStr.removeAll()
        payload=String(bytes: copyOfRange(arr: byteArray, from: idx, to: idx + payloadSize)!, encoding: String.Encoding.ascii)!
        idx += payloadSize
        
        idx+=1
        
//        print("functionId " + functionId)
//        print("sequenceNumber " + sequenceNumber)
//        print("statusCode " + statusCode)
//        print(payloadSize)
//        print("payload " + payload)
//        print(idx)
//        print(byteArray.count)
//        let rsa=GetReadValue(payload: self.payload)["rsa_key"]
//        print(rsa!)
        
//        RSAHelper().loadPubKey(key: rsa!)
    }
    
    
    func getF11Values() -> [String:String] {
        var returnvalue : [String : String] = [:]

        if(self.functionId == "11" && self.statusCode == "0")
        {
            var list = self.payload.split(separator: ",", maxSplits: Int.max , omittingEmptySubsequences: false)
//            print(list)
            let count = list.count < identifiers.count ? list.count : identifiers.count
            
            for number in 0...count-1
            {
                //    print(list[number])
                returnvalue[identifiers[number]] = String(list[number])
            }
//            print(returnvalue)
            return returnvalue
        }
        else
        {
            return returnvalue
        }
        
    }
    
    
    
    
    
    func copyOfRange<T>(arr: [T], from: Int, to: Int) -> [T]? where T: ExpressibleByIntegerLiteral {
        guard from >= 0 && from <= arr.count && from <= to else { return nil }
        
        var to = to
        var padding = 0
        
        if to > arr.count {
            padding = to - arr.count
            to = arr.count
        }
        
        return Array(arr[from..<to]) + [T](repeating: 0, count: padding)
    }
    
}
