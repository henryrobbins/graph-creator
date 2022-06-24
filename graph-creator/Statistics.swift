//
//  Statistics.swift
//  Graph Creator
//
//  Created by Henry Robbins on 5/30/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import Foundation

class Statistics {
    
    // HashMap used to calculate statistics
    var hashMap = [Int: [Int]]()
    
    // ArrayList of stats
    var statistics = [Stat]();
    var nodes:Stat = Stat(name: "Nodes");
    var edges:Stat = Stat(name: "Edges");
    var connected:Stat = Stat(name: "Connected");
    var sDegree:Stat = Stat(name: "Smallest Degree");
    var lDegree:Stat = Stat(name: "Largest Degree");
    var aDegree:Stat = Stat(name: "Average Degree");
    var sGeodesic:Stat = Stat(name: "Smallest Geodesic");
    var lGeodesic:Stat = Stat(name: "Largest Geodesic");
    var aGeodesic:Stat = Stat(name: "Average Geodesic");
    
    // Add stats to ArrayList
    init () {
        statistics.append(nodes);
        statistics.append(edges);
        statistics.append(connected);
        statistics.append(sDegree);
        statistics.append(lDegree);
        statistics.append(aDegree);
        statistics.append(sGeodesic);
        statistics.append(lGeodesic);
        statistics.append(aGeodesic);
    }
    
    //Updates the hashMap
    func updateHashMap(hM :[Int: [Int]]) {
        hashMap = hM;
    
        for id in hashMap.keys {
            hashMap[id] = shortenArray(id: id, array: hashMap[id]!);
        }
    
        setStatistics();
    }
    
    func setStatistics() {
        setNodes();
        setEdges();
        if (nodes.intStat > 0) {
            setConnected();
            setSDegree();
            setLDegree();
            setADegree();
            setSGeodesic();
            setLGeodesic();
            setAGeodesic();
        }
    }
    
    func setNodes() {
        nodes.setStat(statistic: hashMap.count);
    }
    
    func setEdges() {
    
        var value:Int = 0;
    
        for id1 in hashMap.keys {
            for id2 in hashMap.keys {
				if (id2 > id1) {
                    if (FindDegreeOfSeparation(member1: id1,member2: id2) == 1) {
                        value += 1;
                    }
				}
            }
        }
    
        edges.setStat(statistic: value);
    }
    
    func setConnected() {
        
        for id1 in hashMap.keys {
            for id2 in hashMap.keys {
				if (id2 != id1) {
                    if (FindDegreeOfSeparation(member1: id1,member2: id2) == 0) {
                        connected.setStat(statistic: false);
                        return;
                    }
				}
            }
        }
        connected.setStat(statistic: true);
    }
    
    func setSDegree() {
    
        var value:Int = hashMap[0]!.count;
    
        for id in hashMap.keys {
            if ((hashMap[id]?.count)! <= value) {
				value = (hashMap[id]?.count)!
            }
        }
    
        sDegree.setStat(statistic: value);
    }
    
    func setLDegree() {
    
        var value:Int = hashMap[0]!.count;
        
        for id in hashMap.keys {
            if ((hashMap[id]?.count)! >= value) {
                value = (hashMap[id]?.count)!
            }
        }
        
        lDegree.setStat(statistic: value);
    }
    
    func setADegree() {
    
        var value:Double = 0;
    
        for id in hashMap.keys {
            value += Double((hashMap[id]?.count)!)
        }
    
        value /= Double(hashMap.count);
    
        aDegree.setStat(statistic: value);
    }
    
    func setSGeodesic() {
    
        var value:Int
    
        if (hashMap.count > 1) {
    
            value = FindDegreeOfSeparation(member1: 1,member2: 2);
    
            for id1 in hashMap.keys {
                for id2 in hashMap.keys {
                    if (id2 > id1) {
                        if (FindDegreeOfSeparation(member1: id1,member2: id2) <= value) {
                            value = FindDegreeOfSeparation(member1: id1,member2: id2);
                        }
                    }
				}
            }
        } else {
            value = 0;
        }
    
        sGeodesic.setStat(statistic: value);
    }
    
    func setLGeodesic() {
    
        var value:Int
    
        if (hashMap.count > 1) {
    
            value = FindDegreeOfSeparation(member1: 1,member2: 2);
    
            for id1 in hashMap.keys {
                for id2 in hashMap.keys {
                    if (id2 > id1) {
                        if (FindDegreeOfSeparation(member1: id1,member2: id2) >= value) {
                            value = FindDegreeOfSeparation(member1: id1,member2: id2);
                        }
                    }
				}
            }
        } else {
            value = 0;
        }
    
        lGeodesic.setStat(statistic: value);
    }
    
    func setAGeodesic() {
    
        var value:Double
    
        if (hashMap.count > 1) {
            value = 0;
    
            for id1 in hashMap.keys {
                for id2 in hashMap.keys {
                    if (id2 > id1) {
                        value += Double(FindDegreeOfSeparation(member1: id1,member2: id2))
                    }
				}
            }
    
            value /= (Double((hashMap.count*(hashMap.count-1))/2));
        } else {
            value = 0;
        }
    
        aGeodesic.setStat(statistic: value);
    
    }
    
    //Given two random people, finds degree of separation between them
    func FindDegreeOfSeparation(member1 :Int, member2 : Int) -> Int{
        var degrees = [Int]()
        degrees.append(member1);
        var degree:Int = 0;
        var found:Bool = false;
        while (found == false) {
            if (degree < hashMap.count) {
				//Generate an array of all connections in the given degree of separation
				var degreesArray = [Int]()
				for person in degrees {
                    for connection in hashMap[person]! {
                        degreesArray.append(connection);
                    }
				}
				degrees = degreesArray;
				var shortArray = [Int]()
				for element in degrees {
                    if (shortArray.contains(element) ==  false) {
                        shortArray.append(element);
                    }
				}
				degrees = shortArray;
    
				//Checks array for the second member
				if (degrees.contains(member2)) {
                    found = true;
				}
				degree += 1;
            } else {
				return 0;
            }
        }
        return degree;
    }
    
    // Shortens a given array and removes id
    func shortenArray(id :Int, array :[Int]) -> [Int] {
    
    var newArray = [Int]()
    
        for n in array{
            if (!newArray.contains(n) && n != id) {
				newArray.append(n);
            }
        }
    
        return newArray;
    
    }
    
}
