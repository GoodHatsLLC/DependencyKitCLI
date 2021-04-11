import Foundation

struct ModuleDeclarations {
    let parsingConfig: ModuleCodeParsingConfiguration
    let name: String
    let imports: Set<ModuleImportStatement>
    let requirements: Set<Requirements>
    let resources: Set<Resource>
}

struct ModuleImportStatement: Hashable, CustomStringConvertible {
	let identifier: String
    
    var description: String { identifier }
}

struct FieldDefinition: Hashable, CustomStringConvertible {
	let identifier: String
	let type: String
	let access: String?
    let optional: Bool
    
    var description: String { "\(access ?? "") var \(identifier): \(type)\(optional ? "?" : "")" }
}

struct Requirements: Hashable, CustomStringConvertible {
    let access: String?
    let identifier: String
	let implicitGeneratedProtocol: String?
    let fields: [FieldDefinition]

    private func accessDescription() -> String {
        access.map { $0 + " " } ?? ""
    }

    private func fieldDescriptions() -> [String] {
        fields.map(\.description)
    }

    var description: String {
        return
            accessDescription() +
            "protocol \(identifier): Requirements\(implicitGeneratedProtocol.map {",\n#     \($0) "} ?? " " )" +
            "{\n" +
            "\(fieldDescriptions().reduce (""){ $0 + "#      \($1)\n"})" +
            "#   }"
    }
}

struct FieldImplementation: Hashable, CustomStringConvertible {
    let identifier: String
    let type: String
    let access: String?
    
    var description: String { "\(access ?? "") var \(identifier): \(type) \\ TODO: show impl" }
}

struct Resource: Hashable, CustomStringConvertible {
	let access: String?
    let identifier: String
	let genericIdentifier: String
	let conformanceIdentifiers: [String]
    let fields: [FieldImplementation]
    
    private func accessDescription() -> String {
        access.map { $0 + " " } ?? ""
    }

    private func declarationDescription() -> String {
        "class \(identifier)<I: \(genericIdentifier)>: Resource<I>"
    }
    
    var description: String {
        return
            accessDescription() +
            declarationDescription() +
            "\(conformanceIdentifiers.reduce("") { $0 + ",\n#     " + $1 })" +
            "\(fields.reduce("") { $0 + "\n#       " + $1.description })" +
            " {" +
            "\n#       // TODO: indicate implementation" +
            "\n#   }"
    }
}

extension ModuleDeclarations: CustomStringConvertible {
    var description: String {
        let module = "# module: " + name + " #"
        let moduleLine = module + "\n"
        let hashLine = String(repeating: "#", count: module.count) + "\n"
        let dashLine = "#" + String(repeating: "-", count: module.count) + "\n"
        let importsBlock = imports.reduce("") { $0 + "# - " + String(describing: $1) + "\n" }
        let requirementsBlock = requirements.reduce("") { $0 + "# - " + String(describing: $1) + "\n" }
        let resourcesBlock = resources.reduce("") { $0 + "# - " + String(describing: $1) + "\n" }
        return hashLine
            + moduleLine
            + hashLine
            + "# imports: \n"
            + importsBlock
            + dashLine
            + "# requirements: \n"
            + requirementsBlock
            + dashLine
            + "# resources: \n"
            + resourcesBlock
            + dashLine
    }
}

