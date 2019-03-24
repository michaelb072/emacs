(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(irony-eldoc irony company-lsp rtags cmake-ide lsp-mode evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'evil)
(evil-mode 1)

(load-theme 'zenburn t)

;; ccls config ;;
(require 'projectile)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Clang support
(use-package ccls
  :ensure t
  :hook ((c-mode c++-mode) .
         (lambda () (require 'ccls) (lsp)))
  :init
  (setq ccls-executable "/usr/local/bin/run-ccls.sh")
  )
(with-eval-after-load 'projectile
  (setq projectile-project-root-files-top-down-recurring
        (append '("compile_commands.json"
                  ".ccls")
                projectile-project-root-files-top-down-recurring)))

(use-package lsp-mode
  :init
  (require 'lsp-clients)
  (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)
  :hook ((python-mode . lsp)
	 (lsp-after-open . (lambda () (lsp-enable-imenu))))
  
  :preface (setq lsp-enable-flycheck 1
                 lsp-enable-indentation nil
                 lsp-highlight-symbol-at-point nil))
(use-package lsp-ui
  :config
  (setq lsp-ui-sideline-ignore-duplicate t
	lsp-ui-doc-position "top")
  :hook (lsp-mode . lsp-ui-mode))

(use-package company-lsp
  :config
  (setq
   company-lsp-async t
   company-lsp-enable-snippet t
   company-lsp-enable-recompletion t
   company-lsp-cache-candidates t)
  (push 'company-lsp company-backends))

(provide 'init-lsp)

(setq ccls-sem-highlight-method 'overlay)
(setq-default c-basic-offset 4)

;; Turn on line numbers
(global-display-line-numbers-mode)

;; Turn off backups
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files
