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
        
        // 단방향 연결리스트와 달리 tail을 수정 후 기존 연결된 부분만 수정
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
        
        if index == 0 { // head 변경 시
            newNode.next = self.head
            self.head = newNode
            self.count += 1
            print("HEAD 변경됨")
            print("HEAD 다음 값 (기존 HEAD) \(self.head?.next?.data)")
            return
        } else if index >= self.count { // tail 변경 시
            self.append(data)
            print("TAIL 변경됨")
            return
        }
        
        var isHead = self.count / 2 >= index // head, tail의 가까운 지점을 count로 계산
        print(isHead ? "HEAD로 진행" : "PREV로 진행")
        
        var nowNode = isHead ? self.head : self.tail
        // head는 내 앞에 데이터를 추가해야하기 때문에 index(count - 1)만큼 이동
        // tail의 경우 내 전에 데이터를 추가해야 하기 때문에 self.count에 -1을 하지 않음 (내 자신을 뒤로 밀기 위함 -> nowNode는 내 자신)
        // newNode를 원하는 index에 추가하고 nowNode는 index가 밀리게 함
        for _ in stride(from: isHead ? 0 : self.count, to: isHead ? index - 1 : index + 1, by: isHead ? +1 : -1) {
            if (isHead && nowNode?.next == nil) || (!isHead && nowNode?.prev == nil) {
                break
            }
            nowNode = isHead ? nowNode?.next : nowNode?.prev
        }
        if isHead {
            newNode.next = nowNode?.next
            nowNode?.next = newNode
            
            newNode.next?.prev = newNode
            newNode.prev = nowNode
            
            print("변경 기준 점 \(nowNode?.data)")
            print("변경 기준 점 다음 값 (insert) \(nowNode?.next?.data)")
            print("insert한 값 (위와 동일해야함) \(newNode.data)")
            print("insert한 다음 값 \(newNode.next?.data)")
            print("insert한 다음 값의 전 값 (insert data가 나와야함) \(newNode.next?.prev?.data)")
            print("insert한 다음 값의 전 전 값 (insert data의 전 데이터가 나와야함) \(newNode.next?.prev?.prev?.data)")
        } else {
            newNode.prev = nowNode?.prev
            newNode.prev?.next = newNode
            
            newNode.next = nowNode
            nowNode?.prev = newNode
            
            print("변경 기준 점 \(nowNode?.data)")
            print("변경 기준 점 전 값 (insert) \(nowNode?.prev?.data)")
            print("insert한 값 (위와 동일해야함) \(newNode.data)")
            print("insert한 다음 값 (변경 기준 점이 나와야함) \(newNode.next?.data)")
            print("insert한 다음 값의 다음 값 (insert Data의 다다음 나와야함) \(newNode.next?.next?.data)")
            print("insert한 값의 전 값 (insert Data의 전이 나와야함) \(newNode.prev?.data)")
        }
       
        self.count += 1
        
       
    }
    
    func removeLast() {
        if self.head == nil || self.tail == nil {
            return
        } else if self.count == 1 { // 데이터가 하나만 있을 때
            self.head = nil
            self.tail = nil
            self.count -= 1
            return
        }
        
        // 단방향 연결리스트와 달리 tail을 수정 후 기존 연결된 부분만 수정
        self.tail = self.tail?.prev
        self.tail?.next = nil
        self.count -= 1
        print("RemoveLast 후 Tail 값 \(self.tail?.data)")
        print("RemoveLast 후 Tail의 Next 값 \(self.tail?.next?.data)")
    }
    
    func remove(at index: Int) {
        if self.head == nil || self.tail == nil || self.count < index { // index 값이 잘못되거나 삭제할 데이터가 없는 경우 return
            return
        }
        
        if index == 0 {
            self.head = self.head?.next
            self.head?.prev = nil
            print("HEAD 변경됨")
            return
        } else if index == self.count - 1 {
            self.removeLast()
            print("TAIL 변경됨")
            return
        }
        
        var isHead = self.count / 2 >= index
        var nowNode = isHead ? self.head : self.tail
        // tail의 경우 insert와 달리 자기 자신은 자신이 지울 수 없기 때문에 index(count - 1)을 적용하여 내 뒤에서 자신을 지우도록 함
        // Head 또한 자기 자신은 자신이 지울 수 없기 때문에 index - 1을 적용하여 내 앞에서 자신을 지우도록 함
        for _ in stride(from: isHead ? 0 : self.count - 1, to: isHead ? index - 1 : index + 1, by: isHead ? +1 : -1) {
            if (isHead && nowNode?.next == nil) || (!isHead && nowNode?.prev == nil) {
                return // next, prev가 없을 때는 지우지 않고 return
            }
            nowNode = isHead ? nowNode?.next : nowNode?.prev
        }
        
        if isHead {
            nowNode?.next = nowNode?.next?.next
            nowNode?.next?.prev = nowNode
        } else {
            nowNode?.prev = nowNode?.prev?.prev
            nowNode?.prev?.next = nowNode
        }
        self.count -= 1;
        
        print("기준점이 되는 Node \(nowNode?.data)")
        print("기준점이 되는 Node의 전 값 \(nowNode?.prev?.data)")
        print("기준점이 되는 Node의 다음 값 \(nowNode?.next?.data)")
    }
    
    func search(from data: T) -> Node<T>? {
        if self.head == nil || self.tail == nil, self.count == 0 {
            return nil
        }
        
        var firstNode = self.head
        var lastNode = self.tail
        
        for _ in (0 ..< self.count / 2) {
            // Head와 Tail 값을 이용해서 동시에 검색해요.
            if firstNode?.data == data {
                return firstNode
            } else if lastNode?.data == data {
                return lastNode
            }
            
            firstNode = firstNode?.next
            lastNode = lastNode?.next
            if firstNode == nil && lastNode == nil {
                break
            }
        }
        return nil
    }
    
}

var intList = DoublyLinkedList<Int>()
intList.append(0) // 0
intList.append(1) // 0, 1
intList.append(2) // 0, 1, 2
intList.append(3) // 0, 1, 2, 3
print("-----------")
intList.insert(data: 4, index: 1) // 0, 4, 1, 2, 3
print("-----------")
intList.insert(data: 9, index: 3) // 0, 4, 1, 9, 2, 3
print("-----------")
intList.removeLast() // 0, 4, 1, 9, 2
print("-----------")
intList.insert(data: -1, index: 0) // -1 ,0 ,4, 1, 9, 2
print("-----------")
intList.insert(data: 10, index: 6) // -1, 0, 4, 1, 9, 2, 10
print("-----------")
intList.remove(at: 0) // 0, 4, 1, 9, 2, 10
print("-----------")
intList.remove(at: 1) // 0, 1, 9, 2, 10
print("-----------")
intList.remove(at: 4) // 0, 1, 9, 10
print("-----------")
let result = intList.search(from: 0)
print(result?.data) // 0
print(result?.next?.data) // 1
print(result?.next?.next?.data) // 9
print(result?.next?.next?.next?.data) // 10


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
