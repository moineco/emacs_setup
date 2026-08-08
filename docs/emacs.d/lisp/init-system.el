;;; init-system.el --- Cross-platform system settings -*- lexical-binding: t; -*-

;; ==================================================
;; Cross-platform resolution helpers
;; ==================================================
;; Other modules (init-org, init-roam, init-citations, init-latex,
;; init-editing, init-pandoc) use these instead of hardcoding a single
;; path/tool, so the same init.el works regardless of where a synced
;; folder happens to mount or which spell-checker/PDF viewer happens
;; to be installed on a given machine.

(defun my/first-existing-directory (&rest candidates)
  "Return the first directory among CANDIDATES that exists, or nil.
Each candidate is expanded with `expand-file-name'."
  (seq-find #'file-directory-p (mapcar #'expand-file-name candidates)))

(defun my/first-existing-file (&rest candidates)
  "Return the first file among CANDIDATES that exists, or nil.
Each candidate is expanded with `expand-file-name'."
  (seq-find #'file-exists-p (mapcar #'expand-file-name candidates)))

(defun my/first-executable (&rest candidates)
  "Return the full path of the first executable among CANDIDATES found
on `exec-path', or nil if none are found."
  (seq-some #'executable-find candidates))

;; ==================================================
;; Environment inheritance (recommended approach)
;; ==================================================

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x pgtk))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; ==================================================
;; macOS settings
;; ==================================================

(when (eq system-type 'darwin)

  ;; Prefer Homebrew / system TeXLive (NOT MacPorts). Only add this if
  ;; a TeX toolchain isn't already reachable (e.g. via
  ;; exec-path-from-shell above), so we don't silently prepend a path
  ;; that shadows a deliberately different install.
  (unless (executable-find "latexmk")
    (let ((tex-path (my/first-existing-directory "/Library/TeX/texbin")))
      (when tex-path
        (add-to-list 'exec-path tex-path)
        (setenv "PATH" (concat tex-path ":" (getenv "PATH"))))))

  ;; UI defaults
  (dolist (setting '((ns-appearance . dark)
                     (ns-transparent-titlebar . t)
                     (fullscreen . maximized)))
    (add-to-list 'default-frame-alist setting)))

;; ==================================================
;; Linux / Ubuntu settings
;; ==================================================

(when (eq system-type 'gnu/linux)

  ;; Minimal safe PATH extensions (avoid overwriting system PATH)
  (dolist (p '("/usr/local/bin" "/usr/bin" "~/.local/bin"))
    (let ((dir (my/first-existing-directory p)))
      (when dir
        (add-to-list 'exec-path dir))))

  ;; Start maximized
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))

;; ==================================================
;; Frame behavior (all platforms)
;; ==================================================

(setq frame-resize-pixelwise t)

;; ==================================================
;; Input / UX defaults
;; ==================================================

(setq select-enable-clipboard t
      save-interprogram-paste-before-kill t
      use-dialog-box nil)

;; smoother scrolling (important for PDF + Org)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      scroll-step 1)

;; ==================================================
;; Optional UI cleanup
;; ==================================================

;; Uncomment if you want minimal UI
;; (menu-bar-mode -1)
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1)

;; ==================================================
;; Provide
;; ==================================================

(provide 'init-system)

;;; init-system.el ends here