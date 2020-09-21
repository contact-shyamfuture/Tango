//
//  CartListCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 14/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol UserCartProtocol {
    func userAddToCart(cell : CartListCell)
    func userAddToCartPlus(cell : CartListCell)
    func userAddToCartMinus(cell : CartListCell)
}

class CartListCell: UITableViewCell {
    
    @IBOutlet weak var cartPlusBtnOulet: UIButton!
    @IBOutlet weak var cartMinusBtnOutlet: UIButton!
    @IBOutlet weak var addBntOutlet: UIButton!
    @IBOutlet weak var cartPlusMinusView: UIStackView!
    @IBOutlet weak var cartAddView: RoundUIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCartCount: UILabel!
    
    @IBOutlet weak var imgItemView: UIImageView!
    @IBOutlet weak var lblItemMenu: UILabel!
    var delegate : UserCartProtocol?
    static let identifier = "CartListCell"
    static func nib() -> UINib{
        return UINib(nibName: "CartListCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addBntAction(_ sender: Any) {
        delegate?.userAddToCart(cell: self)
    }
    
    @IBAction func cartMinusBtnAction(_ sender: Any) {
        delegate?.userAddToCartMinus(cell: self)
    }
    
    @IBAction func btnCartPlusAction(_ sender: Any) {
        delegate?.userAddToCartPlus(cell: self)
    }
    
    func intializecelletails(cellDic : CategoriesProducts , cartDetails : ProfiledetailsModel){
        lblItemMenu.text = cellDic.name
        if cellDic.categoriesProductsImages != nil && cellDic.categoriesProductsImages!.count > 0 {
            imgItemView.sd_setImage(with: URL(string: cellDic.categoriesProductsImages![0].url ?? ""))
        }
        lblPrice.text = "\(cellDic.pricesprice!)"
        cartAddView.isHidden = false
        if let cartList = cartDetails.userCart {
            for obj in cartList {
                if cellDic.id == obj.product_id {
                    cartAddView.isHidden = true
                    lblCartCount.text = "\(obj.quantity ?? 0)"
                    break
                }
            }
        }
    }
    
    func initializecellDetails(cellDic : ProfileCartModel){
        
        lblItemMenu.text = cellDic.CartProduct!.name
        if cellDic.CartProduct!.categoriesProductsImages != nil && cellDic.CartProduct!.categoriesProductsImages!.count > 0 {
            imgItemView.sd_setImage(with: URL(string: cellDic.CartProduct!.categoriesProductsImages![0].url!))
        }
        
        lblPrice.text = "\(cellDic.CartProduct!.cartItemPrice!.price! * cellDic.quantity!)"
       // cartAddView.isHidden = false
        cartAddView.isHidden = true
        lblCartCount.text = "\(cellDic.quantity ?? 0)"
    }
}
