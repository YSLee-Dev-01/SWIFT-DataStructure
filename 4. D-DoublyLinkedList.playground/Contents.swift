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
    var data: T?
    var prev: Node?
    var next: Node?
    
    init(data: T, prev: Node? = nil, next: Node? = nil) {
        self.data = data
        self.prev = prev
        self.next = next
    }
}

class DoublyLinkedList<T: Equatable> {
    private var head: Node<T>?
    private var tail: Node<T>?
    
    private var count = 0 // 노드의 카운트를 기록하여 head 접근이 빠른지, tail 접근이 빠른지 구별해요.
    
    func append(_ data: T) {
        let newNode = Node(data: data)
        self.count += 1
        
        if self.head == nil || self.tail == nil {
            self.head = newNode
            self.tail = newNode
            print("HEAD,TAIL 세팅")
            return
        }
        
        newNode.prev = self.tail
        self.tail?.next = newNode
        self.tail = newNode
        print("TAIL 데이터: \(self.tail?.data), TAIL 전 데이터 \(self.tail?.prev?.data)")
    }
    
    func insert(data: T, index: Int) {
        let newNode = Node(data: data)
        
        if self.head == nil || self.tail == nil {
            self.head = newNode
            self.tail = newNode
            self.count += 1
            print("HEAD,TAIL 세팅, index 무시됨")
            return
        }
        
        
        var isHead = self.count / 2 >= index
        print(isHead ? "HEAD로 진행" : "PREV로 진행")
        
        var nowNode = isHead ? self.head : self.tail
        for _ in stride(from: isHead ? 0 : self.count, to: isHead ? index - 1 : index + 1, by: isHead ? +1 : -1) {
            if (isHead && nowNode?.next == nil) || (!isHead && nowNode?.prev == nil) {
                break
            }
            nowNode = isHead ? nowNode?.next : nowNode?.prev
        }
        newNode.next = nowNode?.next
        nowNode?.next = newNode
        
        newNode.next?.prev = newNode
        newNode.prev = nowNode
        self.count += 1
        
        print("변경 기준 점 \(nowNode?.data)")
        print("변경 기준 점 다음 값 (insert) \(nowNode?.next?.data)")
        print("insert한 값 (위와 동일해야함) \(newNode.data)")
        print("insert한 다음 값 \(newNode.next?.data)")
        print("insert한 다음 값의 전 값 (insert data가 나와야함) \(newNode.next?.prev?.data)")
        print("insert한 다음 값의 전 전 값 (insert data의 전 데이터가 나와야함) \(newNode.next?.prev?.prev?.data)")
    }
    
}

var intList = DoublyLinkedList<Int>()
intList.append(0)
intList.append(1)
intList.append(2)
intList.append(3)
print("-----------")
intList.insert(data: 4, index: 1)
print("-----------")
intList.insert(data: 9, index: 3)

// 이전 공부 기록
//
//class Node<T: Equatable> {
//    var prev: Node?
//    var data: T?
//    var next: Node?
//    
//    init(data: T, prev: Node? = nil, next: Node? = nil) {
//        self.data = data
//        self.prev = prev
//        self.next = next
//    }
//    
//    deinit {
//        print("DEINIT---- \(self.data)")
//    }
//}
//
//class DobuleLinkedList<T: Equatable> {
//    private var head: Node<T>?
//    private var tail: Node<T>?
//    
//    func append(data: T) {
//        // 데이터가 아예 없을 때
//        guard self.head != nil ||
//        self.tail != nil else {
//            self.head = Node(data: data)
//            self.tail = self.head
//            return
//            
//        }
//        
//        self.tail?.next = Node(data: data, prev: self.tail)
//        self.tail = self.tail?.next
//    }
//    
//    func insert(data: T, index: Int) {
//        guard self.head != nil ||
//        self.tail != nil else {
//            self.head = Node(data: data)
//            self.tail = self.head
//            return
//            
//        }
//        
//        guard index != 0 else {
//            self.head?.prev = Node(data: data, next: self.head)
//            self.head = self.head?.prev
//            return
//        }
//        
//        var node = self.head
//        for _ in 1 ..< index {
//            if node?.next == nil {break}
//            node = node?.next
//        }
//        
//        let next = node?.next
//        let new = Node(data: data, prev: node, next: next)
//        node?.next = new
//        next?.prev = new
//        
//        // node가 마지막일 때
//        if node?.next == nil {
//            self.tail = new
//        }
//    }
//    
//    func removeLast() {
//        guard self.head != nil ||
//        self.tail != nil else {return}
//        
//        guard self.head?.next != nil else {
//            self.head = nil
//            self.tail = nil
//            return
//        }
//        
//        self.tail?.prev?.next = nil
//        self.tail = self.tail?.prev
//    }
//    
//    func remove(index: Int) {
//        guard self.head != nil ||
//        self.tail != nil else {return}
//        
//        guard self.head?.next != nil else {
//            self.head = self.head?.next
//            self.tail = nil
//            return
//        }
//        
//        guard index != 0 else {
//            self.head = self.head?.next
//            self.head?.prev = nil
//            return
//        }
//        
//        var node = self.head
//        for _ in 1 ..< index {
//            if node?.next?.next == nil {break}
//            node = node?.next
//        }
//        
//        let next = node?.next?.next
//        next?.prev = node
//        node?.next = next
//        
//        // node가 마지막일 때
//        if next?.next == nil {
//            self.tail = next
//        }
//    }
//    
//    func searchNode(data: T) -> Node<T>? {
//        guard self.head != nil ||
//        self.tail != nil else {return nil}
//        
//        var node = self.head
//        while node != nil {
//            if node?.data == data {break}
//            node = node?.next
//        }
//        
//        return node
//    }
//    
//    func searchNodeFromTail(data: T) -> Node<T>? {
//        guard self.head != nil ||
//        self.tail != nil else {return nil}
//        
//        var node = self.tail
//        while node != nil {
//            if node?.data == data {break}
//            node = node?.prev
//        }
//        
//        return node
//    }
//}
//
//var intList = DobuleLinkedList<Int>()
//
//for item in 1 ... 10 {
//    intList.append(data: item)
//}
//
//print(intList.searchNode(data: 5)?.data)
//
//intList.removeLast()
//
//print(intList.searchNode(data: 9)?.data)
//
//intList.remove(index: 1)
//// 13456789
//intList.insert(data: 10000, index: 4)
//// 1345 10000 6789
//
//print(intList.searchNode(data: 10000)?.next?.data)
//print(intList.searchNode(data: 9)?.data)
//
//intList.append(data: 0)
//// 1345 10000 6789 0
//print(intList.searchNodeFromTail(data: 0)?.prev?.data)
//print(intList.searchNodeFromTail(data: 0)?.next?.data)
