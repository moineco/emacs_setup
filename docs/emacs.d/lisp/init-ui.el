;;; init-ui.el --- UI, theme, fonts -*- lexical-binding: t; -*-

;; ==================================================
;; Theme
;; ==================================================

(use-package doom-themes
  :ensure t
  :config
  (condition-case nil
      (load-theme 'doom-one t)
    (error
     (load-theme 'wombat t))))

;; ==================================================
;; Fonts (cross-platform, stable)
;; ==================================================

(defun my/set-first-available-font (height &rest families)
  "Set the default face to the first font in FAMILIES that is installed
on this machine, at HEIGHT. Falls back to just setting HEIGHT if none
of FAMILIES are found, so startup never errors out over a missing font."
  (let ((family (seq-find (lambda (f) (member f (font-family-list))) families)))
    (if family
        (set-face-attribute 'default nil :family family :height height)
      (set-face-attribute 'default nil :height height))))

(defun my/setup-fonts ()
  "Set fonts with safe fallbacks, checked against what's actually
installed rather than assumed per-OS -- a font list here works
unmodified whether it happens to be installed on macOS or Linux."

  (when (display-graphic-p)
    ;; Height differs by OS because point size renders differently on
    ;; macOS vs Linux at the same nominal :height value, not because
    ;; any of these fonts are OS-exclusive.
    (my/set-first-available-font
     (if (eq system-type 'darwin) 180 140)
     "JetBrains Mono" "Fira Code" "Monaco" "Menlo" "DejaVu Sans Mono"))

  ;; -------------------------
  ;; Emoji support
  ;; -------------------------
  (let ((emoji-family (seq-find (lambda (f) (member f (font-family-list)))
                                 '("Apple Color Emoji" "Noto Color Emoji"
                                   "Segoe UI Emoji"))))
    (when emoji-family
      (set-fontset-font t 'symbol (font-spec :family emoji-family) nil 'prepend))))

(add-hook 'after-init-hook #'my/setup-fonts)

;; ==================================================
;; Line numbers (disable in special modes)
;; ==================================================

(global-display-line-numbers-mode 1)

(dolist (hook '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                pdf-view-mode-hook
                dired-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode 0))))

;; ==================================================
;; Visual behavior
;; ==================================================

(global-visual-line-mode 1)

(pixel-scroll-precision-mode 1)

(setq scroll-conservatively 101
      scroll-margin 3
      use-dialog-box nil
      ring-bell-function 'ignore)

;; ==================================================
;; UI extras
;; ==================================================

(column-number-mode 1)
(show-paren-mode 1)
(global-hl-line-mode 1)

(blink-cursor-mode 0)

(setq frame-title-format '("%b — Emacs"))

;; ==================================================
;; Provide
;; ==================================================

(provide 'init-ui)

;;; init-ui.el ends here