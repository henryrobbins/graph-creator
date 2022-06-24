//
//  DirectedStatistics.swift
//  Graph Creator
//
//  Created by Henry Robbins on 5/30/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import Foundation

class DirectedStatistics: Statistics {
    
    override func setEdges() {
        var value:Int = 0;
    
        for id in hashMap.keys {
            value += (hashMap[id]?.count)!;
        }
    
        edges.setStat(statistic: value);
    }
    
}
