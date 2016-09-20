import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
//: # Operation Cancellation
//: If you've got a long-running operation that you decide you no longer want to run, then you can cancel it using the `cancel()` method. But what does that actually do.
//:
//:
//: `ArraySumOperation` take an array of `(Int, Int)` tuples, and uses the `slowAdd()` function provided in __Sources__ to generate an array of the resultant values.
class ArraySumOperation: Operation {
  let inputArray: [(Int, Int)]
  var outputArray = [Int]()
  
  init(input: [(Int, Int)]) {
    inputArray = input
    super.init()
  }
  
  override func main() {
    for pair in inputArray {
        if isCancelled { return }
        outputArray.append(slowAdd(pair))
    }
  }
}

//: `AnotherArraySumOperation` uses the `slowAddArray` function to add
class AnotherArraySumOperation: Operation {
  let inputArray: [(Int, Int)]
  var outputArray: [Int]?
  
  init(input: [(Int, Int)]) {
    inputArray = input
    super.init()
  }
  
  override func main() {
    outputArray = slowAddArray(inputArray) {
        progress in
        print("\(progress*100)% of the array processed")
        return !self.isCancelled
    }
  }
}

//: Input array
let numberArray = [(1,2), (3,4), (5,6), (7,8), (9,10)]

//: Operation and queue
let sumOperation = AnotherArraySumOperation(input: numberArray)
let queue = OperationQueue()

//: Start the operation and
startClock()
queue.addOperation(sumOperation)

delay(3.5) {
    sumOperation.cancel()
}

sumOperation.completionBlock = {
  stopClock()
  sumOperation.outputArray
   PlaygroundPage.current.finishExecution()
}

