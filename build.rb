module EBJB_Party
  # Build filename
  FINAL   = "build/EBJB_Party.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/Party_Config.rb",
    "src/Game Objects/Game_Party.rb",
    "src/Game Objects/Game_Parties.rb",
    "src/Game Objects/Game_Map.rb",
    "src/Game Objects/Game_Faction.rb",
    "src/Game Objects/Game_Actor.rb",
    "src/Scenes/Scene_Menu.rb",
    "src/Scenes/Scene_Map.rb",
    "src/Scenes/Scene_Title.rb",
    "src/Scenes/Scene_File.rb",
    "src/Scenes/Scene_Party.rb",
    "src/Scenes/Scene_Formation.rb",
    "src/User Interface/Font.rb",
    "src/User Interface/Color.rb",
    "src/User Interface/Vocab.rb",
    "src/Windows/Window_Member_Info.rb",
    "src/Windows/Window_Reserve_Members.rb",
    "src/Windows/Window_Party_Selection.rb",
    "src/Windows/Window_Status.rb",
    "src/Windows/Window_MenuStatus.rb",
    "src/Windows/Window_Battle_Formations.rb",
    "src/Windows/Window_Party_Order.rb",
    "src/Windows/Window_SaveFile.rb",
    "src/Windows/Window_BattleFormationDetails.rb",
    "src/User Controls/UCFormationCharFace.rb",
    "src/User Controls/UCBattleFormation.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_Party::FINAL, "w+")
  EBJB_Party::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()