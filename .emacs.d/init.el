
(setq inhibit-startup-message t)

(scroll-bar-mode -1)    ; disable visible scrollbar
(tool-bar-mode -1)      ; disable the toolbar
(tooltip-mode -1)       ; disable the tooltips
(set-fringe-mode 10)    ; give some breathing room

(menu-bar-mode -1)      ; disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Font family and size
(set-face-attribute 'default nil :height 150)

(load-theme 'wombat)

;; -------------------------------;;
;; Initialize package sources     ;;
;; -------------------------------;;
(require 'package)

;; All package repositories
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package install 'use-package))

;; Get package loader:
;; https://github.com/jwiegley/use-package
;; Basic syntax:
;; (use-package XXXXX)
(require 'use-package)
(setq use-package-always-ensure t)

;; Key log actions
(use-package command-log-mode)

;;-----;;
;; Ivy ;;
;;-----;;
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-search-kill))
  :init (ivy-mode 1))

;; counsel provides great fuzzy find functionalities
(use-package counsel
  :bind(("M-x" . counsel-M-x)
	("C-x b" . counsel-ibuffer)
	("C-x C-f" . counsel-find-file)
	:map minibuffer-local-map
	("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; don't start searches with ^

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15))
)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(doom-modeline doom-modelinne counsel ivy command-log-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

