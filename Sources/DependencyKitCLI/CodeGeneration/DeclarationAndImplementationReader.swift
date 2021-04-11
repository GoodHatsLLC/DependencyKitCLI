import Foundation
import SwiftSyntax

class DeclarationAndImplementationReader {
    
    let moduleParsingConfig: ModuleCodeParsingConfiguration
    private let declarationVisitor: DeclarationSyntaxVisitor
    
    init(config: ModuleCodeParsingConfiguration, displayDebugInfo: Bool) {
        self.moduleParsingConfig = config
        self.declarationVisitor = DeclarationSyntaxVisitor(config: config, displayDebugInfo: displayDebugInfo)
        if displayDebugInfo {
            let header = "# Module: \(moduleParsingConfig.name)"
            let separator = String(repeating: "#", count: header.count) + ""
            print(separator)
            print(header)
            print(separator)
            print("# Files: \(moduleParsingConfig.files.reduce("") { $0 + "\n#   - \($1)"})")
            print("# Excluded files: \(moduleParsingConfig.excludedFiles.reduce("") {  $0 + "\n#   - \($1)"})")
            print("# Codegen file: \n#    - \(moduleParsingConfig.codegenFile)")
            print(String(repeating: "#", count: header.count) + "\n")
            print("")
        }
    }
 
    private func parseSources() -> [SourceFileSyntax] {
        moduleParsingConfig.files.map {
            guard let source = try? SyntaxParser.parse($0)
            else { fatalError("Source couldn't be parsed: \($0)")}
            return source
        }
    }
    
    func parseModules() -> ModuleDeclarations {
        parseSources().forEach { declarationVisitor.walk($0) }
        return ModuleDeclarations(parsingConfig: moduleParsingConfig,
                                  name: moduleParsingConfig.name,
                                  imports: declarationVisitor.imports,
                                  requirements: declarationVisitor.requirements,
                                  resources: declarationVisitor.resources)
    }

}
