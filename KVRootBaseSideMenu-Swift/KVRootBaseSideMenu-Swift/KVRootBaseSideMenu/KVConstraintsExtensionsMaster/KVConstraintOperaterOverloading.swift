//
//  KVConstraintOperaterOverloading.swift
//  https://github.com/keshavvishwkarma/KVConstraintExtensionsMaster.git
//
//  Distributed under the MIT License.
//
//  Created by Keshav on 7/28/16.
//  Copyright © 2016 Keshav. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//

import UIKit

//********* DEFINE NEW OPERATOR *********//
infix operator  <- { }; infix operator  +== { }; infix operator  +>= { }
infix operator +<= { }; infix operator +*== { }; infix operator <==> { }

//********* DEFINE NEW INTERFACE *********//

public protocol Addable:class {
    /// TO ADD SINGLE CONSTRAINT
    func +(lhs: Self, rhs: NSLayoutConstraint)  -> NSLayoutConstraint
}

public protocol Removable:class {
    /// TO REMOVE SINGLE CONSTRAINT
    func -(lhs: Self, rhs: NSLayoutConstraint)  -> NSLayoutConstraint
}

public protocol Accessable:class {
    /// TO ACCESS CONSTRAINT BASED ON LAYOUT ATTRIBUTE
    func <-(lhs: Self, rhs: NSLayoutAttribute) -> NSLayoutConstraint?
}

public protocol LayoutRelationable:class
{
    /// TO ADD SINGLE GREATER THAN OR EQUAL RELATION CONSTRAINT
    func +<=(lhs: Self, rhs: NSLayoutAttribute) -> NSLayoutConstraint
    
    /// TO ADD SINGLE EQUAL RELATION CONSTRAINT
    func +==(lhs: Self, rhs: NSLayoutAttribute) -> NSLayoutConstraint
    
    /// TO ADD SINGLE LESS THAN OR EQUAL RELATION CONSTRAINT
    func +>=(lhs: Self, rhs: NSLayoutAttribute) -> NSLayoutConstraint
    
    /// TO ADD MULTIPLE EQUAL RELATION CONSTRAINT
    func +==(lhs: Self, rhs: [NSLayoutAttribute])
    
    /// TO ADD SINGLE EQUAL RELATION CONSTRAINT WITH MULTIPLEIR
    func +*==(lhs: Self, rhs: (NSLayoutAttribute, CGFloat)) -> NSLayoutConstraint
    
    /// TO ADD SIBLING CONSTRAINT WITH EQUAL RELATION
    func <==>(lhs: View, rhs: (NSLayoutAttribute, NSLayoutAttribute, View, CGFloat))
}

extension View : Addable, Removable, Accessable, LayoutRelationable { }

// MARK: Addable

/// To add single constraint on the receiver view
public func +(lhs: View, rhs: NSLayoutConstraint) -> NSLayoutConstraint {
    return lhs.applyPreparedConstraintInView(constraint: rhs)
}

// MARK: Removable

/// To remove single constraint from the receiver view
public func -(lhs: View, rhs: NSLayoutConstraint) -> NSLayoutConstraint {
    lhs.removeConstraint(rhs); return rhs
}

// MARK: Accessable

public func <-(lhs: View, rhs: NSLayoutAttribute) -> NSLayoutConstraint?{
    return lhs.accessAppliedConstraintBy(attribute: rhs)
}

public func <-(lhs: View, rhs: (NSLayoutAttribute, NSLayoutRelation)) -> NSLayoutConstraint?{
    return lhs.accessAppliedConstraintBy(attribute: rhs.0, relation: rhs.1)
}

//MARK: LayoutRelationable

/// (leftContainerView +== .Top).constant = 0
public func +<=(lhs: View, rhs: NSLayoutAttribute) -> NSLayoutConstraint {
    return lhs.superview! + lhs.prepareConstraintToSuperview(attribute: rhs, attribute: rhs, relation: .LessThanOrEqual)
}

/// (leftContainerView +== .Top).constant = 0
public func +==(lhs: View, rhs: NSLayoutAttribute) -> NSLayoutConstraint {
    return lhs.superview! + lhs.prepareEqualRelationPinConstraintToSuperview(attribute: rhs, constant: defaultConstant)
}

/// (leftContainerView +== .Top).constant = 0
public func +>=(lhs: View, rhs: NSLayoutAttribute) -> NSLayoutConstraint {
    return lhs.superview! + lhs.prepareConstraintToSuperview(attribute: rhs, attribute: rhs, relation: .GreaterThanOrEqual)
}

// With defaultt constant value that is - 0 (Zero) on a specific attribute
public func +==(lhs: View, rhs: [NSLayoutAttribute]) {
    for attribute in rhs { lhs +== attribute }
}

/// (leftContainerView *== (.Top, multiplier) ).constant = 0
public func +*==(lhs: View, rhs: (NSLayoutAttribute, CGFloat)) -> NSLayoutConstraint {
    return lhs.superview! + lhs.prepareEqualRelationPinRatioConstraintToSuperview(attribute: rhs.0, multiplier: rhs.1)
}

public func <==>(lhs: View, rhs: (NSLayoutAttribute, NSLayoutAttribute, View, CGFloat)) {
    lhs.applyConstraintFromSiblingView(attribute: rhs.0, toAttribute: rhs.1, ofView: rhs.2, constant: rhs.3)
}
