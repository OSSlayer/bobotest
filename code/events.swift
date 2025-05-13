import Foundation

func checkEscape() {
    if capturedKids.isEmpty { return }
    if capturedKids.count > 4 && random() < massEscapeChance {
        let x = Int.random(in: 4...capturedKids.count)
        var escapees = Set<Int>()
        for _ in 0..<x {
            let kid = capturedKids.randomElement()!
            capturedKids.remove(kid)
            escapedKids.insert(kid)
            escapees.insert(kid)
        }
        event("Mass breakout! \(x) kids escaped the basement!")
        print("View escaped children? [y/n]")
        if input().lowercased() == "y" { printNames(escapees) }
        usedSpace -= x
    } else {
        var escapees = Set<Int>()
        var shackleCount = assetCounts["s", default: 0]
        for kid in capturedKids {
            shackleCount -= 1
            if random() > scaleDown(escapeChance, shackleCount + 1 > 0 ? 0.5 : 0) { continue }
            escapees.insert(kid)
            capturedKids.remove(kid)
            escapedKids.insert(kid)
        }
        if escapees.count == 1 {
            event("\(children[escapees.randomElement()!].name) escaped the basement!")
        } else if !escapees.isEmpty {
            event("\(escapees.count) kids escaped the basement!")
            print("View escaped children? [y/n]")
            if input().lowercased() == "y" { printNames(escapees) }
        }
        usedSpace -= escapees.count
    }
}

func checkReport() {
    for _ in 0..<escapedKids.count {
        if random() > reportChance * (1 - reportSuppressLevel) { continue }
        print("An escaped child has contacted the police!")
        check()
        
        suspicionLevel += investigationThreshold * 0.5
        eventFlag = true
        checkArrest()
        return
    }
}

func checkInvestigation() {
    if !activeInvestigation && suspicionLevel > investigationThreshold {
        event("The police have launched an investigation into the missing children.")
        activeInvestigation = true
    }
    if activeInvestigation && suspicionLevel < (investigationThreshold / 2) {
        event("The police investigation case has gone cold.")
        suspicionLevel = scaleUp(suspicionLevel, 0.2)
        activeInvestigation = false
    }
    
    let chance = pow(suspicionLevel, 2) * (1 - investigationSuppressLevel) / 5
    if activeInvestigation && random() < chance {
        event("The police have caught on to Bobo!")
        checkArrest()
    }
}

func checkArrest() {
    if random() > evadeChance {
        print("Bobo has evaded the police!")
        totalEvasions += 1
        latestEvasions += 1
        return
    }
    
    event("Bobo has been arrested!")
    check()
    
    print("The children have been released from Bobo's basement.")
    
    usedSpace -= capturedKids.count
    capturedKids = []
    escapedKids = []
    activeInvestigation = false
    investigationThreshold *= 0.75
    suspicionLevel = investigationThreshold * 0.5
    
    var crimes = [String:(Int,Int,Int)]() // crime, counts, day amount, fine amount
    if latestCaptures > 0 { crimes["Federal Kidnapping"] = (latestCaptures, 10, 1000) }
    if latestMurders > 0 { crimes["First Degree Murder"] = (latestMurders, 100, 5000) }
    if latestEvasions > 0 {
        if latestEvasions < 5 {
            crimes["Misdemeanor Evading"] = (latestEvasions, 1, 2500)
        } else {
            crimes["Felony Evading"] = (latestEvasions, 5, 5000)
        }
    }
    checkSentence(crimes)
}

