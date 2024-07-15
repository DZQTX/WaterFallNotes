//
//  NotesViewController.swift
//  AppDemo1
//
//  Created by 夜凛(丁志强) on 2024/7/4.
//

import AFNetworking
import UIKit
import YYModel

// MARK: - ViewController

class ViewController: UIViewController {
    // MARK: Internal

    var notes = [NotesModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        //添加手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
        
        self.title = "瀑布流笔记Demo"
        if let navigationBar = navigationController?.navigationBar{
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                 NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        }
        fetchNotes()
    }

    func fetchNotes() {
        let manager = AFHTTPSessionManager()
        // 设置请求序列化器
        manager.requestSerializer = AFHTTPRequestSerializer()
        // 设置响应序列化器
        manager.responseSerializer.acceptableContentTypes = Set(["application/json", "text/json", "text/javascript", "text/html"])
        manager.get("https://edith.xiaohongshu.com/myNote", parameters: nil, headers: nil, progress: nil, success: { [weak self] (_: URLSessionDataTask, responseObject: Any?) in

            // 请求成功，处理响应数据
            if let responseData = responseObject as? [String: Any], let items = responseData["items"] as? [Any] {
                print("Response Data: \(responseData)")

                // 使用 yymodel 将 JSON Data 转换为模型对象
                if let posts = NSArray.yy_modelArray(with: NotesModel.self, json: items) as? [NotesModel] {
                    self?.notes = posts
                    self?.collectionView.reloadData()
                }
            }
        }) { (_: URLSessionDataTask?, error: Error) in
            // 请求失败
            print("Error: \(error)")
        }
    }
    
    //处理长按事件
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point) {
                showToast(message: "你长按了第 \(indexPath.row + 1) 个item",at: point)
            }
        }
    }

    func showToast(message: String, at point: CGPoint) {
        let label = UILabel()
        label.text = message
        label.backgroundColor = .white
        label.textAlignment = .center
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 16)

        let textSize = label.intrinsicContentSize
        let labelWith = min(view.frame.width - 40, textSize.width + 20)
        let labelHeight = textSize.height + 20
        let xPos = max(20, min(point.x - labelWith / 2, view.frame.width - labelWith - 20))
        let yPos = max(20, min(point.y - labelHeight / 2, view.frame.height - labelHeight - 20))
        label.frame = CGRect(x: xPos, y: yPos, width: labelWith, height: labelHeight)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true

        view.addSubview(label)

        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            label.alpha = 0.0
        }, completion: { _ in
            label.removeFromSuperview()
        })
    }

    // MARK: Private

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NotesCell.self, forCellWithReuseIdentifier: String(describing: NotesCell.self))
        return collectionView
    }()
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NotesCell.self), for: indexPath)
        if let cell = cell as? NotesCell {
            cell.configure(with: notes[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = NotesDetailViewController()
        detail.itemIndex = indexPath.row
        navigationController?.pushViewController(detail, animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 14
        let width = (UIScreen.main.bounds.width - spacing) / 2
        let height = (UIScreen.main.bounds.height - spacing) / 2.5
        return CGSize(width: width, height: height)
    }
}

// MARK: - NotesDetailViewController

// 显示cell详细信息
class NotesDetailViewController: UIViewController {
    var itemIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        if let index = itemIndex {
            label.text = "你点击了第 \(index) 个Item "
            label.font = UIFont.systemFont(ofSize: 26)
            label.textAlignment = .center
            label.textColor = .black
            label.frame = CGRect(x: 0, y: view.frame.height / 2, width: view.frame.width, height: 100)
            view.addSubview(label)
        }
    }
}
