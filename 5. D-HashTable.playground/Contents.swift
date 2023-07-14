import UIKit

struct HashTable<T: Equatable> {
    private var hashTable: [T?] = .init(repeating: nil, count: 4)
    
    func hash(key: String) -> Int {
        // string의 자리수에 따라 hashIndex로 바꾸어주는 임시 로직
        key.count % 4
        
    }
    
    mutating func updateValue(key: String, data: T) {
        let hashIndex = hash(key: key)
        self.hashTable[hashIndex] = data
    }
    
    mutating func getValue(key: String) -> T? {
        let hashIndex = hash(key: key)
        
        if self.hashTable.count > hashIndex {
            return self.hashTable[hashIndex]
        } else {
            return nil
        }
    }
}

var intValue = HashTable<Int>()

intValue.updateValue(key: "1", data: 1)
intValue.updateValue(key: "12", data: 12)

print(intValue.getValue(key: "1"))
print(intValue.getValue(key: "12"))

intValue.updateValue(key: "9", data: 9)
print(intValue.getValue(key: "1"))
// HASH Index가 동일함으로 발생하는 충돌현상

print(intValue.getValue(key: "999"))

print("--------------------------------------")
// Chaining > LinkedList를 사용하여 충돌을 없앰
class Node<T: Equatable> {
    var data: (data: T, key: String)?
    var next: Node?
    
    init(data: T, key: String, next: Node? = nil) {
        self.data = (data: data, key: key)
        self.next = next
    }
}

class LinkedList<T: Equatable> {
    private var head: Node<T>?
    
    func append(data: (data: T, key: String)) {
        guard self.head != nil else {
            self.head = Node(data: data.data, key: data.key)
            return
        }
        
        var node = self.head
        while node?.next != nil {
            node = node?.next
        }
        node?.next = Node(data: data.data, key: data.key)
    }
    
    func removeLast() {
        guard self.head != nil else {return}
        guard self.head?.next != nil else {self.head = nil; return}
        
        var node = self.head
        while node?.next?.next != nil {
            node = node?.next
        }
        
        node?.next = nil
    }
    
    func searchNode(key: String) -> (data: T, key: String)? {
        guard self.head != nil else {return nil}
        guard self.head?.next != nil else {return self.head?.data}
        
        var node = self.head
        while node?.next != nil {
            if node?.data?.key == key {break}
            node = node?.next
        }
        
        return node?.data
    }
}

struct HashTableWithNode<T: Equatable> {
    private var hashTable: [LinkedList<T>?] = .init(repeating: nil, count: 4)
    
    func hash(key: String) -> Int {
        key.count % 4
    }
    
    mutating func updateValue(key: String, data: T) {
        let hashIndex = hash(key: key)
        
        if self.hashTable[hashIndex] == nil {
            self.hashTable[hashIndex] = LinkedList<T>.init()
        }
        
        self.hashTable[hashIndex]?.append(data: (data: data, key: key))
    }
    
    mutating func getValue(key: String) -> T? {
        let hashIndex = hash(key: key)
        
        if self.hashTable.count > hashIndex {
            return self.hashTable[hashIndex]?.searchNode(key: key)?.data
        } else {
            return nil
        }
    }
}

var stringValue = HashTableWithNode<String>()

stringValue.updateValue(key: "1", data: "1")
stringValue.updateValue(key: "12", data: "12")

print(stringValue.getValue(key: "1"))
print(stringValue.getValue(key: "12"))

stringValue.updateValue(key: "9", data: "9")
print(stringValue.getValue(key: "1"))

stringValue.updateValue(key: "10", data: "10")
print(stringValue.getValue(key: "12"))
print(stringValue.getValue(key: "10"))

print(stringValue.getValue(key: "999"))
