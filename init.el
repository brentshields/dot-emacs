(require 'package)

(setq package-archives '(;; ("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")))
                         ;; ("org" . "http://orgmode.org/elpa/")
                         ;;("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

;; This bootstraps us if we don't have anything
(when (not package-archive-contents)
  (package-refresh-contents))

(defun ensure-installed (p)
  (when (not (package-installed-p p))
    (package-install p)))

(ensure-installed 'better-defaults)

(ensure-installed 'exec-path-from-shell)
(exec-path-from-shell-initialize)

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

(ensure-installed 'markdown-mode)

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

(ensure-installed 'color-theme-solarized)
(load-theme 'solarized-dark t)

(set-face-attribute 'default nil :family "Andale Mono")
(set-face-attribute 'default nil :height 140)
(add-to-list 'default-frame-alist '(height . 49))

(add-hook 'c++-mode-hook
  (lambda ()
    (auto-fill-mode)
    (c-set-style "bsd")
    (setq c-basic-offset 2)
    (setq indent-tabs-mode nil)
    (c-set-offset 'innamespace 0)
    (add-hook 'local-write-file-hooks
      '(lambda() (save-excursion (delete-trailing-whitespace))))))
