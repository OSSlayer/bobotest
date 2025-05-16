import Foundation

func save() {
    let saveString = makeSaveString()
    let saveURL = URL(fileURLWithPath: "savefile.txt")

    do {
        try saveString.write(to: saveURL, atomically: true, encoding: .utf8)
        print("Game saved.")
    } catch {
        print("Failed to save game: \(error)")
    }
}

func makeSaveString() -> String {
    func s(_ set: Set<Int>) -> String {
        if set.count == 0 { return "!" }
        var str = ""
        for item in set {
            str.append(String(item))
            str.append(",")
        }
        str = String(str.dropLast(1)) // remove trailing comma
        return str
    }
    
    let a = "\(day)/\(money)/\(s(capturedKids))/\(s(escapedKids))/\(sentenceLength)/\(totalCaptures)/\(latestCaptures)/\(totalMurders)/\(latestMurders)/\(totalEvasions)/\(latestEvasions)/\(space)/\(usedSpace)"
    let b = "/\(captureChance)/\(baseCapture)/\(captureFalloff)/\(captureSuspicion)/\(reportChance)/\(reportSuppressLevel)"
    let c = "/\(suspicionLevel)/\(activeInvestigation ? 1 : 0)/\(investigationThreshold)/\(investigationSuppressLevel)/\(investigationFalloff)"
    let d = "/\(evadeChance)/\(murderChance)/\(murderSuspicion)/\(baseSellChance)/\(sellChanceFalloff)/\(salePrice)/\(saleSuspicion)"
    let e = "/\(undercoverChance)/\(massEscapeChance)/\(escapeChance)/"
    var output = a + b + c + d + e
    
    // Child structure: /firstname,secondname,m;firstname,secondname,f/
    for child in children { output += "\(child.first),\(child.last),\(child.gender ? 1 : 0);" }
    if children.count > 0 { output = String(output.dropLast(1)) } else { output += "!" }
    output += "/"
    
    // Asset structure: /tag,tag,tag,tag,tag/
    for asset in assets { output += asset + "," }
    if assets.count > 0 { output = String(output.dropLast(1)) } else { output += "!" }
    output += "/"
    
    // Asset structure: /tag,tag,tag,tag,tag/
    for asset in lockedAssets { output += asset + "," }
    if lockedAssets.count > 0 { output = String(output.dropLast(1)) } else { output += "!" }
    
    return output
}

