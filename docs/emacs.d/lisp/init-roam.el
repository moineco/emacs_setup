;;; init-roam.el --- Org-roam setup -*- lexical-binding: t; -*-

;; ==================================================
;; Core Org-roam
;; ==================================================

(use-package org-roam
  :ensure t
  :demand t
  :init
  (setq org-roam-v2-ack t)

  :custom
  ;; Prefer an existing MEGA roam folder; otherwise nest under
  ;; my/org-root (init-org.el) so it stays consistent with wherever
  ;; Org notes actually resolved to on this machine.
  (org-roam-directory
   (or (my/first-existing-directory "~/MEGA/org/roam")
       (expand-file-name "roam" my/org-root)))
  (org-roam-completion-everywhere t)

  :config
  (unless (file-directory-p org-roam-directory)
    (make-directory org-roam-directory t))
  (org-roam-db-autosync-mode))

;; ==================================================
;; Keybindings (clean grouping)
;; ==================================================

(use-package org-roam
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n b" . org-roam-buffer-toggle)
         ("C-c n l" . org-roam-buffer-toggle)

         ;; custom capture shortcuts
         ("C-c n I" . my/org-roam-node-insert-immediate)
         ("C-c n t" . my/org-roam-capture-task)
         ("C-c n p" . my/org-roam-capture-project))

  :bind-keymap
  ("C-c n d" . org-roam-dailies-map))

;; ==================================================
;; Dailies
;; ==================================================

(require 'org-roam-dailies)

(setq org-roam-dailies-directory "daily/")

;; Optional key tweaks
(define-key org-roam-dailies-map (kbd "Y")
            #'org-roam-dailies-capture-yesterday)

(define-key org-roam-dailies-map (kbd "T")
            #'org-roam-dailies-capture-tomorrow)

;; ==================================================
;; Immediate insert helper
;; ==================================================

(defun my/org-roam-node-insert-immediate (&optional arg)
  "Insert node and finish capture immediately."
  (interactive "P")
  (let ((org-roam-capture-templates
         (list (append (car org-roam-capture-templates)
                       '(:immediate-finish t)))))
    (org-roam-node-insert arg)))

;; ==================================================
;; Tag utilities (cleaned)
;; ==================================================

(defun my/org-roam-filter-by-tag (tag)
  (lambda (node)
    (member tag (org-roam-node-tags node))))

(defun my/org-roam-files-by-tag (tag)
  "Return list of Org-roam files with TAG."
  (mapcar #'org-roam-node-file
          (seq-filter (my/org-roam-filter-by-tag tag)
                      (org-roam-node-list))))

;; ==================================================
;; Projects (simplified model)
;; ==================================================

(defun my/org-roam-projects ()
  "Return all project files."
  (my/org-roam-files-by-tag "Project"))

;; ==================================================
;; Capture: Inbox
;; ==================================================

(defun my/org-roam-capture-inbox ()
  (interactive)
  (org-roam-capture-
   :node (org-roam-node-create)
   :templates
   '(("i" "inbox"
      plain "* %?"
      :if-new (file+head "inbox.org"
                         "#+title: Inbox\n#+filetags: Inbox\n")))))

;; ==================================================
;; Capture: Task
;; ==================================================

(defun my/org-roam-capture-task ()
  (interactive)
  (org-roam-capture-
   :node (org-roam-node-read
          nil
          (my/org-roam-filter-by-tag "Project"))
   :templates
   '(("t" "task"
      entry "** TODO %?"
      :if-new (file+head+olp
               "%<%Y%m%d%H%M%S>-${slug}.org"
               "#+title: ${title}\n#+filetags: Project\n"
               ("Tasks"))))))

;; ==================================================
;; Capture: Project
;; ==================================================

(defun my/org-roam-capture-project ()
  "Find an existing project node, or capture a new one using the project template."
  (interactive)
  (org-roam-node-find
   nil nil
   (my/org-roam-filter-by-tag "Project")
   :templates
   '(("p" "project"
      plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Initial task\n\n* Notes\n"
      :if-new (file+head
               "%<%Y%m%d%H%M%S>-${slug}.org"
               "#+title: ${title}\n#+filetags: Project\n")
      :unnarrowed t))))

;; ==================================================
;; Provide
;; ==================================================

(provide 'init-roam)

;;; init-roam.el ends here