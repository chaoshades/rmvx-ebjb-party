module EBJB_Party_Ext
  # Build filename
  FINAL   = "build/EBJB_Party_Ext.rb"
  # Source files
  TARGETS = [
    "src/External Scripts/MA_MultipleParties.rb",
  ]
end

def ebjb_build_ext
  final = File.new(EBJB_Party_Ext::FINAL, "w+")
  EBJB_Party_Ext::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build_ext()