(require 'package)
(package-initialize)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
    (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
    (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
    (add-to-list 'package-archives
	         '("melpa-stable" . "https://stable.melpa.org/packages/") t)
    (add-to-list 'package-archives
                 '("org" . "https://orgmode.org/elpa/") t)
    (add-to-list 'package-archives
                 '("org-plus-contrib" . "https://orgmode.org/elpa/") t)
    ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
    ;; and `package-pinned-packages`. Most users will not need or want to do this.
    (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
    )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "nil" :family "Fira Code")))))

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(unless (package-installed-p 'org-plus-contrib)
  (package-refresh-contents)
  (package-install 'org-plus-contrib))
(require 'org)

(use-package better-defaults
  :init
  :ensure t)

(use-package doom-modeline
  :ensure t
  :requires all-the-icons
  :init (doom-modeline-mode 1))
;; M-x all-the-icons-install-fonts

(use-package atom-one-dark-theme
  :ensure t
  :init (load-theme 'atom-one-dark))

;; Org-Id
(require 'org-id)
(require 'org-archive)
(setq org-id-link-to-org-use-id t)

;; Update ID file on startup
(org-id-update-id-locations)

(use-package htmlize
  :init
  :ensure t)

(use-package deft
  :init
  :ensure t)

;;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; load evil
(use-package evil
  :ensure t ;; install the evil package if not installed
  :init ;; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config ;; tweak evil after loading it
  (evil-mode)
  ;; example how to map a command in normal mode (called 'normal state' in evil)
    (define-key evil-normal-state-map (kbd ", w") 'evil-window-vsplit))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package emojify
  :ensure t
  :init (global-emojify-mode))

;; Python Configurations
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package company
  :ensure t
  :config
  (progn
    (add-hook 'after-init-hook 'global-company-mode)))

(use-package py-autopep8
  :ensure t
  :init)

(use-package blacken
  :ensure t
  :init)

(use-package elpy
  :ensure t
  :requires (flycheck py-autopep8 blacken company)
  :init)

;; PUBLISHING
(require 'ox-publish)
(require 'ox-rss)
(setq org-publish-project-alist
      '(
	("blog-notes"
	 :base-directory "~/blog/src"
	 :base-extension "org"
	 :publishing-directory "~/blog/public_html/"
	 :recursive t
	 :publishing-function org-html-publish-to-html
	 :auto-preamble nil
	 :with-toc t
         :htmlized-source t
         :html-doctype "html5"
	 :html-html5-fancy t
         :htmlized-source t
         :html-container nil
         :with-todo-keywords t
	 :html-todo-kwd-class-prefix t
	 :auto-sitemap t
	 :sitemap-title "Index"
	 :sitemap-filename "index.org"
         :html-head-include-default-style nil
         :html-head-extra "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/style.css\" />"
         )
	
	("blog-static"
	 :base-directory "~/blog/src"
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	 :publishing-directory "~/blog/public_html"
	 :recursive t
	 :publishing-function org-publish-attachment
	 )
        
        ("blog-rss"
	 :base-directory "~/blog/src"
	 :base-extension "org"
         :recursive nil
	 :publishing-directory "~/blog/public_html/"
	 :publishing-function (org-rss-publish-to-rss)
	 :html-link-home "http://www.leetdatageek.com/"
	 :html-link-use-abs-url t
         :rss-extension "xml"
         :section-numbers nil
         :exclude ".*"
         :include ("index.org")
         :table-of-contents nil
         )

        ("blog" :components ("blog-notes" "blog-static" "blog-rss"))
        ))

(defun org-capture-at-point ()
  "Insert an org capture template at point."
  (interactive)
  (org-capture 0))

(global-set-key (kbd "C-c c") #'org-capture-at-point)

(setq org-capture-templates
      '(("l" "Link nofollow" plain (file "") "{{{a(%?,%x)}}}")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (emojify elpy magit evil deft htmlize atom-one-dark-theme doom-modeline better-defaults org-plus-contrib use-package))))
