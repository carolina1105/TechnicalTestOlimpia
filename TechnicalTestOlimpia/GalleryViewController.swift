//
//  GalleryViewController.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit
import Photos
import CropViewController

protocol GalleryControllerDelegate {
    func did(photo: String, message: String)
    
    func didCompleteSelection(_ picker: GalleryViewController)
    func didCancel(_ picker: GalleryViewController)
    
    func isAssetSelected(_ picker: GalleryViewController, asset: PHAsset) -> Bool
    func didSelectAsset(_ picker: GalleryViewController, asset: PHAsset, data: Data?, url: URL?, uti: String)
    func didDeselectAsset(_ picker: GalleryViewController, asset: PHAsset)
    
    var isInBatchSelectMode: Bool { get }
    var isPickingAsDocument: Bool { get }
    func canSelectMoreItems(_ picker: GalleryViewController) -> Bool
    func didTryToSelectTooMany(_ picker: GalleryViewController)
}

class GalleryViewController: UICollectionViewController, PhotoLibraryDelegate, PhotoickerDelegate, CropViewControllerDelegate {
    private let btnSize: CGFloat = 40
    private let size: CGFloat = 25
    private let x: CGFloat = -20
    private let sizeImage = CGSize(width: 2, height: 3)
    
    var delegate: GalleryControllerDelegate?
    
    private let library: PhotoLibrary = PhotoLibrary()
    private var photoCollection: PhotoCollection
    private var photoCollectionContents: PhotoCollectionContents
    private let photoMediaSize = PhotoMediaSize()
    
    private var btnClose: UIButton!
    private var btnBack: UIButton!
    private var btnReady: UIButton!
    private var isReadyToSend: Bool = false {
        didSet {
            btnReady.isHidden = !isReadyToSend
        }
    }
    
    private var data: Data!
    private var url: URL!
    private var uti: String!
    private var mediaType: PHAssetMediaType!
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout
    
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    private let imageView = UIImageView()
    var cropType: CropViewControllerAspectRatioPreset = .preset3x2
    let padding: CGFloat = 20.0
    var assetItemSelected: PhotoPickerAssetItem?
    
