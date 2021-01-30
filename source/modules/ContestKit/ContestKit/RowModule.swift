//
//  RowModule.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation
import UIKit

class RowModule {
    private let store: RDXKit.Store<RowState>

    init(store: RDXKit.Store<RowState>) {
        self.store = store
        setup()
    }

    private func setup() {}

    func setup(cell: RowCell) {
        _ = store.stateObservable
            .addObserver { [weak cell] row in
                cell?.state = row.cell
            }

        cell.handlers = {
            switch store.state.id {
            case .picker:
                return PickerCell.Handlers { [self, weak store] in
                    store?.dispatch(selectRow())
                }
            case .button:
                return ButtonCell.Handlers { [self, weak store] in
                    store?.dispatch(selectRow())
                }
            case .animationTiming:
                return AnimationTimingCell.Handlers(
                    onSlideTopSlider: { [self, weak store] fraction in
                        store?.dispatch((updateAnimationTimingC2Fraction(fraction)))
                    },
                    onSlideRightCentralSlider: { [self, weak store] fraction in
                        store?.dispatch((updateAnimationTimingEndsAtFraction(fraction)))
                    },
                    onSlideLeftCentralSlider: { [self, weak store] fraction in
                        store?.dispatch((updateAnimationTimingStartsAtFraction(fraction)))
                    },
                    onSlideBottomSlider: { [self, weak store] fraction in
                        store?.dispatch((updateAnimationTimingC1Fraction(fraction)))
                    }
                )
            }
        }()
    }
}

extension RowModule {
    func selectRow() -> RDXKit.AnyAction<RowState> {
        RDXKit.Thunk<RDXKit.Store<RowState>> { rowStore in
            switch rowStore.state {
            case .picker(.messageAnimationID):
                AppComponents.shared.uiCoordinator.showIDPicker()
            case .picker(.messageAnimationDuration):
                AppComponents.shared.uiCoordinator.showDurationActionSheet()
            case .button(.share):
                AppComponents.shared.uiCoordinator.showShareActionSheet()
            case .button(.import):
                AppComponents.shared.uiCoordinator.showImportActionSheet()
//            case .button(.restore):
//                AppComponents.shared.uiCoordinator.showActionSheet(withTitle: "", actions: [])
            case .button(.messageAnimation(let id)):
                AppComponents.shared.store.dispatchCustom { app in
                    app.selectedConfigID = id
                }
                AppComponents.shared.uiCoordinator.hideIDPicker()
            default:
                return
            }
        }.boxed()
    }

    func updateAnimationTimingC1Fraction(_ c1Fraction: Float) -> RDXKit.AnyAction<RowState> {
        RDXKit.Custom(id: "") { row in
            guard case .animationTiming(var messageAnimationTiming) = row else { return fallback() }
            messageAnimationTiming.timing.c1Fraction = c1Fraction
            row = .animationTiming(messageAnimationTiming)
        }.boxed()
    }

    func updateAnimationTimingC2Fraction(_ c2Fraction: Float) -> RDXKit.AnyAction<RowState> {
        RDXKit.Custom(id: "") { row in
            guard case .animationTiming(var messageAnimationTiming) = row else { return fallback() }
            messageAnimationTiming.timing.c2Fraction = c2Fraction
            row = .animationTiming(messageAnimationTiming)
        }.boxed()
    }

    func updateAnimationTimingStartsAtFraction(_ startsAtFraction: Float) -> RDXKit.AnyAction<RowState> {
        RDXKit.Custom(id: "") { row in
            guard case .animationTiming(var messageAnimationTiming) = row else { return fallback() }
            messageAnimationTiming.timing.startsAtFraction = startsAtFraction
            row = .animationTiming(messageAnimationTiming)
        }.boxed()
    }

    func updateAnimationTimingEndsAtFraction(_ endsAtFraction: Float) -> RDXKit.AnyAction<RowState> {
        RDXKit.Custom(id: "") { row in
            guard case .animationTiming(var messageAnimationTiming) = row else { return fallback() }
            messageAnimationTiming.timing.endsAtFraction = endsAtFraction
            row = .animationTiming(messageAnimationTiming)
        }.boxed()
    }
}

private struct SelectRow: RDXKit.Action {
    typealias State = RowState

    func adjust(_ state: inout RowState) {
        print("SelectRow")
    }
}
