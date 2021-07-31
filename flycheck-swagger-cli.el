;;; flycheck-swagger-cli.el --- Flycheck checker for swagger-cli.

;; Copyright (C) 2017-2018 Marc-André Goyette
;; Author: Marc-André Goyette <goyette.marcandre@gmail.com>
;; URL: https://github.com/magoyette/flycheck-swagger-cli
;; Version: 0.1.0
;; Package-Requires: ((emacs "25"))
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; flycheck-swagger-cli provides a Flycheck checker for swagger-cli.
;; This allows to validate OpenAPI 2 and Swagger files.

;; The checker can be activating by requiring this package.

;; (require 'flycheck-swagger-cli)

;; By default, only the first 4000 characters of a file are scanned to
;; find the swagger 2.0 element.  To avoid stack overflow in Emacs
;; multi-line regex, this value is necessary.  The defcustom
;; swagger-cli-predicate-regexp-match-limit can be used to change this
;; limit.  That could be necessary for YAML files with long initial comments.

;;; Code:

(require 'flycheck)

(defgroup flycheck-swagger-cli nil
  "Validate swagger files with swagger-cli."
  :group 'swagger
  :prefix "flycheck-swagger-cli-")

(defcustom flycheck-swagger-cli-predicate-regexp-match-limit 4000
  "Defines the number of characters that will be scanned at the beginning of a buffer to find the swagger 2.0 element."
  :type 'integer
  :group 'flycheck-swagger-cli)

;;;###autoload
(flycheck-define-checker swagger-cli
  "A checker that uses swagger-cli to validate OpenAPI 2/3 and Swagger files.
See URL `https://github.com/BigstickCarpet/swagger-cli'."
  :command ("swagger-cli" "validate" source)
  :predicate
  (lambda ()
    (string-match
     "[\"]\\{0,1\\}\\(openapi\\|swagger\\)[\"]\\{0,1\\}:[[:space:]]*\"[23].0[^\"]*\""
     ;; Need to avoid stack overflow for multi-line regex
     (buffer-substring 1 (min (buffer-size)
                              flycheck-swagger-cli-predicate-regexp-match-limit))))
  :error-patterns
  ((error line-start
          "Error parsing "
          (file-name)
          ": "
          (message)
          "(" line ":" column ")"
          line-end)
   (error line-start
          blank blank
          (message (not space)
                   (one-or-more not-newline))
          line-end))
  :error-filter
  ;; Add line number 1 if the error has no line number
  (lambda (errors)
    (dolist (err errors)
      (unless (flycheck-error-line err)
        (setf (flycheck-error-line err) 1)))
    errors)
  :modes (json-mode openapi-yaml-mode yaml-mode))

(add-to-list 'flycheck-checkers 'swagger-cli)

(provide 'flycheck-swagger-cli)
;;; flycheck-swagger-cli.el ends here
