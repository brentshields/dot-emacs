(require 'package)

(setq package-archives '(;; ("gnu" . "http://elpa.gnu.org/packages/")
			 ;; ("marmalade" . "https://marmalade-repo.org/packages/")
                         ;; ("org" . "http://orgmode.org/elpa/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

;; This bootstraps us if we don't have anything
(when (not package-archive-contents)
  (package-refresh-contents))

(defun ensure-installed (p)
  (when (not (package-installed-p p))
    (package-install p)))

(ensure-installed 'better-defaults)

(ensure-installed 'qml-mode)

(ensure-installed 'exec-path-from-shell)
(exec-path-from-shell-initialize)

(ensure-installed 'magit)
(load "rebase-mode.el" 'noerror)

(defalias 'yes-or-no-p 'y-or-n-p)

(set-default 'indicate-empty-lines t)
(column-number-mode)

(ensure-installed 'haskell-mode)
(eval-after-load 'haskell-mode
  '(add-hook 'haskell-mode-hook #'turn-on-haskell-indentation))

(eval-after-load 'haskell-mode
  '(font-lock-add-keywords
    'haskell-mode
    `(("\\(->\\)"
       (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                 (string-to-char "→")))))
      ("\\(<-\\)"
       (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                 (string-to-char "←")))))
      ("\\(\\\\\\)"
       (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                 (string-to-char "λ"))))))))

(ensure-installed 'purescript-mode)

(ensure-installed 'markdown-mode)

(ensure-installed 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

(ensure-installed 'solarized-theme)
(load-theme 'solarized-dark t)
(set-frame-parameter nil 'background-mode 'dark)

(set-face-attribute 'default nil :family "Andale Mono")
(set-face-attribute 'default nil :height 220)
(add-to-list 'default-frame-alist '(height . 49))

;; Add local delete trailing whitespace hook
(defun no-whitespace()
  (add-hook 'local-write-file-hooks
            '(lambda () (save-excursion (delete-trailing-whitespace)))))

;; Gyp handling
(add-to-list 'auto-mode-alist '("\\.gyp\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.gypi\\'" . python-mode))
(add-hook 'python-mode-hook (lambda ()
                              (no-whitespace)
                              (setq python-indent-offset 4)))

(defun c-like()
  (auto-fill-mode)
  (c-set-style "bsd")
  (setq c-basic-offset 2)
  (setq indent-tabs-mode nil)
  (c-set-offset 'innamespace 0)
  (no-whitespace))

;; objc
(add-hook 'objc-mode-hook 'c-like)

;; c
(add-hook 'c-mode-hook 'c-like)

;; c++
(add-hook 'c++-mode-hook 'c-like)

;; clang format
(ensure-installed 'clang-format)
;;(add-hook
;; 'c++-mode-hook
;; (lambda ()
;;   (add-hook 'local-write-file-hooks
;;             '(lambda () (save-excursion (clang-format-buffer))))))
(defalias 'uglify 'clang-format-buffer)

;; js
(add-hook `js-mode-hook (lambda () (no-whitespace) (setq js-indent-level 2)))

(ensure-installed 'ansi-color)
(ignore-errors
  (require 'ansi-color)
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))

(ensure-installed 'jade-mode)

(ensure-installed 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;;(add-to-list 'auto-mode-alist '("\\.js?\\'" . web-mode))
(setq web-mode-content-types-alist
  '(("jsx" . "\\.js[x]?\\'")))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (set-face-attribute 'web-mode-html-tag-bracket-face nil :foreground "#8DE6F4")
  (no-whitespace)
)

(add-hook 'web-mode-hook 'my-web-mode-hook)

(add-hook 'yaml-mode-hook
          (lambda ()
            (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(add-hook 'purescript-mode-hook 'turn-on-purescript-indentation)

(ensure-installed 'typescript-mode)

(defun my-typescript-hook ()
  (setq typescript-indent-level 2)
)
(add-hook 'typescript-mode-hook 'my-typescript-hook)

(ensure-installed 'graphql-mode)

(ensure-installed 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(menu-bar-mode -1)
(tool-bar-mode -1)
