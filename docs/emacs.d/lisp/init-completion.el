;;; init-completion.el --- Minibuffer completion UI + keybinding discovery -*- lexical-binding: t; -*-

;;; Commentary:
;; This is the single biggest quality-of-life upgrade for the
;; citation- and note-heavy workflow this config is built around:
;; citar's citation search, org-roam-node-find, and M-x all go
;; through the minibuffer, and all get dramatically better with
;; fuzzy/out-of-order matching and inline previews.
;;
;; Loaded early (right after init-system) so it's already active by
;; the time init-citations.el and init-roam.el set up their own
;; completing-read-based commands.

;;; Code:

;; ==================================================
;; Vertico: vertical, incremental minibuffer completion UI
;; ==================================================

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  (vertico-count 12))

;; ==================================================
;; Orderless: match completion candidates in any order
;; ==================================================
;; e.g. typing "smith 2020" finds "Smith, J. (2020) ..." in citar
;; regardless of word order -- this is what makes fuzzy citation and
;; node search actually fast rather than requiring exact prefixes.

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; ==================================================
;; Marginalia: rich annotations in the minibuffer
;; ==================================================
;; Shows docstrings next to M-x candidates, file sizes/dates next to
;; find-file candidates, etc. -- context you'd otherwise have to look
;; up separately.

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; ==================================================
;; Consult: a set of drop-in replacement commands with previews
;; ==================================================

(use-package consult
  :ensure t
  :bind (("C-x b"   . consult-buffer)
         ("C-c s l" . consult-line)
         ("C-c s r" . consult-ripgrep)
         ("C-c s o" . consult-outline)
         ("C-c s h" . consult-org-heading)
         ("M-y"     . consult-yank-pop)))

;; ==================================================
;; which-key: shows available keybindings as you type a prefix
;; ==================================================
;; With C-c b/n/p/s all in active use in this config, pausing after
;; a prefix key now pops up what's available instead of needing to
;; check the handbook.

(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.4)
  (which-key-sort-order 'which-key-key-order-alpha))

;; ==================================================
;; Provide
;; ==================================================

(provide 'init-completion)

;;; init-completion.el ends here
