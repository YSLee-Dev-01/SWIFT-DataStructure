import UIKit

/// 6. BST
/// Tree란?
/// Node와 Branch를 이용하여 사이클을 이루지 않도록 구성한 데이터 구조
/// - Node를 사용하기 때문에 LinkedList를 구현함 (Heap도 가능)
///
/// LinkedList와 Tree는 동일하게 Node를 통해 데이터를 구성
/// 단, LinkedList는 prev, next를 통해 데이터를 선형적으로 관리하지만,
/// Tree는 최상단을 기준으로 왼쪽, 오른쪽에 자식이 배치되는 비선형적 구조를 가지고 있음
/// - 자식이 배치됨에 따라 Tree의 Node는 계층을 가지고 구성됨
///
/// 자식의 Node를 가르키는 선을 Branch(edge)라고 함
/// - 현 Node의 다음 주소 값은 내 자식 주소 값이 됨
/// Branch는 아래로만 뻗을 수 있기 때문에 삼각형 구조가 되지 못함
///
/// Tree 용어
/// Node: Tree에서 데이터를 구성하고 있는 요소
/// RootNode: 최상위 Node
/// Level: Node의 깊이
/// ParentNode: 나를 가르키는 내 윗 Level의 Node
/// ChildNode: 내가 가르키는 내 아래 Level의 Node
/// LeafNode: ChildNode가 없는 Node
/// Depth: Tree에서 Node가 가질 수 있는 최대 깊이
///
/// 이진트리
/// Tree의 Branch는 여러개로 이루어질 수 있음
/// Branch의 개수를 0~2개로 제한한 Node로만 이루어진 Tree를 이진트리라고 함
///
/// 이진 탐색 트리
/// 이진트리에 더불어 아래 규칙을 준수하고 있는 트리를 말함
///
/// 1. Node의 데이터에 Nil 값이 올 수 없음
/// 2. Node의 데이터는 고유해야함 (중복이 올 수 없음)
/// 3. Node의 데이터를 기준으로 자신의 Node 데이터보다 큰 값은 오른쪽, 작은 값은 왼쪽 Node에 위치시킴 (Child)
///
/// 이진 탐색 트리는 BST로 부르기도 함
///

class Node<T: Comparable> {
    let data: T
    var left: Node?
    var right: Node?
    
    init(data: T, left: Node? = nil, right: Node? = nil) {
        self.data = data
        self.left = left
        self.right = right
    }
}

class BST<T: Comparable> {
    private var rootNode: Node<T>?
    
    func drawDiagram() {
        print(diagram(for: self.rootNode))
    }
     
    private func diagram(for node: Node<T>?,
                         _ top: String = "",
                         _ root: String = "",
                         _ bottom: String = "") -> String {
       guard let node = node else {
            return root + "nil\n"
        }
        if node.left == nil && node.right == nil {
            return root + "\(node.data)\n"
        }
        return diagram(for: node.right, top + " ", top + "┌──", top + "│ ")
            + root + "\(node.data)\n"
            + diagram(for: node.left, bottom + "│ ", bottom + "└──", bottom + " ")
    }
    
    func insert(data: T) {
        let newNode = Node(data: data)
        if self.rootNode == nil {
            self.rootNode = newNode
            return
        }
        
        var nowNode = self.rootNode
        while true {
            if nowNode!.data == data {return} // 중복 값은 처리하지 않음
            
            if nowNode!.data < data {
                if nowNode?.right == nil {
                    nowNode?.right = newNode
                    return
                } else {
                    nowNode = nowNode?.right
                }
            } else {
                if nowNode?.left == nil {
                    nowNode?.left = newNode
                    return
                } else {
                    nowNode = nowNode?.left
                }
            }
        }
    }
    
    func search(data: T) -> Bool { // 있는지 여부를 Bool 값으로 반환
        if self.rootNode == nil {return false}
        
        var nowNode = self.rootNode
        while nowNode != nil {
            if nowNode!.data == data {
                return true
            } else if nowNode!.data < data {
                nowNode = nowNode?.right
            } else {
                nowNode = nowNode?.left
            }
        }
        return false
    }
}

var intValue = BST<Int>()
intValue.insert(data: 50)
intValue.insert(data: 100)
intValue.insert(data: 75)
intValue.insert(data: 25)
intValue.insert(data: 60)
intValue.insert(data: 0)
intValue.insert(data: -10)
intValue.drawDiagram()

print(intValue.search(data: 0))
print(intValue.search(data: 1000))

