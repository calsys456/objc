;;;; P1: The Objective-C to Lisp Bridge with Transparent Layer
;;; Copyright (C) 2025-2026 The Calendrical System
;;; SPDX-License-Identifier: 0BSD

;;; Test of cl-objc

(defpackage objc-test
  (:use :cl :parachute))
(in-package :objc-test)

;;; Test for P2

(define-test test-translate-name-from-foreign
  (let ((sym (cffi:translate-name-from-foreign "stringWithUTF8String:" (find-package "OBJC-METHOD"))))
    (is eq (find-package "OBJC-METHOD") (symbol-package sym))
    (is string= "STRING-WITH-UTF8-STRING." (symbol-name sym))))

(define-test test-translate-name-to-foreign
  (is string= "stringWithUTF8String:"
      (cffi:translate-name-to-foreign 'objc-method:string-with-utf8-string. (find-package "OBJC-METHOD"))))

(define-test test-parse-selector-name-to-arglist
  (let ((lst (objc::parse-selector-name-to-arglist "initWithContentRect:styleMask:backing:defer:")))
    (true (every (lambda (sym) (eq (symbol-package sym) (find-package "OBJC-METHOD"))) lst))
    (is = 4 (length lst))))

;;; [TODO] Test for P3

;;; Test for P4

(define-test test-translate-selector-from-foreign
  (let ((sel (cffi:foreign-funcall "sel_registerName"
                                   :string "initWithContentRect:styleMask:backing:defer:"
                                   objc:selector)))
    (is cffi:pointer-eq (objc-raw::sel-register-name "initWithContentRect:styleMask:backing:defer:")
        (objc:objc-obj sel))))

;;; [TODO] Test for P5

;;; [TODO] Test for P6

;;; Test for P7

(define-test test-ns-object-property
  (is string= "NSObject"
      (slot-value (objc-method:alloc (objc:cls ns-object))
                  'objc-prop:class-name)))

;;; Test for P8 & P9

;; ensure-objc-class

(define-test test-ensure-objc-class-pointer
  (let ((cls (objc:ensure-objc-class (objc-raw::objc-lookup-class "NSObject"))))
    (is cffi:pointer-eq (objc-raw::objc-lookup-class "NSObject") (objc:objc-obj cls))
    (true (typep cls 'objc:objc-class))
    (is eq 'objc-class:ns-object (class-name cls))))

(define-test test-ensure-objc-class-string
  (let ((cls (objc:ensure-objc-class "NSObject")))
    (is cffi:pointer-eq (objc-raw::objc-lookup-class "NSObject") (objc:objc-obj cls))
    (true (typep cls 'objc:objc-class))
    (is eq 'objc-class:ns-object (class-name cls))))

(define-test test-ensure-objc-class-object
  (let ((cls (objc:ensure-objc-class (objc:ensure-objc-class "NSObject"))))
    (is cffi:pointer-eq (objc-raw::objc-lookup-class "NSObject") (objc:objc-obj cls))
    (true (typep cls 'objc:objc-class))
    (is eq 'objc-class:ns-object (class-name cls))))

(define-test test-ensure-objc-class-symbol
  (let ((cls (objc:ensure-objc-class :ns-object)))
    (is cffi:pointer-eq (objc-raw::objc-lookup-class "NSObject") (objc:objc-obj cls))
    (true (typep cls 'objc:objc-class))
    (is eq 'objc-class:ns-object (class-name cls))))

;; ensure-objc-meta-class

(define-test test-ensure-objc-meta-class-pointer
  (let ((cls (objc:ensure-objc-meta-class (objc-raw::objc-get-meta-class "NSObject"))))
    (is cffi:pointer-eq (objc-raw::objc-get-meta-class "NSObject") (objc:objc-obj cls))
    (true (typep cls 'objc:objc-class))
    (is eq 'objc-meta:ns-object (class-name cls))))

(define-test test-ensure-objc-meta-class-string
  (let ((cls (objc:ensure-objc-meta-class "NSObject")))
    (is cffi:pointer-eq (objc-raw::objc-get-meta-class "NSObject") (objc:objc-obj cls))
    (true (typep cls 'objc:objc-class))
    (is eq 'objc-meta:ns-object (class-name cls))))

(define-test test-ensure-objc-meta-class-object
  (let ((cls (objc:ensure-objc-meta-class (objc:ensure-objc-class "NSObject"))))
    (is cffi:pointer-eq (objc-raw::objc-get-meta-class "NSObject") (objc:objc-obj cls))
    (true (typep cls 'objc:objc-class))
    (is eq 'objc-meta:ns-object (class-name cls))))

(define-test test-ensure-objc-meta-class-symbol
  (let ((cls (objc:ensure-objc-meta-class :ns-object)))
    (is cffi:pointer-eq (objc-raw::objc-get-meta-class "NSObject") (objc:objc-obj cls))
    (true (typep cls 'objc:objc-class))
    (is eq 'objc-meta:ns-object (class-name cls))))

;; subclassing - basic

(define-test test-subclassing-basic
  (eval-when (:compile-toplevel :load-toplevel :execute)
    (defclass test-subclass (objc-class:ns-object)
      ()
      (:metaclass objc:objc-class)))
  (let ((cls (find-class 'test-subclass)))
    (true (typep cls 'objc:objc-class))
    (true (objc-raw::class-is-meta-class (objc-raw::object-get-class (objc:objc-obj cls))))
    (is eq 'test-subclass (class-name cls))))

(define-test test-subclassing-redefine
  (eval-when (:compile-toplevel :load-toplevel :execute)
    (defclass test-subclass (objc-class:ns-object)
      ()
      (:metaclass objc:objc-class)))
  (let ((cls (find-class 'test-subclass)))
    (true (typep cls 'objc:objc-class))
    (true (objc-raw::class-is-meta-class (objc-raw::object-get-class (objc:objc-obj cls))))
    (is eq 'test-subclass (class-name cls)))
  (eval-when (:compile-toplevel :load-toplevel :execute)
    (defclass test-subclass (objc-class:ns-object)
      ()
      (:metaclass objc:objc-class)))
  (let ((cls (find-class 'test-subclass)))
    (true (typep cls 'objc:objc-class))
    (true (objc-raw::class-is-meta-class (objc-raw::object-get-class (objc:objc-obj cls))))
    (is eq 'test-subclass (class-name cls))))
