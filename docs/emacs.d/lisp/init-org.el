;;; init-org.el --- Org mode configuration -*- lexical-binding: t; -*-

;; ==================================================
;; Notes root (resolved, not hardcoded)
;; ==================================================
;; Prefers an existing MEGA-synced org directory (checked under a
;; couple of plausible names, since sync clients don't always mount
;; identically across macOS and Ubuntu), then a plain ~/org, and only
;; falls back to a directory inside user-emacs-directory if neither is
;; found -- so a not-yet-mounted sync folder on a fresh machine
;; degrades gracefully instead of quietly writing notes nowhere.

(defvar my/org-root
  (or (my/first-existing-directory "~/MEGA/org" "~/Org" "~/org")
      (expand-file-name "org" user-emacs-directory))
  "Root directory for Org notes.")

(unless (file-directory-p my/org-root)
  (make-directory my/org-root t))

;; ==================================================
;; Core Org setup
;; ==================================================

(use-package org
  :ensure t
  :hook ((org-mode . org-indent-mode)
         (org-mode . visual-line-mode))
  :config

  ;; ------------------------------------------------
  ;; Basic behavior
  ;; ------------------------------------------------
  (setq org-log-done 'time
        org-startup-folded t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-return-follows-link t
        org-use-speed-commands t
        org-startup-indented t)

  ;; ------------------------------------------------
  ;; Academic writing improvements
  ;; ------------------------------------------------

  ;; better LaTeX preview in Org
  (setq org-preview-latex-default-process 'dvisvgm)

  ;; syntax highlight in src blocks
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0)

  ;; better export defaults
  (setq org-export-with-smart-quotes t
        org-export-headline-levels 5)

  ;; ------------------------------------------------
  ;; Links & navigation
  ;; ------------------------------------------------
  (setq org-mouse-1-follows-link t)

  ;; ------------------------------------------------
  ;; TODO system (light but useful)
  ;; ------------------------------------------------
  (setq org-todo-keywords
        '((sequence "TODO(t)" "DOING(i)" "|" "DONE(d)" "CANCELLED(c)")))

  ;; ------------------------------------------------
  ;; Files (important for your workflow)
  ;; ------------------------------------------------
  (setq org-directory my/org-root
        org-default-notes-file (expand-file-name "inbox.org" my/org-root))

  ;; ------------------------------------------------
  ;; LaTeX integration (important for Emacs 30 + AUCTeX)
  ;; ------------------------------------------------
  (setq org-preview-latex-image-directory
        (concat temporary-file-directory "ltximg/"))

  ;; nicer LaTeX fragments scaling
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.6))

  ;; ------------------------------------------------
  ;; Citations (org-cite, native to Org 9.5+)
  ;; ------------------------------------------------
  ;; The bibliography path and the insert/follow/activate backend are
  ;; configured in init-citations.el (citar) — that's the single
  ;; source of truth so this file and init-latex.el can't drift out
  ;; of sync with it. Only the export processor choice lives here.
  (setq org-cite-export-processors '((latex . biblatex)
                                      (t . csl))))

;; ==================================================
;; Modern Org UI
;; ==================================================

(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star 'replace
        org-modern-hide-stars nil
        org-modern-table nil))

;; ==================================================
;; Org utilities (optional but useful)
;; ==================================================

(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t
        org-appear-autosubmarkers t))

;; ==================================================
;; Provide
;; ==================================================

(provide 'init-org)

;;; init-org.el ends here