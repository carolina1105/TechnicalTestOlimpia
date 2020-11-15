//
//  PhotoLibrary.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit
import Photos
import CoreServices

protocol PhotoLibraryDelegate: class {
    func photoLibraryDidChange(_ photoLibrary: PhotoLibrary)
}

public enum ImageQualityTier: UInt {
    case original
    case high
    case mediumHigh
    case medium
    case mediumLow
    case low
}

public enum ImageQuality: UInt {
    case original
    case medium
    case compact

    func imageQualityTier() -> ImageQualityTier {
        switch self {
        case .original:
            return .original
        case .medium:
            return .mediumHigh
        case .compact:
            return .medium
        }
    }
}

class PhotoMediaSize {
    var thumbnailSize: CGSize

    init() {
        self.thumbnailSize = .zero
    }

    init(thumbnailSize: CGSize) {
        self.thumbnailSize = thumbnailSize
    }
}

class PhotoPickerAssetItem: PhotoGridItem {

    let asset: PHAsset
    let photoCollectionContents: PhotoCollectionContents
    let photoMediaSize: PhotoMediaSize

    init(asset: PHAsset, photoCollectionContents: PhotoCollectionContents, photoMediaSize: PhotoMediaSize) {
        self.asset = asset
        self.photoCollectionContents = photoCollectionContents
        self.photoMediaSize = photoMediaSize
    }

    // MARK: PhotoGridItem

    var type: PhotoGridItemType {
        if asset.mediaType == .video {
            return .video
        } else if #available(iOS 11, *), asset.playbackStyle == .imageAnimated {
            return .animated
        } else {
            return  .photo
        }
    }

    func asyncThumbnail(completion: @escaping (UIImage?) -> Void) -> UIImage? {
        var syncImageResult: UIImage?
        var hasLoadedImage = false

        // Surprisingly, iOS will opportunistically run the completion block sync if the image is
        // already available.
        photoCollectionContents.requestThumbnail(for: self.asset, thumbnailSize: photoMediaSize.thumbnailSize) { image, _ in
            DispatchQueue.main.async {
                syncImageResult = image

                // Once we've _successfully_ completed (e.g. invoked the completion with
                // a non-nil image), don't invoke the completion again with a nil argument.
                if !hasLoadedImage || image != nil {
                    completion(image)

                    if image != nil {
                        hasLoadedImage = true
                    }
                }
            }
        }
        return syncImageResult
    }
}

class PhotoCollectionContents {

    let fetchResult: PHFetchResult<PHAsset>
    let localizedTitle: String?

    enum PhotoLibraryError: Error {
        case assertionError(description: String)
        case unsupportedMediaType
    }

    init(fetchResult: PHFetchResult<PHAsset>, localizedTitle: String?) {
        self.fetchResult = fetchResult
        self.localizedTitle = localizedTitle
    }

    private let imageManager = PHCachingImageManager()

    // MARK: - Asset Accessors

    var assetCount: Int {
        return fetchResult.count
    }

    var lastAsset: PHAsset? {
        guard assetCount > 0 else {
            return nil
        }
        return asset(at: assetCount - 1)
    }

    var firstAsset: PHAsset? {
        guard assetCount > 0 else {
            return nil
        }
        return asset(at: 0)
    }

    func asset(at index: Int) -> PHAsset {
        return fetchResult.object(at: index)
    }

    // MARK: - AssetItem Accessors

    func assetItem(at index: Int, photoMediaSize: PhotoMediaSize) -> PhotoPickerAssetItem {
        let mediaAsset = asset(at: index)
        return PhotoPickerAssetItem(asset: mediaAsset, photoCollectionContents: self, photoMediaSize: photoMediaSize)
    }

    func firstAssetItem(photoMediaSize: PhotoMediaSize) -> PhotoPickerAssetItem? {
        guard let mediaAsset = firstAsset else {
            return nil
        }
        return PhotoPickerAssetItem(asset: mediaAsset, photoCollectionContents: self, photoMediaSize: photoMediaSize)
    }

