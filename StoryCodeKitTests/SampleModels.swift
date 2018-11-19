//
//  SampleModels.swift
//  StoryCodeKitTests
//
//  Created by Neil Allain on 11/18/18.
//  Copyright © 2018 Neil Allain. All rights reserved.
//

import Foundation
import StoryCodeKit

struct Campaign {
	var id: Int
	var name: String
	var npcs: [Npc]
//	var locations: [Location]
//	var events: [Event]
}

struct Npc {
	var id: Int
	var name: String
	var race: String
}

struct RootScene: SceneDefinition {
	func restoreValue(_ model: [Campaign]) -> String { return "" }
	typealias Model = [Campaign]
	let viewCampaign = DetailSegue<RootScene, CampaignScene>("viewCampaign")
}

struct CampaignScene: SceneDefinition {
	typealias Model = Campaign
	func restoreValue(_ model: Campaign) -> String { return "\(model.id)" }
	let viewNpc = NavigationSegue<CampaignScene, NpcScene>("viewNpc")
	let editName = ModalSegue<CampaignScene, TextScene>("editName")
}

struct NpcScene: SceneDefinition {
	typealias Model = Npc
	func restoreValue(_ model: Npc) -> String { return "\(model.id)" }
	let editName = ModalSegue<NpcScene, TextScene>("editName")
	let editRace = ModalSegue<NpcScene, TextScene>("editRace")
}

struct TextScene: SceneDefinition {
	typealias Model = String
	func restoreValue(_ model: String) -> String { return model }
}

typealias RootController = TestSceneController<RootScene>
typealias CampaignController = TestSceneController<CampaignScene>
typealias NpcController = TestSceneController<NpcScene>
typealias TextController = TestSceneController<TextScene>

func sampleCampaigns() -> [Campaign] {
	let npc1 = Npc(id: 1, name: "Aragon", race: "Human")
	let npc2 = Npc(id: 2, name: "Gimli", race: "Dwarf")
	let npc3 = Npc(id: 2, name: "Legolas", race: "Elf")
	let c1 = Campaign(id: 1, name: "Master of the Bands", npcs: [npc1, npc2, npc3])
	return [c1]
}
//struct Location {
//	var name: String
//}
//
//struct Event {
//	var details: String
//}
