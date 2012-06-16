;; ~/.emacs
;; git@github.com:ivanhanigan/disentangle.git
;; 2012-05-23
;; NOTES
;; set up to work with Emacs24 with orgmode and ESS on WinXP
;; inspiration taken from http://kieranhealy.org/emacs-starter-kit.html
;; and http://kieranhealy.org//blog/archives/2012/04/23/updates-to-the-emacs-starter-kit-for-the-social-sciences/

;; -*- mode: elisp -*-
(find-file  "I:/My Dropbox/org/overview.org")
;;disable the splash screen (to enable it agin, replace the t with 0)
(setq inhibit-splash-screen t)
(setq org-startup-truncated nil)
;;enable syntax highlighting
(global-font-lock-mode t)
(transient-mark-mode 1)
(defun jbr-init ()
  "Called from term-setup-hook after the default
terminal setup is
done or directly from startup if term-setup-hook not
used.  The value
0xF030 is the command for maximizing a window."
  (interactive)
  (w32-send-sys-command #xf030)
  (ecb-redraw-layout)
  (calendar)
)
(setq term-setup-hook 'jbr-init)
(setq window-setup-hook 'jbr-init)
;;;;org-mode configuration
;;enable org-mode
;;(require 'org)
(require 'org-install)
;;make org-mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(load "C:/ess/ess-5.14/lisp/ess-site")
(define-key ess-mode-map [f2] 'ess-r-args-show)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "I:/My Dropbox/org/overview.org"))
     (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
        (R . t)))

(define-skeleton org-skeleton
  "Header info for a emacs-org file."
  "Title: "
  "#+TITLE:" str " \n"
  "#+AUTHOR: Ivan Hanigan\n"
  "#+email: ivan.hanigan@anu.edu.au\n"
  "#+LaTeX_CLASS: article\n"
  "#+LaTeX_CLASS_OPTIONS: [a4paper]\n"
  "-----"
 )
(global-set-key [C-S-f4] 'org-skeleton)

(define-skeleton newnode-skeleton
  "Info for a newnode chunk."
  "Title: "
  "#+name:" str "\n"
  "#+begin_src R :session *R* :tangle analysis/transformations_overview.r :exports none :eval no\n"
  "\n"
"newnode(dsc='" str "', clearpage = F, ttype='transformations', nosectionheading = T,\n"
" o = '" str "',append = T,end_doc = F,\n"
" notes='',echoCode = FALSE,\n"
" code=NA)\n"
  "#+end_src\n"
)
(global-set-key [?\C-x ?\C-/] 'newnode-skeleton)

(define-skeleton chunk-skeleton
  "Info for a code chunk."
  "Title: "
  "#+name:" str "\n"
  "#+begin_src R :session *R* :tangle go.r :exports none :eval no\n"
  "\n"
  "#+end_src\n"
)
(global-set-key [?\C-x ?\C-\\] 'chunk-skeleton)

(define-skeleton insertgraph-skeleton
  "Info for a insertgraph."
  "graph file: "
  "\\begin{figure}[!h]\n"
  "\\centering\n"
  "\\includegraphics[width=\\textwidth]{" str "}\n"

  "\\caption{" str "}\n"
  "\\label{fig:" str "}\n"
  "\\end{figure}\n"
  "\\clearpage\n"
)
(global-set-key [?\C-x ?\C-.] 'insertgraph-skeleton)





;; Adapted with one minor change from Felipe Salazar at
;; http://www.emacswiki.org/emacs/EmacsSpeaksStatistics

(setq ess-ask-for-ess-directory nil)
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
(defun my-ess-start-R ()
  (interactive)
  (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
      (progn
        (delete-other-windows)
        (setq w1 (selected-window))
        (setq w1name (buffer-name))
        (setq w2 (split-window w1 nil t))
        (R)
        (set-window-buffer w2 "*R*")
        (set-window-buffer w1 w1name))))
(defun my-ess-eval ()
  (interactive)
  (my-ess-start-R)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-region)
    (call-interactively 'ess-eval-line-and-step)))
(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(add-hook 'inferior-ess-mode-hook
          '(lambda()
             (local-set-key [C-up] 'comint-previous-input)
             (local-set-key [C-down] 'comint-next-input)))
(add-hook 'Rnw-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(require 'ess-site)

    ;; aspell is the spell checker that works for me
    (setq-default ispell-program-name "C:\\Program Files\\Aspell\\bin\\aspell.exe")
    (setq text-mode-hook '(lambda()
                             (flyspell-mode t)       ; spellchek (sic) on the fly
                             ))
							 
;;to display time
(display-time)

;;to set the cursor color
(set-cursor-color "red")

;;to set the font
(set-frame-font "-outline-Consolas-normal-r-normal-normal-14-90-96-96-c-*-iso8859-1")

;;to set foreground color to white
;;(set-foreground-color "white")
(set-foreground-color "white")
;;to set background color to black
;;(set-background-color "black")
(set-background-color "#1f1f1f")
;;(set-face-background 'ac-candidate-face "#366060")
;;(set-face-foreground 'ac-selection-face "#1f1f1f")
;;(set-face-background 'ac-selection-face "#8cd0d3")
;;(set-face-foreground 'ac-selection-face "#1f1f1f")

(global-set-key [C-tab] 'other-window)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-skip-scheduled-if-done t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

