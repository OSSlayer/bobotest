var otherActions = [String:(String,()->())]()

func other() {
    print("*** Other Actions ***")
    for (tag,action) in otherActions { print("[\(tag)] \(action.0)") }
    
    while true {
        print("Enter tag to perform action:")
        let i = input().lowercased()
        
        guard let a = otherActions[i] else { print("Invalid tag.") ; return }
        a.1()
        break
    }
}

func attemptCapture() {
    var x = Int.random(in: 0...maxCapture())
    
    if unusedSpace == 0 {
        print("Bobo does not have enough space in his basement for more kids.")
        return
    }
    
    if x == 0 {
        print("Bobo could not find any children to capture.")
        return
    }
    
    if random() > captureChance {
        print("Bobo has failed to capture a child.")
        return
    }
    
    x = min(unusedSpace, x)
    if x == 1 {
        print("Bobo has captured a child.")
    } else {
        print("Bobo has captured \(x) children.")
    }
    
    for _ in 0..<x { let c = Child() ; capturedKids.insert(c.id) ; usedSpace += 1 }
    totalCaptures += x
    latestCaptures += x
    
    for _ in 0..<x { suspicionLevel = scaleUp(suspicionLevel, captureSuspicion) }
    captureAttempts += 1
}

func attemptMurder() {
    if escapedKids.isEmpty {
        print("There are no escaped kids to murder.")
        return
    }
    if murderAttempted {
        print("Bobo has already attempted to murder today.")
        return
    }
    
    var x = 0
    for _ in 0..<escapedKids.count where random() < murderChance { x += 1 }
    
    var murdered = Set<Int>()
    for _ in 0..<x {
        let kid = escapedKids.randomElement()!
        escapedKids.remove(kid)
        murdered.insert(kid)
    }
    
    murderAttempted = true
    
    if x == 0 {
        print("Bobo has failed to murder any escaped children.")
        return
    } else if x == 1 {
        print("Bobo has murdered \(children[murdered.randomElement()!].name).")
    } else if x == escapedKids.count {
        print("Bobo has murdered all the escaped children.")
    } else {
        print("Bobo has murdered \(x) escaped children.")
    }
    
    totalMurders += x
    latestMurders += x
    var barrelCount = assetCounts["hab", default: 0]
    for _ in 0..<x {
        barrelCount -= 1
        suspicionLevel = scaleUp(suspicionLevel, scaleDown(murderSuspicion, barrelCount + 1 > 0 ? 0.66 : 0))
    }
    
    if murdered.count > 1 {
        print("View murdered kids? [y/n]")
        if input().lowercased() == "y" { printNames(murdered) }
    }
}

func attemptSale(_ specific: Bool = false) {
    if capturedKids.isEmpty {
        print("Bobo does not have any children to sell.")
        return
    }
    if random() < adjUndercoverChance() {
        print("Bamboozled! Bobo tried to sell a child but the buyer was an undercover cop!")
        checkArrest()
        return
    }
    if noSale || random() > sellChance() {
        print("Nobody wants to buy a child right now.")
        noSale = true
        return
    }
    
    var id = -1
    if specific {
        print("Children in basement:")
        printNames(childrenIds)
        while true {
            print("Which child does Bobo want to sell? Type 'any' or 'a' to select a random child.")
            let i = input()
            if i == "any" || i == "a" {
                id = capturedKids.randomElement()!
                break
            }
            if let c = capturedKids.first(where: { children[$0].name == i }) {
                id = c
                break
            } else {
                print("Invalid child, please type the child's full name or type 'any' / 'a'.")
            }
        }
    } else {
        id = capturedKids.randomElement()!
    }
    
    let price = salePrice + Int(2 * (random() - 0.5) * D(salePrice) * 0.2) // TODO: add child-based price
    print("Bobo has sold \(children[id].name) for $\(price).")
    capturedKids.remove(id)
    money += price
    salesCount += 1
    suspicionLevel = scaleUp(suspicionLevel, saleSuspicion)
    usedSpace -= 1
}
