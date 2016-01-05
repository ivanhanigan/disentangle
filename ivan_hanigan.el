
(add-hook 'latex-mode-hook
          (lambda ()
            (set-face-attribute 'font-latex-sectioning-5-face nil :inherit nil :foreground "#b58900")
            (set-face-attribute 'font-latex-sectioning-0-face nil :height 3)
            (set-face-attribute 'font-latex-sectioning-1-face nil :height 2)
            (set-face-attribute 'font-latex-sectioning-2-face nil :height 1.5)
            (set-face-attribute 'font-latex-sectioning-3-face nil :height 1.2)
            (set-face-attribute 'font-latex-sectioning-4-face nil :height 1.0)))

 (add-hook 'org-mode-hook
           (lambda ()
             (set-face-attribute 'org-level-1 nil :height 1.5)
             (set-face-attribute 'org-level-2 nil :height 1.2)
             (set-face-attribute 'org-level-3 nil :height 1.1)
             (set-face-attribute 'org-level-4 nil :height 1.1)
             (set-face-attribute 'org-level-5 nil :height 1.1)))

(defun fullscreen (&optional f)
  (interactive)
  (set-frame-parameter f 'fullscreen
                       (if (frame-parameter f 'fullscreen) nil 'fullboth)))
(global-set-key (kbd "C-c f") 'fullscreen)
(add-hook 'after-make-frame-functions 'fullscreen)

(load "dired-x")

(eval-after-load "dired"
'(progn
   (define-key dired-mode-map "F" 'my-dired-find-file)
   (defun my-dired-find-file (&optional arg)
     "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
     (interactive "P")
     (let* ((fn-list (dired-get-marked-files nil arg)))
       (mapc 'find-file fn-list)))))

(require 'stripe-buffer)
(add-hook 'org-mode-hook 'org-table-stripes-enable)
(add-hook 'dired-mode-hook 'stripe-listify-buffer)

(setq TeX-open-quote "“")
(setq TeX-close-quote "”")

;; Synctex with Skim
  (add-hook 'TeX-mode-hook
  (lambda ()
  (add-to-list 'TeX-output-view-style
  '("^pdf$" "."
   "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o %b")))
   )

(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
     '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))

(server-start); start emacs in server mode so that skim can talk to it

  ;; Make emacs aware of multi-file projects
  ;; (setq-default TeX-master nil)

  ;; Auto-raise Emacs on activation (from Skim, usually)
  (defun raise-emacs-on-aqua()
  (shell-command "osascript -e 'tell application \"Emacs\" to activate' &"))
  (add-hook 'server-switch-hook 'raise-emacs-on-aqua)

;; Make RefTex able to find my local bib files
(setq reftex-bibpath-environment-variables
'("/Users/kjhealy/Library/texmf/bibtex/bib"))

;; Default bibliography
(setq reftex-default-bibliography
'("/Users/kjhealy/Documents/bibs/socbib.bib"))


;; CDLaTex minor mode: tab-trigger environments, paired paren
;; insertion, etc
;; (autoload 'cdlatex-mode "cdlatex" "CDLaTeX Mode" t)
;; (autoload 'turn-on-cdlatex "cdlatex" "CDLaTeX Mode" nil)
;; (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX
;;                                         ; mode

;; set which characters are autopaired // Doesn't work. Set in custom, below.
;; (add-hook 'cdlatex-mode-hook
;;   (function (lambda ()
;;               (setq cdlatex-paired-parens
;;                     '("$[{("))
;;             )))

(fset 'run-vc-then-xelatex
[?\M-! ?v ?c return ?\C-c ?\C-c return])
(global-set-key (kbd "C-c c") 'run-vc-then-xelatex);; Run the VC command before running xelatex
(fset 'run-vc-then-xelatex
[?\M-! ?v ?c return ?\C-c ?\C-c return])
(global-set-key (kbd "C-c c") 'run-vc-then-xelatex)

(global-set-key (kbd "C-c v")
                    (lambda ()
                      (interactive)
                      (shell-command "vc")))

(load "pandoc-mode")
(add-hook 'markdown-mode-hook 'turn-on-pandoc)
(add-hook 'TeX-mode-hook 'turn-on-pandoc)
(add-hook 'pandoc-mode-hook 'pandoc-load-default-settings)

(setq ibuffer-saved-filter-groups
    '(("home"
       ("emacs-config" (or (filename . ".emacs.d")
                           (filename . "emacs-config")))
       ("Org" (or (mode . org-mode)
                  (filename . "OrgMode")))
       ("Web Dev" (or (mode . html-mode)
                      (mode . css-mode)))
       ("Magit" (name . "\*magit"))
       ("ESS" (mode . ess-mode))
       ("LaTeX" (mode . latex-mode))
       ("Help" (or (name . "\*Help\*")
                   (name . "\*Apropos\*")
                   (name . "\*info\*"))))))

      (add-hook 'ibuffer-mode-hook
                   '(lambda ()
                   (ibuffer-switch-to-saved-filter-groups "home")))
     (setq ibuffer-show-empty-filter-groups nil)
     (setq ibuffer-expert t)
     (add-hook 'ibuffer-mode-hook
     '(lambda ()
     (ibuffer-auto-mode 1)
     (ibuffer-switch-to-saved-filter-groups "home")))

(setq org-archive-location "~/Dropbox/Org/archive.org::From %s")

;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/MobileOrg")
;; Set to the files (or directory of files) you want sync'd
(setq org-agenda-files (quote (
                               "~/projects/ivanhanigan.github.com.raw"
                               "~/Dropbox/org/overview.org")))
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/org/from-mobile.org")

(setq org-src-window-setup 'current-window)

(require 'org-latex)
  ;; Choose either listings or minted for exporting source code blocks.
  ;; Using minted (as here) requires pygments be installed. To use the
  ;; default listings package instead, use
  ;; (setq org-export-latex-listings t)
  ;; and change references to "minted" below to "listings"
  ;;(setq org-export-latex-listings 'minted)
  (setq org-export-latex-listings t)

  ;; default settings for minted code blocks
  ;;(setq org-export-latex-minted-options
  (setq org-export-latex-listings-options
        '(;("frame" "single")
          ("bgcolor" "bg") ; bg will need to be defined in the preamble of your document. It's defined in org-preamble-pdflatex.sty and org-preamble-xelatex.sty below.
          ("fontsize" "\\small")
          ))
;; turn off the default toc behavior; deal with it properly in headers to files.
(defun org-export-latex-no-toc (depth)
    (when depth
      (format "%% Org-mode is exporting headings to %s levels.\n"
              depth)))
(setq org-export-latex-format-toc-function 'org-export-latex-no-toc)

  (add-to-list 'org-export-latex-classes
               '("memarticle"
                 "\\documentclass[11pt,oneside,article]{memoir}\n\\input{vc} % vc package"
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}" . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-export-latex-classes
               '("membook"
                 "\\documentclass[11pt,oneside]{memoir}\n\\input{vc} % vc package"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

  ;; Originally taken from Bruno Tavernier: http://thread.gmane.org/gmane.emacs.orgmode/31150/focus=31432
  ;; but adapted to use latexmk 4.22 or higher.
  (defun my-auto-tex-cmd ()
    "When exporting from .org with latex, automatically run latex,
                     pdflatex, or xelatex as appropriate, using latexmk."
    (let ((texcmd)))
    ;; default command: pdflatex
    (setq texcmd "latexmk -pdflatex='pdflatex -synctex=1 --shell-escape --' -pdf %f")
    ;; pdflatex -> .pdf
    (if (string-match "LATEX_CMD: pdflatex" (buffer-string))
        (setq texcmd "latexmk -pdflatex='pdflatex -synctex=1 --shell-escape' -pdf %f"))
    ;; xelatex -> .pdf
    (if (string-match "LATEX_CMD: xelatex" (buffer-string))
        (setq texcmd "latexmk -pdflatex='xelatex -synctex=1 --shell-escape' -pdf %f"))
    ;; LaTeX compilation command
    (setq org-latex-to-pdf-process (list texcmd)))

  (add-hook 'org-export-latex-after-initial-vars-hook 'my-auto-tex-cmd)

  ;; Default packages included in /every/ tex file, latex, pdflatex or xelatex
  (setq org-export-latex-packages-alist
        '(("" "graphicx" t)
          ("" "longtable" nil)
          ("" "float" )))

  ;; Custom packages
  (defun my-auto-tex-parameters ()
    "Automatically select the tex packages to include. See https://github.com/kjhealy/latex-custom-kjh for the support files included here."
    ;; default packages for ordinary latex or pdflatex export
    (setq org-export-latex-default-packages-alist
          '(("AUTO" "inputenc" t)
      ("" "hyperref" t)))
    ;;        ("minted,minion" "org-preamble-pdflatex" t)))
    ;; Packages to include when xelatex is used
    (if (string-match "LATEX_CMD: xelatex" (buffer-string))
        (setq org-export-latex-default-packages-alist
              '(("minted" "org-preamble-xelatex" t) ))))

  (add-hook 'org-export-latex-after-initial-vars-hook 'my-auto-tex-parameters)

(org-add-link-type "ebib" 'ebib)

 (org-add-link-type
   "cite" 'ebib
   (lambda (path desc format)
     (cond
      ((eq format 'latex)
       (if (or (not desc) (equal 0 (search "cite:" desc)))
             (format "\\cite{%s}" path)
             (format "\\cite[%s]{%s}" desc path)
             )))))

 (org-add-link-type
   "parencite" 'ebib
   (lambda (path desc format)
     (cond
      ((eq format 'latex)
       (if (or (not desc) (equal 0 (search "parencite:" desc)))
             (format "\\parencite{%s}" path)
             (format "\\parencite[%s]{%s}" desc path)
)))))

(org-add-link-type
   "textcite" 'ebib
   (lambda (path desc format)
     (cond
      ((eq format 'latex)
       (if (or (not desc) (equal 0 (search "textcite:" desc)))
             (format "\\textcite{%s}" path)
             (format "\\textcite[%s]{%s}" desc path)
)))))

(org-add-link-type
   "autocite" 'ebib
   (lambda (path desc format)
     (cond
      ((eq format 'latex)
       (if (or (not desc) (equal 0 (search "autocite:" desc)))
             (format "\\autocite{%s}" path)
         (format "\\autocite[%s]{%s}" desc path)
)))))

(org-add-link-type
 "footcite" 'ebib
 (lambda (path desc format)
   (cond
    ((eq format 'latex)
     (if (or (not desc) (equal 0 (search "footcite:" desc)))
         (format "\\footcite{%s}" path)
       (format "\\footcite[%s]{%s}" desc path)
       )))))

(org-add-link-type
 "fullcite" 'ebib
 (lambda (path desc format)
   (cond
    ((eq format 'latex)
     (if (or (not desc) (equal 0 (search "fullcite:" desc)))
         (format "\\fullcite{%s}" path)
       (format "\\fullcite[%s]{%s}" desc path)
       )))))

(org-add-link-type
 "citetitle" 'ebib
 (lambda (path desc format)
   (cond
    ((eq format 'latex)
     (if (or (not desc) (equal 0 (search "citetitle:" desc)))
         (format "\\citetitle{%s}" path)
       (format "\\citetitle[%s]{%s}" desc path)
       )))))

(org-add-link-type
 "citetitles" 'ebib
 (lambda (path desc format)
   (cond
    ((eq format 'latex)
     (if (or (not desc) (equal 0 (search "citetitles:" desc)))
         (format "\\citetitles{%s}" path)
       (format "\\citetitles[%s]{%s}" desc path)
       )))))

(org-add-link-type
   "headlessfullcite" 'ebib
   (lambda (path desc format)
     (cond
      ((eq format 'latex)
       (if (or (not desc) (equal 0 (search "headlessfullcite:" desc)))
             (format "\\headlessfullcite{%s}" path)
             (format "\\headlessfullcite[%s]{%s}" desc path)
)))))

(setq org-publish-project-alist
       '(("org"
          :base-directory "~/.emacs.d/"
          :publishing-directory "~/Documents/websites/esk/"
          :auto-sitemap t
          :sitemap-filename "index.org"
          :sitemap-title "Emacs Starter Kit for the Social Sciences: Documentation"
          :section-numbers t
          :table-of-contents nil
          :style "<link rel=\"stylesheet\"
                 href=\"http://kieranhealy.org/stylesheets/screen.css\"
                 type=\"text/css\"/>")))

  (setq org-export-html-style-extra "")
  (setq org-export-html-postamble nil)

;; connect to irc on invocation but don't autojoin any channels
(require 'rcirc)
(add-to-list 'rcirc-server-alist
                     '("irc.freenode.net"))

;; Line-spacing tweak (Optimized for PragmataPro)
(setq-default line-spacing 5)

;; minimize fringe
(setq-default indicate-empty-lines nil)

;; Add keybindings for commenting regions of text
(global-set-key (kbd "C-c ;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-'") 'comment-or-uncomment-region)

;; Base dir
(cd "~/")

;; custom variables kludge. Why can't I get these to work via setq?
(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
'(LaTeX-XeTeX-command "xelatex -synctex=1")
'(TeX-engine (quote xetex))
;; '(TeX-view-program-list (quote (("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o %b"))))
;; '(TeX-view-program-selection (quote (((output-dvi style-pstricks) "dvips and gv") (output-dvi "xdvi") (output-pdf "Skim") (output-html "xdg-open"))))
'(show-paren-mode t)
'(blink-cursor-mode nil)
'(text-mode-hook (quote (text-mode-hook-identify)))
)
