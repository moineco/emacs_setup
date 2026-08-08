;;; init-company.el --- Company-mode configuration -*- lexical-binding: t; -*-

;; ==================================================
;; Core company-mode
;; ==================================================

(use-package company
  :hook (after-init . global-company-mode)

  :config
  (setq company-idle-delay 0.15
        company-minimum-prefix-length 2
        company-selection-wrap-around t
        company-tooltip-align-annotations t
        company-dabbrev-downcase nil
        company-require-match nil)

  ;; Better UX responsiveness
  (setq company-show-numbers t)

  ;; Slightly more responsive popup
  (setq company-frontends
        '(company-pseudo-tooltip-frontend
          company-echo-metadata-frontend)))

;; ==================================================
;; Backends for academic workflow
;; ==================================================

(defun my/company-backends-setup ()
  "Custom company backends for academic writing and coding."

  (setq-local company-backends
              '((company-capf                ;; LSP / Org / AUCTeX / etc.
                 company-files
                 company-dabbrev
                 company-keywords))))

;; Enable in relevant modes
;; NOTE: LaTeX-mode-hook is intentionally excluded here; it gets the more
;; specific AUCTeX-aware backend list from my/company-latex-setup below.
;; (Both used to hook into LaTeX-mode-hook, and because add-hook prepends
;; by default, this generic setup silently ran *after* and clobbered the
;; LaTeX-specific backends.)
(dolist (hook '(prog-mode-hook
                org-mode-hook))
  (add-hook hook #'my/company-backends-setup))

;; ==================================================
;; LaTeX-specific improvements
;; ==================================================

(defun my/company-latex-setup ()
  "Better completion for LaTeX editing."
  (setq-local company-backends
              '((company-auctex-labels
                 company-auctex-bibs
                 company-auctex-macros
                 company-capf
                 company-dabbrev))))

(add-hook 'LaTeX-mode-hook #'my/company-latex-setup)

;; ==================================================
;; Optional: better TAB behavior
;; ==================================================

(with-eval-after-load 'company
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

;; ==================================================
;; Provide
;; ==================================================

(provide 'init-company)

;;; init-company.el ends here