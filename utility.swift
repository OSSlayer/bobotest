func clrScrn() { for _ in 0..<80 { print("\n") } }
func input() -> String { while true { if let input = readLine() { return input } } }
func rest() { let _ = input() }
func check() { print("(press enter)") ; rest() }

typealias sId = String

func scaleDown(_ x: Double, _ factor: Double) -> Double { x * (1 - factor) }
func scaleUp(_ x: Double, _ factor: Double) -> Double { 1 - ((1 - x) * (1 - factor)) }

func random() -> Double { Double.random(in: 0...1) }

func pow(_ x: Double, _ n: Int) -> Double {
    var output = 1.0
    for _ in 0..<n { output *= x }
    return output
}

func D(_ x: Int) -> Double { Double(x) }
func I(_ x: Double) -> Int { Int(x) }

func event(_ str: String) { eventFlag = true ; print(str) }

func printDict(_ dict: [String:Int]) {
    let keys = dict.keys.sorted()
    for key in keys { print("\(key): \(dict[key] ?? -1)") }
}

func cap(_ str: String) -> String {
    str.split(separator: " ").map { $0.prefix(1).uppercased() + $0.dropFirst().lowercased() }.joined(separator: " ")
}
