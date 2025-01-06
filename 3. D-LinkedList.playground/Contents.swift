import UIKit

/// 3. Linked List
/// 배열과 동일하게 데이터를 표현하는 자료구조 중 하나
/// 배열과 장단점을 공유함
///
/// Array(배열)
/// - 한 메모리안에 데이터를 나란히 저장함
///
/// index를 이용하여 값에 접근하기 때문에 index를 알고 있으면 검색 속도가 빠름
/// 또한 마지막 elemenet의 삭제, 추가가 빠름
///
/// 중간 index에 있는 element를 삭제하거나 추가할 경우 element를 재배치 해야하기 때문에
/// 오버헤드가 발생함
///
/// Linked List(연결 리스트)
/// - 각각 떨어진 공간에 데이터를 연결하여 저장함
///
/// 원할 때 메모리에 공간을 할당해서 사용할 수 있음
/// 중간에 있는 element를 추가하거나 삭제할 때 연결만 변경하면 되기 때문에
/// 오버헤드가 발생하지 않음
///
/// 단방향 연결 리스트의 경우 검색 시 모든 데이터를 순차적으로 찾아가야함
/// 각 데이터 다른 메모리에 저장하기 때문에 별도의 데이터 저장공간이 필요하여 저장 효율이 낮음
///
/// 단방향 연결 리스트는 각각 떨어진 공간에 데이터를 연결하여 사용하기 때문에
/// 내 다음 순서 데이터의 메모리 주소를 알고 있어야함
///
/// 단방향 연결 리스트의 데이터 모양은 아래와 같음
/// ----------
/// | DATA, NEXT|
/// ----------
/// Data는 내 데이터를 저장하며, Next는 내 다음 데이터의 주소 값을 저장함
/// 이와 같은 형태를 Node(노드)라고 칭함
///
/// -> 연결 리스트는 Node들이 연결되어 이루어진 자료구조

// 단방향 연결 리스트(Linked List)

class Node<T: Equatable> {
    var data: T? // 현재 데이터를 나타내는 프로퍼티
    var next: Node? // 다음 순서 데이터의 메모리를 가르키는 프로퍼티
    
    init(data: T, next: Node? = nil) {
        self.data = data
        self.next = next
    }
}

class LinkedList<T: Equatable> {
    /// 연결리스트는 각각 떨어진 공간에 데이터를 연결하여 사용하기 떄문에 첫 Node를 가르키는 Head가 필수적
    private var head: Node<T>? // 첫 Node를 가르키는 프로퍼티
    
    func append(data: T) {
        if self.head == nil { // Head가 없을 경우 Head를 지정
            self.head = Node(data: data)
            return
        }
        
        var nowNode = self.head
        while nowNode?.next != nil { // next 값이 없으면 가장 마지막 Node로 간주
            nowNode = nowNode?.next
        }
        
        nowNode?.next = Node(data: data)
    }
    
    func insert(data: T, at index: Int) {
        if self.head == nil { // Head가 없을 경우 Head를 지정
            self.head = Node(data: data)
            return
        }
        
        var nowNode = self.head
        for _ in 0 ..< index - 1 { // 해당 index의 전 Node까지만 이동하여 순서를 변경함
            nowNode = nowNode?.next
        }
        var newNode = Node(data: data, next: nowNode?.next)
        nowNode?.next = newNode
    }
    
    func searchNode(data: T) -> Node<T>? {
        var nowNode = self.head
        while nowNode != nil {
            if nowNode?.data == data {
                return nowNode
            }
            nowNode = nowNode?.next
        }
        return nil // 만약 전체를 돌았는데도 값이 나오지 않는 경우 nil이 반환됨
    }
    
    func removeLast() {
        if self.head == nil {return}
        if self.head?.next == nil {self.head = nil; return}
        
        var nowHead = self.head
        while nowHead?.next?.next != nil { // 현재 Head의 next의 next가 없다는 건 Head의 바로 이후 next가 마지막이라는 뜻
            nowHead = nowHead?.next
        }
        nowHead?.next = nil
    }
    
