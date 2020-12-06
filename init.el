(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))


(setq use-package-always-ensure t)

(use-package rust-mode
  :ensure t
  )

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  )

(use-package ag
  :ensure t
  )

(use-package cmake-mode
  :ensure t
  )

(use-package evil-indent-plus
  :ensure t
  :after evil
  :config
  (evil-indent-plus-default-bindings)
  )

(use-package evil-snipe
  :ensure t
  :after evil
  :config
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  )

(use-package flymake
  :ensure t
  :config
  (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
  )

(use-package evil-easymotion
  :ensure t
  :after evil
  :config
  (evilem-default-keybindings "SPC")
  )

(use-package evil-commentary
  :ensure t
  :after evil
  :config
  (evil-commentary-mode)
  )

;; (load-theme 'zenburn t)
(use-package zenburn-theme
  :ensure t
  :init
  (load-theme 'zenburn t)
  )

;; use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Turn off backups
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; remove top menu bar
(menu-bar-mode -1)

;; setup yassnippet for template auto completion
;; allows for pressing tab to jump to next parameter
(use-package yasnippet
  :ensure t
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  )

;; setup eglot and company mode for lsp based syntax checking and
;; company mode auto-complete
(use-package company
  :ensure t
  :init
  (setq company-transformers nil)
  ;; see flymake errors (from eglot) on cursor hover
  (add-hook 'after-init-hook 'global-company-mode)
  )

(use-package web-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (setq web-mode-code-indent-offset 2)
  )

(use-package eglot
  :ensure t
  :config
  (advice-add 'eglot-eldoc-function :around
              (lambda (oldfun)
                (let ((help (help-at-pt-kbd-string)))
                  (if help (message "%s" help) (funcall oldfun)))))
  ;; look in build/private for compile_commands.json
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) . ("ccls" "-init={\"compilationDatabaseDirectory\": \"build/private\"}")))
  (add-to-list 'eglot-server-programs '((rust-mode) . ("rls")))
  (add-to-list 'eglot-server-programs '((web-mode) . ("javascript-typescript-stdio")))
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c++-mode-hook 'eglot-ensure)
  (add-hook 'rust-mode-hook 'eglot-ensure)
  (add-hook 'web-mode-hook 'eglot-ensure)
  )

;; don't let company mode sory ccls server returned data
(setq-default c-basic-offset 4)


(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; relative line numbering
(use-package linum-relative
  :ensure t
  :init
  (linum-relative-global-mode)
  (global-linum-mode 1)
  )

(use-package plantuml-mode
  :ensure t
  :init
  (setq plantuml-jar-path (substitute-in-file-name "$HOME/.emacs.d/jar/plantuml.jar"))
  (setq plantuml-default-exec-mode 'jar)
  (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
  )



(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after treemacs evil
  :ensure t)

(with-eval-after-load 'evil-maps
  (define-key evil-normal-state-map (kbd "C-n") nil))
(global-set-key (kbd "C-n") 'treemacs)

(use-package evil-org
  :ensure t
  :after org
  :init
  (setq evil-want-C-i-jump nil)
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; (use-package smartparens-config
(use-package smartparens
  :ensure t
  :config
  (add-hook 'c++-mode-hook #'smartparens-mode)
  (add-hook 'c-mode-hook #'smartparens-mode)
  )

(use-package evil-magit
  :ensure t
  :after evil magit
  )

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind
  (:map projectile-mode-map
        ("s-p" . projectile-command-map)
        ("C-c p" . projectile-command-map)
        )
  )

(use-package helm
  :ensure t
  :init
  (helm-mode 1)
  (setq helm-ff-auto-update-initial-value t)
  :config
  (setq projectile-completion-system 'helm)
  :bind
  (:map helm-find-files-map
              ("TAB" . helm-execute-persistent-action))
  (:map global-map
        ("M-x" . helm-M-x)
        ([remap find-file] . helm-find-files)
        ([remap recentf-open-files] . helm-recentf)
        ([remap projectile-switch-to-buffer] . helm-projectile-switch-to-buffer)
        ([remap projectile-recentf] . helm-projectile-recentf)
        ([remap projectile-find-file] . helm-projectile-find-file)
        )
  )

;; Improve the auto-mode-interpreter-regexp to include envroot
;; interpreters in addition to bare env-prefixed interpreters.
;;
;; This regexp supports the following interpreter formats (at
;; minimum):
;;
;; /bin/env python
;; /usr/bin/env python
;; /apollo/bin/env python
;; /apollo/sbin/envroot "$ENVROOT/bin/python"
;;
(setq auto-mode-interpreter-regexp "#![ 	]?\\([^
]*/s?bin/env[a-z_]*[ 	]\\)?\\(?:.*/\\)?\\([^
\"']+\\)")

;; highlight matching parenthesis
(show-paren-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil helm-ag helm projectile evil-indent-plus evil-easymotion evil-commentary evil-snipe smartparens evil-org transpose-frame plantuml-mode evil-magit magit cmake-mode yasnippet-snippets yasnippet treemacs-evil treemacs linum-relative lsp-mode company eglot zenburn-theme evil-visual-mark-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
