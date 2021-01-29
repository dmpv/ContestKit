//
//  draft.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 25.01.2021.
//

import Foundation

extension AppConfigState {
    var messageAnimationIDPickerSectionedList: SectionedListState {
        get {
            .init(
                sections: [
                    .messageAnimations(
                        rows: messageAnimationConfigs.map { messageAnimationConfig in
                            .button(.messageAnimation(id: messageAnimationConfig.id))
                        }
                    )
                ]
            )
        }
        set {
            fatalError(.shouldNeverBeCalled(nil))
        }
    }
}

extension RDXKit.Store where StateT == AppState {
    var sectionedListStore: RDXKit.Store<SectionedListState> {
        makeProxy(
            config: .init(
                lens: Lens(\.config.messageAnimationIDPickerSectionedList)
            )
        )
    }
}
