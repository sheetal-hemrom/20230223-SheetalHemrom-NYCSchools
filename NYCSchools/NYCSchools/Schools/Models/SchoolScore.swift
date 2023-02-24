//
//  SchoolScore.swift
//  NYCSchools
//
//  Created by Sheetal on 2/23/23.
//

struct SchoolScore: Decodable {
    
    let dbn: String
    let num_of_sat_test_takers: String
    let sat_critical_reading_avg_score: String
    let sat_math_avg_score: String
    let sat_writing_avg_score: String
}


//"[{\"dbn\":\"21K728\",\"school_name\":\"LIBERATION DIPLOMA PLUS\",\"num_of_sat_test_takers\":\"10\",\"sat_critical_reading_avg_score\":\"411\",\"sat_math_avg_score\":\"369\",\"sat_writing_avg_score\":\"373\"}]\n"
