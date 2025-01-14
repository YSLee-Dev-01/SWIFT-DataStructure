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
///
/// Hash란?
/// 다양한 길이의 데이터를 고정된 길이의 데이터로 매핑하는 것
/// - 큰 값을 넣어도, 작은 값을 넣어도 정해진 크기가 나오는 것
/// 무결성, 보안성을 가지고 있지만, 충돌 가능성이 있음
/// - 입력값보다 출력값이 작음으로 서로 다른 값이야도 동일한 Hash가 나올 수 있음
///
/// HashTable은 Hash를 이용하기 때문에 충돌이 발생할 가능성이 있음
/// - 충돌은 Key 값이 동일하여 Value가 덮어씌어지는 현상을 의미
///
/// 이러한 문제를 해결하기 위해 개방 Hash, 폐쇄 Hash 방식을 사용함
///
/// 개방 Hash
/// HashTable 이외에 저장공간을 활용하여 충돌을 해결하는 것
/// - LinkedList를 주로 사용함
///
/// HashTable에 Data를 저장할 때 바로 저장하는 것이 아닌 LinkedList 내부에 저장하는 것
/// - Key값의 중복 관리를 위해 Key, Value 모두 Node에 저장함
///
/// 폐쇄 Hash
/// HashTable 내에서 충돌을 해결하는 방법
/// - Index를 통해 충돌이 발생한 HashTable을 순회하여 가장 처음에 나오는 빈공간에 데이터를 저장하는 것
/// - Key 값의 중복 관리를 위해 동일하게 Key, Value를 모두 저장함
///
/// HashTable은 O(1)의 속도를 가지고 있음
/// - 충돌이 발생하는 상황을 최대한 고려하고 제작하기 때문에 O(1)로 취급
/// 실행속도는 빠르지만, 공간의 효율성은 낮은 자료구조

struct HashTable<T: Equatable> {
    private var hashTable: [T?] = Array(repeating: nil, count: 10)
    
    private func hash(_ key: String) -> Int {
        // key의 count에 따라 index를 반환하는 로직
        key.count
    }
    
    mutating func updateValue(_ data: T, forKey key: String ) {
        let hash = self.hash(key)
        
        if self.hashTable[hash] != nil {
            print("충돌 발생 데이터 소멸됨 키: \(key)")
        }
        self.hashTable[hash] = data
    }
    
    mutating func getValue(forKey key: String) -> T? {
        self.hashTable[self.hash(key)]
    }
    
    mutating func remove(forKey key: String) {
        self.hashTable[self.hash(key)] = nil
    }
}
var stringValue = HashTable<String>()
stringValue.updateValue("철수", forKey: "김")
stringValue.updateValue("しんのすけ", forKey: "野原") // 신짱구
stringValue.updateValue("Milfer", forKey: "Penny") // 한유리

print(stringValue.getValue(forKey: "김"))
print(stringValue.getValue(forKey: "野原"))
print(stringValue.getValue(forKey: "Penny"))

stringValue.updateValue("훈이", forKey: "이")
print(stringValue.getValue(forKey: "김")) // 충돌 발생


class Node<T: Equatable> {
    var data: T?
    var key: String
    var next: Node?
    
    init(data: T, key: String, next: Node? = nil) {
        self.data = data
        self.key = key
        self.next = next
    }
}

class LinkedList<T: Equatable> {
    private var head: Node<T>?
    
    func append(data: T, forKey key: String) {
        if self.head == nil {
            self.head = Node(data: data, key: key)
            return
        }
        
        var nowNode = self.head
        while nowNode?.next != nil {
            nowNode = nowNode?.next
        }
        
        nowNode?.next = Node(data: data, key: key)
    }
    
    func search(_ key: String) -> T? {
        if self.head == nil {return nil}
        
        var nowNode = self.head
        while nowNode != nil {
            if nowNode?.key == key {
                return nowNode?.data
            }
            nowNode = nowNode?.next
        }
        return nil
    }
    
    func remove(_ key: String) -> Bool { // head가 없음을 bool로 리턴
        if self.head == nil {return true}
        if self.head?.next == nil && self.head?.key == key {
            self.head = nil
            return true
        }
        
        var nowNode = self.head
        while nowNode?.next != nil {
            if nowNode?.next?.key == key {break}
            nowNode = nowNode?.next
        }
        nowNode?.next = nowNode?.next?.next
        return false
    }
}

struct HashTableWithChaining<T: Equatable> {
    private var hashTable: [LinkedList<T>?] = Array(repeating: nil, count: 10)
    
    private func hash(_ key: String) -> Int {
        // key의 count에 따라 index를 반환하는 로직
        key.count
    }
    
