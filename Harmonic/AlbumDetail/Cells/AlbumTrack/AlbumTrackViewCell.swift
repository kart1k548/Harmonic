import UIKit

class AlbumTrackViewCell: UITableViewCell {
    static let identifier = "AlbumTrackViewCell"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            trackNumberLabel,
            labelStackView
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 8)
        
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let topSpacer = UIView()
        topSpacer.makeSpacerView(height: 4)
        let bottomSpacer = UIView()
        bottomSpacer.makeSpacerView(height: 4)
        let stackView = UIStackView(arrangedSubviews: [
            topSpacer,
            nameLabel,
            artistsLabel,
            bottomSpacer
        ])
        stackView.makeStackView(axis: .vertical, spacing: 2, distribution: .equalSpacing)
        
        return stackView
    }()
    
    private lazy var trackNumberLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(alignment: .center)
        label.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .getCustomSizedFont(fontWeight: .semibold, size: 16))
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var artistsLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .getCustomSizedFont(fontWeight: .regular, size: 14))
        label.numberOfLines = 2
        
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .bgColor
        addToContentView(view: stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(viewModel: AlbumTrackCellViewModel) {
        nameLabel.text = viewModel.name
        trackNumberLabel.text = viewModel.currentRow
        artistsLabel.text = viewModel.artists.joined(separator: " & ") + " \u{2022} \(viewModel.duration)"
    }
}
