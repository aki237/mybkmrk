;;; mybkmrk.el --- Project Bookmark manager for emacs

;; Copyright (C) 2016 Akilan Elango

;; Author: Akilan Elango <akilan1997 [at] gmail.com>
;; Keywords: convenience, emulations
;; X-URL: https://github.com/aki237/mybkmrk
;; URL: https://github.com/aki237/mybkmrk
;; Package-Requires: ((cl-lib "0.3"))
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; A simple Project bookmark management for emacs
;;
;;; Installation:
;;
;;   (require 'mybkmrk)
;;
;;; Use:
;; This is used bookmark projects and navigate easily and fastly to them.
;;
;;; Code:

;; require
(require 'ido)
(require 'ido-better-flex)

;; variables

(defvar mybkmrk/current-project default-directory
  "Current project directory. This is used for fuzzy-file-finder.")

(defvar mybkmrks '()
  "A global variable consisting of all the bookmarks")

;; functions
(defun mybkmrk/init()
  (load-file "~/.emacs.d/.mybkmrks")
  )

(defun mybkmrk/add-new-project()
  "mybkmrk/add-new-project : this fuction is used to add a new project to the bookmarks."
  (interactive)
  (add-to-list 'mybkmrks default-directory)
  (write-region (mybkmrk/get-lisp-save-string) nil "~/.emacs.d/.mybkmrks")
  )

(defun mybkmrk/split-and-get-dir-name(dir)
  "mybkmrk/split-and-get-dir-name : This function is used to get the basename of a directory from the Absolute path"
  (car (mybkmrk/get-clean-string-split-array (split-string dir "/")))
  )

(defun mybkmrk/goto-project (mybkmark/project)
  (interactive
   (list
    (ido-completing-read "sGoto Project: "
			 (progn
			   (mapcar 'mybkmrk/split-and-get-dir-name mybkmrks)
			   ))))
  (find-file (mybkmrk/find-in-list mybkmark/project))
  (setq mybkmrk/current-project (mybkmrk/find-in-list mybkmark/project))
  )

(defun mybkmrk/find-in-list (basename)
  "mybkmrk/find-in-list : find which directory matches the basename passed"
  (setq returnDir "")
  (loop for i in mybkmrks do
	(if (string= basename (mybkmrk/split-and-get-dir-name i))
	    (setq returnDir i))
	)
  returnDir)

(defun mybkmrk/replace-string (str what with howmany)
  "mybkmrk/replace-string : This function is used to replace a string with another string fo `howmany` occurances"
  (setq splitted (split-string str what))
  (setq index 0)
  (setq returnstr "")
  (if (> 0 howmany)
      (setq howmany ( + (length splitted) 1 ))
      )
  (loop for i in splitted do
	(if (< index (- (length splitted) 1))
	    (if (< index howmany)
		(setq returnstr (concat returnstr (concat i with)))
	      (setq returnstr (concat returnstr (concat i what))))
	  (setq returnstr (concat returnstr (concat i "")))
	  )
	(setq index (+ index 1))
	)
  returnstr
  )

(defun mybkmrk/get-clean-string-split-array(array)
  "Internal function"
  (setq returnlist '())
  (loop for i in array do
	(if (not (string= i ""))
	    (add-to-list 'returnlist i)
	  ))
  returnlist
  )

(defun mybkmrk/get-lisp-save-string ()
  (setq returnstr "(setq mybkmrks (list \n")
  (loop for i in mybkmrks do
	(setq returnstr (concat returnstr "\"" i "\"\n")))
  (concat returnstr "))"))

(defun mybkmrk/get-where-to-fuzzy ()
  "mybkmrk/get-where-to-fuzzy : This function is to check where to run the fuzzy file finder"
  (if (mybkmrk/is-in-project)
      mybkmrk/current-project
    default-directory))

(defun mybkmrk/get-abs-path (dir)
  "mybkmrk/get-abs-path : Used to get the absolute path of a given path"
  (string-trim (shell-command-to-string (concat "stat -c '%n' " dir))))

(defun mybkmrk/is-in-project ()
  "mybkmrk/is-in-project : This file is used to get whether the file opened is in current project"
  (interactive)
  (setq returnIsOrNo nil)
  (loop for i in mybkmrks do
	(if (not returnIsOrNo)
	    (if (numberp (string-match
			  (concat "^"
				  (mybkmrk/replace-string i "~" (mybkmrk/get-abs-path "~") 1) ".*")
			  (mybkmrk/replace-string default-directory "~" (mybkmrk/get-abs-path "~") 1)))
		(progn
		  (setq mybkmrk/current-project i)
		  (setq returnIsOrNo t))
	      nil)))
  returnIsOrNo
  )

(provide 'mybkmrk)
;; Local Variables:
;; coding: utf-8
;; End:
;;; mybkmrk.el ends here
