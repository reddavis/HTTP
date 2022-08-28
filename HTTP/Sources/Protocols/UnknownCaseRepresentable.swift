/// A protocol to give Enums the ability to have a fallback case if it cannot be decoded.
///
/// When an enum cannot be decoded it will default to the case
/// that is declared in `unknownCase`.
public protocol UnknownCaseRepresentable: RawRepresentable, CaseIterable where RawValue: Equatable {
    static var unknownCase: Self { get }
}

// MARK: Default implementations

extension UnknownCaseRepresentable {
    public init(rawValue: RawValue) {
        let value = Self.allCases.first { currentCase -> Bool in
            currentCase.rawValue == rawValue
        }

        self = value ?? Self.unknownCase
    }

    public init(rawValue: RawValue?) {
        guard let rawValue = rawValue else {
            self = Self.unknownCase
            return
        }

        let value = Self.allCases.first { $0.rawValue == rawValue }
        self = value ?? Self.unknownCase
    }
}
