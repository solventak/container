//===----------------------------------------------------------------------===//
// Copyright © 2025 Apple Inc. and the container project authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//===----------------------------------------------------------------------===//

import Foundation

/// Runtime status for a sandbox or container.
public enum RuntimeStatus: Sendable, Codable, Equatable {
    /// The object is in an unknown status.
    case unknown
    /// The object is currently stopped.
    case stopped(stoppedAt: Date?)
    /// The object is currently running.
    case running(startedAt: Date?)
    /// The object is currently stopping.
    case stopping

    public static var running: RuntimeStatus { .running(startedAt: Date.now) }
    public static var stopped: RuntimeStatus { .stopped(stoppedAt: Date.now) }
}

extension RuntimeStatus {
    /// Compares two runtime statuses for equality based on state only, ignoring timestamps.
    public static func == (lhs: RuntimeStatus, rhs: RuntimeStatus) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown):
            return true
        case (.stopped, .stopped):
            return true // ignore stoppedAt timestamp
        case (.running, .running):
            return true // ignore startedAt timestamp
        case (.stopping, .stopping):
            return true
        default:
            return false
        }
    }

    /// Compares two runtime statuses for exact equality, including timestamps.
    public func exactEq(_ other: RuntimeStatus) -> Bool {
        switch (self, other) {
        case (.unknown, .unknown):
            return true
        case (.stopping, .stopping):
            return true
        case (.stopped(let date1), .stopped(let date2)):
            return date1 == date2
        case (.running(let date1), .running(let date2)):
            return date1 == date2
        default:
            return false
        }
    }
}

extension RuntimeStatus {
    public var stateName: String {
        switch self {
        case .unknown:  return "unknown"
        case .stopped:  return "stopped"
        case .running:  return "running"
        case .stopping: return "stopping"
        }
    }
}
