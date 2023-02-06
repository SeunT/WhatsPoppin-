//
//  FormTableViewCell.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/23/23.
//

import UIKit
protocol FormTableViewCellDelegate: AnyObject{
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel)
}

class FormTableViewCell: UITableViewCell, UITextFieldDelegate{

    static let identifier = "FormTableViewCell"
    
    private var model: EditProfileFormModel?
    
    public weak var delegate: FormTableViewCellDelegate?
    
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
        
    }()

    private let field: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(with model: EditProfileFormModel)
    {
        self.model = model
        formLabel.text = model.label
        field.placeholder = model.placeholder
        field.text = model.value
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let model = model else {
            return true
        }
        
        if model.label == "name" {
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return prospectiveText.count <= 12
        }
        return true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        formLabel.frame = CGRect(x: 5, y: 0, width: contentView.frame.width/3, height: contentView.frame.height)
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.leadingAnchor.constraint(equalTo: formLabel.trailingAnchor, constant: 5).isActive = true
        field.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        field.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        field.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        

    }
    func saveButtonTapped(){
            model?.value = field.text
            guard let model = model else {
               return
            }
            delegate?.formTableViewCell(self, didUpdateField: model)
        }
}
