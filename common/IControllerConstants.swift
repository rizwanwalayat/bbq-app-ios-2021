//
//  IControllerConstants.swift
//  Aduro
//
//  Created by Macbook Pro on 13/07/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import Foundation


 struct IControllerConstants {
    

    
    static var boilerTemp="boiler_temp"
    static var boilerRef = "boiler_ref"
    static var content = "content"
    static var dhwTemp = "dhw_temp"
    static var dhwRef = "dhw_ref"
    static var dhwValveState = "dhw_valve_state"
    static var state = "state"
    static var substateSec = "substate_sec"
    static var substate = "substate"
    static var ashClean = "ash_clean"
    
    static var compressorClean = "compressor_clean"
    static var boilerPumpState = "boiler_pump_state"
    static var houseValveState = "house_valve_state"
    static var housePumpState = "house_pump_state"
    static var house2PumpState = "house2_pump_state"
    static var exhaustSpeed = "exhaust_speed"
    
    static var offOnAlarm = "off_on_alarm"
    static var chillOut = "chill_out"
    static var externalTemp = "external_temp"
    static var forwardTemp = "forward_temp"
    static var forwardRef = "forward_ref"
    static var meanOutTemp = "mean_out_temp"
    static var distance = "distance"
    static var pressure = "pressure"
    
    static var feedHigh = "feed_high"
    static var feedLow = "feed_low"
    static var oxygen = "oxygen"
    static var oxygenRef = "oxygen_ref"
    static var photoLevel = "photo_level"
    static var corrLow = "corr_low"
    static var corrHigh = "corr_high"
    static var powerKw = "power_kw"
    
    static var returnTemp = "return_temp"
    static var flow1 = "flow1"
    static var corrMedium = "corr_medium"
    static var shaftTemp = "shaft_temp"
    static var powerPct = "power_pct"
    static var smokeTemp = "smoke_temp"
    static var internetUptime = "internet_uptime"
    static var sunPumpspeed = "sun_pumpspeed"
    
    static var sunTemp = "sun_temp"
    static var sun2Temp = "sun2_temp"
    static var sunPowerKw = "sun_power_kw"
    static var sunDhwTemp = "sun_dhw_temp"
    static var city = "city"
    static var outdoorTemp = "outdoor_temp"
    static var house2ValveState = "house2_valve_state"
    static var clouds = "clouds"
    
    
    static var mean2OutTemp = "mean2_out_temp"
    static var humidity = "humidity"
    static var windDirection = "wind_direction"
    static var chill2Out = "chill2_out"
    static var airPressure = "air_pressure"
    static var windSpeed = "wind_speed"
    static var forward2Temp = "forward2_temp"
    
    static var forward2Ref = "forward2_ref"
    static var boilerDiffOver = "boiler.diff_over"
    static var augerKwMin = "auger.kw_min"
    static var augerKwMax = "auger.kw_max"
    static var augerAugerCapacity = "auger.auger_capacity"
    static var hot_waterDiffUnder = "hot_water.diff_under"
    
    
    static var hotWaterOutput = "hot_water.output"
    static var hotWaterTimer = "hot_water.timer"
    static var regulationBoilerGainI = "regulation.boiler_gain_i"
    static var regulationBoilerGainP = "regulation.boiler_gain_p"
    static var hopperTrip1 = "hopper.trip1"
    
    static var hopperTrip2 = "hopper.trip2"
    static var hopperAugerCapacity = "hopper.auger_capacity"
    static var wifiRouter = "wifi.router"
    static var cleaningOutputAsh = "cleaning.output_ash"
    static var cleaningOutputBurner = "cleaning.output_burner"
    
    static var cleaningOutputBoiler1 = "cleaning.output_boiler1"
    static var cleaningOutputBoiler2 = "cleaning.output_boiler2"
    static var cleaningPressureT7 = "cleaning.pressure_t7"
    static var pumpOutput = "pump.output"
    static var pumpStartTempRun = "pump.start_temp_run"
    
    static var pumpStartTempIdle = "pump.start_temp_idle"
    static var weatherActive = "weather.active"
    static var weatherOutputPump = "weather.output_pump"
    static var weatherOutputUp = "weather.output_up"
    static var weatherOutputDown = "weather.output_down"
    
    static var weather2Active = "weather2.active"
    static var weather2OutputPump = "weather2.output_pump"
    static var weather2OutputUp = "weather2.output_up"
    static var weather2OutputDown = "weather2.output_down"
    static var fanOutputExhaust = "fan.output_exhaust"
    
    static var fanExhaust10 = "fan.exhaust_10"
    static var fanExhaust50 = "fan.exhaust_50"
    static var fanExhaust100 = "fan.exhaust_100"
    static var sunOutputPump = "sun.output_pump"
    static var sunOutputExcess = "sun.output_excess"
    static var consumptionMidnight = "consumption_midnight"
    
    static var consumptionTotal = "consumption_total"
    static var consumptionHeatVvb = "consumption_heat_vvb"
    static var time = "time"
    static var sunPumpState = "sun_pump_state"
    static var sunSurplusState = "sun_surplus_state"
    static var stateSuper = "state_super"
    static var stateSec = "state_sec"
    
    
    static var regulationFixedPower = "regulation.fixed_power"
    static var operationMode = "operation_mode"
    static var coYellow = "co_yellow"
    static var coRed = "co_red"
    static var setupvarmluftSetpunkt = "setup.static varmluft_setpunkt"
    static var driftBackPressure = "drift.back_pressure"
    
    static var driftvarmeblaeserPct = "drift.static varmeblaeser_pct"
    static var driftT1Temp = "drift.t1_temp"
    static var driftWifiLoad = "drift.wifi_load"
    static var driftCo = "drift.co"
    static var setupMinBeholdning = "setup.min_beholdning"
    
    static var compressorCountdown = "compressor_countdown"
    static var driftVacuumAktiv = "drift.vacuum_aktiv"
    static var vacuumTime = "vacuum_time"
    static var driftAskeskuffekontakt = "drift.askeskuffekontakt"
    static var driftAskeskuffeMinutter = "drift.askeskuffe_minutter"
    
    static var boilerTime = "boiler.time"
    static var vacuumMinDistance = "vacuum_min_distance"
    static var vacuumMaxDistance = "vacuum_max_distance"
    static var cloudUrl = "cloud_url"
    static var timeAuger = "time_auger"
    static var timeIgnition = "time_ignition"
    
    static var runTimePelletsburning = "run_time_pelletsburning"
    static var runTimeWoodburning = "run_time_woodburning"
    static var ignitionCount = "ignition_count"
    static var wirelessSensorStatus = "wireless_sensor_status"
    
    static var wiredRoomtemperatureReading = "wired_roomtemperature_reading"
    static var woodburningActive = "woodburning_active"
    static var dateTime = "date_time"
}