    mutating func updateValue(_ data: T?, forKey key: String) {
        let hash = self.hash(key)
        if self.hashTable[hash] == nil && data != nil {
            self.hashTable[hash] = LinkedList<T>() // 처음 hash에 값을 넣는 경우 LinkedList 생성
            print("CREATE LINKEDLIST")
        }
        
        if data == nil {
            let isLast = self.hashTable[hash]!.remove(key) // data에 nil을 넣는 경우 remove
            if isLast {
                self.hashTable[hash] = nil // 만약 마지막 데이터를 지운 경우 LinkedList도 nil
                print("REMOVE LINKEDLIST")
            }
        } else {
            self.hashTable[hash]?.append(data: data!, forKey: key)
        }
        
    }
    
    mutating func getValue(forKey key: String) -> T? {
        let hash = self.hash(key)
        return self.hashTable[hash]?.search(key)
    }
}

print("-----------------")

var stringValueWithChaining = HashTableWithChaining<String>()
stringValueWithChaining.updateValue("철수", forKey: "김")
stringValueWithChaining.updateValue("しんのすけ", forKey: "野原") // 신짱구
stringValueWithChaining.updateValue("Milfer", forKey: "Penny") // 한유리

print(stringValueWithChaining.getValue(forKey: "김"))
print(stringValueWithChaining.getValue(forKey: "野原"))
print(stringValueWithChaining.getValue(forKey: "Penny"))

stringValueWithChaining.updateValue("훈이", forKey: "이")
print(stringValueWithChaining.getValue(forKey: "김"))
print(stringValueWithChaining.getValue(forKey: "이"))

stringValueWithChaining.updateValue(nil, forKey: "Penny")
print(stringValueWithChaining.getValue(forKey: "Penny"))


struct HashTableWithLinearProbing<T: Equatable> {
    struct DataSaveModel<T: Equatable> {
        let key: String
        let value: T
    }
    
    private var hashTable: [DataSaveModel<T>?] = Array(repeating: nil, count: 10)
    
    private func hash(_ key: String) -> Int {
        // key의 count에 따라 index를 반환하는 로직
        key.count
    }
    
    mutating func updateValue(_ data: T?, forKey key: String) {
        if data == nil {
            self.remove(forKey: key)
            return
        }
        
        let hash = self.hash(key)
        let model = DataSaveModel(key: key, value: data!)
        
        if self.hashTable[hash] == nil {
            self.hashTable[hash] = model
            return
        }
        
        let isUp = hash >= self.hashTable.count / 2
        var index = 1
        
        while isUp ? index < self.hashTable.count : index >= 0 {
            if self.hashTable.count > index + hash {
                if self.hashTable[index + hash] == nil {
                    self.hashTable[index + hash] = model
                    return
                }
            }
            if hash - index >= 0 {
                if self.hashTable[hash - index] == nil {
                    self.hashTable[hash - index] = model
                    return
                }
            }
            index += 1
        }
        
        print("Array 공간을 꽉차서 더 이상 저장 불가")
    }
    
    mutating private func remove(forKey key: String) {
        let hash = self.hash(key)
        
        if self.hashTable[hash]?.key == key {
            self.hashTable[hash] = nil
            print("원래 자리에서 제거 됨, \(hash)")
            return
        }
        
        let isUp = hash >= self.hashTable.count / 2
        var index = 1
        
        while isUp ? index < self.hashTable.count : index >= 0 {
            if self.hashTable.count > index + hash {
                if self.hashTable[index + hash]?.key == key {
                    self.hashTable[index + hash] = nil
                    print("다른 자리에서 제거됨")
                    return
                }
            }
            if hash - index >= 0 {
                if self.hashTable[hash - index]?.key == key{
                    self.hashTable[hash - index] = nil
                    print("다른 자리에서 제거됨")
                    return
                }
            }
            index += 1
        }
    }
    
    mutating func getValue(forKey key: String) -> T? {
        let hash = self.hash(key)
        
        if self.hashTable[hash]?.key == key {
            return self.hashTable[hash]?.value
        }
        
        let isUp = hash >= self.hashTable.count / 2
        var index = 1
        
        while isUp ? index < self.hashTable.count : index >= 0 {
            if self.hashTable.count > index + hash {
                if self.hashTable[index + hash]?.key == key {
                    return self.hashTable[index + hash]?.value
                }
            }
            
            if hash - index >= 0 {
                if self.hashTable[hash - index]?.key == key {
                    return self.hashTable[hash - index]?.value
                }
            }
            index += 1
        }
      
        return nil
    }
}

print("-----------------")

var stringValueLinearProbing = HashTableWithLinearProbing<String>()
stringValueLinearProbing.updateValue("철수", forKey: "김")
stringValueLinearProbing.updateValue("しんのすけ", forKey: "野原") // 신짱구
stringValueLinearProbing.updateValue("Milfer", forKey: "Penny") // 한유리