    init(cropType: CropViewControllerAspectRatioPreset) {
        collectionViewFlowLayout = type(of: self).buildLayout()
        photoCollection = library.defaultPhotoCollection()
        photoCollectionContents = photoCollection.contents()
        self.cropType = cropType
        super.init(collectionViewLayout: collectionViewFlowLayout)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActive(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background()
        navigation()
        
        library.add(delegate: self)
        
        collectionView!.register(PhotoGridViewCell.self, forCellWithReuseIdentifier: PhotoGridViewCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.nBackground
        
        let selectionPanGesture = DirectionalPanGestureRecognizer(direction: [.horizontal], target: self, action: #selector(didPanSelection))
        selectionPanGesture.delegate = self
        self.selectionPanGesture = selectionPanGesture
        collectionView.addGestureRecognizer(selectionPanGesture)
    }
    
    func background() {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = UIColor.nBackground
        view.addSubview(background)
    }
    
    func navigation() {
        confingBack()
        confingReady()
        title = photoCollection.localizedTitle()
        navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.nPrimary
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.nSecondaryText as Any,
                                                                                      .font: UIFont(name: FontConfig.default.robotoBold,
                                                                                                    size: FontSizeConfig.default.title) as Any]
    }
    
    func confingBack() {
        let symbol = UIImage.SymbolConfiguration(pointSize: size, weight: .regular)
        let back = UIImage(systemName: "chevron.left", withConfiguration: symbol)
        btnBack = UIButton(type: .custom)
        let insets = UIEdgeInsets(top: .zero, left: x, bottom: .zero, right: .zero)
        btnBack.imageEdgeInsets = insets
        btnBack.setImage(back, for: .normal)
        btnBack.frame = CGRect(x: .zero, y: .zero, width: btnSize, height: btnSize)
        btnBack.tintColor = UIColor.nSecondaryText
        let itemBack = UIBarButtonItem(customView: btnBack)
        itemBack.tintColor = UIColor.nIcon
        btnBack.on(.touchUpInside) { (sender, event) in
            if self.isShowingCollectionPickerController {
                self.hideCollectionPicker()
            } else {
                self.showCollectionPicker()
            }
        }
        navigationItem.leftBarButtonItem = itemBack
    }
    
    func confingReady() {
        let symbol = UIImage.SymbolConfiguration(pointSize: size, weight: .regular)
        let ready = UIImage(systemName: "checkmark", withConfiguration: symbol)
        btnReady = UIButton(type: .custom)
        btnReady.setImage(ready, for: .normal)
        btnReady.frame = CGRect(x: .zero, y: .zero, width: btnSize, height: btnSize)
        btnReady.tintColor = UIColor.nSecondaryText
        let itemReady = UIBarButtonItem(customView: btnReady)
        itemReady.tintColor = UIColor.nIcon
        btnReady.on(.touchUpInside) { (sender, event) in
            self.prepareToSend()
        }
        navigationItem.rightBarButtonItem = itemReady
        btnReady.isHidden = !isReadyToSend
    }
    
    func confingClose() {
        let symbol = UIImage.SymbolConfiguration(pointSize: size, weight: .regular)
        let close = UIImage(systemName: "xmark", withConfiguration: symbol)
        btnClose = UIButton(type: .custom)
        btnClose.setImage(close, for: .normal)
        btnClose.frame = CGRect(x: .zero, y: .zero, width: btnSize, height: btnSize)
        btnClose.tintColor = UIColor.nSecondaryText
        let itemClose = UIBarButtonItem(customView: btnClose)
        itemClose.tintColor = UIColor.nIcon
        btnClose.on(.touchUpInside) { (sender, event) in
            self.dismiss(animated: true, completion: nil)
        }
        navigationItem.leftBarButtonItem = itemClose
    }
    
    func prepareToSend() {
        imageView.image = UIImage(data: data)
        let crop = CropViewController(croppingStyle: croppingStyle,
                                      image: imageView.image!)
        if self.cropType == .presetSquare {
            crop.aspectRatioPreset = self.cropType
        } else if self.cropType == .preset3x2 {
            crop.aspectRatioPreset = self.cropType
        } else {
            crop.aspectRatioPreset = .presetCustom
            crop.customAspectRatio = self.sizeImage
        }
        crop.aspectRatioLockEnabled = true
        crop.aspectRatioPickerButtonHidden = true
        crop.resetButtonHidden = true
        crop.delegate = self
        
        self.present(crop, animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasEverAppeared = true
        
        DispatchQueue.main.async {
            // pre-layout collectionPicker for snappier response
            self.pickerController.view.layoutIfNeeded()
        }
    }
    
    // MARK:
    
    func cropViewController(_ cropViewController: CropViewController,
                            didCropToImage image: UIImage,
                            withRect cropRect: CGRect,
                            angle: Int) {
        croppedRect = cropRect
        croppedAngle = angle
        updateImage(image, controller: cropViewController)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
        croppedRect = rect
        croppedAngle = angle
        updateImage(imageView.image!, controller: cropViewController)
    }
    
    func updateImage(_ image: UIImage, controller: CropViewController) {
        imageView.image = image
        layoutImageView()
        imageView.isHidden = true
        controller.dismissAnimatedFrom(self,
                                       withCroppedImage: image,
                                       toView: imageView,
                                       toFrame: .zero,
                                       setup: {
                                        self.layoutImageView()
        }) {
            self.imageView.isHidden = false
            guard let data: Data = self.imageView.image?.jpegData(compressionQuality: 0.25) else {
                return
            }
            let base64 = data.base64EncodedString()
            self.delegate?.did(photo: base64, message: "")
            self.imageView.image = nil
        }
    }
    
    func layoutImageView() {
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        
        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;
        
        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        } else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
    
    var lastPageYOffset: CGFloat {
        var yOffset = collectionView.contentSize.height - collectionView.frame.height + collectionView.contentInset.bottom
        yOffset += view.safeAreaInsets.bottom
        return yOffset
    }
    
    func scrollToBottom(animated: Bool) {
        self.view.layoutIfNeeded()
        
        guard let collectionView = collectionView else {
            print("collectionView was unexpectedly nil")
            return
        }
        let yOffset = lastPageYOffset
        guard yOffset > 0 else {
            // less than 1 page of content. Do not offset.
            return
        }
        collectionView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !hasEverAppeared, collectionView.contentOffset.y != lastPageYOffset {
            // We initially want the user to be scrolled to the bottom of the media library content.
            // However, at least on iOS12, we were finding that when the view finally presented,
            // the content was not *quite* to the bottom (~20px above it).
            //
            // Debugging shows that initially we have the correct offset, but that *something* is
            // causing the content to adjust *after* viewWillAppear and viewSafeAreaInsetsDidChange.
            // Because that something results in `scrollViewDidScroll` we re-adjust the content
            // insets to the bottom.
            print("adjusting scroll offset back to bottom")
            scrollToBottom(animated: false)
        }
    }
    
    public func reloadData() {
        guard let collectionView = collectionView else {
            print("Missing collectionView.")
            return
        }
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    static let kInterItemSpacing: CGFloat = 2
    private class func buildLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        if #available(iOS 11, *) {
            layout.sectionInsetReference = .fromSafeArea
        }
        layout.minimumInteritemSpacing = kInterItemSpacing
        layout.minimumLineSpacing = kInterItemSpacing
        layout.sectionHeadersPinToVisibleBounds = true
        
        return layout
    }
    
    func updateLayout() {
        let containerWidth: CGFloat
        if #available(iOS 11.0, *) {
            containerWidth = self.view.safeAreaLayoutGuide.layoutFrame.size.width
        } else {
            containerWidth = self.view.frame.size.width
        }
        let minItemWidth: CGFloat = 100
        let itemCount = floor(containerWidth / minItemWidth)
        let interSpaceWidth = (itemCount - 1) * type(of: self).kInterItemSpacing
        
        let availableWidth = containerWidth - interSpaceWidth
        
        let itemWidth = floor(availableWidth / CGFloat(itemCount))
        let newItemSize = CGSize(width: itemWidth, height: itemWidth)
        let remainingSpace = availableWidth - (itemCount * itemWidth)
        
        if (newItemSize != collectionViewFlowLayout.itemSize) {
            collectionViewFlowLayout.itemSize = newItemSize
            // Inset any remaining space around the outside edges to ensure all inter-item spacing is exactly equal, otherwise
            // we may get slightly different gaps between rows vs. columns
            collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: remainingSpace / 2, bottom: 0, right: remainingSpace / 2)
            collectionViewFlowLayout.invalidateLayout()
        }
    }
    
