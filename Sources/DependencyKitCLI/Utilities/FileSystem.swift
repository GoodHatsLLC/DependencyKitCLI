import Foundation

class FileSystem {
    static func find(_ url: URL) -> [URL]{
        FileManager.default
            .enumerator(at: url,
                        includingPropertiesForKeys: [.isRegularFileKey],
                        options: [.skipsHiddenFiles, .skipsPackageDescendants]
            )?
            .compactMap { $0 as? URL }
            .filter { (try? $0.resourceValues(forKeys:[.isRegularFileKey]).isRegularFile) ?? false }
            ?? []
    }

    static func writeFile(to url: URL, contents: String) {
        if !FileManager.default.fileExists(atPath: url.absoluteString) {
            do {
                try FileManager.default
                    .createDirectory(atPath: url.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                preconditionFailure("could not get or create file at: \(url)")
            }
        }
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            preconditionFailure("could not write to file at: \(url)")
        }
    }
}

typealias FS = FileSystem
