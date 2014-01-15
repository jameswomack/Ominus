//
//  NGKit.m
//  Ominus
//
//  Created by James Womack on 3/24/13.
//  Copyright (c) 2013 Noble Gesture. All rights reserved.
//

#import "NGKit.h"


#pragma mark —
#pragma mark Noble Gesture style guide


//  3 line breaks between sections in an implementation file
//  2 line breaks between methods in an implementation file && sections in a header file
//  1 line break between declarations of and operations on different variables in an ...
    //...  implementation file and between pragma-sub-sections of a header file
//  0 line breaks between declaration of and operations on the same variable and ...
    //...  within pragma-sub-sections of a header file


//  Comment in the header next to a dynamic property declaration &&/|| ...
    //... place a pragma couplet before a list of dynamic property declarations

//  Place the opening if/function/do brace on the second line by itself
//  Place the opening block brace on the same line as the parameter it is being passed through

// Use camelCase for inline variable and property names
// Use PascalCase for class, function, type names
// Namespace all classes, categories, protocols and public constants
// Use method names that clearly state exactly what the methods does
// Consider alternate namespaced getters/setters on "Vendor" (incl. Apple) category ...
   //... properties to prevent clashes.

// Provide comments when an ideal solution was not possible due to unchangeable ...
   //... conditions. See NSNotification(NGNimbleCenterAdditions)::hashObject.

// Prefer dot dyntax for accessing values on instance and class objects
// Insist on bracket syntax for verb methods, i.e. methods focused on side effects

// Create class/instance initializer couplets
/* Instance initialization template:
     if ((self = super.init))
     {
         self.foo = foo;
     }
     return self;
    */
