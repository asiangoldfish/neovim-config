;; Prevent startup message
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
;; TODO pick a good font (face: "font name")
(set-face-attribute 'default nil :font "Noto Mono 14" :height 120)
;; Default theme
(load-theme 'wombat)

;; Magic editor ruler for specific modes
(setq-default fill-column 80)

(setq-default show-trailing-whitespace nil)

;; ------------------------------ ;;
;;             Fixes              ;;
;; -------------------------------;;
;; Fix Control+Backspace so it doesn't delete too much
(defun aborn/backward-kill-word ()
  "Customize/Smart backward-kill-word."
  (interactive)
  (let*((cp (point))
	 (backword)
         (end)
         (space-pos)
         (backword-char (if (bobp)
                          ""           ;; cursor in begin of buffer
                          (buffer-substring cp (- cp 1)))))
    (if (equal (length backword-char) (string-width backword-char))
      (progn
        (save-excursion
          (setq backword (buffer-substring (point) (progn (forward-word -1) (point)))))
        (setq ab/debug backword)
        (save-excursion
          (when (and backword          ;; when backword contains space
                  (s-contains? " " backword))
            (setq space-pos (ignore-errors (search-backward " ")))))
        (save-excursion
          (let* ((pos (ignore-errors (search-backward-regexp "\n")))
                  (substr (when pos (buffer-substring pos cp))))
            (when (or (and substr (s-blank? (s-trim substr)))
                    (s-contains? "\n" backword))
              (setq end pos))))
        (if end
          (kill-region cp end)
          (if space-pos
            (kill-region cp space-pos)
            (backward-kill-word 1))))
      (kill-region cp (- cp 1)))         ;; word is non-english word
    ))

(global-set-key  [C-backspace]
  'aborn/backward-kill-word)


;; ------------------------------ ;;
;;           Elisp Mode           ;;
;; ------------------------------ ;;
;; Set tab size
(setq lisp-indent-offset 2)

;; ------------------------------ ;;
;;         Latex Support          ;;
;; ------------------------------ ;;
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

;; -------------------------------;;
;; Initialize package sources     ;;
;; -------------------------------;;
(require 'package)

;; All package repositories
(setq package-archives '(("org" . "https://orgmode.org/elpa/")
			  ("elpa" . "https://elpa.gnu.org/packages/")))
(add-to-list 'package-archives
  '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

;; Possibly excessive?
(unless package-archive-contents
  (refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Get package loader:
;; https://github.com/jwiegley/use-package
;; Basic syntax:
;; (use-package XXXXX)
(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t) ;; Enable line numbers

;; Remove line numbers for some modes
(defun do-not-display-line-numbers-mode-hook()
  "Hook to disable line-number-mode"
  (display-line-numbers-mode 0))

;; TODO: Remove line numbers for the listed modes
(dolist (mode '(org-mode-hook
		 term-mode-hook
		 shell-mode-hook
		 eshell-mode-hook))
  (add-hook 'mode #'do-not-display-line-numbers-mode-hook))

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
  :bind(
	 ;; Extended M-x
	 ("M-x" . counsel-M-x)
	 ;; List all opened buffers
	 ("C-x b" . counsel-ibuffer)
	 ;; Find a file
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; don't start searches with ^

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons)

;; Nice status bar
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15))
  )

;; Nice theming
(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; List all available combinations for an activated key
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; Gives counsel-M-x description for each command
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Make help pages more helpful
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package general
  :config
  ;; Function for future key generation
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "C-SPC"))

;; Example usage: (unset-space-key emacs-lisp-mode-map)
(defun rune/evil-hook()
  (dolist (mode '(custom-mode
		   eshell-mode
		   git-rebase-mode
		   erc-mode
		   circe-server-mode
		   circe-chat-mode
		   circe-query-mode
		   sauron-mode
		   term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

;; Vim key bindings
;; If need to go back to Emacs mode, use C-z
(use-package evil
  ;; evil-want configures evil-mode the way we want
  :init
  (setq evil-want-ingegration t)
  (setq evil-want-keybinding nil) ;; turn off this
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))
  
;; Project manager
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile ; Better integration with ivy
  :config (counsel-projectile-mode))

;; Configure orgmode
(defun goldfish/org-mode-setup()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq org-adapt-indentation t)
  (setq evil-auto-indent nil))

;; Org: Get the latest version
(use-package org
  :hook (org-mode . goldfish/org-mode-setup)
  :config
  (setq org-ellipsis " ⮟")  ; Appears when collapsing blocks
  org-hide-emphasis-markers t
  (goldfish/org-mode-setup)) ; Hide formatting characters



;; Org: Heading better bullet list
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))
;(set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
;(org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Org: Scale up headings
 (dolist (face '((org-level-1 . 1.4)
        	 (org-level-2 . 1.35)
        	 (org-level-3 . 1.25)
        	 (org-level-4 . 1.2)
        	 (org-level-5 . 1.1)
        	 (org-level-6 . 1.1)
        	 (org-level-7 . 1.1)
        	 (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

;; Org: Ensure that anything that should be fixed-pitch appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-table nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(ord-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

;; Org: Latex support
;; https://github.com/io12/org-fragtog
(use-package org-fragtog)
(add-hook 'org-mode-hook 'org-fragtog-mode)

;; Org: Centralize the text editor
(defun goldfish/org-mode-visual-fill()
  (setq visual-fill-column-width 100
    visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :defer t
  :hook (org-mode . goldfish/org-mode-visual-fill))

;; ----------------------- ;;
;;   Custom variables      ;;
;; ----------------------- ;;
;; Do NOT edit the below! They are auto-generated

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

