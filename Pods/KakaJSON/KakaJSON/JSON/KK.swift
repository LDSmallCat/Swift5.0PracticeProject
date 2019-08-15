//
//  KK.swift
//  KakaJSON
//
//  Created by MJ Lee on 2019/7/30.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

public struct KK<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

// MARK: - protocol for normal types
public protocol KKCompatible {}
public extension KKCompatible {
    static var kk: KK<Self>.Type {
        get { return KK<Self>.self }
        set {}
    }
    var kk: KK<Self> {
        get { return KK(self) }
        set {}
    }
}

// MARK: - protocol for types with a generic parameter
public struct KKGeneric<Base, T> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
public protocol KKGenericCompatible {
    associatedtype T
}
public extension KKGenericCompatible {
    static var kk: KKGeneric<Self, T>.Type {
        get { return KKGeneric<Self, T>.self }
        set {}
    }
    var kk: KKGeneric<Self, T> {
        get { return KKGeneric(self) }
        set {}
    }
}

// MARK: - protocol for types with two generic parameter2
public struct KKGeneric2<Base, T1, T2> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
public protocol KKGenericCompatible2 {
    associatedtype T1
    associatedtype T2
}
public extension KKGenericCompatible2 {
    static var kk: KKGeneric2<Self, T1, T2>.Type {
        get { return KKGeneric2<Self, T1, T2>.self }
        set {}
    }
    var kk: KKGeneric2<Self, T1, T2> {
        get { return KKGeneric2(self) }
        set {}
    }
}
