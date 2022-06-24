//
//  Stat.swift
//  Graph Creator
//
//  Created by Henry Robbins on 5/30/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import Foundation

class Stat {
    
    var name:String = "";
    var statistic:String = "";
    var intStat:Int = 0;
    var doubleStat:Double = 0;
    var booleanStat:Bool = true;
    
    init (name :String) {
        self.name = name;
    }
    
    func setStat(statistic :Int) {
        self.intStat = statistic;
        self.statistic = String(intStat);
    }
    
    func setStat(statistic :Double) {
        self.doubleStat = statistic;
        self.statistic = String(doubleStat);
    }
    
    func setStat(statistic :Bool) {
        self.booleanStat = statistic;
        self.statistic = String(booleanStat);
    }
    
}
