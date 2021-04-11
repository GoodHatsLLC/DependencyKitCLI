import Foundation

let args = CLIArguments.DependencyKit.parseOrExit()
let projectRoot = args.rootPath
let yamlConfigPath = args.configPath
let rootURL = URL(fileURLWithPath: projectRoot)
let configURL = URL(fileURLWithPath: yamlConfigPath)
let configReader = ConfigurationReader(rootURL: rootURL, configURL: configURL, displayDebugInfo: args.debugInfo)
let callConfiguration = configReader.getParsingConfiguration()
let readers = callConfiguration.modules.map {
    ModuleReader(config: $0, displayDebugInfo: callConfiguration.displayDebugInfo)
}
let moduleDeclarations = readers.map { $0.parseModules() }
if args.debugInfo {
    moduleDeclarations.forEach {
        print(String(describing: $0))
    }
}
moduleDeclarations.forEach {
    let writer = ModuleWriter(moduleDeclarations: $0)
    FS.writeFile(to: $0.parsingConfig.codegenFile, contents: writer.moduleCodegenFileContents())
}
