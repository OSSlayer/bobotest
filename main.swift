nonisolated(unsafe) var day = 1
nonisolated(unsafe) var money = 100
nonisolated(unsafe) var earnings = [String:Int]()
nonisolated(unsafe) var capturedKids = Set<Int>()
nonisolated(unsafe) var escapedKids = Set<Int>()
nonisolated(unsafe) var sentenceLength = 0
nonisolated(unsafe) var totalMurders = 0
nonisolated(unsafe) var latestMurders = 0
nonisolated(unsafe) var totalCaptures = 0
nonisolated(unsafe) var latestCaptures = 0
nonisolated(unsafe) var totalEvasions = 0
nonisolated(unsafe) var latestEvasions = 0
nonisolated(unsafe) var eventFlag = false
nonisolated(unsafe) var laborPool = 0 // don't manually set inside functions. Updates within main game loop
nonisolated(unsafe) var laborShortage = 0 // only used if laborPool is inadequate to track shortage amount
nonisolated(unsafe) var space = 100 // 1 space = 10 sqft
nonisolated(unsafe) var usedSpace = 0
nonisolated(unsafe) var unusedSpace: Int { space - usedSpace }
nonisolated(unsafe) var forceEndDay = false

nonisolated(unsafe) var captureChance = 0.66
nonisolated(unsafe) var baseCapture = 5 // base amount of kids to capture
nonisolated(unsafe) var captureFalloff = 0.404 // pct falloff in amount of available kids to capture
nonisolated(unsafe) var captureAttempts = 0
nonisolated(unsafe) var captureSuspicion = 0.015 // supicion level increase per capture
func maxCapture() -> Int { I(D(baseCapture) * pow(1 - captureFalloff, captureAttempts)) }

nonisolated(unsafe) var reportChance = 0.1
nonisolated(unsafe) var reportSuppressLevel = 0.0 // decrease the chance for a child to report you

nonisolated(unsafe) var suspicionLevel = 0.0 // increased by various acts
nonisolated(unsafe) var activeInvestigation = false
nonisolated(unsafe) var investigationThreshold = 0.2 // how suspicious they need to get to begin an investigation
nonisolated(unsafe) var investigationSuppressLevel = 0.0 // decrease the chance for their investigation to find you
nonisolated(unsafe) var investigationFalloff = 0.075 // defund police so they cant sustain costly investigation

nonisolated(unsafe) var evadeChance = 0.5

nonisolated(unsafe) var murderChance = 0.1
nonisolated(unsafe) var murderSuspicion = 0.1
nonisolated(unsafe) var murderAttempted = false

nonisolated(unsafe) var baseSellChance = 0.66
nonisolated(unsafe) var sellChanceFalloff = 0.25
nonisolated(unsafe) var salesCount = 0
nonisolated(unsafe) var noSale = false
nonisolated(unsafe) var salePrice = 60
nonisolated(unsafe) var saleSuspicion = 0.0075
nonisolated(unsafe) var undercoverChance = 0.02
func adjUndercoverChance() -> Double { activeInvestigation ? scaleUp(undercoverChance, suspicionLevel) : undercoverChance }
func sellChance() -> Double { baseSellChance * pow((1 - sellChanceFalloff), salesCount) }

nonisolated(unsafe) var massEscapeChance = 0.01
nonisolated(unsafe) var escapeChance = 0.01


// Main Game Loop
clrScrn()
print("Bobo's Basement v1.3.0")
print("Press enter to advance each day.")
while true {
    forceEndDay = false
    print("+-------== day \(day) ==-------+")
    
    // Update day-by-day features
    update()
    
    // Check if in jail
    if sentenceLength > 0 {
        sentenceLength -= 1
        print("Bobo is in jail. \(sentenceLength) day\(sentenceLength == 1 ? "" : "s") remain\(sentenceLength == 1 ? "s" : "").")
        rest()
        continue
    }
    
    // Handle player actions
    while true {
        if sentenceLength > 0 || forceEndDay { break }
        summary()
        let i = input()
        if i == "" { break }
        if i == "capture" || i == "c" { attemptCapture() }
        if i == "murder" || i == "m" { attemptMurder() }
        if i == "sell" || i == "s" { attemptSale() }
        if i == "sell specific" || i == "ss" { attemptSale(true) }
        if i == "stats" || i == "st" { stats() }
        if i == "help" || i == "h" { help() }
        if i == "list captured" || i == "lc" { printNames(capturedKids) }
        if i == "list escaped" || i == "le" { printNames(escapedKids) }
        if i == "list assets" || i == "la" { print("*** Assets ***") ; printAssets() }
        if i == "buy" || i == "b" { buy() }
        if i == "buy many" || i == "bm" { buy(true) }
        if i == "other" || i == "o" { other() }
        if i == "save" || i == "sv" { save() }
        if i == "load" || i == "ld" { load() }
        //if i == "~!" { devTools() }
    }
    if forceEndDay { continue }
    
    // Handle monetary events
    laborPool = capturedKids.count
    laborShortage = 0
    earnings = [:]
    for asset in assets {
        guard let asset = assetList[asset] else { print("An unexpected error has occurred [0031]") ; continue }
        asset.dayAction?()
    }
    
    if !earnings.isEmpty {
        var net = 0
        let keys = earnings.keys.sorted(by: { earnings[$0] ?? 0 > earnings[$1] ?? 0 })
        print("*** End-of-Day Earnings Report ***")
        for key in keys {
            print(String(key).capitalized + ": \(earnings[key]! < 0 ? "-" : "")$\(abs(earnings[key]!))")
            money += earnings[key]!
            net += earnings[key]!
        }
        if earnings.count > 1 { print("Net: \(net < 0 ? "-" : "")$\(abs(net))") }
    }
    if laborShortage > 0 { print("Bobo is short on labor! Estimated labor shortage: \(laborShortage)") }
    if !earnings.isEmpty || laborShortage > 0 { check() }
    
    // Handle random events
    checkEscape()
    checkReport()
    checkInvestigation()
    if eventFlag { check() }
}


func update() {
    // Update day-by-day variables
    day += 1
    eventFlag = false
    murderAttempted = false
    noSale = false
    salesCount = 0
    captureAttempts = 0
    suspicionLevel = scaleDown(suspicionLevel, investigationFalloff)
    
    otherActions = [:]
    if assetCounts["sm", default: 0] >= 40 {
        guard let ss = assetList["ss"] else { print("An unexpected error has occured. [0000]") ; return }
        otherActions["ss"] = ("Open Sweatshop, \(ss.cost) - \(ss.description)", openSweatshop)
    }
}
