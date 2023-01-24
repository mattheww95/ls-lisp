(defsystem "ls-lisp"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "ls-lisp/tests"))))

(defsystem "ls-lisp/tests"
  :author ""
  :license ""
  :depends-on ("ls-lisp"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for ls-lisp"
  :perform (test-op (op c) (symbol-call :rove :run c)))
