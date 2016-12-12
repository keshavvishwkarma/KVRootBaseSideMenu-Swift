//
//  KVConstraintsExtensionsMaster.swift
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

public typealias View = UIView

extension View {
    
    /// This method is used to create new instance of ui elements for autolayout.
    final class func prepareNewViewForAutoLayout() -> View! {
        let preparedView = View()
        preparedView.translatesAutoresizingMaskIntoConstraints = false
        return preparedView
    }
    
    /// This method is used to prepare already created instance of ui elements for autolayout.
    final func prepareViewForAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

private extension View
{
    class final func prepareConstraint(firstView: View!, attribute attr1: NSLayoutAttribute, secondView: View?=nil, attribute attr2: NSLayoutAttribute = .NotAnAttribute, relation: NSLayoutRelation = .Equal, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint!
    {
        assert(!multiplier.isInfinite, "Multiplier/Ratio of view must not be INFINITY.")
        assert(!multiplier.isNaN, "Multiplier/Ratio of view must not be NaN.")
        
        assert(!constant.isInfinite, "constant of view must not be INFINITY.")
        assert(!constant.isNaN, "constant of view must not be NaN.")
        
        return KVConstraintsExtensionsMaster.prepareConstraint(firstView, attribute: attr1, relation: relation, toItem: secondView, attribute: attr2, multiplier: multiplier, constant: constant)
    }
}

//MARK: TO PREPARE CONSTRAINTS

extension View {
    
    /// Generalized public constraint methods for views
    // For operator +<=,  +==,  +>=, +*==, +*>= , +*<=
    final func prepareConstraintToSuperview(attribute attr1: NSLayoutAttribute,  relation: NSLayoutRelation = .Equal, multiplier:CGFloat = 1.0) -> NSLayoutConstraint! {
        assert(superview != nil, "You should have addSubView on any other its called's Superview \(self)");
        return View.prepareConstraint(self, attribute: attr1, secondView: superview, attribute:attr1, relation: relation, multiplier:multiplier)
    }
    
    /// Prepare constraint of one sibling view to other sibling view and add it into its superview view.
    // For operator <+<=>,  <+==>, <+>=>, <+*<=>, <+*==>, <+*>=>
    final func prepareConstraintFromSiblingView(attribute attr1: NSLayoutAttribute, toAttribute attr2:NSLayoutAttribute, ofView otherSiblingView: View, relation:NSLayoutRelation = .Equal, multiplier:CGFloat = 1.0) -> NSLayoutConstraint! {
        assert(((NSSet(array: [superview!,otherSiblingView.superview!])).count == 1), "All the sibling views must belong to same superview")
        
        return View.prepareConstraint(self, attribute: attr1, secondView:otherSiblingView, attribute:attr2, relation:relation,  multiplier: multiplier)
    }
    
}

//MARK: TO ADD CONSTRAINT AND ACCESS APPLIED/ADDED CONSTRAINTS
extension View
{
    // MARK: - Add constraints in the non cumulative
    
    /// This is the common methods to add the constraint in the receiver only once. If constraint already exists then it will only update that constraint and return that constraint.
    public final func applyPreparedConstraintInView(constraint c: NSLayoutConstraint) -> NSLayoutConstraint
    {
        // If this constraint is already added then it update the constraint values else added new constraint.
        
        let appliedConstraint = self.constraints.containsApplied(constraint: c)
        
        if (appliedConstraint != nil) {
            appliedConstraint!.constant = c.constant
            return appliedConstraint!
        }
        
        addConstraint(c)
        return c
        
    }
    
    public final func applyConstraintFromSiblingView(attribute attr1: NSLayoutAttribute, toAttribute attr2:NSLayoutAttribute, ofView otherSiblingView: View) -> NSLayoutConstraint {
        let c = self.prepareConstraintFromSiblingView(attribute: attr1, toAttribute: attr2, ofView: otherSiblingView)
        return self.superview! + c
    }
    
    /// MARK: - Access Applied Constraint By Attributes From a specific View
    public final func accessAppliedConstraintBy(attribute attr: NSLayoutAttribute,  relation: NSLayoutRelation = .Equal)->NSLayoutConstraint? {
        let c = self.prepareConstraintToSuperview(attribute: attr, relation: relation)
        let appliedConstraint = self.superview?.constraints.containsApplied(constraint: c)
        return appliedConstraint
    }
    
    public final func accessAppliedConstraintBy(attribute attr: NSLayoutAttribute, relation: NSLayoutRelation = .Equal, completionHandler: ((NSLayoutConstraint?) -> Void)){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            completionHandler(self.accessAppliedConstraintBy(attribute: attr, relation: relation))
        }
    }
    
}

public struct KVConstraintsExtensionsMaster {
    /// :name:	prepareConstraint
    public static func prepareConstraint(item: AnyObject, attribute attr1: NSLayoutAttribute, relation: NSLayoutRelation = .Equal, toItem: AnyObject?=nil, attribute attr2: NSLayoutAttribute = .NotAnAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint! {
        return NSLayoutConstraint(item: item, attribute: attr1, relatedBy: relation, toItem: toItem, attribute: attr2, multiplier: multiplier, constant: constant)
    }
    
}

private extension NSLayoutConstraint {
    final func isEqualTo(constraint c:NSLayoutConstraint)-> Bool {
        return firstItem === c.firstItem && firstAttribute == c.firstAttribute && relation == c.relation && secondItem === c.secondItem && secondAttribute == c.secondAttribute && multiplier == c.multiplier
    }
    
}

private extension Array where Element: NSLayoutConstraint {
    func containsApplied(constraint c: Element) -> Element? {
        return reverse().filter { $0.isEqualTo(constraint: c)}.first
    }
}
