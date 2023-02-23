//
//  SchoolScore.swift
//  NYCSchools
//
//  Created by Sheetal on 2/23/23.
//

struct SchoolScore: Decodable {
    
    let dbn: String
    let numOfSatTestTakers: Int
    let satCriticalReadingAvgScore: Int
    let satMathAvgScore: Int
    let satWritingAvgScore: Int
}
