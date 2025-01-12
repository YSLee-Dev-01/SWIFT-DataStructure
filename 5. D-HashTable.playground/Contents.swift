import UIKit

/// 5. HashTable
/// Key와 Value로 데이터를 저장하며, Key를 입력하면 맞는 Value가 나오는 형태의 자료구조
/// - Swift의 딕셔너리와 유사하며, 실제로 딕셔너리도 내부에서 HashTable을 이용하여 구성이 되어 있음
/// - 자료의 순서를 보장하지 않음
///
/// HashTable은 내부에 배열을 통해 값을 저장하고 있음
/// Key와 Value을 저장하면, Hash 함수를 통해 Key를 Hash하고, Hash 주소 값에 해당하는 HashTable 슬롯에 데이터를 저장함
/// - Key 값만으로 배열의 index를 확인하고, 데이터를 가져올 수 있어야함
///
/// Key값을 항상 고유의 Hash 주소로 만들어 주는 함수를 Hash 함수라고함
/// 해당 함수를 이용하여 Key는 Hash 주소로 변환 후, HashTable의 특정 주소의 테이블 값에 접근하는 것

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
