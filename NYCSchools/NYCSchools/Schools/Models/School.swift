//
//  School.swift
//  NYCSchools
//
//  Created by Sheetal on 2/23/23.
//
//struct Schools: Decodable {
//    let schools: [School]
//}
struct School: Decodable {
    
    let dbn: String
    let name: String
    let overview: String
    let location: String
    let phone_number: String
    let fax_number: String
    let email: String
    let website: String
    
    // The keys will be converted to camelCase from the NetworkManager itself so only assign CodingKeys where keys are different
    enum CodingKeys: String, CodingKey {
        case name = "school_name"
        case dbn, location, phone_number, fax_number, website
        case overview = "overview_paragraph"
        case email = "school_email"
    }
}
