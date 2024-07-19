//
//  NotesPageController.swift
//  AppDemo1
//
//  Created by 夜凛(丁志强) on 2024/7/18.
//

import Foundation
import Pipe
import PipeCore
import UIKit

// MARK: - NotesPageController

public class NotesPageController: SectionListController, CollectionFlowLayoutable {
    override public func interfaceDidLoad() {
        super.interfaceDidLoad()
        reload {
            Section {
                MCell.build.header(align: .points(20))
                ForEach(0 ..< 10) {
                    NotesPageCellController.build.adapter(String($0))
                }
            }
        }
    }

    override public func interfaceDidMounted() {
        super.interfaceDidMounted()
//        NotesPageLayout.link(to: self, as: UICollectionViewDelegateFlowLayout.self)
//        // 设置代理
//        let collectionView = scrollView as? UICollectionView
//        collectionView?.delegate = self[bridge: UICollectionViewDelegateFlowLayout.self]
        // collectionView?.reloadData()
//
    }

    public func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let W = UIScreen.main.bounds.width / 2.1
        let H = UIScreen.main.bounds.height / 2.5
        return CGSize(width: W, height: H)
    }
    public func insetForSection(at index: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
    }
    
}

// MARK: - MCell

public class MCell: UILabel, CellReusable {
    // MARK: Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        text = "Note PipeList"
        backgroundColor = .blue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public

    public func prepareForReuse() {
    }
}

// MARK: - NotesPageCellController

public class NotesPageCellController: CellController<NotesCell>, Manipulatable, CollectionViewDelegate {
    public typealias Model = String

    override public var alignDimension: ListDimension {
        .ratios(1) // 占cell数
    }

    override public var crossDimension: ListDimension {
        .slots(1)
    }

    override public var contentInsets: UIEdgeInsets {
        .init(top: 5, left: 10, bottom: 0, right: 10)
    }

    override public func modelDidUpdate() {
        super.modelDidUpdate()
    }

    override public func shouldBind(to view: NotesCell) {
        view.backgroundColor = .white
        view.configure()
        view.likesLabel.text = model
        let collectionView = scrollView as? UICollectionView
        collectionView?.reloadData()
    }

    override public func willFullDisplay(cell: any CellInterface) {
        print("full d \(indexPath)")
    }

    override public func didSelectItemForCell() {
        super.didSelectItemForCell()

        if index == 0 {
            sectionController?.reload {}
        } else {
            move(to: 0)
        }
    }
}

// MARK: - NotesPageController + Capable

extension NotesPageController: Capable {
    public var CapableKeys: [CapableKey] {
        NSObjectProtocol.self
    }
}

// MARK: - String + JustBuildable

extension String: JustBuildable {
    public typealias EI = NotesPageCellController
    public func build() -> Packable {
        NotesPageCellController.build.adapter(self).build()
    }
}

// MARK: - NotesPageLayout

//
// class NotesPageLayout: ObjcProtocolBridge<NotesPageController>, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    }
//
// }
