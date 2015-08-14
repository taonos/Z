//
//  FeaturedListBusinessTableViewCell.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-20.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    //MARK: constants
    private let avatarWidth = CGFloat(40)
    private let avatarHeight = CGFloat(40)
    private let avatarGap = CGFloat(10)
    
    
    // MARK: - UI Controls
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var participationView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    @IBOutlet weak var peopleWantogoLabel: UILabel!
    @IBOutlet weak var avatarList: UIView!
    @IBOutlet weak var joinButton: UIButton!
    
    // MARK: Properties

    private var viewmodel: FeaturedBusinessViewModel!
    private let compositeDisposable = CompositeDisposable()
    /// whether this instance of cell has been reused
    private let isReusedCell = MutableProperty<Bool>(false)
    private var users: [User] = [User]()
    
    // MARK: Setups
    
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        var infoViewContent = NSBundle.mainBundle().loadNibNamed("infopanel", owner: self, options: nil)[0] as! UIView
        infoViewContent.frame = CGRectMake(0, 0, infoView.frame.width, infoView.frame.height)
        infoView.addSubview(infoViewContent)
        var participationViewContent = NSBundle.mainBundle().loadNibNamed("participationview", owner: self, options: nil)[0] as! UIView
        participationViewContent.frame = CGRectMake(0, 0, participationView.frame.width, participationView.frame.height)
        participationView.addSubview(participationViewContent)
        
        
        /**
        *  When the cell is prepared for reuse, set the state.
        *
        */
        compositeDisposable += rac_prepareForReuseSignal.toSignalProducer()
            |> start(next: { [weak self] _ in
                self?.isReusedCell.put(true)
            })
    }
    
    deinit {
        compositeDisposable.dispose()
    }
    
    // MARK: Bindings
    
    public func bindViewModel(viewmodel: FeaturedBusinessViewModel) {
        self.viewmodel = viewmodel
        
        self.nameLabel.rac_text <~ viewmodel.businessName.producer
           |> takeUntilPrepareForReuse(self)
        self.cityLabel.rac_text <~ viewmodel.city.producer
            |> takeUntilPrepareForReuse(self)
        self.priceLabel.rac_text <~ viewmodel.price.producer
            |> takeUntilPrepareForReuse(self)
        self.etaLabel.rac_text <~ viewmodel.eta.producer
            |> takeUntilPrepareForReuse(self)
        self.peopleWantogoLabel.rac_text <~ viewmodel.participation.producer
            |> takeUntilPrepareForReuse(self)
        compositeDisposable += self.viewmodel.coverImage.producer
            |> takeUntilPrepareForReuse(self)
            |> ignoreNil
            |> start (next: { [weak self] image in
                if let viewmodel = self?.viewmodel, isReusedCell = self?.isReusedCell where viewmodel.isCoverImageConsumed.value || isReusedCell.value {
                    self?.businessImage.rac_image.put(image)
                }
                else {
                    self?.businessImage.setImageWithAnimation(image)
                    viewmodel.isCoverImageConsumed.put(true)
                }
            })
        
        compositeDisposable += self.viewmodel.userArr.producer
            |> start (next: { [weak self] users in
                self?.users = users
                BOLogDebug("count of returned users \(users.count)")
                self?.setupParticipationView()
            })
    }
    private func setupParticipationView(){
        BOLogDebug("setupcalled")
        for user in self.users{
            if user.profileImg != nil{
                BOLogDebug("setupimage")
                let frame = CGRectMake(0, 0, self.avatarWidth, self.avatarHeight)
                let imageView = UIImageView(frame: frame)
                let data = user.profileImg!.getData()
                let image = UIImage(data: data)
                imageView.setImageWithAnimation(image!)
                self.avatarList.addSubview(imageView)
            }
        }
    }
}