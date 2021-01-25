//
//  Observable.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 25.01.2021.
//

import Foundation

final class Observable<ValueT> {
    typealias ObserverID = UUID

    private var observations: [Observation<ValueT>] = []
    private var isBroadcasting = false

    var value: ValueT {
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

    init(value: ValueT) {
        self.value = value
    }

    func addObserver(_ observer: @escaping (ValueT) -> Void) -> Disposable {
        guard !isBroadcasting else { return fallback(Disposable()) }
        let observation = Observation(observer: observer)
        observations[observation.id] = observation
        observer(value)
        return Disposable { [weak self] in self?.observations[observation.id] = nil }
    }
}

struct Observation<ValueT>: Identifiable {
    var id = UUID()
    var observer: (ValueT) -> Void
}

class Disposable {
    var dispose: () -> Void

    init(dispose: @escaping () -> Void = {}) {
        self.dispose = dispose
    }
}

extension Disposable {
    func add(_ otherDisposable: Disposable) {
        let dispose = self.dispose
        self.dispose = {
            otherDisposable.dispose()
            dispose()
        }
    }


    func disposed(by otherDisposable: Disposable) {
        otherDisposable.add(self)
    }
}
