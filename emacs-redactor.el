;;; emacs-redactor.el --- package to programmatically encrypt parts of files.

;; Copyright (C) 2022 Michael Hernandez

;; Author: Michael Hernandez <michael@hernandez.ai>
;; Keywords: encrypt encryption emacs
;; Version:: 0.1.0

;; Copyright 2022 Michael Hernandez

;; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

;;; Commentary:

;;; Code:

(provide 'redact)

; constants
(setq redactions_keyword "#+REDACTIONS:")
(setq redactions_length (length redactions_keyword))

(defun get_redactions (line)
  "docs"
  ;; (message "launching get_redactions")
  (setq words (split-string line))
  (setq selected_words nil)

  (message "starting loop")
  (dolist (word words)
    (unless
        (string=
         word
         redactions_keyword)
        (push word selected_words)

      )
    )
  selected_words
  )

(defun get_redactions_wrapper (ln)
  "docs"
  ;; (message "launching get_redactions_wrapper")
  (setq redactions_full nil)

  (if (
       >
       (length ln)
       12)
      (progn
        (if (
             string=
             (substring ln 0 13)
             redactions_keyword)
            (progn
              ;; (message "redaction config found")
              (setq redactions (get_redactions ln))
              )
            )
        )
    (setq redactions 'nil)
      )
  redactions
  )

(defun redact ()
  "docs"
  (interactive)
  (message "redact v0.1.0")

  (defvar encryption_targets nil)

  ;; loop over lines
  (goto-char (point-min))
  (while (not (eobp))
    ;; get line
    (let* ((lb (line-beginning-position))
           (le (line-end-position))
           (ln (buffer-substring-no-properties lb le)))

      ;; loop body
      (
       setq
       encryption_target (
                          get_redactions_wrapper
                          ln
                          )
       )

      (if encryption_target
          (setq encryption_targets (
                                    append
                                    encryption_targets
                                    encryption_target
                                    )
                )
          )
      ;; end loop body

    ;; continue loop
    (forward-line 1))
  )
  (message (format "encryption targets %s" encryption_targets))
)
