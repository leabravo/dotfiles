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

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(require 'diminish)
(require 'bind-key)

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

(use-package evil
  :ensure t
  :config
  (evil-mode t))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package atom-one-dark-theme
  :ensure t
  :init
  (load-theme 'atom-one-dark))

(use-package tern
  :ensure t
  :config
  (use-package company-tern
    :config
    (add-to-list 'company-backends 'company-tern)))

(use-package web-mode
  :ensure t
  :config
  (defun my-web-mode-hook ()
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2))
  (add-hook 'web-mode-hook (lambda ()
                           (tern-mode t)
                           (my-web-mode-hook))))

(use-package flycheck
  :ensure t
  :config
  (setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))
  ;;(add-hook 'after-init-hook #'global-flycheck-mode)
  (setq-default flycheck-temp-prefix ".flycheck")
  (global-flycheck-mode))

(use-package better-defaults
  :ensure t
  :config
  (require 'better-defaults))

(use-package jedi-core
  :ensure t
  :config
  (use-package company-jedi
    :ensure t
    :config
    (add-hook
     'python-mode-hook
     (lambda() (add-to-list 'company-backends 'company-jedi)))
    (setq jedi:complete-on-dot t)
    (setq jedi:get-in-function-call-delay 0.2)))

;; Basic Options
;; =============
(setq inhibit-startup-message t)

(setq
 backup-by-copying t ; no clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacstory"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

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

(global-linum-mode t)

(custom-set-variables
 '(python-shell-interpreter "python3"))
(custom-set-faces
 )

(provide '.emacs)
;;; .emacs ends here
