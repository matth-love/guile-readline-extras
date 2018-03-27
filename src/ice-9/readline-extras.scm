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
;; (use-modules (ice-9 readline)
;;              (ice-9 readline-extras))
;; (readline-activate)
;;
;; (define my-readline-rc
;;   '(("set editing-mode emacs")
;;     ("\\C-xc" ",sh ")
;;     ("\\C-xm" "(use-modules ())\\C-b\\C-b")
;;     ("\\C-xp" "()\\C-b")))
;;
;; (readline-config-set! my-readline-rc)
;;
;; and the next time you start guile the keybinding C-xc will insert ,sh into the line
;; and C-cp will insert parens and move the cursor between them.
;;
;; Also, if you wanted to bind \C-xd to a print and run a date function, using:
;; "(strftime \"%c\" (localtime (current-time)))\\r" doesn't work.
;; "(strftime \\\"%c\\\" (localtime (current-time)))\\r" does work.
;; Also, you could define it before-hand to, say, 'date, and use "(date)\\r" instead...
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
