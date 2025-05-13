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
