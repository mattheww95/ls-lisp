(ql:quickload :osicat)
(ql:quickload :unix-opts)
(defpackage ls-lisp
  (:use :cl))
(in-package :ls-lisp)

;; mimic the ls behaviour in lisp

;;; TODO Need to add wild card, and symbol support
;;; TODO support symlinks
;;; TODO add ansi control schemes to colourize outputs

(defun combine-directories (fp)
  "Gather and list all files and directories"
  (let ((path fp))
    (cons path (append (uiop:directory-files path) (uiop:subdirectories path)))))


(defun normalize-directory-name (dir)
   "append a path delimiter to the end fo a directory if there is not one"
  (if (and (> (length dir) 1) (char-equal (char dir (- (length dir) 1)) (uiop:directory-separator-for-host)))
      dir
      (if (char-equal (char dir (- (length dir) 1)) (uiop:directory-separator-for-host))
          dir
          (concatenate `string dir (format nil "~a" (uiop:directory-separator-for-host))))))


(defun list-directories (path)
  "Return a list off all files and directories"
  (let* ((fp (normalize-directory-name path))
         (fpt (uiop:native-namestring fp)))
    (if (or (uiop:directory-exists-p fpt) (uiop:file-exists-p fpt))
        (combine-directories fpt)
        `())))


(print (uiop:subdirectories (uiop:native-namestring "~")))
(print (list-directories "~"))
(print (list-directories "/"))
(print (list-directories "~/"))
(print (list-directories "/home/"))
(print (list-directories "/home"))


(defun access-octal-to-text (number)
  "convert the ocat numer to the directory access text"
  (cond ((eql #\0 number) "---")
        ((eql #\1 number) "--x")
        ((eql #\2 number) "-w-")
        ((eql #\3 number) "-wx")
        ((eql #\4 number) "r--")
        ((eql #\5 number) "r-x")
        ((eql #\6 number) "rw-")
        ((eql #\7 number) "rwx")
        (t "?")))

(defun base8 (n)
  "Convert decimal number to a reversed octal list"
  (cdddr (coerce (format nil "~8R" n) `list)))



(defun get-file-dir-info (file-name)
  "Get informatoin about each file and print it out"
  ;;; ls output permisions, number of hard links file owner file group, file size, made time, name
  (let ((stat (osicat-posix:stat file-name)))
    (format T "~& ~{~a~} ~a ~a ~a ~a ~a ~a"
            (mapcar #'access-octal-to-text (base8 (osicat-posix:stat-mode stat)))
            (osicat-posix:stat-nlink stat)
            (osicat-posix:stat-uid stat)
            (osicat-posix:stat-gid stat)
            (osicat-posix:stat-ctime stat)
            (osicat-posix:stat-size stat)
            file-name)))

(defun print-dir-info (fp)
  "Print all of the info for a supplied directory"
  (handler-case (mapcar #'get-file-dir-info (list-directories fp))
    (osicat-posix:enoent ()
      `())))

(print-dir-info "~/")
(print-dir-info "~")
(print-dir-info #P"/home/")

(opts:define-opts
  (:name :help
   :description "list files and directories"
   :short #\h
   :long "help"))
