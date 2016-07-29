//
//  KVConstraintOperaterOverloading.swift
//  KVRootBaseSideMenu-Swift
//
//  Created by Keshav on 7/30/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

import KVConstraintExtensionsMaster

public typealias View = UIView

//********* DEFINE NEW OPERATOR *********//
infix operator <<- { }; infix operator +==  { }; infix operator +>=  { }
infix operator +<= { }; infix operator +*== { }; infix operator <==> { }

//********* DEFINE NEW INTERFACE *********//

public protocol Addable:class {
    /// TO ADD SINGLE CONSTRAINTS
    func +(lhs: Self, rhs: NSLayoutConstraint)  -> NSLayoutConstraint
    
    /// TO ADD MULTIPLE CONSTRAINTS
    func +(lhs: Self, rhs: [NSLayoutConstraint])-> [NSLayoutConstraint]
}

public protocol Removable:class {
    /// TO REMOVE SINGLE CONSTRAINTS
    func -(lhs: Self, rhs: NSLayoutConstraint)  -> NSLayoutConstraint
    
    /// TO REMOVE MULTIPLE CONSTRAINTS
    func -(lhs: Self, rhs: [NSLayoutConstraint])-> [NSLayoutConstraint]
}

public protocol LayoutRelationable:class {
    /// TO ADD SINGLE EQUAL RELATION CONSTRAINT
    func +==(lhs: Self, rhs: NSLayoutAttribute) -> NSLayoutConstraint
    
    /// TO ADD MULTIPLE EQUAL RELATION CONSTRAINT
    func +==(lhs: Self, rhs: [NSLayoutAttribute])
    
    /// TO ADD SINGLE EQUAL RELATION CONSTRAINT WITH MULTIPLEIR
    func +*==(lhs: Self, rhs: (NSLayoutAttribute, CGFloat)) -> NSLayoutConstraint
    
    /// TO ADD SIBLING CONSTRAINT WITH EQUAL RELATION
    func <==>(lhs: View, rhs: (NSLayoutAttribute, NSLayoutAttribute, View, CGFloat))
    
    /// TO ACCESS CONSTRAINT BASED ON LAYOUT ATTRIBUTE
    func <<-(lhs: Self, rhs: NSLayoutAttribute) -> NSLayoutConstraint?
}

extension View : Addable, Removable, LayoutRelationable { }

//MARK: LayoutRelationable

public func <<-(lhs: View, rhs: NSLayoutAttribute) -> NSLayoutConstraint?{
    return lhs.accessAppliedConstraintByAttribute(rhs)
}

/// (leftContainerView *== (.Top, multiplier) ).constant = 0
public func +*==(lhs: View, rhs: (NSLayoutAttribute, CGFloat)) -> NSLayoutConstraint {
    assert(lhs.superview != nil, "You should have addSubView on any other its called's Superview \(lhs)");
    return lhs.superview! + lhs.prepareEqualRelationPinRatioConstraintToSuperview(rhs.0, multiplier: rhs.1)
}

/// (leftContainerView +== .Top).constant = 0
public func +==(lhs: View, rhs: NSLayoutAttribute) -> NSLayoutConstraint {
    assert(lhs.superview != nil, "You should have addSubView on any other its called's Superview \(lhs)");
    return lhs.superview! + lhs.prepareEqualRelationPinConstraintToSuperview(rhs, constant: defualtConstant)
}

// With defualt constant value that is - 0 (Zero) on a specific attribute
public func +==(lhs: View, rhs: [NSLayoutAttribute]) {
    for attribute in rhs { lhs +== attribute }
}

public func <==>(lhs: View, rhs: (NSLayoutAttribute, NSLayoutAttribute, View, CGFloat)) {
    assert(!rhs.3.isInfinite, "Constant must not be INFINITY.")
    assert(!rhs.3.isNaN, "Constant must not be NaN.")
    lhs.applyConstraintFromSiblingViewAttribute(rhs.0, toAttribute: rhs.1, ofView: rhs.2, spacing: rhs.3)
}

// MARK: Addable

/// to add single constraint on the receiver view
public func +(lhs: View, rhs: NSLayoutConstraint) -> NSLayoutConstraint {
    lhs.applyPreparedConastrainInView(rhs); return rhs
}

/// to add multiple constraints on the receiver view
public func +(lhs: View, rhs: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
    for constraint in rhs { lhs + constraint }; return rhs
}

// MARK: Removable

/// to remove single constraint from the receiver view
public func -(lhs: View, rhs: NSLayoutConstraint) -> NSLayoutConstraint {
    lhs.removeConstraint(rhs); return rhs
}

/// to remove multiple constraints from the receiver view
public func -(lhs: View, rhs: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
    lhs.removeConstraints(rhs); return rhs
}
