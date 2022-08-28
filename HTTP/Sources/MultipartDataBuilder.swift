import Foundation
import CoreServices
import UniformTypeIdentifiers

public final class MultipartDataBuilder {
    public var headers: [String: String] {
        ["Content-Type": "multipart/form-data; charset=utf-8; boundary=\(self.boundary)"]
    }

    // Private
    private let boundary = UUID().uuidString
    private let parts: [Part]

    // MARK: Initialization

    public init(parts: Part...) {
        self.parts = parts
    }

    // MARK: Body Data

    public func data() -> Data {
        var bodyData = Data()

        for part in parts {
            switch part {
            case let .data(key, data): ()
                bodyData.append(self.boundaryPrefix)
                bodyData.append(self.contentDisposition(name: key, data: data))
                bodyData.append("\r\n")

                let contentType = self.contentType(for: data)
                bodyData.append(contentType)
                bodyData.append("\r\n\r\n")
                bodyData.append(data)
                bodyData.append("\r\n")
            case let .value(key, value):
                bodyData.append(self.boundaryPrefix)
                bodyData.append(self.contentDisposition(name: key, data: nil))
                bodyData.append("\r\n\r\n")
                bodyData.append(value)
                bodyData.append("\r\n")
            }
        }

        bodyData.append(self.boundarySuffix)

        return bodyData
    }

    // MARK: Boundary

    private var boundaryPrefix: String {
        "--\(self.boundary)\r\n"
    }

    private var boundarySuffix: String {
        "--\(self.boundary)--\r\n"
    }

    private func contentDisposition(name: String, data: Data?) -> String {
        var contentDisposition = "Content-Disposition: form-data; name=\"\(name)\""

        if let unwrappedFileExtension = data?.fileExtension {
            contentDisposition += "; filename=\"\(UUID().uuidString).\(unwrappedFileExtension)\""
        }

        return contentDisposition
    }

    private func contentType(for part: Data) -> String {
        "Content-Type: \(part.mimeType)"
    }
}

// MARK: Part

extension MultipartDataBuilder {
    public enum Part {
        case value(String, String)
        case data(String, Data)
    }
}

// MARK: Data extension

extension Data {
    fileprivate mutating func append(_ string: String) {
        guard let stringData = string.data(using: .utf8) else { return }
        self.append(stringData)
    }

    // MARK: MIME types

    fileprivate static let mimeTypeSignatures: [UInt8: String] = [
        0xFF: "image/jpeg",
        0x89: "image/png",
        0x47: "image/gif",
        0x49: "image/tiff",
        0x4D: "image/tiff",
        0x25: "application/pdf",
        0xD0: "application/vnd",
        0x46: "text/plain"
    ]

    fileprivate var mimeType: String {
        let defaultMimeType = "application/octet-stream"
        guard count > 0 else { return defaultMimeType }

        var c: UInt8 = 0
        self.copyBytes(to: &c, count: 1)

        return Data.mimeTypeSignatures[c] ?? defaultMimeType
    }

    fileprivate var fileExtension: String? {
        UTType(mimeType: self.mimeType)?.preferredFilenameExtension
    }
}
