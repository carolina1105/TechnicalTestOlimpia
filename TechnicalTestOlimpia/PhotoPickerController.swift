//
//  PhotoPickerController.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit

import Photos

protocol PhotoickerDelegate: class {
    func didPick(_ picker: PhotoPickerController, collection: PhotoCollection)
}

class PhotoPickerController: UITableViewController, PhotoLibraryDelegate {

    private weak var delegate: PhotoickerDelegate?

    private let library: PhotoLibrary
    private var collections: [PhotoCollection]

    required init(library: PhotoLibrary,
                  delegate: PhotoickerDelegate) {
        self.library = library
        self.collections = library.allPhotoCollections()
        self.delegate = delegate
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.nBackground
        tableView.backgroundColor = UIColor.nBackground
        tableView.separatorColor = .clear
    }
    
    func reloadContent() {
        library.add(delegate: self)

        collections = library.allPhotoCollections()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return buildTableCell(collection: collections[indexPath.row])
    }
    
    // MARK: -

    private let numberFormatter: NumberFormatter = NumberFormatter()

    private func buildTableCell(collection: PhotoCollection) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.backgroundColor = UIColor.nBackground
        cell.selectedBackgroundView?.backgroundColor = UIColor(white: 0.2, alpha: 1)

        let contents = collection.contents()

        let titleLabel = UILabel()
        titleLabel.text = collection.localizedTitle()
        titleLabel.font = UIFont(name: FontConfig.default.robotoBold, size: FontSizeConfig.default.title)
        titleLabel.textColor = UIColor.nPrimaryText

        let countLabel = UILabel()
        countLabel.text = numberFormatter.string(for: contents.assetCount)
        countLabel.font = UIFont(name: FontConfig.default.robotoRegular, size: FontSizeConfig.default.text)
        countLabel.textColor = UIColor.nSecondaryDark

        let textStack = UIStackView(arrangedSubviews: [titleLabel, countLabel])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 2

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let kImageSize = 80
        imageView.autoSetDimensions(to: CGSize(width: kImageSize, height: kImageSize))

        let hStackView = UIStackView(arrangedSubviews: [imageView, textStack])
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.spacing = 11

        let photoMediaSize = PhotoMediaSize(thumbnailSize: CGSize(width: kImageSize, height: kImageSize))
        if let assetItem = contents.lastAssetItem(photoMediaSize: photoMediaSize) {
            imageView.image = assetItem.asyncThumbnail { [weak imageView] image in
                guard let imageView = imageView else {
                    return
                }

                guard let image = image else {
                    print("image was unexpectedly nil")
                    return
                }
                imageView.image = image
            }
        }

        cell.contentView.addSubview(hStackView)
        _ = hStackView.autoPinToSuperviewMargins()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didPick(self, collection: collections[indexPath.row])
    }

    // MARK: PhotoLibraryDelegate
    func photoLibraryDidChange(_ photoLibrary: PhotoLibrary) {
        tableView.reloadData()
    }
    
}
