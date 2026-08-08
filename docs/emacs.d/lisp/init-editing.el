;;; init-editing.el --- Editing enhancements -*- lexical-binding: t; -*-

;; ==================================================
;; Command completion
;; ==================================================

(use-package smex
  :bind (("M-x" . smex)))

;; ==================================================
;; Structural editing (parens, brackets)
;; ==================================================

(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1)

  ;; better LaTeX / Org support
  (sp-pair "\\[" "\\]" :actions '(insert wrap))
  (sp-pair "$" "$" :actions '(insert wrap)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-identifiers
  :hook ((prog-mode latex-mode LaTeX-mode)
         . rainbow-identifiers-mode))

;; ==================================================
;; Soft wrapping (academic writing friendly)
;; ==================================================

(use-package visual-fill-column
  :config
  (setq-default visual-fill-column-center-text t
                visual-fill-column-width 90))

(use-package adaptive-wrap
  :hook (visual-line-mode . adaptive-wrap-prefix-mode))

(global-visual-line-mode 1)

;; ==================================================
;; Spell checking (clean + unified)
;; ==================================================

(use-package flyspell
  :ensure t
  :hook ((text-mode . flyspell-mode)
         (org-mode  . flyspell-mode)
         (prog-mode . flyspell-prog-mode))
  :config
  ;; Resolve whichever spell-checker is actually installed, rather
  ;; than assuming aspell specifically. hunspell uses a differently
  ;; formatted dictionary name ("en_US") than aspell/ispell ("en").
  (let ((prog (my/first-executable "aspell" "hunspell" "ispell")))
    (if prog
        (setq ispell-program-name prog
              ispell-dictionary (if (string-match-p "hunspell" prog) "en_US" "en"))
      (message "No spell-checker (aspell/hunspell/ispell) found on PATH; flyspell will not work until one is installed."))))

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map
              ("C-;" . flyspell-correct-wrapper)))

;; Optional: ensure external tools
;; Ubuntu: sudo apt install aspell aspell-en
;; macOS: brew install aspell

;; ==================================================
;; Editing behavior tweaks
;; ==================================================

(electric-indent-mode -1)

(setq-default indent-tabs-mode nil)

;; Safer default for academic writing
(setq sentence-end-double-space nil)

;; ==================================================
;; Handy utilities
;; ==================================================

;; Kill inner s-expression / region helper
(defun my/copy-sexp-at-point ()
  "Copy current balanced expression."
  (interactive)
  (save-excursion
    (forward-char)
    (backward-sexp)
    (let ((beg (point)))
      (forward-sexp)
      (kill-ring-save beg (point)))))

(global-set-key (kbd "C-x w") #'my/copy-sexp-at-point)

;; ==================================================
;; Debugging
;; ==================================================

;; Off by default so a minor error doesn't throw a backtrace buffer
;; into the middle of a writing session. Run with
;;   EMACS_DEBUG=1 emacs
;; (or M-x toggle-debug-on-error) when you actually want it.
(setq debug-on-error (and (getenv "EMACS_DEBUG") t))

;; ==================================================
;; Provide
;; ==================================================

(provide 'init-editing)

;;; init-editing.el ends here