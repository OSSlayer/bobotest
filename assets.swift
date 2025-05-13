struct Asset {
    let name: String
    let description: String
    let cost: Int
    let size: Int
    let renewable: Bool
    let buyAction, dayAction: (()->())?
    
    init(
        _ name: String,
        _ cost: Int,
        _ description: String,
        size: Int = 0,
        _ renewable: Bool = true,
        buyAction: (()->())? = nil,
        dayAction: (()->())? = nil
    ) {
        self.name = name
        self.description = description
        self.cost = cost
        self.size = size
        self.renewable = renewable
        self.buyAction = buyAction
        self.dayAction = dayAction
    }
}

func removeAsset(_ str: String) {
    guard let i = assets.firstIndex(where: { $0 == str }) else {
        print("An unexpected error has occured [0020]") ; return
    }
    assets.remove(at: i)
}

var assets = [sId]()
var lockedAssets: Set<sId> = [
    "ss", "ict", "bex", "b2", "b3", "b4", "b5", "ad", "mkt", "lw2", "lw3", "lw4", "lgt", "sg"
]
var assetCounts: [sId:Int] {
    var output = [String:Int]()
    for a in assets { output[a] = output[a, default: 0] + 1 }
    return output
}

var assetList: [sId:Asset] = [
    "wv": .init("White Van", 22500, "Improve kidnapping abilities.", false,
                buyAction: {
                    captureChance = scaleUp(captureChance, 0.33)
                    baseCapture += 4
                    lockedAssets.remove("ict")
                }
               ),
    "ict": .init("Ice Cream Truck", 17000, "Convert the white van into an ice cream truck for improved kidnapping.", false,
                buyAction: {
                    captureChance = scaleUp(captureChance, 0.5)
                    baseCapture += 6
                    removeAsset("wv")
                }
               ),
    "c": .init("Candy", 100, "Temporarily increases kidnapping ability.", false,
                buyAction: {
                    baseCapture += 5
                },
                dayAction: {
                    if random() > 0.15 { return }
                    baseCapture -= 5
                    removeAsset("c")
                    lockedAssets.remove("c")
                    print("Bobo has run out of candy.")
                }
               ),
    "sm": .init("Sewing Machine", 200, "Use child labor to produce clothing and earn money.", size: 2,
                dayAction: {
                    if laborPool > 0 {
                        laborPool -= 1
                        earnings["clothes sales"] = earnings["clothes sales", default: 0] + 75
                    } else {
                        laborShortage += 1
                    }
                }
               ),
    "s": .init("Shackles", 60, "Metal shackles to prevent child from escaping. Better than rope."),
    "h": .init("Hitman", 10000, "Hired bounty hunter to help kill escaped children.",
               buyAction: {
                   murderChance = scaleUp(murderChance, 0.2)
               }
              ),
    "hab": .init("Hydrochloric Acid Barrel", 400, "Traceless method of body disposal. Reduces murder suspicion.", size: 1,
                 buyAction: {
                     murderSuspicion = scaleDown(murderSuspicion, 0.2)
                 }
                ),
    "ss": .init("Sweatshop", 50000, "far more efficient clothes production.", size: 150,
                dayAction: {
                    if laborPool >= 50 {
                        laborPool -= 50
                        earnings["clothes sales"] = earnings["clothes sales", default: 0] + 8000
                    } else {
                        laborShortage += 50
                    }
                }
               ),
    "bcs": .init("Basement Camera System", 4000, "Install surveillance cameras in the basement.", false,
                buyAction: {
                    escapeChance = scaleDown(escapeChance, 0.3)
                    massEscapeChance = scaleDown(massEscapeChance, 0.3)
                }
               ),
    "rbw": .init("Reinforced Basement Windows", 13000, "Solid steel bars and reinforced glass.", false,
                buyAction: {
                    escapeChance = scaleDown(escapeChance, 0.4)
                    massEscapeChance = scaleDown(massEscapeChance, 0.4)
                }
               ),
    "rbd": .init("Reinforced Basement Door", 30000, "4-inch steel bank vault door.", false,
                 buyAction: {
                     escapeChance = scaleDown(escapeChance, 0.5)
                     massEscapeChance = scaleDown(massEscapeChance, 0.5)
                 }
                ),
    "brv": .init("Basement Renovation", 9000, "Renovate the basement for 20% more space and additional security.", false,
                 buyAction: {
                     escapeChance = scaleDown(escapeChance, 0.5)
                     massEscapeChance = scaleDown(massEscapeChance, 0.5)
                     space += 20
                     lockedAssets.remove("bex")
                 }
                ),
    "bex": .init("Basement Expansion", 27000, "Excavate additional room in the basement. +50% space.", false,
                 buyAction: {
                     space += 60
                     lockedAssets.remove("b2")
                 }
                ),
    "b2": .init("Second Basement", 95000, "Dig out a second basement beneath the first. +180 space.", false,
                 buyAction: {
                     space += 180
                     lockedAssets.remove("b3")
                 }
                ),
    "b3": .init("Third Basement", 100000, "Dig out a third basement beneath the second. +180 space.", false,
                 buyAction: {
                     space += 180
                     lockedAssets.remove("b4")
                 }
                ),
    "b4": .init("Fourth Basement", 105000, "Dig out a fourth basement beneath the third. +180 space.", false,
                 buyAction: {
                     space += 180
                     lockedAssets.remove("b5")
                 }
                ),
    "b5": .init("Fifth Basement", 110000, "Dig out a fifth and final basement beneath the fourth. +180 space.", false,
                 buyAction: {
                     space += 180
                 }
                ),
    "swh": .init("Small Warehouse", 335000, "Purchase a small warehouse. +500 space.",
                 buyAction: {
                     space += 500
                 },
                 dayAction: {
                     if money >= 0 {
                         earnings["property taxes"] = earnings["property taxes", default: 0] - 800
                         //earnings["utility costs"] = earnings["utility costs", default: 0] - 400
                     } else {
                         event("The local government has seized Bobo's small warehouse because he has failed to pay the property tax.")
                         removeAsset("swh")
                     }
                 }
                ),
    "ps": .init("Police Scanner", 1100, "Decrypt police radio messages to aide in evasion of arrest.", false,
                 buyAction: {
                     evadeChance = scaleUp(evadeChance, 0.5)
                 }
                ),
    "hss": .init("Home Security System", 14000, "Advanced system to buy time during police raids. Also lessens escapes.", false,
                 buyAction: {
                     evadeChance = scaleUp(evadeChance, 0.5)
                     escapeChance = scaleDown(escapeChance, 0.33)
                     massEscapeChance = scaleDown(massEscapeChance, 0.33)
                 }
                ),
    "fly": .init("Flyers", 60, "Handouts to boost sales of children", false,
                 buyAction: {
                     baseSellChance = scaleUp(baseSellChance, 0.5)
                     sellChanceFalloff = scaleDown(sellChanceFalloff, 0.5)
                     undercoverChance = scaleDown(undercoverChance, 0.5)
                     salePrice *= 2
                     lockedAssets.remove("ad")
                 }
                ),
    "ad": .init("Advertising", 4000, "Advertising campaign to increase sales of children.", false,
                 buyAction: {
                     baseSellChance = scaleUp(baseSellChance, 0.5)
                     sellChanceFalloff = scaleDown(sellChanceFalloff, 0.5)
                     undercoverChance = scaleDown(undercoverChance, 0.5)
                     salePrice *= 3
                     lockedAssets.remove("mkt")
                 }
                ),
    "mkt": .init("Marketing Team", 8750, "Team of marketing experts who work tirelessly to bolster your sales.", false,
                 buyAction: {
                     baseSellChance = scaleUp(baseSellChance, 0.5)
                     sellChanceFalloff = scaleDown(sellChanceFalloff, 0.5)
                     undercoverChance = scaleDown(undercoverChance, 0.5)
                     salePrice *= 4
                 }
                ),
    "lw1": .init("Grade D Lawyer", 12000, "Rookie attorney to defend you in court.", false,
                 buyAction: {
                     lockedAssets.remove("lw2")
                 },
                 dayAction: {
                     if money < 0 {
                         print("Bobo does not have enough money to pay his lawyer. The lawyer has ended his contract with Bobo.")
                         removeAsset("lw1")
                         return
                     }
                     earnings["Legal Expenses"] = earnings["Legal Expenses", default: 0] - 600
                 }
                ),
    "lw2": .init("Grade C Lawyer", 70000, "Average attorney to defend you in court.", false,
                 buyAction: {
                     removeAsset("lw1")
                     lockedAssets.remove("lw3")
                 },
                 dayAction: {
                     if money < 0 {
                         print("Bobo does not have enough money to pay his lawyer. The lawyer has ended his contract with Bobo.")
                         removeAsset("lw1")
                         return
                     }
                     earnings["Legal Expenses"] = earnings["Legal Expenses", default: 0] - 1100
                 }
                ),
    "lw3": .init("Grade B Lawyer", 140000, "Veteran attorney to defend you in court.", false,
                 buyAction: {
                     removeAsset("lw2")
                     lockedAssets.remove("lw4")
                 },
                 dayAction: {
                     if money < 0 {
                         print("Bobo does not have enough money to pay his lawyer. The lawyer has ended his contract with Bobo.")
                         removeAsset("lw1")
                         return
                     }
                     earnings["Legal Expenses"] = earnings["Legal Expenses", default: 0] - 1800
                 }
                ),
    "lw4": .init("Grade A Lawyer", 360000, "Master attorney to defend you in court.", false,
                 buyAction: {
                     removeAsset("lw3")
                     lockedAssets.remove("sg")
                 },
                 dayAction: {
                     if money < 0 {
                         print("Bobo does not have enough money to pay his lawyer. The lawyer has ended his contract with Bobo.")
                         removeAsset("lw1")
                         return
                     }
                     earnings["Legal Expenses"] = earnings["Legal Expenses", default: 0] - 2700
                 }
                ),
    "sg": .init("Grade A Lawyer", 690000, "Saul Goodman.", false,
                 buyAction: {
                     removeAsset("lw4")
                 },
                 dayAction: {
                     if money < 0 {
                         print("Bobo does not have enough money to pay his lawyer. The lawyer has ended his contract with Bobo.")
                         removeAsset("lw1")
                         return
                     }
                     earnings["Legal Expenses"] = earnings["Legal Expenses", default: 0] - 6000
                 }
                ),
    "lgt": .init("Legal Team", 540000, "An entire legal team for your personal defense in court.",
                 dayAction: {
                     if money < 0 {
                         print("Bobo does not have enough money to pay his lawyer. The lawyer has ended his contract with Bobo.")
                         removeAsset("lw1")
                         return
                     }
                     earnings["Legal Expenses"] = earnings["Legal Expenses", default: 0] - 5200
                 }
                )
]

