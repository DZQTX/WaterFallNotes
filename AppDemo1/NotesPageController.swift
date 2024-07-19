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

// MARK: - MCellController

public class NotesPageController: CellController<NotesCell>, Manipulatable, CollectionViewDelegate {
    
    public typealias Model = String
    
    override public func interfaceDidLoad() {
        super.interfaceDidLoad()
        NotesPageLayout.link(to: self, as: UICollectionViewDelegateFlowLayout.self)
        //设置代理
     let collectionView = self.scrollView as? UICollectionView
        collectionView?.delegate = self[bridge: UICollectionViewDelegateFlowLayout.self]
    }

    override public var alignDimension: ListDimension {
        .ratios(1)//占cell数
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

    public override func shouldBind(to view: NotesCell) {
        view.backgroundColor = .white
        view.configure()
        view.likesLabel.text = model
        let collectionView = self.scrollView as? UICollectionView
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

extension NotesPageController: Capable {
    public var CapableKeys: [CapableKey] {
        NSObjectProtocol.self
    }
}

// MARK: - String + JustBuildable

extension String: JustBuildable {
    public typealias EI = NotesPageController
    public func build() -> Packable {
        NotesPageController.build.adapter(self).build()
    }
}

class NotesPageLayout: ObjcProtocolBridge<NotesPageController>, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let W = collectionView.frame.width / 2
        let H = collectionView.frame.height / 2
        return CGSize(width: W, height: H)
    }
    
    
}
