import Foundation

struct CodegenConstants {
	static var codegenDirectory = "__generated__"
	static var codegenFile = "Generated.swift"
	static var swiftFileExtension = "swift"
    static var implicitGeneratedProtocolPrefix = "GENERATED_IMPLICIT_"
    static var indent = String(repeating: " ", count: 4)
}

struct FrameworkConstants {
    static var importString = "DependencyKit"
    static var requirementsProtocolString = "Requirements"
    static var nilRequirementsProtocolString = "NilRequirements"
    static var resourceClassString = "Resource"
    static var resourceProtocolIdentifier = "ResourceType"
    static var nilResourceClassString = "NilResource"
    static var genericI = "I"
}
