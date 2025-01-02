import UIKit

/// 1. Queue
/// 한쪽 끝에서만 삽입이 이루어지고, 다른 한쪽 끝에서는 삭제만 이루어지는 자료구조
/// 삭제 연산이 되는 곳을 Front, 산입 연산이 이루어지는 곳을 Rear라고 함
/// Queue는 FIFO 구조를 가지고 있음
/// - 물건을 사기 위해 기다리고 있는 사람들
///
/// Queue는 DeQueue를 통해 데이터를 get (제거) 할 수 있고,
/// enQueue를 통해 데이터를 삽입할 수 있음
///
/// deQueue를 통해 데이터를 제거할 시 앞에 데이터가 빠지기 때문에 Front가 뒤로 밀려나게 됨
/// -> Queue의 가용범위가 줄어듬 (Rear는 밀리지 않기 때문에)
/// -> Front와 Rear가 동일한 주소를 바라보게 될 경우 Queue는 사용이 불가능하게 됨
/// 해당 문제는 원형Queue를 사용하여 해결할 수 있음


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
        self.queue.count - self.frontIndex
    }
    
    public func isEmpty() -> Bool {
        self.frontIndex == 0 ? self.queue.isEmpty : self.queue[self.frontIndex] == nil
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
        
        if self.frontIndex == 50 { // nil 값이 30개가 되면 그 때 오버헤드 발생 (removeFirst)
            self.queue.removeFirst(self.frontIndex)
            self.frontIndex = 0
        } else {
        }
        
        return element
    }
}

print("FIX QUEUE--------------------------------")
var fixStringQueue = FixQueue<Int>()
for x in 0 ..< 500 {
    fixStringQueue.enQueue(x)
}
print(fixStringQueue.count())

for _ in 0 ... 69 {
    print(fixStringQueue.deQueue())
}
print(fixStringQueue.count())
