;;; config --- Summary:
;;; Commentary:

;;; Code:

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;;;; Org-mode configurations
;(org-babel-do-load-languages
; 'org-babel-load-languages
; '((sh . t)
;   (python . t)
;   (R . t)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("~/Dropbox/Private/ORG/rutinas.org" "~/Dropbox/Private/ORG/gtd.org")))
 '(org-archive-save-context-info nil)
 '(org-capture-templates
   (quote
    (("t" "Todo")
     ("tm" "Mail" entry
      (file "~/Dropbox/Private/ORG/inbox.org")
      "* TODO [[%l][%:subject]]")
     ("tt" "Task" entry
      (file "~/Dropbox/Private/ORG/inbox.org")
      (file "~/Dropbox/Private/ORG/tpl-todo.txt"))
     ("b" "Bookmark" entry
      (file "~/Dropbox/Private/ORG/references.org")
      (file "~/Dropbox/Private/ORG/tpl-bookmark.txt"))
     ("r" "Review")
     ("rd" "Daily Review" entry
      (file "~/Dropbox/Private/ORG/dailyreview.org")
      (file "~/Dropbox/Private/ORG/tpl-dreview.txt")))))
 '(org-outline-path-complete-in-steps nil)
 '(org-refile-targets
   (quote
    ((nil :maxlevel . 2)
     (org-agenda-files :maxlevel . 2))))
 '(org-refile-use-outline-path t)
 '(org-startup-truncated nil)
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
(add-to-list 'default-frame-alist '(font . "Inconsolatazi4-13" ))
(set-face-attribute 'default t :font "Inconsolatazi4-13")

(add-hook 'focus-in-hook (lambda () (progn (setq org-tags-column (- 5 (window-body-width)))) (org-align-all-tags)))
(add-hook 'focus-out-hook (lambda () (progn (setq org-tags-column (- 5 (window-body-width)))) (org-align-all-tags)))

(setq org-icalendar-combined-agenda-file "~/Dropbox/Private/ORG/calendar.ics")
(add-hook 'org-capture-after-finalize-hook (lambda () (org-icalendar-combine-agenda-files)))

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
  (projectile-mode))

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

;;;; R specific configurations
;;;; ~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package ess
  :ensure t
  :config
  (require 'ess))
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

(use-package ox-hugo
  :after ox)

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


;;;; Gnus Configuration
(setq gnus-select-method
      '(nnimap "fastmail"
	       (nnimap-address "imap.fastmail.com")  ; it could also be imap.googlemail.com if that's your server.
	       (nnimap-server-port "imaps")
	       (nnimap-stream ssl)))

(setq auth-sources
      '((:source "~/.authinfo.gpg")))

(setq epa-pinentry-mode 'loopback)
;;;; end

(provide '.emacs)
;;; .emacs ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
