//
//  Observable.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 25.01.2021.
//

import Foundation

public final class Observable<ValueT> {
    typealias ObserverID = UUID

    public var value: ValueT {
        willSet {
            assert(!isBroadcasting)
        }
        didSet {
            isBroadcasting = true
            for observation in observations {
                observation.observer(value)
            }
            isBroadcasting = false
        }
    }

    private var observations: [Observation<ValueT>] = []
    private var isBroadcasting = false

    public init(value: ValueT) {
        self.value = value
    }

    public func addObserver(_ observer: @escaping (ValueT) -> Void) -> Disposable {
        guard !isBroadcasting else { return fallback(Disposable()) }
        let observation = Observation(observer: observer)
        observations[observation.id] = observation
        observer(value)
        return Disposable { [weak self] in self?.observations[safe: observation.id] = nil }
    }
}

struct Observation<ValueT>: CKIdentifiable {
    var id = UUID()
    var observer: (ValueT) -> Void
}

public class Disposable {
    var dispose: () -> Void

    public init(dispose: @escaping () -> Void = {}) {
        self.dispose = dispose
    }

//    deinit {
//        dispose()
//    }
}

extension Disposable {
    public func disposed(by otherDisposable: Disposable) {
        otherDisposable.add(self)
    }

    func add(_ otherDisposable: Disposable) {
        let dispose = self.dispose
        self.dispose = {
            otherDisposable.dispose()
            dispose()
        }
    }
}
