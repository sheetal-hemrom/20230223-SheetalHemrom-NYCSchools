//
//  SchoolScore.swift
//  NYCSchools
//
//  Created by Sheetal on 2/23/23.
//

struct SchoolScore: Decodable, Equatable {
    
    let dbn: String
    let num_of_sat_test_takers: String
    let sat_critical_reading_avg_score: String
    let sat_math_avg_score: String
    let sat_writing_avg_score: String
}