    func lastAssetItem(photoMediaSize: PhotoMediaSize) -> PhotoPickerAssetItem? {
        guard let mediaAsset = lastAsset else {
            return nil
        }
        return PhotoPickerAssetItem(asset: mediaAsset, photoCollectionContents: self, photoMediaSize: photoMediaSize)
    }

    // MARK: ImageManager
    func requestThumbnail(for asset: PHAsset, thumbnailSize: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) {
        _ = imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: resultHandler)
    }

    private func requestImage(for asset: PHAsset,
                              sucess: @escaping (Data?, URL?, String) -> Void) {
        let options: PHImageRequestOptions = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        imageManager.requestImageDataAndOrientation(for: asset,
                                                    options: options) { data, uti, orientation, info in
            guard let data = data else {
                print("imageData was unexpectedly nil")
                return
            }
            guard let uti = uti else {
                print("dataUTI was unexpectedly nil")
                return
            }
            sucess(data, nil, uti)
        }
    }

    private func requestVideo(for asset: PHAsset,
                              sucess: @escaping (Data?, URL?, String) -> Void) {
        let options: PHVideoRequestOptions = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true

        _ = imageManager.requestExportSession(forVideo: asset, options: options, exportPreset: AVAssetExportPresetMediumQuality) { exportSession, _ in

            guard let exportSession = exportSession else {
                print("exportSession was unexpectedly nil")
                return
            }

            exportSession.outputFileType = AVFileType.mp4
            exportSession.metadataItemFilter = AVMetadataItemFilter.forSharing()

            let exportPath = FileSystem.shared.temporaryPath(with: "mp4")
            let exportURL = URL(fileURLWithPath: exportPath)
            exportSession.outputURL = exportURL

            print("starting video export")
            exportSession.exportAsynchronously {
                print("Completed video export")
                sucess(nil, exportURL, kUTTypeMPEG4 as String)
            }
        }
    }

    func outgoingAttachment(for asset: PHAsset,
                            imageQuality: ImageQuality,
                            sucess: @escaping (Data?, URL?, String) -> Void) {
        switch asset.mediaType {
        case .image:
            requestImage(for: asset, sucess: sucess)
        case .video:
            requestVideo(for: asset, sucess: sucess)
        default:
            break
        }
    }
}

class PhotoCollection {
    private let collection: PHAssetCollection

    // The user never sees this collection, but we use it for a null object pattern
    // when the user has denied photos access.
    static let empty = PhotoCollection(collection: PHAssetCollection())

    init(collection: PHAssetCollection) {
        self.collection = collection
    }

    func localizedTitle() -> String {
        guard let localizedTitle = collection.localizedTitle?.trimmingCharacters(in: .whitespacesAndNewlines),
            localizedTitle.count > 0 else {
            return "system photo collections which have no name"
        }
        return localizedTitle
    }

    func contents(ascending: Bool = true, limit: Int = 0) -> PhotoCollectionContents {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: ascending)]
        options.fetchLimit = limit
        options.predicate = NSPredicate(format: "mediaType = %d AND playbackStyle != %d", PHAssetMediaType.image.rawValue, PHAsset.PlaybackStyle.imageAnimated.rawValue)
        let fetchResult = PHAsset.fetchAssets(in: collection, options: options)

        return PhotoCollectionContents(fetchResult: fetchResult, localizedTitle: localizedTitle())
    }
}

extension PhotoCollection: Equatable {
    static func == (lhs: PhotoCollection, rhs: PhotoCollection) -> Bool {
        return lhs.collection == rhs.collection
    }
}

class PhotoLibrary: NSObject, PHPhotoLibraryChangeObserver {
    typealias WeakDelegate = Weak<PhotoLibraryDelegate>
    var delegates = [WeakDelegate]()

