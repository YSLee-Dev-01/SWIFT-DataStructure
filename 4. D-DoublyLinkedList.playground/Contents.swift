import UIKit

/// 4. 양방향 연결리스트
/// 기존 단방향 연결리스트는 원하는 데이터를 찾거나, 특정 데이터를 지우려면,
/// Head를 통해 처음부터 모든 연결 리스트를 순회해야함
///
/// 양방향 연결리스트는 첫부분에 Head, 끝부분에 Tail을 두고, 이전/이후 Node를 모두 연결하여,
/// 양방향 탐색이 가능하게 한 자료구조
///
/// Node는 이전, 이후 Node 주소를 모두 저장할 수 있는 모양으로 바뀜
/// ---------------
/// | PREV, DATA, NEXT |
/// ---------------

// 양방향 연결 리스트
class Node<T: Equatable> {
    var prev: Node?
    var data: T?
    var next: Node?
    
    init(data: T, prev: Node? = nil, next: Node? = nil) {
        self.data = data
        self.prev = prev
        self.next = next
    }
    
    deinit {
        print("DEINIT---- \(self.data)")
    }
}

class DobuleLinkedList<T: Equatable> {
    private var head: Node<T>?
    private var tail: Node<T>?
    
    func append(data: T) {
        // 데이터가 아예 없을 때
        guard self.head != nil ||
        self.tail != nil else {
            self.head = Node(data: data)
            self.tail = self.head
            return
            
        }
        
        self.tail?.next = Node(data: data, prev: self.tail)
        self.tail = self.tail?.next
    }
    
    func insert(data: T, index: Int) {
        guard self.head != nil ||
        self.tail != nil else {
            self.head = Node(data: data)
            self.tail = self.head
            return
            
        }
        
        guard index != 0 else {
            self.head?.prev = Node(data: data, next: self.head)
            self.head = self.head?.prev
            return
        }
        
        var node = self.head
        for _ in 1 ..< index {
            if node?.next == nil {break}
            node = node?.next
        }
        
        let next = node?.next
        let new = Node(data: data, prev: node, next: next)
        node?.next = new
        next?.prev = new
        
        // node가 마지막일 때
        if node?.next == nil {
            self.tail = new
        }
    }
    
    func removeLast() {
        guard self.head != nil ||
        self.tail != nil else {return}
        
        guard self.head?.next != nil else {
            self.head = nil
            self.tail = nil
            return
        }
        
        self.tail?.prev?.next = nil
        self.tail = self.tail?.prev
    }
    
    func remove(index: Int) {
        guard self.head != nil ||
        self.tail != nil else {return}
        
        guard self.head?.next != nil else {
            self.head = self.head?.next
            self.tail = nil
            return
        }
        
        guard index != 0 else {
            self.head = self.head?.next
            self.head?.prev = nil
            return
        }
        
        var node = self.head
        for _ in 1 ..< index {
            if node?.next?.next == nil {break}
            node = node?.next
        }
        
        let next = node?.next?.next
        next?.prev = node
        node?.next = next
        
        // node가 마지막일 때
        if next?.next == nil {
            self.tail = next
        }
    }
    
    func searchNode(data: T) -> Node<T>? {
        guard self.head != nil ||
        self.tail != nil else {return nil}
        
        var node = self.head
        while node != nil {
            if node?.data == data {break}
            node = node?.next
        }
        
        return node
    }
    
    func searchNodeFromTail(data: T) -> Node<T>? {
        guard self.head != nil ||
        self.tail != nil else {return nil}
        
        var node = self.tail
        while node != nil {
            if node?.data == data {break}
            node = node?.prev
        }
        
        return node
    }
}

var intList = DobuleLinkedList<Int>()

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

intList.append(data: 0)
// 1345 10000 6789 0
print(intList.searchNodeFromTail(data: 0)?.prev?.data)
print(intList.searchNodeFromTail(data: 0)?.next?.data)
