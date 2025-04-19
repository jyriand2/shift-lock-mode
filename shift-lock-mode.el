;;; shift-lock-mode.el --- Caps Lock simulation with fringe indicator -*- lexical-binding: t; -*-

;; Author: Your Name <your.email@example.com>
;; Version: 0.1
;; Package-Requires: ((emacs "26.1"))
;; Keywords: convenience, editing
;; URL: https://github.com/yourname/shift-lock-mode

;;; Commentary:

;; shift-lock-mode simulates Caps Lock by converting input to uppercase.
;; It also visually indicates its state by changing the fringe background color.
;; Fringe colors and keybindings are customizable.

;;; Code:

(defgroup shift-lock nil
  "Simulate Caps Lock with visual fringe indication."
  :prefix "shift-lock-"
  :group 'convenience)

(defcustom shift-lock-caps-fringe-color "red"
  "Fringe color indicating Caps Lock is active."
  :type 'color
  :group 'shift-lock)

(defcustom shift-lock-caps-toggle-key (kbd "C-`")
  "Keybinding to toggle Caps Lock mode."
  :type 'key-sequence
  :group 'shift-lock
  :set (lambda (symbol key)
         (when (boundp 'shift-lock-caps-toggle-key)
           (global-unset-key (eval symbol)))
         (set-default symbol key)
         (global-set-key key #'shift-lock-caps-mode)))

(defvar shift-lock--original-fringe-bg nil
  "Original fringe background color for restoration.")

(defun shift-lock--enable-fringe (color)
  "Set fringe background COLOR."
  (unless shift-lock--original-fringe-bg
    (setq shift-lock--original-fringe-bg (face-background 'fringe)))
  (set-face-background 'fringe color))

(defun shift-lock--disable-fringe ()
  "Restore original fringe background."
  (set-face-background 'fringe shift-lock--original-fringe-bg)
  (setq shift-lock--original-fringe-bg nil))

(defun shift-lock--caps-self-insert (n)
  "Insert characters as uppercase N times."
  (interactive "p")
  (dotimes (_ n)
    (insert-char (upcase last-command-event))))

(defvar shift-lock-caps-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [remap self-insert-command] #'shift-lock--caps-self-insert)
    map)
  "Keymap for `shift-lock-caps-mode`.")

;;;###autoload
(define-minor-mode shift-lock-caps-mode
  "Toggle Caps Lock simulation with visual fringe indicator."
  :lighter " CAPS"
  :global t
  :keymap shift-lock-caps-mode-map
  (if shift-lock-caps-mode
      (shift-lock--enable-fringe shift-lock-caps-fringe-color)
    (shift-lock--disable-fringe)))

;;;###autoload
(global-set-key shift-lock-caps-toggle-key #'shift-lock-caps-mode)

(provide 'shift-lock-mode)

;;; shift-lock-mode.el ends here
