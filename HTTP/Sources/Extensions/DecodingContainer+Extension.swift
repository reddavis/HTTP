import Foundation

extension KeyedDecodingContainer {
    /// Decodes a value of the inferred type for the given key.
    /// - Parameter key: The key that the decoded value is associated with.
    /// - Throws:
    ///     - Error on decoding.
    /// - Returns: The decoded value.
    public func decode<T: Decodable>(_ key: KeyedDecodingContainer<K>.Key) throws -> T {
        try self.decode(T.self, forKey: key)
    }

    /// Decodes a value of the inferred type for the given key, if present.
    /// - Parameter key: The key that the decoded value is associated with.
    /// - Throws:
    ///     - Error on decoding.
    /// - Returns: The decoded value.
    public func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer<K>.Key) throws -> T? {
        try self.decodeIfPresent(T.self, forKey: key)
    }
}

// MARK: SingleValueDecodingContainer

extension SingleValueDecodingContainer {
    /// Decodes a single value of the inferred type.
    /// - Throws:
    ///     - Error on decoding.
    /// - Returns: The decoded value.
    public func decode<T: Decodable>() throws -> T {
        try self.decode(T.self)
    }
}
