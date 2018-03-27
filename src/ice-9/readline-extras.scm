;;-*-scheme-*-
;;; readline-extras.scm
;;
;; Copyright (C) 2018 by Matthew Love
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; The program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with the program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;; Some extra readline stuff.
;;
;;; Code:

(define-module (ice-9 readline-extras)
  #:use-module (ice-9 readline)
  #:export (readline-config-set!))

(load-extension "libguile-readline-extras" "scm_init_readline_extras")

;; Set readline configurations as from a .inputrc file.
;;
;; `spec should be a list of readline configurations.
;; see https://tiswww.cwru.edu/php/chet/readline/readline.html#SEC9 for more information
;; on keybindings and setting variables, etc.
;; e.g. put the follwing in .guile
;;
;; (use-modules (ice-9 readline-extras))
;;
;; (define my-readline-rc
;;   '(("set editing-mode emacs")
;;     ("\\C-xc" "(system \"\")\\C-b\\C-b")
;;     ("\\C-xp" "()\\C-b")
;;     ("\\C-xm" "(use-modules ())\\C-b\\C-b")
;;     ("\\C-xd" "(strftime \\\"%c\\\" (localtime (current-time)))\\r")))
;;
;; (readline-config-set! my-readline-rc)
;;
;; with the cursor between the quotes and C-cp will insert parens and set the cursor between them,
;; C-cm will insert (use-modules ()) with the cursor between the parens and C-xd will insert a 
;; date function and run it, displaying the current-time.
(define (readline-config-set! spec)
  "- Scheme Procedure: readline-config-set! config-spec
    `config-spec should be a list of configuration specifications
    as in a dot inputrc file as specified by readline.
    For keybindings the format is: '((\"\\C-xp\" \"text-to-insert\"))"
  (define (rl-set-string cell)
    (car cell))
  (define (rl-kbd-string cell)
    (string-append "\"" (car cell) "\""))
  (define (rl-kbd-init-string cell)
    (string-append (rl-kbd-string cell) ": "))
  (define (parse-spec-cell cell str)
    (if (or (null? cell)
	    (not (string? (car cell)))) str
	    (let ((astr (if (= (string-length str) 0)
			    (if (not (null? (cdr cell))) 
				(rl-kbd-init-string cell) 
				(rl-set-string cell))
			    (rl-kbd-string cell))))
	      (parse-spec-cell (cdr cell) (string-append str astr)))))
  (for-each
   (lambda (this-cell)
     (let ((this-line (parse-spec-cell this-cell "")))
       (if (> (string-length this-line) 0)
	   (%rl-parse-and-bind this-line))))
   spec))

;;; End
