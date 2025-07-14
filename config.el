;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Set up input method
(setq default-input-method "russian-computer")
(map! "C-'" #'toggle-input-method)

(map! :leader
      :desc "Browse dotfiles"
      "f d" #'(lambda () (interactive) (dired "~/.dotfiles")))


(after! python-black
  (add-hook! 'python-mode-hook #'python-black-on-save-mode)

  (map! :leader :desc "Blacken Buffer" "m b b" #'python-black-buffer)
  (map! :leader :desc "Blacken Region" "m b r" #'python-black-region)
  (map! :leader :desc "Blacken Statement" "m b s" #'python-black-statement)
  )

(after! dap-mode
  (setq dap-auto-configure-mode t)
  (require 'dap-node)
  ;; (dap-node-setup)

  (require 'dap-python)
  (setq dap-python-debugger 'debugpy)
  (map! :leader :desc "Dap Hydra" "d" #'(lambda () (interactive) (dap-hydra))))

(after! lsp-rust
  (setq lsp-rust-analyzer-cargo-watch-command "clippy"))

(after! obsidian
  (obsidian-specify-path "~/braindump")

  (map! :leader :desc "Obsidian" "n o" nil)
  (map! :leader :desc "Follow at point" "n o f" 'obsidian-follow-link-at-point)
  (map! :leader :desc "Jump to note" "n o o" 'obsidian-jump)
  (map! :leader :desc "Tag find" "n o t" 'obsidian-tag-find)
  (map! :leader :desc "Search by expression" "n o s" 'obsidian-search)
  (map! :leader :desc "Insert wikilink" "n o w" 'obsidian-insert-wikilink)
  (map! :leader :desc "Insert link" "n o l" 'obsidian-insert-link)
  (map! :leader :desc "Capture new note" "n o c" 'obsidian-capture)
  (map! :leader :desc "Rescan" "n o r" 'obsidian-update)

  (global-obsidian-mode t))

(after! evil
  (defun my/display-set-relative ()
    (setq display-line-numbers 'relative))

  (defun my/display-set-absolute ()
    (setq display-line-numbers t))

  (add-hook! 'evil-insert-state-entry-hook #'my/display-set-absolute)
  (add-hook! 'evil-insert-state-exit-hook #'my/display-set-relative)

  (setq display-line-numbers-current-absolute t))

(after! poly-markdown
  (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode)))

(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (c-set-offset 'substatement-open 0)
  ;; other customizations can go here

  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4)                  ;; Default is 2
  (setq c-indent-level 4)                  ;; Default is 2

  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
  (setq indent-tabs-mode t)  ; use spaces only if nil
  )

(add-hook! 'c-mode-common-hook 'my-c-mode-common-hook)

(after! renpy
  (add-hook! 'renpy-mode-hook 'visual-line-mode))

;; transparent window for rice
(set-frame-parameter (selected-frame) 'alpha-background 95)
(add-to-list 'default-frame-alist '(alpha-background . 95))
(after! solaire-mode
  (solaire-global-mode -1))
(custom-set-faces
 '(default ((t (:background "#12121A"))))
 '(hl-line ((t (:background "#12121A"))))
 '(mode-line ((t (:background "#12121A"))))
 )

(use-package! xclip
  :config
  (setq xclip-program "wl-copy")
  (setq xclip-select-enable-clipboard t)
  (setq xclip-mode t)
  (setq xclip-method (quote wl-copy)))

;; (setq-hook! 'js-mode-hook +format-with-lsp nil)
;; (setq-hook! 'js-mode-hook +format-with :none)
;; (add-hook 'js-mode-hook 'prettier-js-mode)

(setq +format-on-save-disabled-modes
      '(emacs-lisp-mode  ; elisp's mechanisms are good enough
        sql-mode         ; sqlformat is currently broken
        tex-mode         ; latexindent is broken
        latex-mode
        ein-ipynb-mode))

(add-to-list 'exec-path "/usr/local/texlive/2024/bin/x86_64-linux")
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/texlive/2024/bin/x86_64-linux"))
(map! :leader :desc "Preview mode" "m j" #'latex-preview-pane-mode)

(use-package! proof-general
  :custom
  (proof-colour-locked nil))

(use-package! uv-mode
  :hook (python-mode . uv-mode-auto-activate-hook))

(define-derived-mode astro-mode web-mode "astro")
(setq auto-mode-alist
      (append '((".*\\.astro\\'" . astro-mode))
              auto-mode-alist))

(use-package! direnv
  :config
  (direnv-mode))
