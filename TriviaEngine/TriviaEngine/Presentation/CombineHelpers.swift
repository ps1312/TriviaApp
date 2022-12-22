import Foundation
import Combine

public extension DispatchQueue {
    static var immediateMainQueueScheduler = ImmediateMainQueueScheduler.shared

    struct ImmediateMainQueueScheduler: Scheduler {
        public typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        public typealias SchedulerOptions = DispatchQueue.SchedulerOptions

        public var now = DispatchQueue.main.now
        public var minimumTolerance = DispatchQueue.main.minimumTolerance

        public static let shared = Self()

        private static let key = DispatchSpecificKey<UInt8>()
        private static let value = UInt8.max

        private init() {
            DispatchQueue.main.setSpecific(key: Self.key, value: Self.value)
        }

        private func isMainQueue() -> Bool {
            return DispatchQueue.getSpecific(key: Self.key) == Self.value
        }

        public func schedule(options: DispatchQueue.SchedulerOptions?, _ action: @escaping () -> Void) {
            guard isMainQueue() else { return DispatchQueue.main.async { action() } }
            action()
        }

        public func schedule(after date: DispatchQueue.SchedulerTimeType, tolerance: DispatchQueue.SchedulerTimeType.Stride, options: DispatchQueue.SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }

        public func schedule(after date: DispatchQueue.SchedulerTimeType, interval: DispatchQueue.SchedulerTimeType.Stride, tolerance: DispatchQueue.SchedulerTimeType.Stride, options: DispatchQueue.SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            return DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}
