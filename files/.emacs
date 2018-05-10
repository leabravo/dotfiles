;;; config --- Summary:
;;; Commentary:

;;; Code:

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "https://melpa.org/packages/")
   t)
  (package-initialize))

;;;; Org-mode configurations
(org-babel-do-load-languages
 'org-babel-load-languages
 '((sh . t)
   (python . t)
   (R . t)))

(custom-set-variables
 '(org-agenda-files
   (quote
    ("~/Dropbox/Private/ORG/journal.org" "~/Dropbox/Private/ORG/inbox.org")))
 '(org-refile-targets '((nil :maxlevel . 1)
                        (org-agenda-files :maxlevel . 1)))
 '(org-refile-use-outline-path t)
 '(org-outline-path-complete-in-steps nil)
 '(org-startup-truncated nil)
 '(org-archive-save-context-info nil)
 '(org-capture-templates
   '(("t" "Todo" entry
      (file+headline "~/Dropbox/Private/ORG/inbox.org" "INBOX")
      (file "~/Dropbox/Private/ORG/tpl-todo.txt"))
     ("b" "Bookmark" entry
      (file "~/Dropbox/Private/ORG/references.org")
      (file "~/Dropbox/Private/ORG/tpl-bookmark.txt"))
     ("r" "Review")
     ("rd" "Daily Review" entry
      (file "~/Dropbox/Private/ORG/dailyreview.org")
      (file "~/Dropbox/Private/ORG/tpl-dreview.txt"))))
 
 '(python-shell-interpreter "python3"))
 ;'(python-shell-interpreter-args "--simple-prompt -i"))
;;;; end

;;;; Use-package setup
;;;; ~~~~~~~~~~~~~~~~~
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
;;;; end

;;;; Basic Configuration
;;;; ~~~~~~~~~~~~~~~~~~~
(use-package better-defaults
  :ensure t
  :config
  (require 'better-defaults))

(use-package evil
  :ensure t
  :init
  ;; CRITICAL! Avoid undoing large chunks.
  (setq evil-want-fine-undo 'fine)
  :config
  (evil-mode t))

(use-package magit
  :ensure t
  :init
  (global-set-key (kbd "C-x g") 'magit-status)
  :config
  (require 'magit))

(use-package projectile
  :ensure t
  :config
  (require 'projectile)
  ;; Behave """like""" magit-status
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-commander)
  (projectile-global-mode))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package atom-one-dark-theme
  :ensure t
  :config
  (load-theme 'atom-one-dark t))

(setq inhibit-startup-message t)

(setq
 backup-by-copying t ; no clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacstory"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)
;;;; end

;;;; Clojure specific configurations
;;;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package clojure-mode
  :ensure t
  :config
  (require 'clojure-mode))

(use-package rainbow-delimiters
  :ensure t
  :config
  (require 'rainbow-delimiters))

(use-package cider
  :ensure t
  :config
  (require 'cider))
;;;; end

;;;; Python specific configurations
;;;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package anaconda-mode
  :ensure t
  :init
  (setq python-shell-interpreter "python3")
  (add-hook 'python-mode-hook 'anaconda-mode))

(use-package company-anaconda
  :ensure t
  :config
  (require 'company-anaconda))

(use-package flycheck
  :ensure t
  :init
  (setq-default flycheck-temp-prefix ".flycheck")
  (global-flycheck-mode)
  (add-hook 'after-init-hook #'global-flycheck-mode))
;;;; end

;;;; Web related configurations
;;;; ~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package web-mode
  :ensure t
  :init
  (defun my-web-mode-hook ()
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2))
  :config
  (add-hook 'web-mode-hook (lambda ()
                           (tern-mode t)
                           (my-web-mode-hook))))

(setq web-mode-content-types-alist
      '(("jsx" . "\\.js[x]?\\'")))

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js[x]?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;;;; end

(provide '.emacs)
;;; .emacs ends here

(put 'dired-find-alternate-file 'disabled nil)
