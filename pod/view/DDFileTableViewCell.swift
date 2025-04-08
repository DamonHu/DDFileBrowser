//
//  DDFileTableViewCell.swift
//  DDFileBrowserDemo
//
//  Created by Damon on 2021/5/12.
//

import UIKit
import DDUtils

class DDFileTableViewCell: UITableViewCell {
    lazy var mDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self._createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(model: DDFileModel) {
        mTitleLabel.text = model.name
        
        //计算文件属性
        if model.fileType == .unknown {
            let manager = FileManager.default
            //属性
            var isDirectory: ObjCBool = false
            if manager.fileExists(atPath: model.filepath.path, isDirectory: &isDirectory) {
                model.fileType = DDFileBrowser.shared.getFileType(filePath: model.filepath)
                if let fileAttributes = try? manager.attributesOfItem(atPath: model.filepath.path) {
                    model.modificationDate = fileAttributes[FileAttributeKey.modificationDate] as? Date ?? Date()
                    if isDirectory.boolValue {
                        mAttributedLabel.text = mDateFormatter.string(from: model.modificationDate)
                    } else {
                        model.size = fileAttributes[FileAttributeKey.size] as? Double ?? 0
                        var size = "\(Int(model.size))B"
                        if model.size > 1024 * 1024 {
                            size = "\(Int(model.size/1024/1024))MB"
                        } else if model.size > 1024 {
                            size = "\(Int(model.size/1024))KB"
                        }
                        mAttributedLabel.text = size + " | " + mDateFormatter.string(from: model.modificationDate)
                    }
                }
            }
        }
        mImageView.image = self._getImage(type: model.fileType)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    lazy var mImageView: UIImageView = {
        let tImageView = UIImageView()
        tImageView.translatesAutoresizingMaskIntoConstraints = false
        return tImageView
    }()

    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        tLabel.font = .systemFont(ofSize: 14)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x333333)
        return tLabel
    }()

    lazy var mAttributedLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        tLabel.font = .systemFont(ofSize: 12)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x999999)
        return tLabel
    }()
}

private extension DDFileTableViewCell {
    func _createUI() {
        self.contentView.addSubview(mImageView)
        mImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        mImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        mImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        mImageView.widthAnchor.constraint(equalTo: self.mImageView.heightAnchor).isActive = true
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.leftAnchor.constraint(equalTo: self.mImageView.rightAnchor, constant: 10).isActive = true
        mTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        mTitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true

        self.contentView.addSubview(mAttributedLabel)
        mAttributedLabel.leftAnchor.constraint(equalTo: self.mTitleLabel.leftAnchor).isActive = true
        mAttributedLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5).isActive = true
        mAttributedLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
    }
    
    func _getImage(type: DDFileType) -> UIImage? {
        switch type {
        case .unknown:
            return UIImageHDBoundle(named: "icon_file")
        case .folder:
            return UIImageHDBoundle(named: "icon_folder")
        case .image:
            return UIImageHDBoundle(named: "icon_image")
        case .video:
            return UIImageHDBoundle(named: "icon_video")
        case .audio:
            return UIImageHDBoundle(named: "icon_audio")
        case .web:
            return UIImageHDBoundle(named: "icon_web")
        case .application:
            return UIImageHDBoundle(named: "icon_app")
        case .zip:
            return UIImageHDBoundle(named: "icon_zip")
        case .log:
            return UIImageHDBoundle(named: "icon_log")
        case .excel:
            return UIImageHDBoundle(named: "icon_xls")
        case .word:
            return UIImageHDBoundle(named: "icon_word")
        case .ppt:
            return UIImageHDBoundle(named: "icon_ppt")
        case .pdf:
            return UIImageHDBoundle(named: "icon_pdf")
        case .system:
            return UIImageHDBoundle(named: "icon_system")
        case .txt:
            return UIImageHDBoundle(named: "icon_txt")
        case .db:
            return UIImageHDBoundle(named: "icon_db")
        }
    }
}
