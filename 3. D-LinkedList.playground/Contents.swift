import UIKit

// 단방향 연결 리스트(Linked List)

class Node<T: Equatable> {
    var data: T?
    var next: Node?
    
    init(data: T, next: Node? = nil) {
        self.data = data
        self.next = next
    }
    
    deinit {
        print("DEINIT--\(data)")
    }
}

class LinkedList<T: Equatable> {
    private var head: Node<T>?
    
    func append(data: T) {
        // head가 없을 때
        guard let _ = self.head else {
            self.head = Node(data: data)
            return
        }
        
        // head를 기본으로 두고 연결 list의 끝 == node.next가 nil일 때까지 순회
        var node = self.head
        while node?.next != nil {
            node = node?.next
        }
        let newNode = Node(data: data)
        node?.next = newNode
    }
    
    func insert(data: T, index: Int) {
        guard let _ = self.head else {
            self.head = Node(data: data)
            return
        }
        
        var node = self.head
        // index에서 1을 뺀 만큼 순회
        for _ in 0 ..< (index - 1) {
            if node?.next == nil {break}
            node = node?.next
        }
        let nextNode = node?.next
        node?.next = Node(data: data)
        node?.next?.next = nextNode
    }
    
    func removeLast() {
        guard self.head != nil else {return}
        guard self.head?.next != nil else { self.head = nil; return}
        
        var node = self.head
        // node의 마지막 값까지는 들어가지 않도록 > 자기 자신을 지울 수 없음
        while node?.next?.next != nil {
            node = node?.next
        }
        node?.next = nil
    }
    
    func remove(index: Int) {
        guard self.head != nil else {return}
        guard index != 0 || self.head?.next == nil else {
            self.head = nil
            return
        }
        
        var node = self.head
        for _ in 0 ..< (index - 1) {
            if node?.next?.next == nil {break}
            node = node?.next
        }
        
        let nextValue = node?.next?.next
        node?.next = nextValue
    }
    
    func searchNode(data: T) -> Node<T>? {
        guard self.head != nil else {return nil}
        guard self.head?.data != data else {return self.head}
        
        var node = self.head
        while node?.next != nil {
            if node?.data == data {
                break
            }
            node = node?.next
        }
        
        return node
    }
}

var intList = LinkedList<Int>()

for item in 1 ... 10 {
    intList.append(data: item)
}

print(intList.searchNode(data: 5)?.data)

intList.removeLast()

print(intList.searchNode(data: 9)?.data)

intList.remove(index: 1)
// 13456789
intList.insert(data: 10000, index: 4)
// 1345 10000 6789

print(intList.searchNode(data: 10000)?.next?.data)
print(intList.searchNode(data: 9)?.data)

