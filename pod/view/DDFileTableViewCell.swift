//
//  DDFileTableViewCell.swift
//  DDFileBrowserDemo
//
//  Created by Damon on 2021/5/12.
//

import UIKit
import DDUtils
import SnapKit

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
        return tImageView
    }()

    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.font = .systemFont(ofSize: 14)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x333333)
        return tLabel
    }()

    lazy var mAttributedLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.font = .systemFont(ofSize: 12)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x999999)
        return tLabel
    }()
}

private extension DDFileTableViewCell {
    func _createUI() {
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.width.equalTo(mImageView.snp.height)
        }

        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints {
            $0.left.equalTo(mImageView.snp.right).offset(10)
            $0.top.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-20)
        }

        self.contentView.addSubview(mAttributedLabel)
        mAttributedLabel.snp.makeConstraints {
            $0.left.equalTo(self.mTitleLabel)
            $0.bottom.equalToSuperview().offset(-5)
            $0.right.equalToSuperview().offset(-20)
        }
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
