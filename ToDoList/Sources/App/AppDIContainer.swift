//
//  AppCoodinator.swift
//  ToDoList
//
//  Created by Данил Албутов on 19.02.2026.
//

import Swinject

final class AppDIContainer {
    static let shared = AppDIContainer()
    private let container = Container()
    
    private init() {}
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType, name: nil)
    }
    
    func resolve<Service, Arg1>(
        _ serviceType: Service.Type,
        argument: Arg1
    ) -> Service? {
        return container.resolve(serviceType, name: nil, argument: argument)
    }
    
    func resolve<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        arguments: Arg1,
        _ secondArgument: Arg2
    ) -> Service? {
        return container.resolve(serviceType, name: nil, arguments: arguments, secondArgument)
    }
    
    func registerAssembly() {
        let assemblies: [Assembly] = [
            HomeAssembly(),
            DetailsAssembly()
        ]                
        assemblies.forEach { $0.assemble(container: container) }
    }
    
    
}
