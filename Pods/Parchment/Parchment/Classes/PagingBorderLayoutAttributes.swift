import UIKit

open class PagingBorderLayoutAttributes: UICollectionViewLayoutAttributes {
  
  open var backgroundColor: UIColor?
  open var insets: UIEdgeInsets = UIEdgeInsets()
  
  func configure(_ options: PagingOptions, safeAreaInsets: UIEdgeInsets = .zero) {
    if case let .visible(height, index, borderInsets) = options.borderOptions {
      insets = borderInsets
      backgroundColor = options.borderColor
      frame.origin.y = options.menuHeight - height
      frame.size.height = height
      zIndex = index
    }
  }
  
  func update(contentSize: CGSize, bounds: CGRect, safeAreaInsets: UIEdgeInsets) {
    let width = max(bounds.width, contentSize.width)
    frame.size.width = width - insets.horizontal - safeAreaInsets.horizontal
    frame.origin.x = insets.left + safeAreaInsets.left
    
  }
  
}
