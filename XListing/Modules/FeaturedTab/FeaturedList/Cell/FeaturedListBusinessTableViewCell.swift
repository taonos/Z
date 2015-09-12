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
import Cartography
import XAssets
import Dollar

    
    //Layout Ratios
private let avatarWidth = UIScreen.mainScreen().bounds.height * 0.048
private let avatarGap = avatarWidth * 0.25
private let avatarListToParentRatio = 0.764
private let businessImageContainerWidthToParentRatio = 0.584
private let businessImageContainerHeightToWidthRatio = 0.63
private let businessImageWidthToParentRatio = 0.9315
private let businessImageHeightToParentRatio = 0.89855
private let peopleWantogoLabelToParentRatio = 0.39
private let joinButtonWidthToParentRatio = 0.8
private let joinButtonHeightToWidthRatio = 0.43
private let etaLabelWidthToEtaIconRatio = 2.5
private let priceLabelToEtaLabelRatio = 0.5

    //Sizing and margins
private let avatarHeight = avatarWidth
    
public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    // MARK: - UI Controls - Business Section
    @IBOutlet private weak var businessImageContainer: UIView!
    @IBOutlet private weak var businessImage: UIImageView!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var infoViewSizingHelper: UIView!
    @IBOutlet private weak var pricePerPerson: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var ETA: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var etaLabel: UILabel!
    private lazy var infoViewContent: UIView = UINib(nibName: "infopanel", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first as! UIView
    
    // MARK: - UI Controls - Social Section
    @IBOutlet private weak var participationView: UIView!
    @IBOutlet private weak var WTGButtonView: UIView!
    @IBOutlet private weak var numberOfPeopleGoingView: UIView!
    @IBOutlet private weak var peopleWantogoLabel: UILabel!
    @IBOutlet private weak var avatarList: UIView!
    @IBOutlet private weak var joinButton: UIButton!
    private lazy var participationViewContent: UIView = UINib(nibName: "participationview", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first as! UIView
    private var avatarImageViews = [UIImageView]()

    // MARK: Properties
    private var viewmodel: FeaturedBusinessViewModel!
    
    /// whether this instance of cell has been reused
    private let isReusedCell = MutableProperty<Bool>(false)

    // MARK: Setups
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        infoView.addSubview(infoViewContent)
        participationView.addSubview(participationViewContent)
        
        //Set card's Background color
        businessImageContainer.backgroundColor = .x_FeaturedCardBG()
        infoView.backgroundColor = .x_FeaturedCardBG()
        infoViewSizingHelper.backgroundColor = .x_FeaturedCardBG()
        businessImage.backgroundColor = .x_FeaturedCardBG()
        numberOfPeopleGoingView.backgroundColor = .x_FeaturedCardBG()
        WTGButtonView.backgroundColor = .x_FeaturedCardBG()
        joinButton.backgroundColor = .x_FeaturedCardBG()
        infoViewContent.backgroundColor = .x_FeaturedCardBG()
        participationView.backgroundColor = .x_FeaturedCardBG()
        participationViewContent.backgroundColor = .x_FeaturedCardBG()
        cityLabel.backgroundColor = .x_FeaturedCardBG()
        etaLabel.backgroundColor = .x_FeaturedCardBG()
        nameLabel.backgroundColor = .x_FeaturedCardBG()
        peopleWantogoLabel.backgroundColor = .x_FeaturedCardBG()
        avatarList.backgroundColor = .x_FeaturedCardBG()
        
        //Setting auto-adjust font size
        etaLabel.adjustsFontSizeToFitWidth = true
        priceLabel.adjustsFontSizeToFitWidth = true
        peopleWantogoLabel.adjustsFontSizeToFitWidth = true
        joinButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // Adding price icon
        pricePerPerson.rac_image <~ AssetFactory.getImage(Asset.PriceIcon(size: CGSizeMake(pricePerPerson.frame.width, pricePerPerson.frame.height), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            |> map { Optional<UIImage>($0) }
            |> takeUntilPrepareForReuse(self)
        
        // Adding ETA icon
        ETA.rac_image <~ AssetFactory.getImage(Asset.CarIcon(size: CGSizeMake(ETA.frame.width, ETA.frame.height), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            |> map { Optional<UIImage>($0) }
            |> takeUntilPrepareForReuse(self)
        
        //Setup joinButton
        let join = Action<UIButton, Bool, NSError>{ button in
            return self.viewmodel.participate(ParticipationChoice.我想去)
        }
        
        joinButton.addTarget(join.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        joinButton.layer.cornerRadius = 5
        joinButton.layer.borderWidth = 1
        joinButton.layer.borderColor = UIColor.x_PrimaryColor().CGColor
        
        //When the cell is prepared for reuse, set the state.
        rac_prepareForReuseSignal.toSignalProducer()
            |> takeUntilPrepareForReuse(self)
            |> start(next: { [weak self] _ in
                self?.isReusedCell.put(true)
            })
        
        //Setup avatar image views.
        let count = Int(floor((avatarList.frame.width - avatarWidth) / (avatarWidth + avatarGap))) + 1
        var previousImageView: UIImageView? = nil
        for i in 1...count {
            
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: floor(avatarWidth), height: floor(avatarHeight)))
            // TODO: set the correct background color
            imageView.backgroundColor = .x_FeaturedCardBG()
            imageView.opaque = true
            imageView.contentMode = .Center
            imageView.clipsToBounds = true
            
            avatarList.addSubview(imageView)
            
            if i == 1 {
                constrain(imageView) { view in
                    view.leading == view.superview!.leading
                    view.centerY == view.superview!.centerY
                    view.width == avatarWidth
                    view.height == view.width
                }
            }
            
            if let previousImageView = previousImageView {
                constrain(previousImageView, imageView) { previous, current in
                    previous.trailing == current.leading - avatarGap
                    current.centerY == current.superview!.centerY
                    current.width == avatarWidth
                    current.height == current.width
                }
            }
            
            previousImageView = imageView
            
            avatarImageViews.append(imageView)
            
        }
    }
    
    
    public override func updateConstraints() {

        // only run the setup constraints the first time the cell is constructed for perfomance reason
        $.once({ [weak self] Void -> Void in
            if let this = self {
                //Set anchor size for all related views
                constrain(this.businessImageContainer) { businessImageContainer in
                    //sizes
                    businessImageContainer.width == businessImageContainer.superview!.width * businessImageContainerWidthToParentRatio
                    businessImageContainer.height == businessImageContainer.width * businessImageContainerHeightToWidthRatio
                }

                //Set business image size
                constrain(this.businessImage) {businessImage in
                    businessImage.width == businessImage.superview!.width * businessImageWidthToParentRatio
                    businessImage.height == businessImage.superview!.height * businessImageHeightToParentRatio
                    businessImage.center == businessImage.superview!.center
                }
                
                //Make subview same size as the parent view
                constrain(this.infoViewContent) { infoViewContent in
                    infoViewContent.width == infoViewContent.superview!.width
                    infoViewContent.height == infoViewContent.superview!.height
                    infoViewContent.center == infoViewContent.superview!.center
                }
                
                
                //Make subview same size as the parent view
                constrain(this.participationViewContent, this.businessImage) { participationViewContent, businessImage in
                    participationViewContent.width == participationViewContent.superview!.width * avatarListToParentRatio
                    participationViewContent.height == participationViewContent.superview!.height
                    participationViewContent.leading == businessImage.leading
                    participationViewContent.centerY == participationViewContent.superview!.centerY
                }
                
                //Set peopleWantogoLabel size
                constrain(this.peopleWantogoLabel) { peopleWantogoLabel in
                    peopleWantogoLabel.width == peopleWantogoLabel.superview!.width * peopleWantogoLabelToParentRatio
                }
                
                //Set WTG button size
                constrain(this.joinButton, this.etaLabel) { joinButton, etaLabel in
                    joinButton.width == joinButton.superview!.width * joinButtonWidthToParentRatio
                    joinButton.height == joinButton.width * joinButtonHeightToWidthRatio
                    joinButton.right == etaLabel.right
                }
                
                //Set eta and price labels
                constrain(this.ETA, this.etaLabel, this.priceLabel) {ETA, etaLabel, priceLabel in
                    etaLabel.width == ETA.width * etaLabelWidthToEtaIconRatio
                    priceLabel.width == etaLabel.width * priceLabelToEtaLabelRatio
                }
            }
        })()
        
        super.updateConstraints()
    }
        
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        $.each(avatarImageViews) { _, view in
            view.image = nil
        }
    }

    // MARK: Bindings
    public func bindViewModel(viewmodel: FeaturedBusinessViewModel) {
        self.viewmodel = viewmodel
        
//        joinButton.rac_enabled <~ viewmodel.buttonEnabled.producer
//            |> takeUntilPrepareForReuse(self)
  
        viewmodel.buttonEnabled.producer
            |> ignoreNil
            |> start(next: {[weak self] input in
                    self?.joinButton.enabled = input
                    self?.joinButton.hidden  = false
                })
        
        nameLabel.rac_text <~ viewmodel.businessName.producer
           |> takeUntilPrepareForReuse(self)
        
        cityLabel.rac_text <~ viewmodel.city.producer
            |> takeUntilPrepareForReuse(self)
        
        viewmodel.price.producer
            |> takeUntilPrepareForReuse(self)
            |> ignoreNil
            |> start(next: { [weak self] price in
//                self?.priceLabel.setPriceLabel(price)
//                self?.priceLabel.setNeedsDisplay()
            })
        
        etaLabel.rac_text <~ viewmodel.eta.producer
            |> takeUntilPrepareForReuse(self)
        
        peopleWantogoLabel.rac_text <~ viewmodel.participationString.producer
            |> takeUntilPrepareForReuse(self)
        
        self.viewmodel.coverImage.producer
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
        
        self.viewmodel.participantViewModelArr.producer
            |> takeUntilPrepareForReuse(self)
            |> start (next: { [weak self] participants in
                if let this = self {
                    
                    var filledAvatarImageViews = [UIImageView]()
                    // only add images to image views if the participants count is greater than 0
                    if participants.count > 0 {
                        // iterate through avatarImageViews - 1 (leaving space for etc icon)
                        for i in 0..<(this.avatarImageViews.count - 1) {
                            if i < participants.count {
                                let avatarView = this.avatarImageViews[i]
                                
                                
                                // place the image into image view
                                participants[i].avatar.producer
                                    |> takeUntilPrepareForReuse(this)
                                    |> ignoreNil
                                    |> map { $0.maskWithRoundedRect(avatarView.bounds.size, cornerRadius: avatarView.bounds.height, backgroundColor: .x_FeaturedCardBG()) }
                                    |> start(next: { image in
                                        avatarView.image = image
                                    })
                                
                                // unhide the image view
                                avatarView.hidden = false
                                
                                // add the image view to the list of already processed
                                filledAvatarImageViews.append(avatarView)
                            }
                        }
                        
                        let etcImageView = this.avatarImageViews[filledAvatarImageViews.count]
                        
                        // assign etc icon to image view
                        etcImageView.rac_image <~ AssetFactory.getImage(Asset.EtcIcon(size: CGSizeMake(round(avatarWidth * 0.6), round(avatarHeight * 0.2)), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
                            |> map { Optional<UIImage>($0) }
                            |> takeUntilPrepareForReuse(this)
                        
                        // unhide the image view
                        etcImageView.hidden = false

                        
                        // add the image view to the list of already processed
                        filledAvatarImageViews.append(etcImageView)
                    }
                    
                    for i in (filledAvatarImageViews.count)..<(this.avatarImageViews.count) {
                        this.avatarImageViews[i].hidden = true
                    }
                }
            })
    }
}
