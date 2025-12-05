//
//  TopImageAndBottomTextButton.swift
//  PintarDom
//
//  Created by 一刻 on 2025/12/4.
//

import UIKit
import SnapKit

class TopImageAndBottomTextButton: UIControl {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    private var widthConstraint: Constraint?
    private var iconWidthConstraint: Constraint?
    private var iconHeightConstraint: Constraint?
    private var titleTopConstraint: Constraint?
    
    private let baseWidth: CGFloat = 60
    
    // MARK: - 可配置属性
    
    /// 图片大小（默认 40x40）
    var imageSize: CGSize = CGSize(width: 40, height: 40) {
        didSet {
            updateImageSize()
        }
    }
    
    /// 图片与文字之间的距离
    var imageTitleSpacing: CGFloat = 6 {
        didSet {
            titleTopConstraint?.update(offset: imageTitleSpacing)
            layoutIfNeeded()
        }
    }

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)

        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0        // ★ 多行支持
        titleLabel.lineBreakMode = .byWordWrapping
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        // 图标约束
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            iconWidthConstraint = make.width.equalTo(imageSize.width).constraint
            iconHeightConstraint = make.height.equalTo(imageSize.height).constraint
        }
        
        // 文字约束
        titleLabel.snp.makeConstraints { make in
            titleTopConstraint = make.top.equalTo(iconImageView.snp.bottom).offset(imageTitleSpacing).constraint
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()  // ★ 多行自动撑开高度
        }
        
        // 控件的宽度约束（可动态更新）
        self.snp.makeConstraints { make in
            widthConstraint = make.width.equalTo(baseWidth).constraint
        }
    }

    // MARK: - Public API
    
    func set(image: UIImage?, title: String, titleFont: UIFont? = .systemFont(ofSize: 14), textColor: UIColor = UIColor.black) {
        iconImageView.image = image
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = textColor
        updateSizeForMultiLineText()
    }
    
    // 更新图片大小
    private func updateImageSize() {
        iconWidthConstraint?.update(offset: imageSize.width)
        iconHeightConstraint?.update(offset: imageSize.height)
        layoutIfNeeded()
    }
    
    // MARK: - 自适应宽度（多行版本）
    
    private func updateSizeForMultiLineText() {
        guard let text = titleLabel.text, !text.isEmpty else {
            widthConstraint?.update(offset: baseWidth)
            return
        }
        
        // 根据字体计算一行的文字宽度（决定控件宽度）
        let maxWidth = UIScreen.main.bounds.width   // 临时最大宽度
        let bounding = (text as NSString).boundingRect(
            with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: titleLabel.font!],
            context: nil
        )
        
        let textWidth = ceil(bounding.width)
        let finalWidth = max(baseWidth, textWidth)
        
        widthConstraint?.update(offset: finalWidth)
        layoutIfNeeded()
    }
}