    public func add(delegate: PhotoLibraryDelegate) {
        delegates.append(WeakDelegate(value: delegate))
    }

    var assetCollection: PHAssetCollection!

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            for weakDelegate in self.delegates {
                weakDelegate.value?.photoLibraryDidChange(self)
            }
        }
    }

    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    func defaultPhotoCollection() -> PhotoCollection {
        var fetchedCollection: PhotoCollection?
        PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumUserLibrary,
            options: fetchOptions
        ).enumerateObjects { collection, _, stop in
            fetchedCollection = PhotoCollection(collection: collection)
            stop.pointee = true
        }

        guard let photoCollection = fetchedCollection else {
            print("Using empty photo collection.")
//            assert(PHPhotoLibrary.authorizationStatus() == .denied)
            return PhotoCollection.empty
        }

        return photoCollection
    }

    private lazy var fetchOptions: PHFetchOptions = {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]
        return fetchOptions
    }()

    func allPhotoCollections() -> [PhotoCollection] {
        var collections = [PhotoCollection]()
        var collectionIds = Set<String>()

        let processPHCollection: ((collection: PHCollection, hideIfEmpty: Bool)) -> Void = { arg in
            let (collection, hideIfEmpty) = arg

            // De-duplicate by id.
            let collectionId = collection.localIdentifier
            guard !collectionIds.contains(collectionId) else {
                return
            }
            collectionIds.insert(collectionId)

            guard let assetCollection = collection as? PHAssetCollection else {
                // TODO: Add support for albmus nested in folders.
                if collection is PHCollectionList { return }
                print("Asset collection has unexpected type: \(type(of: collection))")
                return
            }
            let photoCollection = PhotoCollection(collection: assetCollection)
            guard !hideIfEmpty || photoCollection.contents().assetCount > 0 else {
                return
            }

            collections.append(photoCollection)
        }
        let processPHAssetCollections: ((fetchResult: PHFetchResult<PHAssetCollection>, hideIfEmpty: Bool)) -> Void = { arg in
            let (fetchResult, hideIfEmpty) = arg

            fetchResult.enumerateObjects { (assetCollection, _, _) in
                // We're already sorting albums by last-updated. "Recently Added" is mostly redundant
                guard assetCollection.assetCollectionSubtype != .smartAlbumRecentlyAdded else {
                    return
                }

                // undocumented constant
                let kRecentlyDeletedAlbumSubtype = PHAssetCollectionSubtype(rawValue: 1000000201)
                guard assetCollection.assetCollectionSubtype != kRecentlyDeletedAlbumSubtype else {
                    return
                }

                processPHCollection((collection: assetCollection, hideIfEmpty: hideIfEmpty))
            }
        }
        let processPHCollections: ((fetchResult: PHFetchResult<PHCollection>, hideIfEmpty: Bool)) -> Void = { arg in
            let (fetchResult, hideIfEmpty) = arg

            for index in 0..<fetchResult.count {
                processPHCollection((collection: fetchResult.object(at: index), hideIfEmpty: hideIfEmpty))
            }
        }

        // Try to add "Camera Roll" first.
        processPHAssetCollections((fetchResult: PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: fetchOptions),
                                   hideIfEmpty: false))

        // Favorites
        processPHAssetCollections((fetchResult: PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: fetchOptions),
                                   hideIfEmpty: true))

        // Smart albums.
        processPHAssetCollections((fetchResult: PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: fetchOptions),
                                   hideIfEmpty: true))

        // User-created albums.
        processPHCollections((fetchResult: PHAssetCollection.fetchTopLevelUserCollections(with: fetchOptions),
                              hideIfEmpty: true))

        return collections
    }
}

public struct Weak<T> {
    private weak var _value: AnyObject?

    public var value: T? {
        get {
            return _value as? T
        }
        set {
            _value = newValue as AnyObject
        }
    }

    public init(value: T) {
        self.value = value
    }
}
