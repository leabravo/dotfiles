(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

(package-install 'use-package)
(require 'use-package)

(use-package better-defaults
  :ensure t)

(use-package guru-mode
  :ensure t
  :config
  (guru-global-mode t))

(use-package god-mode
  :ensure t
  :hook
  (after-init . god-mode)
  :bind
  ("C-M-]" . god-mode-all))

;; If colors are weird, export COLORTERM=truecolor
;; run (frame-toggle-fullscreen) and press Super+Up
(global-prettify-symbols-mode)

(add-to-list 'default-frame-alist '(drag-internal-border . 1))
(add-to-list 'default-frame-alist '(internal-border-width . 5))
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package nerd-icons
  :ensure t)

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-tokyo-night))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-modal t)
  (setq doom-modeline-modal-icon t)
  (setq doom-modeline-modal-modern-icon t))

(use-package helm
  :ensure t
  :hook (after-init . helm-mode)
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("M-g i" . helm-imenu))

(use-package helm-descbinds
  :ensure t
  :hook (after-init . helm-descbinds-mode))

(use-package org-modern
  :ensure t
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(use-package nyan-mode
  :ensure t
  :hook (after-init . nyan-mode))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-tooltip-align-annotations t)
  (setq company-backends '((company-capf company-dabbrev-code))))

(add-hook 'python-mode-hook 'python-ts-mode)
(add-hook 'python-ts-mode-hook 'eglot-ensure)

(use-package go-ts-mode
  :ensure t
  :mode "\\.go\\'"
  :hook
  (go-ts-mode . eglot-ensure)
  (go-ts-mode . (lambda () (add-hook 'before-save-hook #'eglot-format-buffer)))
  (go-ts-mode . (lambda () (add-hook 'before-save-hook #'eglot-code-action-organize-imports)))
  :custom
  (go-ts-mode-indent-offset 4))
