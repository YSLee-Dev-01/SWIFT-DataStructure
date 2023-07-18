import UIKit

// node 구성
class Node<T: Comparable> {
    var data: T
    var left: Node?
    var right: Node?
    
    init(data: T) {
        self.data = data
    }
}

class BinarySearchTree<T: Comparable> {
    var root: Node<T>?
    
    func search(data: T) -> Bool {
        // root가 없을 경우
        guard self.root != nil else {return false}
        
        var currentNode = self.root
        while let node = currentNode {
            if node.data == data {
                return true
            }
            
            if node.data > data {
                currentNode = node.left
            } else {
                currentNode = node.right
            }
        }
        
        return false
    }
    
    func insert(data: T) {
        // 중복여부 파악
        guard !self.search(data: data) else {return}
             
        // root가 없을 경우
        guard let root = self.root else {
            self.root = Node(data: data)
            return
        }
        
        var currentNode = root
        while true {
            if currentNode.data > data {
                guard let next = currentNode.left else {
                    return currentNode.left = Node(data: data)
                }
                currentNode = next
            } else {
                guard let next = currentNode.right else {
                    return currentNode.right = Node(data: data)
                }
                currentNode = next
            }
        }
    }
    
    func delete(data: T) -> Bool {
        // 값이 없을 때
        guard let root = self.root else {return false}
        
        // root만 있는 경우에서 root를 지우는 경우
        guard self.root?.left != nil &&
                self.root?.right != nil &&
                self.root?.data != data else {
            self.root = nil
            return true
        }
        
        var parentNode = root
        var currentNode = self.root
        
        while let node = currentNode {
            // 삭제항목 찾으면
            if node.data == data {break}
            
            if node.data > data {
                currentNode = node.left
            } else {
                currentNode = node.right
            }
            parentNode = node
        }
        
        // 필터가 없을 경우
        guard let removeNode = currentNode else {
            return false
        }
        
        // left, right 구문
        let filter = parentNode.data > removeNode.data
        
        // leaf node 제거
        if removeNode.left == nil && removeNode.right == nil {
            if filter {
                parentNode.left = nil
            } else {
                parentNode.right = nil
            }
            
            return true
        }
        
        // child가 하나만 있는 경우
        // left
        if removeNode.left != nil && removeNode.right == nil {
            if filter {
                parentNode.left = removeNode.left
            } else {
                parentNode.right = removeNode.left
            }
            
            return true
        } else if removeNode.left == nil && removeNode.right != nil { // right
            if filter {
                parentNode.left = removeNode.right
            } else {
                parentNode.right = removeNode.right
            }
            
            return true
        }
        
        // child가 여러개 있는 경우
        guard let removeNodeRight = removeNode.right else {return false}
        var changeNode = removeNodeRight
        var changeNodeParent = removeNodeRight
      
        // left 끝까지
        while let node = changeNode.left {
            changeNodeParent = changeNode
            changeNode = node
        }
        
        // right가 있는지 여부 확인 + 한번도 left로 내려가지 않은 경우
        if changeNode.data != removeNodeRight.data {
            if let rightNode = changeNode.right {
                changeNodeParent.left = rightNode
            } else {
                changeNodeParent.left = nil
            }
            changeNode.right = removeNode.right
            changeNode.left = removeNode.left
        } else {
            changeNode.left = removeNode.left
        }
       
        
        // 값 변경
        if filter {
            parentNode.left = changeNode
        } else {
            parentNode.right = changeNode
        }
        

        return true
    }
    
    func drawDiagram() {
        print(diagram(for: self.root))
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

}

var intValue = BinarySearchTree<Int>()
intValue.insert(data: 50)
intValue.insert(data: 100)
intValue.insert(data: 75)
intValue.insert(data: 25)
intValue.insert(data: 100)

intValue.insert(data: 40)
intValue.insert(data: 38)
intValue.insert(data: 35)
intValue.insert(data: 31)
intValue.insert(data: 29)
intValue.insert(data: 28)
intValue.insert(data: 34)
intValue.insert(data: 30)
intValue.insert(data: 31)
intValue.insert(data: 32)
intValue.insert(data: 33)
intValue.drawDiagram()

intValue.delete(data: 40)
intValue.drawDiagram()


intValue.delete(data: 31)
intValue.drawDiagram()
