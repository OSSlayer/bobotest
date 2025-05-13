import Foundation

var day = 1
var money = 100
var earnings = [String:Int]()
var capturedKids = Set<Int>()
var escapedKids = Set<Int>()
var sentenceLength = 0
var totalMurders = 0
var latestMurders = 0
var totalCaptures = 0
var latestCaptures = 0
var totalEvasions = 0
var latestEvasions = 0
var eventFlag = false
var laborPool = 0 // don't manually set inside functions. Updates within main game loop
var laborShortage = 0 // only used if laborPool is inadequate to track shortage amount
var space = 100 // 1 space = 10 sqft
var usedSpace = 0
var unusedSpace: Int { space - usedSpace }
var forceEndDay = false

var captureChance = 0.66
var baseCapture = 5 // base amount of kids to capture
var captureFalloff = 0.404 // pct falloff in amount of available kids to capture
var captureAttempts = 0
var captureSuspicion = 0.015 // supicion level increase per capture
func maxCapture() -> Int { I(D(baseCapture) * pow(1 - captureFalloff, D(captureAttempts))) }

var reportChance = 0.1
var reportSuppressLevel = 0.0 // decrease the chance for a child to report you

var suspicionLevel = 0.0 // increased by various acts
var activeInvestigation = false
var investigationThreshold = 0.2 // how suspicious they need to get to begin an investigation
var investigationSuppressLevel = 0.0 // decrease the chance for their investigation to find you
var investigationFalloff = 0.075 // defund police so they cant sustain costly investigation

var evadeChance = 0.5

var murderChance = 0.1
var murderSuspicion = 0.1
var murderAttempted = false

var baseSellChance = 0.66
var sellChanceFalloff = 0.25
var salesCount = 0
var noSale = false
var salePrice = 60
var saleSuspicion = 0.0075
var undercoverChance = 0.02
func adjUndercoverChance() -> Double { activeInvestigation ? scaleUp(undercoverChance, suspicionLevel) : undercoverChance }
func sellChance() -> Double { baseSellChance * pow((1 - sellChanceFalloff), D(salesCount)) }

var massEscapeChance = 0.01
var escapeChance = 0.01


// Main Game Loop
clrScrn()
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
        if i == "~!" { devTools() }
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
            print(key.capitalized + ": \(earnings[key]! < 0 ? "-" : "")$\(abs(earnings[key]!))")
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