func buy(_ many: Bool = false) {
    print("*** Buy Menu ***")
    let keys = assetList.keys.sorted(by: { assetList[$0]?.cost ?? 0 > assetList[$1]?.cost ?? 0 })
    for key in keys where !lockedAssets.contains(key) {
        let a = assetList[key]!
        if a.cost > money { continue }
        print("[\(key)]" + " \(a.name), $\(a.cost) - " + a.description)
    }
    
    while true {
        print("Enter tag to purchase:")
        let i = input().lowercased()
        if let a = assetList[i], !lockedAssets.contains(i) {
            var count = 1
            if many && a.renewable {
                print("How many?")
                guard let c = Int(input()) else {
                    print("Not a number")
                    return
                }
                count = c
            }
            if count == 0 { return }
            
            guard money >= a.cost * count else {
                print("Insufficient funds.")
                return
            }
            guard unusedSpace >= a.size * count else {
                print("Not enough space to put the assets(s).")
                return
            }
            
            money -= a.cost * count
            usedSpace += a.size * count
            if !a.renewable { lockedAssets.insert(i) }
            for _ in 0..<count { assets.append(i) }
            if count > 1 {
                print("Bobo has purchased \(count) '\(a.name)' for $\(a.cost * count).")
            } else {
                print("Bobo has purchased a '\(a.name)' for $\(a.cost).")
            }
            for _ in 0..<count { a.buyAction?() }
            return
        } else {
            print("Invalid tag.")
            return
        }
    }
}

func openSweatshop() {
    guard let ss = assetList["ss"] else { print("An unexpected error has occurred [0001]") ; return }
    guard money > ss.cost else { print("Insufficient funds.") ; return }
    var count = 40
    while count > 0 {
        guard let i = assets.firstIndex(where: { $0 == "sm" }) else {
            print("An unexpected error has occurred [0010]") ; return
        }
        assets.remove(at: i)
        count -= 1
    }
    assets.append("ss")
    money -= ss.cost
    print("Bobo has consolidated 40 of his sewing machines and has opened a sweatshop.")
}
