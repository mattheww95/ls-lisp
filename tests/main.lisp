(defpackage ls-lisp/tests/main
  (:use :cl
        :ls-lisp
        :rove))
(in-package :ls-lisp/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :ls-lisp)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
