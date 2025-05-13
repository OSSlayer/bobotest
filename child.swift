nonisolated(unsafe) var children = [Child]()
nonisolated(unsafe) var childrenIds: Set<Int> {
    var output = Set<Int>()
    for child in children { output.insert(child.id) }
    return output
}

func printNames(_ set: Set<Int>) {
    var names = ""
    for child in set { names += children[child].name + ", " }
    print(names.dropLast(2))
}

class Child {
    let id: Int
    let gender: Bool
    
    let first, last: String
    var name: String { first + " " + last }
    
    init(first: String? = nil, last: String? = nil, gender: Bool? = nil) {
        self.gender = gender ?? .random()
        self.first = first ?? (self.gender ? boys : girls).randomElement()!
        self.last = last ?? lastnames.randomElement()!
        
        id = children.count
        children.append(self)
    }
}

nonisolated let boys: Set<String> = [
    "James", "John", "Will", "Charlie", "George", "Joe", "Thomas",
    "Richard", "Albert", "Frank", "Harold", "Walter", "Harry", "Eugene", "Sam",
    "Ralph", "Alfred", "Fred",
    "Jack", "Stanley", "Andrew",
    "Donald", "Allen", "Norman", "Edwin", "Victor",
    "Clyde", "Lester", "Gilbert", "Jesse", "Peter", "Philip",
    "Martin", "Clifford", "Alvin", "Arnold", "Floyd", "Leo", "Steven",
    "Ben",
    "Jerome", "Hugh", "Grover", "Matthew",
    "Wilbur", "Jacob",
    "Ethan", "Owen", "Bennett", "Dominic", "Ben", "Adam", "Enzo", "Sebastian", "Keegan",
    "Adolf", "Dick", "Bob", "Bobby", "Bobert", "John", "Greg", "Keegan", "Anderson", "Reid",
    "Fidel", "Bruce", "Michael", "Aaron", "Jimmy", "Philbert", "David"
]

nonisolated let girls: Set<String> = [
    "Mary", "Elizabeth", "Anna",
    "Grace", "Alice",
    "Martha", "Laura", "Ella",
    "Annie", "Violet", "Eva", "Julia",
    "Sarah", "Charlotte", "Jenny",
    "Olive", "Emily",
    "Nora", "Barb", "Rachel", "Susan", "Jane",
    "Lucy", "Amy", "Rebecca", "Victoria",
    "Caroline", "Cat",
    "Ann",
]

nonisolated let lastnames: Set<String> = [
    "Smith", "Johnson", "Brown", "Jones", "Miller", "Garcia", "Rodriguez", "Wilson", "Martinez",
    "Jackson", "Thompson", "White", "Lopez",
    "Gonzalez", "Harris", "Perez", "Hall", "Young",
    "Allen", "King", "Adams", "Hill",
    "Ramirez", "Campbell", "Roberts", "Evans",
    "Collins", "Murphy", "Cook", "Rodgers",
    "Bell", "Gomez",
    "Cox", "Diaz", "Wood", "Watson", "Bennett", "Gray", "James", "Reyes",
    "Cruz", "Myers", "Long", "Foster", "Morales", "Powell",
    "Sullivan", "Butler", "Barnes", "Fisher",
    "Coleman", "Simmons", "Jordan", "Gonzales",
    "West", "Bryant", "Ellis",
    "Stevens", "Ford", "Owens", "McDonald", "Kennedy",
    "Woods", "Washington",
    "Simpson",
    "Wagner", "Hunter", "Hunt", "Black",
    "Stone", "Fox", "Rose", "Rice", "Arnold", "Knight",
    "Wheeler", "Dunn", "Pierce", "Berry",
    "Holland", "Ball", "Jacobs",
    "Cummings", "Jennings", "Fields",
    "Bishop", "Carr", "Day",
    "Guyette", "Schwarten", "Bobinski", "Farone", "D'Angelo", "Gerstner", "Fogarty", "Madson", "Klein",
    "LeCaptain", "DeRuyter", "Maxfield", "Beers", "Broekman", "Gretzinger", "Stein",
    "Stary", "Manning", "Geiser", "Masarik",
    "Trump", "Castro", "Wayne", "Biden"
]
