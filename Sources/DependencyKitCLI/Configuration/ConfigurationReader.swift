import ArgumentParser
import Foundation
import Yams

class ConfigurationReader {

    private let rootURL: URL
    private let configURL: URL
    private let displayDebugInfo: Bool
    private let decoder = YAMLDecoder()
    
    init(rootURL: URL, configURL: URL, displayDebugInfo: Bool) {
        self.rootURL = rootURL
        self.configURL = configURL
        self.displayDebugInfo = displayDebugInfo
    }
    
    func getParsingConfiguration() -> CodeParsingConfiguration {
        guard let data = try? Data(contentsOf: configURL)
        else { fatalError("Could not open YAML file at: \(configURL)") }
        guard let config = try? decoder.decode(ConfigurationFile.self, from: data)
        else { fatalError("Could not decode YAML config from file data from: \(configURL)") }
        return CodeParsingConfiguration(displayDebugInfo: displayDebugInfo,
                                        modules: config.modules.map { parsingConfiguration(module: $0) })
    }

    private func parsingConfiguration(module: ModuleConfigurationFileInformation) -> ModuleCodeParsingConfiguration {
        let modulePath = rootURL.appendingPathComponent(module.path)
        let codegenFile = rootURL
            .appendingPathComponent(module.path)
            .appendingPathComponent(module.codegenDirectory ?? CodegenConstants.codegenDirectory)
            .appendingPathComponent(module.codegenFile ?? CodegenConstants.codegenFile)
        let excludedFiles = Set(
            [codegenFile] +
            (module.excludedFiles ?? [String]()).map{ modulePath.appendingPathComponent($0)}
        )
        let files = FileSystem.find(modulePath)
            .filter { $0.pathExtension == CodegenConstants.swiftFileExtension }
            .reduce([URL]()) { (acc, curr) in
                [curr].filter{ !excludedFiles.contains($0) } + acc
            }
        assert(files.count == Set(files).count)
        return ModuleCodeParsingConfiguration(name: module.name,
                                              files: files,
                                              excludedFiles: Array(excludedFiles),
                                              codegenFile: codegenFile)
    }
    
}
