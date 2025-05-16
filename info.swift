func summary() {
    print("- Money: $\(money) | Space: \(unusedSpace) | Kids: \(capturedKids.count)" + (escapedKids.count == 0 ? "" : " | Escaped: \(escapedKids.count)") + " -")
}

func infoScreen() {
    print("Enter tag to view info.")
    print("[ct] Controls")
    print("[d] Days")
    print("[c] Capturing")
    print("[s] Selling")
    print("[m] Murdering")
    print("[e] Escapees")
    print("[p] Police")
    print("[j] Judicial System")
    print("[b] Buying")
    print("[l] Labor")
    print("[sp] Space")
    print("[a] Assets")
    print("[svld] Saving and Loading")
    
    switch input().lowercased() {
    case "ct":
        print("""
            This game is fully command-line controlled. This means that actions are done by entering text into the command prompt.
            You can perform various actions through commands which you can view with 'h' or 'help'.
            A command is something you can enter during the day. Whever you see - Money: ___ | Space: ____ | Kids: ____ - or similar, that means you can enter a command. If you use 'h' to view commands, you can use either the long form or short form of the command.
            Another input method used in this game is the tag pattern. For example, the way you had to select this info subject, or the way you buy things. Because it would suck to type out the entire name of something, shorthand tags are given to reference it instead.
            Oftentimes if you give an invalid input, the game will cancel the action you were trying to do. Ex. If you enter an invalid number when trying to buy, it will cancel and it will show you the - Money: | Space: | Kids: - line again showing that you must enter a command again.
            You will also see times which say (press enter). This is used just to pause the text on the screen and give you a chance to read what is going on, or to make it seem more interactive and/or dramatic.
            """)
    case "d":
        print("""
            Days are the unit of time in this game. Each day you can enter your commands, aka your actions. These can all be viewed with 'h' or 'help'.
            At the start of a day, you can enter your commands, and then when you are done, you can press enter (with no command typed) to finish the day.
            The process of finishing the day involves three parts: 1. Asset updates, 2. Earnings, 3. Random Events.
            During asset updates, each asset will perform whatever its functionality is. Then during earnings, all of your earnings are shown for the day, if you have any. After that, random events are run. Then the day finishes and the next begins.
            """)
    case "c":
        print("""
            When you want to capture a kid, a base success chance is rolled to see if you are successful at all. If you are successful, then a random number of kids is selected. This range includes 0 - found no kids, and the maxCapture, which is a stat that can be improved by upgrades. 
            The maximum capture amount decreases with each *successful* capture attempt per day. So failed captures don't decrease it. But with every successful capture, no matter how many kids, the max amount you can capture with the next attempt decreases.
            This means that you cannot spam infinite captures in one day. You will run out of kids to capture that day, which is realistic.
            Every capture raises the suspicion level by a small amount - the "Capture Suspicion" stat.
            """)
    case "s":
        print("""
            When you sell a kid, a random chance occurs to see if there is even anyone willing to purchase a kid. If there is nobody, the game marks that entire day as having nobody available. The chance that there is a buyer can be increased with upgrades.
            This means that if the game tells you that nobody wants to buy right now, you must wait until the next day to sell again. If you keep trying on the same day, it will not change.
            The only reason I added "sell specific" was for if you wanted to sell a specific kid because of their name or something being funny.
            Also, whenever you sell, there is a small chance that it is an undercover cop and then the police *try* to arrest you. This chance goes up during an active police investigation.
            Every sale raises the suspicion level by a small amount - the "Sale Suspicion" stat.
            """)
    case "m":
        print("""
            When you attempt murder, it rolls a chance of success for each escaped kid. The base chance is only 10% and can be upgraded with hitmen for example. You can only murder once a day.
            Each murder raises the suspicion level by a small amount - the "Murder Suspicion" stat.
            """)
    case "e":
        print("""
            Every day, for each captured child, an escape chance is rolled to determine if that child escapes. This chance can be reduced with shackles (per child) and other upgrades.
            Additionally, there is a chance for a mass breakout if you have more than 4 kids, in which 4 to all of your kids can escape at once. 
            Each escaped child has a daily chance to report you to the police. This chance can be reduced with upgrades.
            """)
    case "p":
        print("""
            Police will catch on to you when your suspicion level gets above the investigation threshold. Various actions affect the former, and the latter can change from events as well.
            Suspicion level slowly declines each turn by default. So if you do not do enough bad actions, your suspicion level will decline.
            If it falls below half of the investigation threshold, the case goes cold and is called off. Then the investigation threshold is raised. (picture it as police not being as willing to begin an investigation since the last one went cold).
            During an investigation, there is a very small chance each turn that their investigation causes them to catch you. This chance is the suspicion level squared times 1/5 times (1 - suppression level). Currently the suppression level is always 0 but future upgrades are planned to allow the chance to be suppressed.
            When police catch you, it is not a guaranteed arrest. You have a base 50% chance to evade arrest. This can be increased with upgrades to a substantial extent. If you fail, however, you get arrested.
            When you are arrested, all your kids are released and the investigation threshold lowers (they are more likely to investigate you in the future now that you are a known criminal).
            """)
    case "j":
        print("""
            The judicial system is modeled heavily off of real US court proceedings, but simplified.
            The crimes you commit, mainly kidnappings, murders, and evasions of arrest (possibly trafficking sales in the future as well) are tracked and you are charged with them when arrested.
            You are given a plea deal with only 75% penalties as a base amount. This can be reduced more with better lawyers.
            Before the hearing to determine if you are guilty, you can bribe or threaten the jury. Threatening the jury has a 50% chance to work, or 50% chance to cause a report and you are retried with an additional 12 charges (and can't bribe/threaten again).
            Bribery has a 25000 / (B + 25000) chance to not work (its the chance to cause them to report you) (its a decimal not a percent). This means the more you offer, the less likely they are to report you. 100 grand is roughly a 20% chance for a report (remember, its divided amongst 12 jurors).
            Both bribery and threatening, if successful, will make the jury rule you not guilty. Otherwise, you have a base 95% chance to be found guilty for each individual count of each charge. This can be reduced with lawyers.
            After the hearing, if you are guilty, you will have the sentencing. Again, you can bribe/threaten the judge. Bribing has the same chance equation. A successful threaten makes the judge 50% less harsh. 
            A successful bribe depends on how much it is. The factor of harshness is the same as that 25000 / (x + 25000) equation for your chance of a successful bribe. So a 100k bribe would make the judge .2x as harsh, or 20%. It is also only 20% likely to fail.
            After bribing/threatening the judge, your lawyers fight to further reduce your guiltiness. Following this, the total time in jail and fines are added up from all convicted counts of charges and then are multiplied by the harshness factor to reduce harshness from your lawyers / bribes / threats.
            You can and often will go into debt from the fines, at least early on before you have a good lawyer. This can be crippling and hard to get out of as you cannot buy anything during this time. I plan to add loans or something to counter this.
            """)
    case "b":
        print("""
            When buying assets, you must have enough money and enough space. 
            Often you will want to buy multiple things, which is when you should use the 'buy multiple' or 'bm' command.
            """)
    case "l":
        print("""
            Some sources of money require labor to function. Each sewing machine, for example, requires 1 labor, and sweatshops require 50. Each child is 1 labor. 
            Before each asset performs its function each day, the total labor is set to the number of captured kids. Then each asset will subtract the amount of labor it uses and perform its action, if there is enough labor.
            If there isn't enough labor, the asset will not perform its action and will add this amount of labor to a variable tracking how much extra labor is needed. 
            However, this variable is marked as an estimate because it is not fully accurate. A sweatshop will fail if there is only 49 labor. So it will add 50 to the variable and then in the earnings report you will see that you have an estimated labor shortage of 50, and then think that you need 50 more kids, even though you only need 1 more.
            """)
    case "sp":
        print("""
            Most assets require 0 space, but some like acid barrels (hab) require 1 space, and sewing machines (sm) require 2 space. (1 space = 1 m^2) (A sewing machine is like a sewing machine on a table and chair for the worker). Children are also 1 space each.
            You can get more space with upgrades and asset purchases.
            """)
    case "a":
        print("""
            An asset is just something that you owned. For example, a sweatshop. Even though you didn't buy it, you made it, and still own it. Assets are most commonly bought, however, and you can view all the assets you own with 'la' ('list assets').
            Each asset may have a buy action and, a day action, both, or neither. These are internally in the code, but basically some assets do things upon purchase, others do them each day, others do both, and others do things in special instances. 
            Ex. Lawyers subtract a pay each day but are also used in the special instance of court. 
            Ex. Shackles don't do anything except when rolling to see if kids escape each day, where the number of shackles is tracked and for each kid a shackle is used and reduces their escape chance. The shackle isn't doing anything on its own, its just serving as a number for how many kids should have their chances reduced..
            """)
    case "svld":
        print("""
            You can save and load your game at any time. Loading a game will move it to the next day just because otherwise issues and bugs could arise based on what point in the day you originally saved at.
            If you use the 'st' or 'stats' menu right after loading, some stats may otherwise not have updated because they are calculated each day. The preivously mentioned forced move to the next day should mostly prevent that.
            Only one game is ever saved at a time. The data is stored in savefile.txt in the same folder as the game. Curious players may inspect this file and note the data stored within. It is possible to manually change this data. 
            However, nothing is labeled and you would have to figure out what each number is based on comparing it to the stats screen or something. I left this detail intentionally to reward smart players and give them the freedom to mess around with their save files if they could figure out certain values. 
            As an example, storing the kids names takes up a lot of space because it stores the entire text of their name. I was going to change this so that the save file just has a number for their name which represents the name at that number spot in the list of all names. This would compact the save file, but I realized it wouldn't allow players to write specific names.
            """)
    default:
        print("Invalid tag.")
    }
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
    print("buy / b = open buy menu")
    print("buy many / bm = open buy menu with option to purchase many(multiple) at once")
    print("list captured / lc = list names of all captured children")
    print("list escaped / le = list names of all escaped children")
    print("list assets / la = list all assets")
    print("other / o = open other (obscure) actions menu")
    print("info / i = view info screen")
    print("stats / st = view stats")
    print("save / sv = save game")
    print("load / ld = load game")
    print("help / h = view help")
}

func printAssets() {
    for (tag,count) in assetCounts {
        guard let name = assetList[tag]?.name else { print("[Asset Error] Could not find asset '\(tag)'.") ; continue }
        print("\(cap(name)): \(count)")
    }
}
