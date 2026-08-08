;;; init-latex.el --- LaTeX/AUCTeX + latexmk -*- lexical-binding: t; -*-

;; ==================================================
;; AUCTeX core
;; ==================================================

(use-package tex
  :ensure auctex
  :defer t
  :hook (LaTeX-mode . my/latex-setup)

  :config

  ;; ------------------------------------------------
  ;; Core AUCTeX settings
  ;; ------------------------------------------------
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-save-query nil
        TeX-PDF-mode t
        TeX-source-correlate-start-server t
        TeX-source-correlate-method 'synctex)

  ;; ------------------------------------------------
  ;; latexmk as default engine (IMPORTANT)
  ;; ------------------------------------------------
  (setq TeX-command-default "LatexMk")

  (add-to-list 'TeX-command-list
               '("LatexMk"
                 "latexmk -pdf -synctex=1 -interaction=nonstopmode -shell-escape %s"
                 TeX-run-TeX nil t
                 :help "Run latexmk with SyncTeX"))

  ;; ------------------------------------------------
  ;; PDF viewer (cross-platform via pdf-tools)
  ;; ------------------------------------------------
  ;; pdf-tools (init-pdf.el) runs inside Emacs itself, so it's
  ;; identical on macOS and Ubuntu -- no per-OS external app
  ;; assumption, and no risk of that app not being installed. It
  ;; needs a graphical frame, though, so fall back to whatever
  ;; OS-native PDF viewer is actually present when running headless
  ;; (e.g. over SSH).
  (if (display-graphic-p)
      (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
            TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view)))
    (let ((viewer (my/first-executable "evince" "okular" "xdg-open" "open")))
      (when viewer
        (setq TeX-view-program-selection
              `((output-pdf ,(file-name-nondirectory viewer)))
              TeX-view-program-list
              `((,(file-name-nondirectory viewer)
                 ,(concat (file-name-nondirectory viewer) " %o")))))))

  ;; Keep the PDF buffer in sync with recompiles
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

  ;; ------------------------------------------------
  ;; SyncTeX integration (editor ↔ PDF sync)
  ;; ------------------------------------------------
  (setq TeX-source-correlate-mode t))

;; ==================================================
;; LaTeX mode setup
;; ==================================================

(defun my/latex-setup ()
  "Academic LaTeX editing setup."

  ;; AUCTeX enhancements
  (turn-on-reftex)
  (setq reftex-plug-in-flag t)

  (LaTeX-math-mode 1)

  ;; Writing comfort
  (visual-line-mode 1)
  (flyspell-mode 1)

  ;; Better indentation behavior
  (setq TeX-brace-indent-level 2
        TeX-newline-function 'reindent-then-newline-and-indent)

  ;; Preview + forward search friendliness
  (setq TeX-source-correlate-start-server t))

;; ==================================================
;; Optional: RefTeX tuning (academic workflow)
;; ==================================================

(setq reftex-default-bibliography
      (if (boundp 'my-bibliography-files)
          my-bibliography-files
        '("~/MEGA/bibliography/references.bib")))

;; ==================================================
;; Provide
;; ==================================================

(provide 'init-latex)

;;; init-latex.el ends here