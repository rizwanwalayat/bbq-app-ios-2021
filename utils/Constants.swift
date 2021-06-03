//
//  Constants.swift
//  Aduro
//
//  Created by Macbook Pro on 02/03/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import Foundation


class Constants {
    static var serialKey:String="serial"
    static var passwordKey:String="password"
    static var languageKey:String="lang"
    static var term1Accept="term1"
    static var term2Accept="term2"
    static var directConnectFlag="directConnectFlag"
    static var secondtime="secondTime"
    static var version=2
    static var build=53
    static var bbqView = "bbqView"
}

class Values {
    static var flags_smoke = "flags-smoke"
    static var flags_ignite = "flags-ignite"
    static var state = "state"
    static var flags_sleep = "flags-sleep"
    static var power_pct: String = "power_pct"
    static var bbq_temperature: String = "bbq_temperature"
    static var bbq_temperature_1: String = "bbq_temperature_1"
    static var bbq_temperature_2: String = "bbq_temperature_2"
    static var bbq_temperature_3: String = "bbq_temperature_3"
    static var meat_temperature_1: String = "meat_temperature_1"
    static var meat_temperature_2: String = "meat_temperature_2"
    static var buzzer_1_active: String = "buzzer_1_active"
    static var buzzer_2_active: String = "buzzer_2_active"
    static var super_state: String = "super_state"
}

class general {
    static var rotation_active: String = "general.rotation_active"
    static var rotation_time: String = "general.rotation_time"
    static var feed_low: String = "general.feed_low"
    static var feed_high: String = "general.feed_high"
    static var fan_low: String = "general.fan_low"
    static var fan_high: String = "general.fan_high"
    static var factory: String = "general.factory"
    static var ignition_heat: String = "general.ignition_heat"
    static var operation_heat: String = "general.operation_heat"
    static var shutdown_time: String = "general.shutdown_time"
    static var shaft_alarm: String = "general.shaft_alarm"
    static var gain_p: String = "general.gain_p"
    static var gain_i: String = "general.gain_i"
    static var fan_shutdown: String = "general.fan_shutdown"
    static var screen_lock_time: String = "general.screen_lock_time"
}

class smoke {
    static var level: String = "smoke.level"
    static var timer: String = "smoke.timer"
    static var feed: String = "smoke.feed"
    static var fan: String = "smoke.fan"
    static var pause: String = "smoke.pause"
}

class bbq {
    static var use_buzzer: String = "bbq.use_buzzer"
    static var fixed_temperature: String = "bbq.fixed_temperature"
    static var meat_temp_1: String = "bbq.meat_temp_1"
    static var meat_temp_2: String = "bbq.meat_temp_2"
    static var fixed_power: String = "bbq.fixed_power"

}

class misc {
    static var temp_unit: String = "misc.temp_unit"
    static var start: String = "misc.start"
    static var stop: String = "misc.stop"
    static var reset_alarm: String = "misc.reset_alarm"
}
