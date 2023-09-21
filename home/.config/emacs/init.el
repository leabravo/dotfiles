(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(unless package-archive-contents
  (package-refresh-contents))

(setq my-package-list '(use-package))

(dolist (package my-package-list)
  (unless (package-installed-p package)
    (package-install package)))

(add-hook 'prog-mode-hook 'eglot-ensure)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

(setq org-directory "~/Notes")
(setq org-default-notes-file (concat org-directory "/inbox.org"))

(use-package flycheck
  :ensure t
  :hook
  (after-init . global-flycheck-mode))

(use-package smartparens
  :ensure t
  :hook
  (prog-mode . smartparens-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package bm
  :ensure t
  :demand t
  :init
  ;; restore on load (even before you require bm)
  (setq bm-restore-repository-on-load t)
  :config
  ;; Allow cross-buffer 'next'
  (setq bm-cycle-all-buffers t)
  ;; where to store persistant files
  (setq bm-repository-file "~/.emacs.d/bm-repository")
  (setq-default bm-buffer-persistence t)
  :hook
  (after-init . bm-repository-load) ; Loading the repository from file when on start up.
  (kill-buffer . bm-buffer-save) ; Saving bookmarks
  (kill-emacs . bm-buffer-save-all)
  (kill-emacs . bm-repository-save)
  (after-save . bm-buffer-save)
  (find-file . bm-buffer-restore) ; Restoring bookmarks
  (after-revert . bm-buffer-restore) ; Restoring bookmarks
  (vc-before-checkin . bm-buffer-save)
  :bind (("<f2>" . bm-next)
         ("S-<f2>" . bm-previous)
         ("C-<f2>" . bm-toggle))
  )

(use-package better-defaults
  :ensure t)

(use-package which-key
  :ensure t
  :hook
  (after-init . which-key-mode)
  :config
  (setq which-key-popup-type 'minibuffer))

(use-package ido-vertical-mode
  :ensure t
  :hook
  (after-init . ido-vertical-mode))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-tokyo-night t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(use-package org
  :ensure t
  :after (org-bullets)
  :hook
  (org-mode . org-indent-mode)
  (org-mode . org-bullets-mode))

(use-package org-bullets
  :ensure t)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package nerd-icons
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(better-defaults)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