// 이전 공부 기록
//// node 구성
//class Node<T: Comparable> {
//    var data: T
//    var left: Node?
//    var right: Node?
//    
//    init(data: T) {
//        self.data = data
//    }
//}
//
//class BinarySearchTree<T: Comparable> {
//    var root: Node<T>?
//    
//    func search(data: T) -> Bool {
//        // root가 없을 경우
//        guard self.root != nil else {return false}
//        
//        var currentNode = self.root
//        while let node = currentNode {
//            if node.data == data {
//                return true
//            }
//            
//            if node.data > data {
//                currentNode = node.left
//            } else {
//                currentNode = node.right
//            }
//        }
//        
//        return false
//    }
//    
//    func insert(data: T) {
//        // 중복여부 파악
//        guard !self.search(data: data) else {return}
//             
//        // root가 없을 경우
//        guard let root = self.root else {
//            self.root = Node(data: data)
//            return
//        }
//        
//        var currentNode = root
//        while true {
//            if currentNode.data > data {
//                guard let next = currentNode.left else {
//                    return currentNode.left = Node(data: data)
//                }
//                currentNode = next
//            } else {
//                guard let next = currentNode.right else {
//                    return currentNode.right = Node(data: data)
//                }
//                currentNode = next
//            }
//        }
//    }
//    
//    func delete(data: T) -> Bool {
//        // 값이 없을 때
//        guard let root = self.root else {return false}
//        
//        // root만 있는 경우에서 root를 지우는 경우
//        guard self.root?.left != nil &&
//                self.root?.right != nil &&
//                self.root?.data != data else {
//            self.root = nil
//            return true
//        }
//        
//        var parentNode = root
//        var currentNode = self.root
//        
//        while let node = currentNode {
//            // 삭제항목 찾으면
//            if node.data == data {break}
//            
//            if node.data > data {
//                currentNode = node.left
//            } else {
//                currentNode = node.right
//            }
//            parentNode = node
//        }
//        
//        // 필터가 없을 경우
//        guard let removeNode = currentNode else {
//            return false
//        }
//        
//        // left, right 구문
//        let filter = parentNode.data > removeNode.data
//        
//        // leaf node 제거
//        if removeNode.left == nil && removeNode.right == nil {
//            if filter {
//                parentNode.left = nil
//            } else {
//                parentNode.right = nil
//            }
//            
//            return true
//        }
//        
//        // child가 하나만 있는 경우
//        // left
//        if removeNode.left != nil && removeNode.right == nil {
//            if filter {
//                parentNode.left = removeNode.left
//            } else {
//                parentNode.right = removeNode.left
//            }
//            
//            return true
//        } else if removeNode.left == nil && removeNode.right != nil { // right
//            if filter {
//                parentNode.left = removeNode.right
//            } else {
//                parentNode.right = removeNode.right
//            }
//            
//            return true
//        }
//        
//        // child가 여러개 있는 경우
//        guard let removeNodeRight = removeNode.right else {return false}
//        var changeNode = removeNodeRight
//        var changeNodeParent = removeNodeRight
//      
//        // left 끝까지
//        while let node = changeNode.left {
//            changeNodeParent = changeNode
//            changeNode = node
//        }
//        
//        // right가 있는지 여부 확인 + 한번도 left로 내려가지 않은 경우
//        if changeNode.data != removeNodeRight.data {
//            if let rightNode = changeNode.right {
//                changeNodeParent.left = rightNode
//            } else {
//                changeNodeParent.left = nil
//            }
//            changeNode.right = removeNode.right
//            changeNode.left = removeNode.left
//        } else {
//            changeNode.left = removeNode.left
//        }
//       
//        
//        // 값 변경
//        if filter {
//            parentNode.left = changeNode
//        } else {
//            parentNode.right = changeNode
//        }
//        
//
//        return true
//    }
//    
//    func drawDiagram() {
//        print(diagram(for: self.root))
//    }
//     
//    private func diagram(for node: Node<T>?,
//                         _ top: String = "",
//                         _ root: String = "",
//                         _ bottom: String = "") -> String {
//       guard let node = node else {
//            return root + "nil\n"
//        }
//        if node.left == nil && node.right == nil {
//            return root + "\(node.data)\n"
//        }
//        return diagram(for: node.right, top + " ", top + "┌──", top + "│ ")
//            + root + "\(node.data)\n"
//            + diagram(for: node.left, bottom + "│ ", bottom + "└──", bottom + " ")
//    }
//
//}
//
//var intValue = BinarySearchTree<Int>()
//intValue.insert(data: 50)
//intValue.insert(data: 100)
//intValue.insert(data: 75)
//intValue.insert(data: 25)
//intValue.insert(data: 100)
//
//intValue.insert(data: 40)
//intValue.insert(data: 38)
//intValue.insert(data: 35)
//intValue.insert(data: 31)
//intValue.insert(data: 29)
//intValue.insert(data: 28)
//intValue.insert(data: 34)
//intValue.insert(data: 30)
//intValue.insert(data: 31)
//intValue.insert(data: 32)
//intValue.insert(data: 33)
//intValue.drawDiagram()
//
//intValue.delete(data: 40)
//intValue.drawDiagram()
//
//
//intValue.delete(data: 31)
//intValue.drawDiagram()
