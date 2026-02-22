(asdf:defsystem cl-objc
  :author "The Calendrical System"
  :license "0BSD"
  :depends-on (:alexandria :anaphora :cffi :cffi-libffi :closer-mop :float-features :log4cl :split-sequence :trivial-main-thread)
  :components ((:file "objc-raw")
               (:file "objc"))
  :in-order-to ((asdf:test-op (asdf:test-op :cl-objc-test))))

(asdf:defsystem cl-objc-test
  :author "The Calendrical System"
  :license "0BSD"
  :depends-on (:cl-objc :parachute)
  :components ((:file "objc-test"))
  :perform (asdf:test-op (op c) (uiop:symbol-call :parachute :test :objc-test)))