func loadFromString(_ str: String) {
    let args = str.split(separator: "/")
    
    // 34 variables + 2 for assets + 1 for children
    guard args.count == 37 else {
        print("Invalid save string. Expected 37 args, got \(args.count). Save string is either misformatted or is from an outdated version.")
        return
    }
    
    func i(_ str: String.SubSequence) -> Int? {
        guard let int = Int(str) else {
            print("Cannot convert '\(str)' to an Int.")
            return nil
        }
        return int
    }
    func d(_ str: String.SubSequence) -> Double? {
        guard let double = Double(str) else {
            print("Cannot convert '\(str)' to a Double.")
            return nil
        }
        return double
    }
    func b(_ str: String.SubSequence) -> Bool? {
        if str == "1" { return true }
        if str == "0" { return false }
        print("Cannot convert '\(str)' to a Bool.")
        return nil
    }
    
    func si(_ str: String.SubSequence) -> Set<Int>? {
        var output = Set<Int>()
        let items = str.split(separator: ",")
        if items.first ?? "" == "!" { return [] }
        for item in items {
            guard let int = i(item) else {
                print("Cannnot convert '\(item)' to int in [\(str)].")
                return nil
            }
            output.insert(int)
        }
        return output
    }
    
    func ss(_ str: String.SubSequence) -> Set<String>? {
        var output = Set<String>()
        let items = str.split(separator: ",")
        if items.first ?? "" == "!" { return [] }
        for item in items { output.insert(String(item)) }
        return output
    }
    
    func ss2(_ str: String.SubSequence) -> [String]? {
        var output = [String]()
        let items = str.split(separator: ",")
        if items.first ?? "" == "!" { return [] }
        for item in items { output.append(String(item)) }
        return output
    }
    
    let ogChildren = children
    children = []
    
    func c(_ str: String.SubSequence) -> Bool {
        let items = str.split(separator: ",")
        guard items.count == 3 else {
            print("Invalid arguments count in [\(str)]. Expected 3, got \(items.count).")
            return false
        }
        guard let gender = b(items[2]) else {
            print("Invalid argument '\(items[2])' in [\(str)]. Expected 1 or 0 (bool).")
            return false
        }
        let _ = Child(first: String(items[0]), last: String(items[1]), gender: gender)
        return true
    }
    
    func ac(_ str: String.SubSequence) -> Bool {
        let chs = str.split(separator: ";")
        if chs.first ?? "" == "!" { return true } // empty set of children, return success
        for ch in chs { if !c(ch) { return false } } // Loop through each child and if fails to decode then mark the entire operation as a fail
        return true // Only return true if all children are decoded properly
    }
    // Child structure: /firstname,secondname,m;firstname,secondname,f/
    // Asset structure: /tag,tag,tag,tag,tag/
    // Asset structure: /tag,tag,tag,tag,tag/
    
    guard
    let _day = i(args[0]), let _money = i(args[1]), let _capturedKids = si(args[2]), let _escapedKids = si(args[3]),
    let _sentenceLength = i(args[4]), let _totalCaptures = i(args[5]), let _latestCaptures = i(args[6]), let _totalMurders = i(args[7]),
    let _latestMurders = i(args[8]), let _totalEvasions = i(args[9]), let _latestEvasions = i(args[10]), let _space = i(args[11]), let _usedSpace = i(args[12]),
    let _captureChance = d(args[13]), let _baseCapture = i(args[14]), let _captureFalloff = d(args[15]), let _captureSuspicion = d(args[16]),
    let _reportChance = d(args[17]), let _reportSuppressLevel = d(args[18]), let _suspicionLevel = d(args[19]),
    let _activeInvestigation = b(args[20]), let _investigationThreshold = d(args[21]), let _investigationSuppressLevel = d(args[22]),
    let _investigationFalloff = d(args[23]), let _evadeChance = d(args[24]), let _murderChance = d(args[25]), let _murderSuspicion = d(args[26]),
    let _baseSellChance = d(args[27]), let _sellChanceFalloff = d(args[28]), let _salePrice = i(args[29]),
    let _saleSuspicion = d(args[30]), let _undercoverChance = d(args[31]), let _massEscapeChance = d(args[32]), let _escapeChance = d(args[33]),
    let _assets = ss2(args[35]), let _lockedAssets = ss(args[36])
    else {
        print("[Load Error] Failed to load one or more values.")
        return
    }
    
    if !ac(args[34]) {
        print("[Load Error] Failed to load one or more children.")
        children = ogChildren
        return
    }
    
    (day, money, capturedKids, escapedKids, sentenceLength, totalCaptures, latestCaptures, totalMurders, latestMurders, totalEvasions, latestEvasions, space, usedSpace, captureChance, baseCapture, captureFalloff, captureSuspicion, reportChance, reportSuppressLevel, suspicionLevel, activeInvestigation, investigationThreshold, investigationSuppressLevel, investigationFalloff, evadeChance, murderChance, murderSuspicion, baseSellChance, sellChanceFalloff, salePrice, saleSuspicion, undercoverChance, massEscapeChance, escapeChance, assets, lockedAssets) = (_day, _money, _capturedKids, _escapedKids, _sentenceLength, _totalCaptures, _latestCaptures, _totalMurders, _latestMurders, _totalEvasions, _latestEvasions, _space, _usedSpace, _captureChance, _baseCapture, _captureFalloff, _captureSuspicion, _reportChance, _reportSuppressLevel, _suspicionLevel, _activeInvestigation, _investigationThreshold, _investigationSuppressLevel, _investigationFalloff, _evadeChance, _murderChance, _murderSuspicion, _baseSellChance, _sellChanceFalloff, _salePrice, _saleSuspicion, _undercoverChance, _massEscapeChance, _escapeChance, _assets, _lockedAssets)
    
    print("Loaded game.")
    for _ in 0..<5 { print(".") }
    forceEndDay = true
}

func load() {
    print("Are you sure you want to load a new game? This will overwrite the current game. [y/n]")
    if input().lowercased() != "y" { return }
    print("Loading game...")
    
    do {
        let str = try String(contentsOfFile: "savefile.txt", encoding: .utf8)
        loadFromString(str)
    } catch {
        print("Failed to load save: \(error)")
    }
    
    
}