    func remove(at index: Int) {
        if self.head == nil {return}
        if index == 0 {
            self.head = self.head?.next
            return
        }
        
        var nowHead = self.head
        for _ in 0 ..< index - 1 {
            nowHead = nowHead?.next
            if nowHead == nil {return} // 삭제를 원했던 index가 잘못되어 nil 값인 경우 아무런 작업을 하지 않음
        }
        nowHead?.next = nowHead?.next?.next
    }
}


var intList = LinkedList<Int>()
intList.append(data: 0) // 0
let zero = intList.searchNode(data: 0)
print(zero?.data, zero?.next?.data)

intList.append(data: 1) // 0, 1

let trashValue = intList.searchNode(data: 99)
print(trashValue?.data, trashValue?.next)

intList.insert(data: 2, at: 2) // 0, 1, 2

let one = intList.searchNode(data: 1)
print(one?.data, one?.next?.data)
let two = intList.searchNode(data: 2)
print(two?.data, two?.next)


intList.insert(data: 9, at: 1)
let nine = intList.searchNode(data: 9) // 0, 9, 1, 2
print(nine?.data, nine?.next?.data)

intList.removeLast()
let removeLastData = intList.searchNode(data: 1)
print(removeLastData?.data, removeLastData?.next?.data) // 0, 9, 1


intList.remove(at: 1)
let removeData = intList.searchNode(data: 0)
print(removeData?.data, removeData?.next?.data, removeData?.next?.next?.data) // 0, 1

intList.remove(at: 2) // index를 초과했기 때문에 값을 지우지 않음
let removeData2 = intList.searchNode(data: 0)
print(removeData2?.data, removeData2?.next?.data, removeData2?.next?.next?.data) // 0, 1

intList.remove(at: 0)
let headRemove = intList.searchNode(data: 1) // 1
print(headRemove?.data, headRemove?.next?.data)

intList.removeLast()
print(intList.searchNode(data: 1)?.data) // nil


/// 이전 공부 기록
//class Node<T: Equatable> {
//    var data: T?
//    var next: Node?
//    
//    init(data: T, next: Node? = nil) {
//        self.data = data
//        self.next = next
//    }
//    
//    deinit {
//        print("DEINIT--\(data)")
//    }
//}
//
//class LinkedList<T: Equatable> {
//    private var head: Node<T>?
//    
//    func append(data: T) {
//        // head가 없을 때
//        guard let _ = self.head else {
//            self.head = Node(data: data)
//            return
//        }
//        
//        // head를 기본으로 두고 연결 list의 끝 == node.next가 nil일 때까지 순회
//        var node = self.head
//        while node?.next != nil {
//            node = node?.next
//        }
//        let newNode = Node(data: data)
//        node?.next = newNode
//    }
//    
//    func insert(data: T, index: Int) {
//        guard let _ = self.head else {
//            self.head = Node(data: data)
//            return
//        }
//        
//        var node = self.head
//        // index에서 1을 뺀 만큼 순회
//        for _ in 0 ..< (index - 1) {
//            if node?.next == nil {break}
//            node = node?.next
//        }
//        let nextNode = node?.next
//        node?.next = Node(data: data)
//        node?.next?.next = nextNode
//    }
//    
//    func removeLast() {
//        guard self.head != nil else {return}
//        guard self.head?.next != nil else { self.head = nil; return}
//        
//        var node = self.head
//        // node의 마지막 값까지는 들어가지 않도록 > 자기 자신을 지울 수 없음
//        while node?.next?.next != nil {
//            node = node?.next
//        }
//        node?.next = nil
//    }
//    
//    func remove(index: Int) {
//        guard self.head != nil else {return}
//        guard index != 0 || self.head?.next == nil else {
//            self.head = self.head?.next
//            return
//        }
//        
//        var node = self.head
//        for _ in 0 ..< (index - 1) {
//            if node?.next?.next == nil {break}
//            node = node?.next
//        }
//        
//        let nextValue = node?.next?.next
//        node?.next = nextValue
//    }
//    
//    func searchNode(data: T) -> Node<T>? {
//        guard self.head != nil else {return nil}
//        guard self.head?.data != data else {return self.head}
//        
//        var node = self.head
//        while node?.next != nil {
//            if node?.data == data {
//                break
//            }
//            node = node?.next
//        }
//        
//        return node
//    }
//}
//
//var intList = LinkedList<Int>()
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
