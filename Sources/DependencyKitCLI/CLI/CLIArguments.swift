import ArgumentParser
import Foundation

struct CLIArguments {
    struct DependencyKit: ParsableArguments {

        @Option(name: [.customShort("r"), .long], help: "Path to project [R]oot")
        var rootPath: String

        @Option(name: [.customShort("c"), .long], help: "Path to [C]onfig file")
        var configPath: String

        @Flag(name: [.customShort("d"), .long], help: "Enable [D]ebug info")
        var debugInfo: Bool = false

    }
}
