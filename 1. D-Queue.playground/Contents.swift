import UIKit

// Queue 자료구조
struct Queue<T> {
    private var queue: [T] = []
    
    public func count() -> Int {
        self.queue.count
    }
    
    public func isEmpty() -> Bool {
        self.queue.isEmpty
    }
    
    public mutating func enQueue(_ element: T) {
        self.queue.append(element)
    }
    
    public mutating func deQueue() -> T? {
        self.queue.isEmpty ? nil : self.queue.removeFirst() // 삭제된 값을 반환
    }
}
print("STRING QUEUE--------------------------------")
var stringQueue = Queue<String>()
stringQueue.enQueue("A")
stringQueue.enQueue("B")
print(stringQueue.isEmpty())
print(stringQueue.count())

print("INT QUEUE--------------------------------")
var intQueue = Queue<Int>()
intQueue.enQueue(1)
intQueue.enQueue(2)
intQueue.enQueue(3)

// removeFirst 함수는 오버헤드를 발생시킴 (시간 복잡도 O(n))
intQueue.deQueue()

print(intQueue.isEmpty())
print(intQueue.count())

// 오버헤드를 최대한 덜 발생시키는 Queue
struct FixQueue<T> {
    private var queue: [T?] = []
    private var frontIndex = 0 // 마지막 값(Front)를 가르키는 Index 정의
    
    public func count() -> Int {
        self.queue.count
    }
    
    public func isEmpty() -> Bool {
        self.queue.isEmpty
    }
    
    public mutating func enQueue(_ element: T) {
        self.queue.append(element)
    }
    
    public mutating func deQueue() -> T?  {
        guard self.frontIndex < self.queue.count,
                let element = self.queue[self.frontIndex]
        else {return nil}
        
        self.queue[self.frontIndex] = nil
        self.frontIndex += 1
        
        if self.frontIndex == 30 { // nil 값이 30개가 되면 그 때 오버헤드 발생 (removeFirst)
            self.queue.removeFirst(self.frontIndex)
            self.frontIndex = 0
        } else {
        }
        
        return element
    }
}

print("FIX QUEUE--------------------------------")
var fixStringQueue = FixQueue<Int>()
for x in 0 ..< 499 {
    fixStringQueue.enQueue(x)
}

for _ in 0 ... 99 {
    print(fixStringQueue.deQueue())
}
