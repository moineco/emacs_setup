;;; init-citations.el --- Citation management with citar (.bib-based) -*- lexical-binding: t; -*-

;;; Commentary:
;; Citation completion, insertion, and preview for a plain .bib
;; workflow (no Zotero/BibDesk sync required). Works in both:
;; - Org mode, via org-cite (native Org 9.5+ citation syntax)
;; - LaTeX mode, via AUCTeX
;;
;; `my-bibliography-files' below should point at the same .bib file(s)
;; as `org-cite-global-bibliography' in init-org.el and
;; `reftex-default-bibliography' in init-latex.el.

;;; Code:

(defvar my-bibliography-files
  (let ((found (my/first-existing-file "~/MEGA/bibliography/references.bib"
                                        "~/Bibliography/references.bib"
                                        "~/bibliography/references.bib")))
    (if found
        (list found)
      (progn
        (message "No .bib file found in the usual locations; citar/org-cite/reftex will have an empty bibliography until my-bibliography-files is set.")
        '("~/MEGA/bibliography/references.bib"))))
  "List of .bib files used for citation completion across the config.")

;; ==================================================
;; Core citar (single block, per upstream recommendation:
;; https://github.com/emacs-citar/citar)
;; ==================================================

(use-package citar
  :ensure t
  :hook ((LaTeX-mode . citar-capf-setup)
         (org-mode   . citar-capf-setup))
  :custom
  (citar-bibliography my-bibliography-files)
  (org-cite-global-bibliography my-bibliography-files)
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  (citar-notes-paths (list org-roam-directory))
  :bind (("C-c b b" . citar-insert-citation)
         ("C-c b o" . citar-open)
         ("C-c b r" . citar-open-notes)
         (:map org-mode-map
               ("C-c b i" . org-cite-insert))))

;; ==================================================
;; LaTeX \cite insertion (AUCTeX)
;; ==================================================

(with-eval-after-load 'tex
  (define-key TeX-mode-map (kbd "C-c b b") #'citar-insert-citation))

;; ==================================================
;; Provide
;; ==================================================

(provide 'init-citations)

;;; init-citations.el ends here
