//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-05.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class LogInViewModel : _BaseViewModel, ILogInViewModel, ViewModelInjectable {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var formStatus: Observable<FormStatus> {
        return form.status
    }
    var submissionEnabled: Observable<Bool> {
        return form.submissionEnabled
    }
    
    // MARK: - Properties
    private enum FieldName : String {
        case Username = "Username"
        case Password = "Password"
    }
    private let form: Form
    
    // MARK: - View Models
    private let usernameAndPasswordValidator: UsernameAndPasswordValidator
    
    // MARK: - Services
    private let meRepository: IMeRepository
    
    // MARK: - Initializers
    typealias Dependency = (router: IRouter, meRepository: IMeRepository)
    
    typealias Token = Void
    
    typealias Input = (username: ControlProperty<String>, password: ControlProperty<String>, submitTrigger: ControlEvent<Void>)
    
    init(dep: Dependency, token: Token, input: Input) {
        self.meRepository = dep.meRepository
        
        let upvm = UsernameAndPasswordValidator()
        usernameAndPasswordValidator = upvm
        
        
        
        let usernameField = FormFieldFactory(
            name: FieldName.Username,
            initialValue: nil,
            input: input.username.asObservable().map { Optional.Some($0) },
            validation: upvm.validateUsername
        )
        
        let passwordField = FormFieldFactory(
            name: FieldName.Password,
            initialValue: nil,
            input: input.password.asObservable().map { Optional.Some($0) },
            validation: upvm.validatePassword
        )
        
        form = Form(
            submitTrigger: input.submitTrigger.asObservable(),
            submitHandler: { fields -> Observable<FormStatus> in
                guard let
                    username = (fields[FieldName.Username.rawValue] as! FormField<String>).inputValue,
                    password = (fields[FieldName.Password.rawValue] as! FormField<String>).inputValue else {
                        return Observable.just(.Error)
                }
                
                return dep.meRepository.rx_logIn(username, password: password)
                    .debug()
                    .map { _ in .Submitted }
                    .catchErrorJustReturn(.Error)
            },
            formField: usernameField, passwordField
        )
        
        super.init(router: dep.router)
    }
    
    // MARK: - Setups
    
    // MARK: - Others
//    var logIn: SignalProducer<Bool, NetworkError> {
//        
//        return usernameAndPasswordViewModel.allInputsValid.producer
//            // only allow TRUE value
//            .filter { $0 }
//            // combine the username and password into one signal
//            .flatMap(.Concat) { _ in
//                zip(self.usernameAndPasswordViewModel.username.producer.ignoreNil(), self.usernameAndPasswordViewModel.password.producer.ignoreNil())
//            }
//            // promote to NSError
//            .promoteErrors(NetworkError)
//            // log in user
//            .flatMap(FlattenStrategy.Merge) { username, password in
//                return self.meRepository.logIn(username, password: password)
//            }
//            .map { _ in
//                return true
//            }
//    }
    
    func finishModule(callback: (CompletionHandler? -> ())? = nil) {
        router.finishModule { handler in
            callback?(handler)
        }
    }
}