    var hasEverAppeared: Bool = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Determine the size of the thumbnails to request
        let scale = UIScreen.main.scale
        let cellSize = collectionViewFlowLayout.itemSize
        photoMediaSize.thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        
        reloadData()
        if !hasEverAppeared {
            scrollToBottom(animated: false)
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        if !hasEverAppeared {
            // To scroll precisely to the bottom of the content, we have to account for the space
            // taken up by the navbar and any notch.
            //
            // Before iOS11 the system accounts for this by assigning contentInset to the scrollView
            // which is available by the time `viewWillAppear` is called.
            //
            // On iOS11+, contentInsets are not assigned to the scrollView in `viewWillAppear`, but
            // this method, `viewSafeAreaInsetsDidChange` is called *between* `viewWillAppear` and
            // `viewDidAppear` and indicates `safeAreaInsets` have been assigned.
            scrollToBottom(animated: false)
        }
    }
    
    var selectionPanGesture: UIPanGestureRecognizer?
    enum BatchSelectionGestureMode {
        case select, deselect
    }
    var selectionPanGestureMode: BatchSelectionGestureMode = .select
    
    @objc
    func didPanSelection(_ selectionPanGesture: UIPanGestureRecognizer) {
        guard let collectionView = collectionView else {
            print("collectionView was unexpectedly nil")
            return
        }
        
        guard let delegate = delegate else {
            print("delegate was unexpectedly nil")
            return
        }
        
        guard delegate.isInBatchSelectMode else {
            return
        }
        
        switch selectionPanGesture.state {
        case .possible:
            break
        case .began:
            collectionView.isUserInteractionEnabled = false
            collectionView.isScrollEnabled = false
            
            let location = selectionPanGesture.location(in: collectionView)
            guard let indexPath = collectionView.indexPathForItem(at: location) else {
                return
            }
            let asset = photoCollectionContents.asset(at: indexPath.item)
            if delegate.isAssetSelected(self, asset: asset) {
                selectionPanGestureMode = .deselect
            } else {
                selectionPanGestureMode = .select
            }
        case .changed:
            let velocity = selectionPanGesture.velocity(in: view)
            
            // Bulk selection is a horizontal pan, while scrolling content is a vertical pan.
            // There will be some ambiguity since users gestures are not perfectly cardinal.
            //
            // We try to account for that here.
            //
            // If the `alpha` is too low, the user will inadvertently select items while trying to scroll.
            // If the `alpha` is too high, the user will not be able to easily horizontally select items.
            let alpha: CGFloat = 4.0
            let isDecidedlyHorizontal = abs(velocity.x) > abs(velocity.y) * alpha
            guard isDecidedlyHorizontal else {
                return
            }
            let location = selectionPanGesture.location(in: collectionView)
            guard let indexPath = collectionView.indexPathForItem(at: location) else {
                return
            }
            tryToToggleBatchSelect(at: indexPath)
        case .cancelled, .ended, .failed:
            collectionView.isUserInteractionEnabled = true
            collectionView.isScrollEnabled = true
        @unknown default:
            print("unexpected selectionPanGesture.state: \(selectionPanGesture.state)")
        }
    }
    
