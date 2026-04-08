;;; display-helpers.el --- ascii-armor org display utilities -*- lexical-binding: t -*-

;; Copyright (C) 2024-2026 aygp-dr
;; Author: aygp-dr
;; URL: https://github.com/aygp-dr/ascii-armor
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (org "9.0"))
;; Keywords: multimedia, data, files

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This package provides helper functions for encoding and decoding
;; binary files as base64 within Org-mode documents.  It supports the
;; ascii-armor pattern of embedding binary data in text-safe formats.
;;
;; Main functions:
;; - `ascii-armor/decode-named-block': Decode a named base64 block to a file
;; - `ascii-armor/decode-all-and-display': Decode all *-b64 blocks and show inline
;; - `ascii-armor/encode-file-to-named-block': Encode a file as a named org block

;;; Code:

(require 'org)

(defun ascii-armor/decode-named-block (block-name dest-path)
  "Decode base64 in named org BLOCK-NAME to DEST-PATH.
Returns DEST-PATH on success, signals error on failure."
  (let* ((b64  (string-trim (org-babel-ref-resolve block-name)))
         (data (base64-decode-string b64)))
    (with-temp-file dest-path
      (set-buffer-multibyte nil)
      (insert data))
    dest-path))

(defun ascii-armor/decode-all-and-display ()
  "Decode all #+name: *-b64 blocks in the current buffer to /tmp/ and display inline."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^#\\+name: \\([a-zA-Z0-9_-]+\\)-b64$" nil t)
      (let* ((name  (match-string 1))
             (block (concat name "-b64"))
             (ext   "jpg")  ; default; override per block if needed
             (dest  (format "/tmp/ascii-armor-%s.%s" name ext)))
        (condition-case err
            (progn
              (ascii-armor/decode-named-block block dest)
              (message "Decoded %s → %s" block dest))
          (error (message "WARN: could not decode %s: %s" block err))))))
  (org-toggle-inline-images))

(defun ascii-armor/encode-file-to-named-block (file block-name)
  "Encode FILE as base64 and insert as a named org src block at point."
  (interactive "fFile: \nsBlock name: ")
  (let* ((data (with-temp-buffer
                 (set-buffer-multibyte nil)
                 (insert-file-contents-literally file)
                 (buffer-string)))
         (b64  (base64-encode-string data))
         (wrapped (with-temp-buffer
                    (insert b64)
                    (goto-char (point-min))
                    (while (< (point) (point-max))
                      (forward-char 76)
                      (unless (eobp) (insert "\n")))
                    (buffer-string))))
    (insert (format "#+name: %s\n#+begin_src text :eval no\n%s\n#+end_src\n"
                    block-name wrapped))))

(provide 'ascii-armor-display-helpers)
;;; display-helpers.el ends here
