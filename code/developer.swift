import Foundation
import CryptoKit

func devTools() {
    var i = input()
    let h = SHA256.hash(data: withUnsafeBytes(of: i, Array.init)).map { String(format: "%02x", $0) }.joined()
    if h != "48664edd102301812a707ddb860eb8893450e2a79e79839ff2a0adf009ed1868" { return }
    
    print("""
*** DEV TOOLS ***
[ac] add children
[am] add money
[ma] murder all
[ar] arrest bobo
[e] exit
""")
    while true {
        i = input()
        if i == "e" { return }
        if i == "ac" {
            print("How many?")
            let n = Int(input()) ?? 0
            for _ in 0..<n {
                let child = Child()
                capturedKids.insert(child.id)
            }
            print("Added \(n) children.")
        }
        if i == "am" {
            print("How much?")
            let n = Int(input()) ?? 0
            money += n
            print("Added $\(n).")
        }
        if i == "ma" {
            escapedKids = []
            print("Murdered all children.")
        }
        if i == "ar" {
            checkArrest()
        }
    }
    
}