func checkSentence(_ crimes: [String:(Int,Int,Int)], _ canLeverage: Bool = true) {
    if crimes.isEmpty { print("Bobo has no charges") ; return }
    print("Bobo is being tried in court...\n")
    print("xxx State of Wisconsin v. Bobo xxx")
    check()
    
    print("Bobo is charged with the following offenses:")
    for (crime,data) in crimes {
        print(" - \(data.0) count\(data.0 > 0 ? "s" : "") of \(crime) - \(data.1) days, $\(data.2) fine / count.")
    }
    check()
    
    var convictions = [String:(Int,Int,Int)]()
    var guiltiness = 0.95
    var severity = 1.0
    
    // Plea Deal
    var pleaConvictions = convictions
    var pleaDeal = 0.75
    if assetCounts["lw1"] ?? 0 > 0 { pleaDeal = 0.66 }
    if assetCounts["lw2"] ?? 0 > 0 { pleaDeal = 0.5 }
    if assetCounts["lw3"] ?? 0 > 0 { pleaDeal = 0.33 }
    if assetCounts["lw4"] ?? 0 > 0 { pleaDeal = 0.25 }
    if assetCounts["lgt"] ?? 0 > 0 { pleaDeal = 0.1 }
    if assetCounts["sg"] ?? 0 > 0 { guiltiness = 0.05 }
    for (crime, data) in crimes {
        pleaConvictions[crime] = (I(D(data.0) * pleaDeal), I(D(data.1) * pleaDeal), I(D(data.2) * pleaDeal))
    }
    print("Bobo's lawyers have negotiated a plea deal. Bobo can plea guilty and face:")
    for (conviction, data) in pleaConvictions where data.0 > 0 {
        print(" - \(data.0) count\(data.0 > 0 ? "s" : "") of \(conviction) - \(data.1) days, $\(data.2) fine (per count).")
    }
    
    var pledGuilty = false
    print("Plea guilty? [y/n]")
    if input().lowercased() == "y" {
        for (crime, data) in crimes {
            convictions[crime] = (I(D(data.0) * pleaDeal), I(D(data.1) * pleaDeal), I(D(data.2) * pleaDeal))
        }
        print("Bobo has pled guilty.")
        pledGuilty = true
    } else {
        print("Bobo has pled not guilty.")
    }
    
    if canLeverage { print("The hearing will begin soon...") }
    
    // Bribe Jury
    var juryBribe = 0
    var juryThreaten = false
    if canLeverage && !pledGuilty {
        print("Bribe or threaten the jury? [b/t/n]")
        let i = input().lowercased()
        if i == "b" {
            print("How much?")
            if let amount = Int(input()) {
                if money >= amount {
                    juryBribe = amount
                } else {
                    print("Bobo doesn't have that much.")
                }
            } else {
                print("Not a number.")
            }
        }
        if i == "t" {
            print("Bobo has threatened the jury.")
            juryThreaten = true
        }
    }
    
    if juryBribe > 0 {
        if random() < 25000 / D(juryBribe + 25000) { // 20% chance at 100k
            print("The jury has reported Bobo for bribery! The case has been thrown out.")
            var newCrimes = crimes
            newCrimes["Bribery of a Juror"] = (12, 15, juryBribe / 12) // disqualifies from office too...
            checkSentence(newCrimes, false)
            return
        } else {
            guiltiness = 0
        }
    }
    if juryThreaten {
        if random() < 0.5 { // could make it a variable based on setting an example by killing jury members
            print("The jury has reported Bobo for threatening! The case has been thrown out.")
            var newCrimes = crimes
            newCrimes["Juror Intimidation"] = (12, 10, 0)
            checkSentence(newCrimes, false)
            return
        } else {
            guiltiness = 0
        }
    }
    
    // Lawyer defense
    if juryBribe == 0 && !juryThreaten {
        if assetCounts["lw1"] ?? 0 > 0 { guiltiness = 0.80 ; severity = 0.90 }
        if assetCounts["lw2"] ?? 0 > 0 { guiltiness = 0.65 ; severity = 0.75 }
        if assetCounts["lw3"] ?? 0 > 0 { guiltiness = 0.50 ; severity = 0.50 }
        if assetCounts["lw4"] ?? 0 > 0 { guiltiness = 0.25 ; severity = 0.33 }
        if assetCounts["lgt"] ?? 0 > 0 { guiltiness = 0.15 ; severity = 0.25 }
        if assetCounts["sg"] ?? 0 > 0 { guiltiness = 0.05 ; severity = 0.10 }
    }
    
    // Hearing
    if !pledGuilty {
        print("The hearing has begun!")
        check()
        
        if guiltiness != 0.95 { print("Bobo's lawyers have improved his odds by \((1 - guiltiness) * 10)%.") }
        
        print("The jury has found Bobo guilty of:")
        for (crime,data) in crimes {
            var count = 0
            for _ in 0..<data.0 where random() < guiltiness { count += 1 }
            convictions[crime] = (count, data.1, data.2)
            print(" - \(count)/\(data.0) count\(count > 0 ? "s" : "") of \(crime)")
        }
        print("")
    }
    
    // Bribe Judge
    if !pledGuilty && canLeverage { print("The sentencing will begin shortly...") }
    
    var judgeBribe = 0
    var judgeThreaten = false
    if canLeverage && !pledGuilty {
        print("Bribe or threaten the judge? [b/t/n]")
        let i = input().lowercased()
        if i == "b" {
            print("How much?")
            if let amount = Int(input()) {
                if money >= amount {
                    judgeBribe = amount
                } else {
                    print("Bobo doesn't have that much.")
                }
            } else {
                print("Not a number.")
            }
        }
        if i == "t" {
            print("Bobo has threatened the judge.")
            judgeThreaten = true
        }
    }
    
    var judgeSeverity = 0.0
    if judgeBribe > 0 {
        let r = 25000 / D(juryBribe + 25000)
        if random() < r { // 20% chance at 100k
            print("The judge has reported Bobo for bribery! The case has been thrown out.")
            var newCrimes = crimes
            newCrimes["Bribery of a Public Official"] = (1, 15, judgeBribe)
            checkSentence(newCrimes, false)
            return
        } else {
            judgeSeverity = 1 - r
        }
    }
    if judgeThreaten {
        if random() < 0.5 {
            print("The jury has reported Bobo for threatening! The case has been thrown out.")
            var newCrimes = crimes
            newCrimes["Threatening a Federal Official"] = (1, 20, 0)
            checkSentence(newCrimes, false)
            return
        } else {
            judgeSeverity = 0.5
        }
    }
    
    // Sentencing
    print("The sentencing has begun!")
    check()
    
    if severity != 1.0 { print("Bobo's lawyers have reduced the punishment by \((1 - severity) * 10)%.") }
    if judgeSeverity > 0 { print("Bobo's \(judgeThreaten ? "threat" : "bribe") has reduced the punishment by \(judgeSeverity)%.") }
    severity = scaleDown(severity, judgeSeverity)
    
    var totalTime = 0
    var totalFines = 0
    var totalConvictions = 0
    for (_,data) in convictions {
        totalConvictions += data.0
        if random() < guiltiness {
            totalTime += data.1 // * data.0 // uncomment to make non-concurrent
        }
        totalFines += data.2 * data.0
    }
    totalTime = I(D(totalTime) * severity)
    totalFines = I(D(totalFines) * severity)
    print("The judge has convicted Bobo of \(convictions.count) crime\(convictions.count > 0 ? "s" : ""), totaling \(totalConvictions) count\(totalConvictions > 0 ? "s" : "").")
    print("The judge has sentenced Bobo to \(totalTime) days in prison and a $\(totalFines) fine")
    
    sentenceLength = totalTime
    money -= totalFines
    
    latestCaptures = 0
    latestMurders = 0
    latestEvasions = 0
}
