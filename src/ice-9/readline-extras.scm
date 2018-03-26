;;-*-scheme-*-
;;; readline-extras.scm
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
  #:use-module (ice-9 format)
  #:export (readline-config-set!))

(load-extension "libguile-readline-extras" "scm_init_readline_extras")

;; `spec should be a list of readline configurations.
;; see https://tiswww.cwru.edu/php/chet/readline/readline.html#SEC9 for more information
;; on keybindings and setting variables, etc.
;; e.g. put the follwing in .guile
;;
;; (use-modules (ice-9 readline-extras))
;;
;; (define my-readline-rc
;;   '(("set editing-mode emacs")
;;     ("\\C-xc" ",sh ")
;;     ("\\C-xp" "()\\C-b")))
;;
;; (readline-config-set! my-readline-rc)
;;
;; and the next time you start guile the keybinding C-xc will insert ,sh into the line
;; and C-cp will insert parens and move the cursor between them.
(define (readline-config-set! spec)
  "- Scheme Procedure: readline-config-set! config-spec
    config-spec should be a list of configuration specifications
    For keybindings the format is: '((\"\\C-xp\" \"text-to-insert\"))"
  (for-each
   (lambda (this-spec)
     (cond
      ((= (length this-spec) 1)
       (%rl-parse-and-bind 
	(format #f "~a" (car this-spec))))
      (else
       (%rl-parse-and-bind 
	(format #f "~{\"~a\"~^: ~}" this-spec)))))
   spec))

;;; End
