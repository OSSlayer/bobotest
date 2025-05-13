func summary() {
    print("- Money: $\(money) | Space: \(unusedSpace) | Kids: \(capturedKids.count)" + (escapedKids.count == 0 ? "" : " | Escaped: \(escapedKids.count)") + " -")
}

func stats() {
    print("Game Stats:")
    print("Day: \(day)")
    print("Money: \(money)")
    print("Captured Kids: \(capturedKids.count)")
    print("Escaped Kids: \(escapedKids.count)")
    print("Sentence Length: \(sentenceLength)")
    print("Total Captures: \(totalCaptures)")
    print("Latest Captures: \(latestCaptures)")
    print("Total Murders: \(totalMurders)")
    print("Latest Murders: \(latestMurders)")
    print("Total Evasions: \(totalEvasions)")
    print("Latest Evasions: \(latestEvasions)")
    print("Estimated Labor Shortage: \(laborShortage)")
    print("Estimated Unused Labor: \(laborPool)")
    print("Space: \(space)")
    print("Used Space: \(usedSpace)")
    print("Unused Space: \(unusedSpace)")
    
    print("--- Capturing ---")
    print("Capture Chance: \(captureChance)")
    print("Base Max Capture Amount: \(baseCapture)")
    print("Actual Max Capture Amount: \(maxCapture())")
    print("Capture Falloff: \(baseCapture)")
    print("Capture Suspicion: \(captureSuspicion)")
    
    print("--- Reporting ---")
    print("Report Chance: \(reportChance)")
    print("Report Supress Level: \(reportSuppressLevel)")
    
    print("--- Investigation ---")
    print("Suspicion Level: \(suspicionLevel)")
    print("Active Investigation: \(activeInvestigation)")
    print("Investigation Threshold: \(investigationThreshold)")
    print("Investigation Suppress Level: \(investigationSuppressLevel)")
    print("Investigation Falloff: \(investigationFalloff)")
    
    print("--- Arresting ---")
    print("Evasion Chance: \(evadeChance)")
    
    print("--- Murdering ---")
    print("Murder Success Chance: \(murderChance)")
    print("Murder Suspicion: \(murderSuspicion)")
    
    print("--- Escaping ---")
    print("Escape Chance: \(escapeChance)")
    print("Mass Escape Chance: \(massEscapeChance)")
    
    print("--- Selling ---")
    print("Base Sell Chance: \(baseSellChance)")
    print("Sell Chance Falloff: \(sellChanceFalloff)")
    print("Actual Sell Chance: \(sellChance())")
    print("Base Sale Price: \(salePrice)")
    print("Sale Suspicion: \(saleSuspicion)")
    print("Base Undercover Cop Chance: \(undercoverChance)")
    print("Actual Undercover Cop Chance: \(adjUndercoverChance())")
}

func help() {
    print("+ Game Help +")
    print("--- Commands ---")
    print("enter (no command) = finish day")
    print("capture / c = attempt to capture children")
    print("sell / s = attempt to sell a random child")
    print("sell specific / ss = attempt to sell a specific child")
    print("murder / m = attempt to murder escaped children")
    print("stats / st = view stats")
    print("help / h = view help")
    print("list captured / lc = list names of all captured children")
    print("list escaped / le = list names of all escaped children")
    print("list assets / la = list all assets")
    print("buy / b = open buy menu")
    print("buy many / bm = open buy menu with option to purchase many(multiple) at once")
    print("other / o = open other (obscure) actions menu")
    print("save / sv = save game")
    print("load / ld = load game")
}

func printAssets() {
    for (tag,count) in assetCounts {
        guard let name = assetList[tag]?.name else { print("[Asset Error] Could not find asset '\(tag)'.") ; continue }
        print("\(cap(name)): \(count)")
    }
}
