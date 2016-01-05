;;; init.el --- Where all the magic begins
;;
;; Part of the Emacs Starter Kit
;;
;; This is the first thing to get loaded.

(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist'("\.text\'" . markdown-mode))
(add-to-list 'auto-mode-alist'("\.markdown\'" . markdown-mode))
(add-to-list 'auto-mode-alist'("\.md\'" . markdown-mode))

(setq load-path (append '("/home/ivan_hanigan/.emacs.d/polymode/" "/home/ivan_hanigan/.emacs.d/polymode/modes") load-path))
(require 'poly-R)
(require 'poly-markdown)


(find-file "~/Dropbox/org/overview.org")
(setq org-src-fontify-natively t)
(define-key global-map "\C-ca" 'org-agenda)

(global-set-key (kbd "<f2>")   'ess-r-args-show)




(define-skeleton org-journalentry
  "Template for a journal entry."
  "project:"
  "*** " (format-time-string "%Y-%m-%d %a") " \n"
  "**** TODO-list \n"
  "***** TODO \n"
  "**** timesheet\n"
  "#+begin_src txt :tangle work-log.csv :eval no :padline no\n"
  (format-time-string "%Y-%m-%d %a") ", " str ", 50\n"
  "#+end_src\n"
)
(global-set-key [C-S-f5] 'org-journalentry)

(define-skeleton org-skeleton
  "Header info for a emacs-org file."
  "Title: "
  "#+TITLE:" str " \n"
  "#+AUTHOR: Ivan Hanigan\n"
  "#+email: ivan.hanigan@anu.edu.au\n"
  "#+LaTeX_CLASS: article\n"
  "#+LaTeX_CLASS_OPTIONS: [a4paper]\n"
  "#+LATEX: \\tableofcontents\n"
  "-----"
 )
(global-set-key [C-S-f4] 'org-skeleton)


;; additions to C-c C-e t by http://orgmode.org/worg/org-tutorials/org-beamer/tutorial.html

(define-skeleton beamer-skeleton
  "Additional header info for a emacs-beamer file."
  "#+startup: beamer\n"
  "#+LaTeX_CLASS: beamer\n"
  "#+BEAMER_HEADER_EXTRA: \\institute[NCEPH]{National Centre for Epidemiology and Population Health (NCEPH) \\ ANU}\n"
  "#+LaTeX_CLASS_OPTIONS: [bigger]\n"
  "#+latex_header: \\mode<beamer>{\\usetheme{Madrid}}\n"
  "#+latex_header: \\usepackage{verbatim}\n"
  "#+BEAMER_FRAME_LEVEL: 2\n"
  "#+COLUMNS: \%40ITEM \%10BEAMER_env(Env) \%9BEAMER_envargs(Env Args) \%4BEAMER_col(Col) \%10BEAMER_extra(Extra)\n"
  "#+latex_header: \\AtBeginSection[]{\\begin{frame}<beamer>\\frametitle{Topic}\\tableofcontents[currentsection]\\end{frame}}\n"
 )
(global-set-key [C-S-f3] 'beamer-skeleton)


(define-skeleton newnode-skeleton
  "Info for a newnode chunk."
  "Title: "
  "#+end_src\n"
  "** " str "\n"
  "#+begin_src R :session *R* :tangle thesis/Hanigan-Thesis-Bridging2.Rmd :exports none :eval no\n"
  "\n"
)
(global-set-key [?\C-x ?\C-/] 'newnode-skeleton)

(define-skeleton chunk-skeleton
  "Info for a code chunk."
  "Title: "
  "*** COMMENT " str "\n"
  "#+name:" str "\n"
  "#+begin_src R :session *R* :tangle " str ".R :exports none :eval no\n"
  "#### name:" str " ####\n"
  "\n"
  "#+end_src\n"
)
(global-set-key [?\C-x ?\C-\\] 'chunk-skeleton)

(define-skeleton knit-skeleton
  "Info for a code chunk."
  "Title: "
  "** " str "\n"
  "*** Rmd\n"
  "#+name:" str "\n"
  "#+begin_src R :session *shell* :tangle IUCNcriteriaEmountainashforests_main_test_run.Rmd :exports none :eval no :padline yes \n"
  "## " str "\n"
  "```{r echo=T, eval = FALSE, results='hide'}\n"
  "#### name: " str " ####\n"
  "eval <- T\n"
  "if(eval){ \n"
  "load(file.path(indir,'.RData'))\n"
  "source(file.path(codedir,'" str ".R'))\n"
  "save.image(file.path(indir,'.RData'))\n"
  "}\n"
  "outdir <- indir \n"
  "```\n"
  "#+end_src\n"
  "*** R\n"
  "#+begin_src R :session *shell* :tangle " str ".R :exports none :eval no\n"
  "#### name: " str " ####\n"
  "setwd(projectdir)\n"
  "source(file.path(codedir, 'utils.R'))\n"
  "#+end_src\n"
)
(global-set-key [?\C-x ?\C-}] 'knit-skeleton)


(define-skeleton package-skeleton
  "Info for a package chunk."
  "Title: "
  "** " str "\n"
  "*** R-" str "\n"
  "#+name:" str "\n"
  "#+begin_src R :session *R* :tangle R/" str ".r :exports none :eval no\n"
  "################################################################\n"
  "# name:" str "\n"
  "\n"
  "#+end_src\n"
  "*** test-" str "\n"
  "#+name:" str "\n"
  "#+begin_src R :session *R* :tangle tests/test-" str ".r :exports none :eval no\n"
  "################################################################\n"
  "# name:" str "\n"
  "\n"
  "#+end_src\n"
  "*** man-" str "\n"
  "#+name:" str "\n"
  "#+begin_src R :session *R* :tangle man/" str ".Rd :exports none :eval no :padline no\n"
  "\n"
  "#+end_src\n"
)
(global-set-key [?\C-x ?\C-|] 'package-skeleton)

(define-skeleton markdown-skeleton
  "Info for a markdown plus code chunk pair."
  "Title: "
  "** " (format-time-string "%Y-%m-%d") "-" str "\n"
  "#+name:" str "-header\n"
  "#+begin_src markdown :tangle ~/projects/ivanhanigan.github.com.raw/_posts/" (format-time-string "%Y-%m-%d") "-" str ".md :exports none :eval no :padline no\n"
  "---\n"
  "name: " str "\n"
  "layout: post\n"
  "title: " str "\n"
  "date: " (format-time-string "%Y-%m-%d") "\n"
  "categories:\n"
  "-\n"
  "---\n"
  "\n"
  "#### Code:" str "\n"
  "    \n"
  "#+end_src\n"
)
(global-set-key [C-S-f6] 'markdown-skeleton)


(define-skeleton markdown2-skeleton
  "Info for a markdown2 chunk."
  "Title: "
  "#+name:" str "-header\n"
  "#+begin_src markdown :tangle " str ".md :exports reports :eval no :padline no\n"
  "---\n"
  "name: " str "\n"
  "layout: default\n"
  "title: " str "\n"
  "---\n"
  "\n"
  "    \n"
  "#+end_src\n"
)
(global-set-key [C-S-f8] 'markdown2-skeleton)

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

(define-skeleton inserttable-skeleton
  "Info for a table."
  "table file: "
  "* " str "\n"
  "Shown in Table \\ref{tab:table1} is ... \n"
  "\\input{tab1.tex}\n"
  "** code\n"
  "#+name:" str "\n"
  "#+begin_src R :session *R* :tangle no :exports none :eval no\n"
  "################################################################\n"
  "# name:" str "\n"
  "x <- read.csv('" str "')\n"
  "require(xtable)\n"
  "sink('tab1.tex')\n"
  "print(xtable(x, caption = 'Region Codes', label = 'tab:table1',\n"
  "  digits = 2), table.placement = 'ht',\n"
  "  caption.placement = 'top',include.rownames=F)\n"
  "sink()\n"
  "#+end_src\n"
  )
(global-set-key [?\C-x ?\C->] 'inserttable-skeleton)

;; org-mode windmove compatibility
(setq org-replace-disputed-keys t)

;; setq dotfiles-dir (file-name-directory (or (buffer-file-name) load-file-name)))
(setq dotfiles-dir (file-name-directory (or load-file-name (buffer-file-name))))


(add-to-list 'load-path (expand-file-name
                         "lisp" (expand-file-name
                                 "org" (expand-file-name
                                        "src" dotfiles-dir))))

;; Package Locations
;; Location of various local packages (in .emacs.d/vendor or .emacs.d/src)
;;  because I don't want to keep them in =/Applications/Emacs.app/= or in
;;  =/usr/share/local/=.

(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
    (let* ((my-lisp-dir "~/.emacs.d/")
           (default-directory my-lisp-dir))
      (setq load-path (cons my-lisp-dir load-path))
      (normal-top-level-add-subdirs-to-load-path)))

;; Font-face setup. Check the availability of a some default fonts, in
;; order of preference. The first of these alternatives to be found is
;; set as the default font, together with base size and fg/bg
;; colors. If none of the preferred fonts is found, nothing happens
;; and Emacs carries on with the default setup. We do this here to
;; prevent some of the irritating flickering and resizing that
;; otherwise goes on during startup. You can reorder or replace the
;; options here with the names of your preferred choices.

(defun font-existsp (font)
  "Check to see if the named FONT is available."
  (if (null (x-list-fonts font))
      nil t))

;; Set default font. First one found is selected.
(cond
 ((eq window-system nil) nil)
 ((font-existsp "PragmataPro")
  (set-face-attribute 'default nil :height 141 :font "PragmataPro"))
 ((font-existsp "Menlo")
  (set-face-attribute 'default nil :height 141 :font "Menlo"))
 ((font-existsp "Consolas")
  (set-face-attribute 'default nil :height 141 :font "Consolas"))
 ((font-existsp "Inconsolata")
  (set-face-attribute 'default nil :height 141 :font "Inconsolata"))
 )

;; Load up Org Mode and Babel
(require 'org-install)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)))


;; load up the main file
(org-babel-load-file (expand-file-name "starter-kit.org" dotfiles-dir))

;;; init.el ends here
(put 'downcase-region 'disabled nil)