    func tryToToggleBatchSelect(at indexPath: IndexPath) {
        guard let collectionView = collectionView else {
            print("collectionView was unexpectedly nil")
            return
        }
        
        guard let delegate = delegate else {
            print("delegate was unexpectedly nil")
            return
        }
        
        guard delegate.isInBatchSelectMode else {
            print("isInBatchSelectMode was unexpectedly false")
            return
        }
        
        let asset = photoCollectionContents.asset(at: indexPath.item)
        switch selectionPanGestureMode {
        case .select:
            guard !isSelected(indexPath: indexPath) else {
                return
            }
            
            guard delegate.canSelectMoreItems(self) else {
                delegate.didTryToSelectTooMany(self)
                return
            }
            isReadyToSend = false
            photoCollectionContents.outgoingAttachment(for: asset,
                                                       imageQuality: imageQuality) { data, url, uti in
                                                        DispatchQueue.main.async {
                                                            self.mediaType = asset.mediaType
                                                            switch asset.mediaType {
                                                            case .image:
                                                                self.data = data
                                                                self.uti = uti
                                                            case .video:
                                                                self.url = url
                                                                self.uti = uti
                                                            default:
                                                                break
                                                            }
                                                            self.isReadyToSend = true
                                                        }
            }
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        case .deselect:
            guard isSelected(indexPath: indexPath) else {
                return
            }
            
            delegate.didDeselectAsset(self, asset: asset)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    var imageQuality: ImageQuality {
        guard let delegate = delegate else {
            return .medium
        }
        
        return delegate.isPickingAsDocument ? .original : .medium
    }
    
    func isSelected(indexPath: IndexPath) -> Bool {
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else {
            return false
        }
        
        return selectedIndexPaths.contains(indexPath)
    }
    
    func batchSelectModeDidChange() {
        applyBatchSelectMode()
    }
    
    func applyBatchSelectMode() {
        guard let delegate = delegate else {
            return
        }
        
        guard let collectionView = collectionView else {
            print("collectionView was unexpectedly nil")
            return
        }
        
        collectionView.allowsMultipleSelection = delegate.isInBatchSelectMode
        updateVisibleCells()
    }
    
    @objc
    func didPressCancel() {
        self.delegate?.didCancel(self)
    }
    
    @objc func didBecomeActive(notification: Notification) {
        photoCollection = library.defaultPhotoCollection()
        photoCollectionContents = photoCollection.contents()
        title = photoCollection.localizedTitle()
        pickerController.reloadContent()
        reloadData()
        scrollToBottom(animated: false)
    }
    
    // MARK: - PhotoLibraryDelegate
    
    func photoLibraryDidChange(_ photoLibrary: PhotoLibrary) {
        photoCollectionContents = photoCollection.contents()
        reloadData()
    }
    
    // MARK: - PhotoCollectionPicker Presentation
    
    var isShowingCollectionPickerController: Bool = false
    
    lazy var pickerController: PhotoPickerController = {
        return PhotoPickerController(library: library,
                                     delegate: self)
    }()
    
    func showCollectionPicker() {
        guard let collectionPickerView = pickerController.view else {
            print("collectionView was unexpectedly nil")
            return
        }
        
        title = "TEXT_GALLERY_ATTACHMENT".localized
        confingClose()
        
        assert(!isShowingCollectionPickerController)
        isShowingCollectionPickerController = true
        addChild(pickerController)
        
        view.addSubview(collectionPickerView)
        collectionPickerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        collectionPickerView.autoPinEdge(toSuperviewSafeArea: .top)
        collectionPickerView.layoutIfNeeded()
        
        // Initially position offscreen, we'll animate it in.
        collectionPickerView.frame = collectionPickerView.frame.offsetBy(dx: 0, dy: collectionPickerView.frame.height)
    }
    
    func hideCollectionPicker() {
        assert(isShowingCollectionPickerController)
        isShowingCollectionPickerController = false
        confingBack()
        
        pickerController.view.removeFromSuperview()
        pickerController.removeFromParent()
    }
    
    // MARK: - PhotoickerDelegate
    
    func didPick(_ picker: PhotoPickerController, collection: PhotoCollection) {
        title = collection.localizedTitle()
        guard photoCollection != collection else {
            hideCollectionPicker()
            return
        }
        
        photoCollection = collection
        photoCollectionContents = photoCollection.contents()
        
        // Any selections are invalid as they refer to indices in a different collection
        reloadData()
        
        scrollToBottom(animated: false)
        hideCollectionPicker()
    }
    
    // MARK: - UICollectionView
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let delegate = delegate else { return false }
        
        if delegate.canSelectMoreItems(self) {
            return true
        } else {
            delegate.didTryToSelectTooMany(self)
            return false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            print("delegate was unexpectedly nil")
            return
        }
        isReadyToSend = false
        
        let asset: PHAsset = photoCollectionContents.asset(at: indexPath.item)
        self.assetItemSelected = photoCollectionContents.assetItem(at: indexPath.item, photoMediaSize: photoMediaSize)
        
        photoCollectionContents.outgoingAttachment(for: asset,
                                                   imageQuality: imageQuality) { data, url, uti in
                                                    DispatchQueue.main.async {
                                                        self.mediaType = asset.mediaType
                                                        switch asset.mediaType {
                                                        case .image:
                                                            self.data = data
                                                            self.uti = uti
                                                        case .video:
                                                            self.url = url
                                                            self.uti = uti
                                                        default:
                                                            break
                                                        }
                                                        self.isReadyToSend = true
                                                    }
        }
        
        if !delegate.isInBatchSelectMode {
            // Don't show "selected" badge unless we're in batch mode
            //            collectionView.deselectItem(at: indexPath, animated: false)
            delegate.didCompleteSelection(self)
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            print("delegate was unexpectedly nil")
            return
        }
        
        let asset = photoCollectionContents.asset(at: indexPath.item)
        delegate.didDeselectAsset(self, asset: asset)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollectionContents.assetCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGridViewCell.reuseIdentifier, for: indexPath) as? PhotoGridViewCell else {
            print("cell was unexpectedly nil")
            return UICollectionViewCell()
        }
        
        cell.loadingColor = UIColor(white: 0.2, alpha: 1)
        let assetItem = photoCollectionContents.assetItem(at: indexPath.item, photoMediaSize: photoMediaSize)
        cell.configure(item: assetItem)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard delegate != nil else { return }
        guard let photoGridViewCell = cell as? PhotoGridViewCell else {
            print("unexpected cell: \(cell)")
            return
        }
        let assetItem = photoCollectionContents.assetItem(at: indexPath.item, photoMediaSize: photoMediaSize)
        let isSelected = assetItem.asset == self.assetItemSelected?.asset
        if isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        photoGridViewCell.isSelected = isSelected
        photoGridViewCell.allowsMultipleSelection = collectionView.allowsMultipleSelection
    }
    
    func updateVisibleCells() {
        guard let delegate = delegate else { return }
        for cell in collectionView.visibleCells {
            guard let photoGridViewCell = cell as? PhotoGridViewCell else {
                print("unexpected cell: \(cell)")
                continue
            }
            
            guard let assetItem = photoGridViewCell.item as? PhotoPickerAssetItem else {
                print("unexpected photoGridViewCell.item: \(String(describing: photoGridViewCell.item))")
                continue
            }
            
            photoGridViewCell.isSelected = delegate.isAssetSelected(self, asset: assetItem.asset)
            photoGridViewCell.allowsMultipleSelection = collectionView.allowsMultipleSelection
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension GalleryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Ensure we can still scroll the collectionView by allowing other gestures to
        // take precedence.
        guard otherGestureRecognizer == selectionPanGesture else {
            return true
        }
        
        // Once we've started the selectionPanGesture, don't allow scrolling
        if otherGestureRecognizer.state == .began || otherGestureRecognizer.state == .changed {
            return false
        }
        
        return true
    }
}
