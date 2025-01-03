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
            self.head = self.head?.next
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

