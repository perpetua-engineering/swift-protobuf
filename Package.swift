// swift-tools-version:6.2

// Package.swift
//
// Copyright (c) 2014 - 2018 Apple Inc. and the project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information:
// https://github.com/apple/swift-protobuf/blob/main/LICENSE.txt
//
// NOTE: This is a minimal fork for runtime-only use (no protoc/conformance tests).
// The protoc target and build plugin have been removed to avoid requiring
// the large protobuf/abseil submodules (~2GB).

import PackageDescription

let package = Package(
    name: "SwiftProtobuf",
    products: [
        .executable(
            name: "protoc-gen-swift",
            targets: ["protoc-gen-swift"]
        ),
        .library(
            name: "SwiftProtobuf",
            targets: ["SwiftProtobuf"]
        ),
        .library(
            name: "SwiftProtobufPluginLibrary",
            targets: ["SwiftProtobufPluginLibrary"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftProtobuf",
            exclude: ["CMakeLists.txt"],
            resources: [.copy("PrivacyInfo.xcprivacy")],
            swiftSettings: .packageSettings
        ),
        .target(
            name: "SwiftProtobufPluginLibrary",
            dependencies: ["SwiftProtobuf"],
            exclude: ["CMakeLists.txt"],
            resources: [.copy("PrivacyInfo.xcprivacy")],
            swiftSettings: .packageSettings
        ),
        .target(
            name: "SwiftProtobufTestHelpers",
            dependencies: ["SwiftProtobuf"],
            swiftSettings: .packageSettings
        ),
        .executableTarget(
            name: "protoc-gen-swift",
            dependencies: ["SwiftProtobufPluginLibrary", "SwiftProtobuf"],
            exclude: ["CMakeLists.txt"],
            swiftSettings: .packageSettings
        ),
        .testTarget(
            name: "SwiftProtobufTests",
            dependencies: ["SwiftProtobuf"],
            swiftSettings: .packageSettings
        ),
        .testTarget(
            name: "SwiftProtobufPluginLibraryTests",
            dependencies: ["SwiftProtobufPluginLibrary", "SwiftProtobufTestHelpers"],
            swiftSettings: .packageSettings
        ),
        .testTarget(
            name: "protoc-gen-swiftTests",
            dependencies: ["protoc-gen-swift", "SwiftProtobufTestHelpers"],
            swiftSettings: .packageSettings
        ),
    ],
    swiftLanguageModes: [.v5],
    cxxLanguageStandard: .gnucxx17
)

// Settings for every Swift target in this package, like project-level settings
// in an Xcode project.
extension Array where Element == PackageDescription.SwiftSetting {
    static var packageSettings: Self {
        [
            .enableExperimentalFeature("StrictConcurrency=complete"),
            .enableUpcomingFeature("ExistentialAny"),
        ]
    }
}
