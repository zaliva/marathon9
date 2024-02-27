import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var array = [1,2,3,4,5,6,7,8,9]
    var cellWidth: CGFloat = 0
    var isScrolling = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupCollectionViewFlowLayout()
        collectionView.reloadData()
    }
    
    private func setupCollectionViewFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = getSizeCell()
        layout.minimumLineSpacing = 0
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func getSizeCell() -> CGSize {
        return CGSize(width: (self.collectionView.bounds.width - 100), height: self.collectionView.bounds.height)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.viewBG.layer.cornerRadius = 10
        cell.viewBG.clipsToBounds = true
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getSizeCell()
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if isScrolling {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = collectionView.bounds.width - 100
            let totalCellWidth = cellWidth + layout.minimumLineSpacing
            var offset = targetContentOffset.pointee.x + collectionView.contentInset.left
            offset = round(offset / totalCellWidth) * totalCellWidth
            let targetOffsetX = max(5, min(offset, collectionView.contentSize.width - collectionView.bounds.width))
            targetContentOffset.pointee = CGPoint(x: targetOffsetX - collectionView.contentInset.left, y: 0)
            isScrolling = false
        }
    }
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewBG: UIView!
}
