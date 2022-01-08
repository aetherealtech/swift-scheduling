//
//  Created by Daniel Coleman on 1/7/22.
//

import Foundation

public class LoopingThread : Thread, Scheduler {

    override init() {

        super.init()

        getRunLoopGroup.enter()

        self.start()
    }
    
    public var runLoop: CFRunLoop {
        
        getRunLoopGroup.wait()
        return runLoopValue
    }

    public func run(_ task: @escaping () -> Void) {

        runLoop.run(task)
    }
    
    public func runAt(time: Date,_ task: @escaping () -> Void) {

        runLoop.runAt(time: time, task)
    }
    
    override public func main() {

        runLoopValue = CFRunLoopGetCurrent()
        getRunLoopGroup.leave()

        let keepAliveSource = CFRunLoopTimerCreateWithHandler(
            CFAllocatorGetDefault().takeUnretainedValue(),
            CFAbsoluteTime.infinity,
            0.0,
            0,
            0
        ) { _ in }

        CFRunLoopAddTimer(runLoopValue, keepAliveSource, .defaultMode)
        CFRunLoopRun()
    }

    private var runLoopValue: CFRunLoop!
    private let getRunLoopGroup = DispatchGroup()
}