print(stringValueLinearProbing.getValue(forKey: "김"))
print(stringValueLinearProbing.getValue(forKey: "野原"))
print(stringValueLinearProbing.getValue(forKey: "Penny"))

stringValueLinearProbing.updateValue("훈이", forKey: "이")
print(stringValueLinearProbing.getValue(forKey: "김"))
print(stringValueLinearProbing.getValue(forKey: "이"))

stringValueLinearProbing.updateValue(nil, forKey: "Penny")
print(stringValueLinearProbing.getValue(forKey: "Penny"))

stringValueLinearProbing.updateValue("野原", forKey: "みさえさん")
print(stringValueLinearProbing.getValue(forKey: "みさえさん"))


// 이전 공부 기록
//
//struct HashTable<T: Equatable> {
//    private var hashTable: [T?] = .init(repeating: nil, count: 4)
//    
//    func hash(key: String) -> Int {
//        // string의 자리수에 따라 hashIndex로 바꾸어주는 임시 로직
//        key.count % 4
//        
//    }
//    
//    mutating func updateValue(key: String, data: T) {
//        let hashIndex = hash(key: key)
//        self.hashTable[hashIndex] = data
//    }
//    
//    mutating func getValue(key: String) -> T? {
//        let hashIndex = hash(key: key)
//        
//        if self.hashTable.count > hashIndex {
//            return self.hashTable[hashIndex]
//        } else {
//            return nil
//        }
//    }
//}
//
//var intValue = HashTable<Int>()
//
//intValue.updateValue(key: "1", data: 1)
//intValue.updateValue(key: "12", data: 12)
//
//print(intValue.getValue(key: "1"))
//print(intValue.getValue(key: "12"))
//
//intValue.updateValue(key: "9", data: 9)
//print(intValue.getValue(key: "1"))
//// HASH Index가 동일함으로 발생하는 충돌현상
//
//print(intValue.getValue(key: "999"))
//
//print("--------------------------------------")
//// Chaining > LinkedList를 사용하여 충돌을 없앰
//class Node<T: Equatable> {
//    var data: (data: T, key: String)?
//    var next: Node?
//    
//    init(data: T, key: String, next: Node? = nil) {
//        self.data = (data: data, key: key)
//        self.next = next
//    }
//}
//
//class LinkedList<T: Equatable> {
//    private var head: Node<T>?
//    
//    func append(data: (data: T, key: String)) {
//        guard self.head != nil else {
//            self.head = Node(data: data.data, key: data.key)
//            return
//        }
//        
//        var node = self.head
//        while node?.next != nil {
//            node = node?.next
//        }
//        node?.next = Node(data: data.data, key: data.key)
//    }
//    
//    func removeLast() {
//        guard self.head != nil else {return}
//        guard self.head?.next != nil else {self.head = nil; return}
//        
//        var node = self.head
//        while node?.next?.next != nil {
//            node = node?.next
//        }
//        
//        node?.next = nil
//    }
//    
//    func searchNode(key: String) -> (data: T, key: String)? {
//        guard self.head != nil else {return nil}
//        guard self.head?.next != nil else {return self.head?.data}
//        
//        var node = self.head
//        while node?.next != nil {
//            if node?.data?.key == key {break}
//            node = node?.next
//        }
//        
//        return node?.data
//    }
//}
//
//struct HashTableWithNode<T: Equatable> {
//    private var hashTable: [LinkedList<T>?] = .init(repeating: nil, count: 4)
//    
//    func hash(key: String) -> Int {
//        key.count % 4
//    }
//    
//    mutating func updateValue(key: String, data: T) {
//        let hashIndex = hash(key: key)
//        
//        if self.hashTable[hashIndex] == nil {
//            self.hashTable[hashIndex] = LinkedList<T>.init()
//        }
//        
//        self.hashTable[hashIndex]?.append(data: (data: data, key: key))
//    }
//    
//    mutating func getValue(key: String) -> T? {
//        let hashIndex = hash(key: key)
//        
//        if self.hashTable.count > hashIndex {
//            return self.hashTable[hashIndex]?.searchNode(key: key)?.data
//        } else {
//            return nil
//        }
//    }
//}
//
//var stringValue = HashTableWithNode<String>()
//
//stringValue.updateValue(key: "1", data: "1")
//stringValue.updateValue(key: "12", data: "12")
//
//print(stringValue.getValue(key: "1"))
//print(stringValue.getValue(key: "12"))
//
//stringValue.updateValue(key: "9", data: "9")
//print(stringValue.getValue(key: "1"))
//
//stringValue.updateValue(key: "10", data: "10")
//print(stringValue.getValue(key: "12"))
//print(stringValue.getValue(key: "10"))
//
//print(stringValue.getValue(key: "999"))
