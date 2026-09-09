;;(setq inhibit-startup-message t)
(global-display-line-numbers-mode 1)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
;;(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
;;(setq visible-bell t)
(setq ring-bell-function #'ignore)

(add-to-list 'default-frame-alist '(font . "Iosevka Term-20"))

(load-theme 'wombat)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package command-log-mode)

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
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; (use-package doom-modeline
  ;; :ensure t
   ;;:init (doom-modeline-mode 1)
   ;;:custom ((doom-modeline-height 15)))

;; (load-theme 'catppuccin :no-confirm)
;;(use-package doom-themes
  ;;:ensure t
   ;;:config
   ;;(load-theme 'doom-winter-is-coming-dark-blue t))
(use-package ef-themes
  :ensure t
  :config
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t)
  (modus-themes-load-theme 'ef-tritanopia-dark))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; Date and time
(setq display-time-format "%I:%M %p")
(setq display-time-default-load-average nil)
(display-time-mode 1)

;; Remove the time from its default position
(setq global-mode-string
      (remove 'display-time-string global-mode-string))

;; Put the time at the far right
(setq-default mode-line-format
              (append
               (remove 'mode-line-format-right-align
                       (remove 'display-time-string mode-line-format))
               '(mode-line-format-right-align
                 display-time-string)))
