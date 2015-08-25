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

private let avatarHeight = UIScreen.mainScreen().bounds.height * 0.07
private let avatarWidth = UIScreen.mainScreen().bounds.height * 0.07
private let avatarGap = UIScreen.mainScreen().bounds.width * 0.015
private let WTGButtonScale = CGFloat(0.5)
private let avatarLeadingMargin = CGFloat(5)
private let avatarTailingMargin = CGFloat(5)
private let businessImageWidthToParentRatio = 0.57
private let businessImageHeightToWidthRatio = 0.68
private let avatarListWidthtoParentRatio = 1.0
private let avatarListHeightToParentRatio = 1.0
private let BackgroundColor = UIColor(hex: "EEEEEE")

public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    // MARK: - UI Controls
    @IBOutlet private weak var businessImage: UIImageView!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var participationView: UIView!
    @IBOutlet private weak var ETAIcon: UIView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var priceLabel: UIView!
    @IBOutlet private weak var etaLabel: UILabel!
    
    @IBOutlet private weak var peopleWantogoLabel: UILabel!
    @IBOutlet private weak var avatarList: UIView!
    @IBOutlet private weak var joinButton: UIButton!
    private lazy var infoViewContent: UIView = UINib(nibName: "infopanel", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first as! UIView
    private lazy var participationViewContent: UIView = UINib(nibName: "participationview", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first as! UIView
    private var avatarImageViews = [UIImageView]()
    
    // MARK: Properties
    private var viewmodel: FeaturedBusinessViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    /// whether this instance of cell has been reused
    private let isReusedCell = MutableProperty<Bool>(false)

    // MARK: Setups
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        infoView.addSubview(infoViewContent)
        participationView.addSubview(participationViewContent)
        
        /**
        *   Setup joinButton
        */
        let join = Action<UIButton, Bool, NSError>{ button in
            return self.viewmodel.participate(ParticipationChoice.我想去)
        }
        
        joinButton.addTarget(join.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        compositeDisposable += AssetFactory.getImage(Asset.WTGButtonTapped(scale: WTGButtonScale))
            |> start(next: { [weak self] image in
                self?.joinButton.setBackgroundImage(image, forState: .Disabled)
                })
        compositeDisposable += AssetFactory.getImage(Asset.WTGButtonUntapped(scale: WTGButtonScale))
            |> start(next: { [weak self] image in
                self?.joinButton.setBackgroundImage(image, forState: .Normal)
                })
        
        /**
        *  When the cell is prepared for reuse, set the state.
        *
        */
        compositeDisposable += rac_prepareForReuseSignal.toSignalProducer()
            |> start(next: { [weak self] _ in
                self?.isReusedCell.put(true)
            })
        
        /**
        *   Setup avatar image views.
        */

        let count = Int(floor((avatarList.frame.width - avatarLeadingMargin - avatarTailingMargin - avatarWidth) / (avatarWidth + avatarGap))) + 1
        var previousImageView: UIImageView? = nil
        for i in 1...count {
            
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: avatarWidth, height: avatarHeight))
            imageView.backgroundColor = BackgroundColor
            imageView.opaque = true
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            
            avatarList.addSubview(imageView)
            
            if i == 1 {
                constrain(imageView) { view in
                    view.leading == view.superview!.leading + avatarLeadingMargin
                    view.centerY == view.superview!.centerY
                    view.width == avatarWidth
                    view.height == avatarHeight
                }
            }
            if let previousImageView = previousImageView {
                constrain(previousImageView, imageView) { previous, current in
                    previous.trailing == current.leading - avatarGap
                    current.centerY == current.superview!.centerY
                    current.width == avatarWidth
                    current.height == avatarHeight
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
                constrain(this.businessImage) { businessImage in
                    //sizes
                    businessImage.width == businessImage.superview!.width * businessImageWidthToParentRatio
                    businessImage.height == businessImage.width * businessImageHeightToWidthRatio
                }
                
                //Make subview same size as the parent view
                constrain(this.infoViewContent) { infoViewContent in
                    infoViewContent.left == infoViewContent.superview!.left
                    infoViewContent.top == infoViewContent.superview!.top
                    infoViewContent.width == infoViewContent.superview!.width
                    infoViewContent.height == infoViewContent.superview!.height
                }
                
                //Make subview same size as the parent view
                constrain(this.participationViewContent) { participationViewContent in
                    participationViewContent.left == participationViewContent.superview!.left
                    participationViewContent.top == participationViewContent.superview!.top
                    participationViewContent.width == participationViewContent.superview!.width
                    participationViewContent.height == participationViewContent.superview!.height
                }
                
                //Set avatar list size
                constrain(this.avatarList) { avatarList in
                    avatarList.width == avatarList.superview!.width * avatarListWidthtoParentRatio
                    avatarList.height == avatarList.superview!.height * avatarListHeightToParentRatio
                }
                
                //Set WTG button size
                constrain(this.joinButton, this.avatarList) { joinButton, avatarList in
                    joinButton.height == avatarList.height * 1.618
                    joinButton.width == joinButton.height * 0.935
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
    
    deinit {
        compositeDisposable.dispose()
    }

    
    // MARK: Bindings
    public func bindViewModel(viewmodel: FeaturedBusinessViewModel) {
        self.viewmodel = viewmodel
        
        joinButton.rac_enabled <~ viewmodel.buttonEnabled.producer
            |> takeUntilPrepareForReuse(self)
        
        nameLabel.rac_text <~ viewmodel.businessName.producer
           |> takeUntilPrepareForReuse(self)
        
        cityLabel.rac_text <~ viewmodel.city.producer
            |> takeUntilPrepareForReuse(self)
        
        compositeDisposable += viewmodel.price.producer
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
        
        compositeDisposable += self.viewmodel.coverImage.producer
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
        
        compositeDisposable += self.viewmodel.participantViewModelArr.producer
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
                                this.compositeDisposable += avatarView.rac_image <~ participants[i].avatar
                                
                                // unhide the image view
                                avatarView.hidden = false
                                
                                // add the image view to the list of already processed
                                filledAvatarImageViews.append(avatarView)
                            }
                        }
                        
                        let etcImageView = this.avatarImageViews[filledAvatarImageViews.count]
                        // assign etc icon to image view
                        this.compositeDisposable += etcImageView.rac_image <~ AssetFactory.getImage(Asset.EtcIcon(scale: 1.0))
                            |> map { Optional<UIImage>($0) }
                        
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
