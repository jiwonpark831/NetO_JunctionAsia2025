//
//  MainCategory.swift
//  NetO_JunctionAsia2025
//
//  Created by 최승아 on 8/24/25.
//

enum MainCategory: String, CaseIterable {
    case foundation = "Foundation Work" // basic
    case framing = "Framing Construction" // bone
    case facility = "Facility Construction" // facility
    case exterior = "Exterior Construction" // final

    var subcategories: [String] {
        switch self {
        case .foundation:
            return ["Excavation", "Earth Retaining Work / Temporary Shoring", "Pilling", "Foundation Concrete Pouring", "Waterproofing (Foundation)", "Mat Foundation / Isolated Footing", "Subsurface Drainage", "Backfilling"]
        case .framing:
            return ["Rebar Work/Reinforcement", "Formwork", "Concrete Pouring", "Column/Beam/Slab Construction", "Precast Installation", "Structural Frame Inspection"]
        case .facility:
            return ["Water Supply and Drainage System", "Sanitary Plumbing", "HVAC (Heating, Ventilation, Air Conditioning)", "Gas Supply System", "Fire Protection System", "Building Automation System (BAS)", "Elevator / Escalator Installation"]
        case .exterior:
            return ["Exterior Finishing (Stone, Metal, Curtain Wall)", "Window and Door Installation", "Insulation Work", "Waterproofing (Above Ground)", "Interior Wall / Ceiling Finishing", "Tile / Stone / Flooring Installation", "Painting and Coating", "Lighting / Electrical Fixture Installation", "Interior Fit-out"]
        }
    }
}

