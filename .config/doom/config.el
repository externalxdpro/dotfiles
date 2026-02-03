(add-hook 'c++-mode-hook
  (lambda ()
    (if buffer-file-name
      (let* ((src (file-name-nondirectory (buffer-file-name)))
             (exe (file-name-sans-extension src)))
        (setq-local compile-command (concat "make " exe " && timeout 1s ./" exe))
))))

(after! lsp-clangd
  (setq lsp-clients-clangd-args
        '("-j=3"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=iwyu"
          "--header-insertion-decorators=0"))
  (set-lsp-priority! 'clangd 2))

;; (setq company-selection-wrap-around t)

;; ;; Have snippets come up before keywords
;; (setq +lsp-company-backends '(:separate company-yasnippet company-capf))

;; (after! company
;;   (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
;;   (define-key company-active-map (kbd "TAB") 'company-complete-selection)
;;   (define-key company-active-map (kbd "C-SPC") 'company-abort)
;;   (define-key company-active-map (kbd "RET") nil)
;;   (define-key company-active-map (kbd "<return>") nil)

;;   (company-prescient-mode 1))

(after! corfu
  (setq! corfu-preselect 'first))
(map! :after corfu
      :map corfu-map
      :i "TAB" #'corfu-complete
      :i "<tab>" #'corfu-complete
      :i "C-SPC" #'corfu-quit
      :i "<backspace>" #'evil-delete-backward-char-and-join)

(after! dape
  (setq! dape-info-buffer-window-groups '((dape-info-scope-mode)
                                          (dape-info-watch-mode dape-info-stack-mode dape-info-modules-mode dape-info-sources-mode)
                                          (dape-info-breakpoints-mode dape-info-threads-mode)))

  (defun my/codelldb-path ()
    "If codelldb is in the path, return it, if not, return the default directory"
    (if (executable-find "codelldb")
        "codelldb"
      "/home/sakib/.config/doom/debug-adapters/codelldb/extension/adapter/codelldb"))

  ;; C/C++ config
  (add-to-list 'dape-configs
               `(codelldb-cc
                 modes (c-mode c-ts-mode c++-mode c++-ts-mode)
                 command-args ("--port" :autoport)
                 ensure dape-ensure-command
                 command-cwd dape-command-cwd
                 command my/codelldb-path
                 port :autoport
                 :type "lldb"
                 :request "launch"
                 :cwd "."
                 :program (read-file-name "Select a file to debug: ")
                 :args []
                 :stopOnEntry nil))
  ;; Rust config
  (add-to-list 'dape-configs
               `(codelldb-rust
                 modes (rust-mode rust-ts-mode)
                 command-args ("--port" :autoport "--settings" "{\"sourceLanguages\":[\"rust\"]}")
                 ensure dape-ensure-command
                 command-cwd dape-command-cwd
                 command my/codelldb-path
                 port :autoport
                 :type "lldb"
                 :request "launch"
                 :cwd "."
                 :program (read-file-name "Select a file to debug: ")
                 :args []
                 :stopOnEntry nil))

  (defhydra dape-hydra (:hint nil)
    "
^Stepping^           ^Breakpoints^               ^Info
^^^^^^^^-----------------------------------------------------------
_n_: Next            _bb_: Toggle (add/remove)   _si_: Info
_i_/_o_: Step in/out   _bd_: Delete                _sm_: Memory
_<_/_>_: Stack up/down _bD_: Delete all            _ss_: Select Stack
_c_: Continue        _bl_: Set log message       _R_: Repl
_r_: Restart
            _d_: Init   _k_: Kill   _q_: Quit
"
    ("n" dape-next)
    ("i" dape-step-in)
    ("o" dape-step-out)
    ("<" dape-stack-select-up)
    (">" dape-stack-select-down)
    ("c" dape-continue)
    ("r" dape-restart)
    ("bb" dape-breakpoint-toggle)
    ("be" dape-breakpoint-expression)
    ("bd" dape-breakpoint-remove-at-point)
    ("bD" dape-breakpoint-remove-all)
    ("bl" dape-breakpoint-log)
    ("si" dape-info)
    ("sm" dape-memory)
    ("ss" dape-select-stack)
    ("R"  dape-repl)
    ("d" dape)
    ("k" dape-kill :color blue)
    ("q" dape-quit :color blue))
  )

(map! :after dape
      :map dape-global-map
      :leader
      "d" nil ;; Clear pre-existing keybindings
      :prefix "d"
      ;; basics
      :desc "Start"                      "d" #'dape
      :desc "Next"                       "n" #'dape-next
      :desc "Step in"                    "i" #'dape-step-in
      :desc "Step out"                   "o" #'dape-step-out
      :desc "Continue"                   "c" #'dape-continue
      :desc "Hydra"                      "h" #'dape-hydra/body
      :desc "Restart"                    "r" #'dape-restart
      :desc "Evaluate expression"        "e" #'dape-evaluate-expression
      :desc "Toggle watch expression"    "w" #'dape-watch-dwim
      :desc "Quit"                       "q" #'dape-quit

      ;; misc
      :desc "Toggle info buffers" "I" #'dape-info
      :desc "Select stack up"     "<" #'dape-stack-select-up
      :desc "Select stack down"   ">" #'dape-stack-select-down
      :desc "Select stack"        "s" #'dape-select-stack
      :desc "Select thread"       "t" #'dape-select-thread
      :desc "Disconnect"          "D" #'dape-disconnect-quit
      :desc "Memory"              "m" #'dape-memory
      :desc "Disassemble"         "M" #'dape-disassemble
      :desc "Pause"               "p" #'dape-pause
      :desc "REPL"                "R" #'dape-repl

      ;; breakpoints
      :prefix ("db" . "breakpoint")
      :desc "Toggle"     "b" #'dape-breakpoint-toggle
      :desc "Expression" "e" #'dape-breakpoint-expression
      :desc "Hit count"  "h" #'dape-breakpoint-hits
      :desc "Log"        "l" #'dape-breakpoint-log
      :desc "Remove"     "d" #'dape-breakpoint-remove-at-point
      :desc "Remove all" "D" #'dape-breakpoint-remove-all)

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-find-file
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-up-directory
  (kbd "% l") 'dired-downcase
  (kbd "% u") 'dired-upcase
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'nsxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "nsxiv")
                              ("jpg" . "nsxiv")
                              ("png" . "nsxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")

(setq doom-theme 'doom-one)

(after! eglot
  (map! :leader
        (:prefix ("t" . "toggle")
         :desc "LSP inlay hints" "L" #'eglot-inlay-hints-mode))
  (require 'dape))

(add-hook 'after-make-frame-functions
  (lambda (frame) (elcord-mode 1)))
(add-hook 'after-delete-frame-functions
  (lambda (frame)
    (if (eq (- (length (visible-frame-list)) 1) 0) (elcord-mode 0))))

(setq elcord-editor-icon "emacs_icon")

(use-package! emojify
  :hook (after-init . global-emojify-mode))

(setq browse-url-browser-function 'eww-browse-url)
(map! :leader
      :desc "Search web for text between BEG/END"
      "s w" #'eww-search-words
      (:prefix ("e" . "evaluate/EWW")
       :desc "Eww web browser" "w" #'eww
       :desc "Eww reload page" "R" #'eww-reload))

(setq doom-font (font-spec :family "Caskaydia Cove Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "Avenir Next LT Pro" :size 17)
      doom-big-font (font-spec :family "Caskaydia Cove Nerd Font" :size 24)
      mixed-pitch-set-height t)
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))
(add-hook 'text-mode-hook 'mixed-pitch-mode)

(setq-hook! 'rjsx-mode-hook +format-with-lsp nil)
(setq-hook! 'typescript-mode-hook +format-with-lsp nil)

(after! js
  (setq-default js--prettify-symbols-alist '()))

(after! lsp-mode
  (map! :leader
        (:prefix ("t" . "toggle")
         :desc "LSP inlay hints" "L" #'lsp-inlay-hints-mode))
  (setq lsp-ui-peek-always-show t)
  (setq lsp-inlay-hint-enable t)
  (setq lsp-headerline-breadcrumb-enable t))

(after! ox-latex
  (add-to-list 'org-latex-classes
             '("org-plain-latex"
               "\\documentclass{article}
           [NO-DEFAULT-PACKAGES]
           [PACKAGES]
           [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))


(use-package! engrave-faces
  :config
  (setq org-latex-src-block-backend 'engraved))

(defun my-leetcode () (interactive)
  (leetcode)
  (leetcode-set-prefer-language)

  (setq leetcode-directory
        (cdr (assoc leetcode-prefer-language
                    '(("cpp"     . "~/repos/LeetcodeSolutions/CPP")
                      ("csharp"  . "~/repos/LeetcodeSolutions/CS")
                      ("python3" . "~/repos/LeetcodeSolutions/Python")
                      ("rust"    . "~/repos/LeetcodeSolutions/Rust/src/bin"))))))

(map! :leader
      :prefix ("l" . "leetcode")
      :desc "leetcode"            "l" #'my-leetcode)
(map! :map leetcode-solution-mode-map
      :leader
      :prefix "l"
      :desc "reset layout"        "r" #'leetcode-restore-layout
      :desc "try"                 "t" #'leetcode-try
      :desc "submit"              "s" #'leetcode-submit
      :desc "quit"                "q" #'leetcode-quit
      :desc "set prefer language" "L" #'leetcode-set-prefer-language
      :desc "daily"               "d" #'leetcode-daily)

(after! leetcode
  (setq leetcode-save-solutions t))

(setq display-line-numbers-type 'relative)
(pixel-scroll-precision-mode 1)
(map! :leader
      :desc "Comment or uncomment lines" "TAB TAB" #'comment-line
      (:prefix ("t" . "toggle")
       :desc "Toggle line numbers" "l" #'doom/toggle-line-numbers
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle truncate lines" "t" #'toggle-truncate-lines))

;; (defvar my-mu4e-account-alist
;;   '(("acc1-domain"
;;      (mu4e-sent-folder "/acc1-domain/Sent")
;;      (mu4e-drafts-folder "/acc1-domain/Drafts")
;;      (mu4e-trash-folder "/acc1-domain/Trash")
;;      (mu4e-compose-signature
;;        (concat
;;          "Ricky Bobby\n"
;;          "acc1@domain.com\n"))
;;      (user-mail-address "acc1@domain.com")
;;      (smtpmail-default-smtp-server "smtp.domain.com")
;;      (smtpmail-smtp-server "smtp.domain.com")
;;      (smtpmail-smtp-user "acc1@domain.com")
;;      (smtpmail-stream-type starttls)
;;      (smtpmail-smtp-service 587))
;;     ("acc2-domain"
;;      (mu4e-sent-folder "/acc2-domain/Sent")
;;      (mu4e-drafts-folder "/acc2-domain/Drafts")
;;      (mu4e-trash-folder "/acc2-domain/Trash")
;;      (mu4e-compose-signature
;;        (concat
;;          "Suzy Q\n"
;;          "acc2@domain.com\n"))
;;      (user-mail-address "acc2@domain.com")
;;      (smtpmail-default-smtp-server "smtp.domain.com")
;;      (smtpmail-smtp-server "smtp.domain.com")
;;      (smtpmail-smtp-user "acc2@domain.com")
;;      (smtpmail-stream-type starttls)
;;      (smtpmail-smtp-service 587))
;;     ("acc3-domain"
;;      (mu4e-sent-folder "/acc3-domain/Sent")
;;      (mu4e-drafts-folder "/acc3-domain/Drafts")
;;      (mu4e-trash-folder "/acc3-domain/Trash")
;;      (mu4e-compose-signature
;;        (concat
;;          "John Boy\n"
;;          "acc3@domain.com\n"))
;;      (user-mail-address "acc3@domain.com")
;;      (smtpmail-default-smtp-server "smtp.domain.com")
;;      (smtpmail-smtp-server "smtp.domain.com")
;;      (smtpmail-smtp-user "acc3@domain.com")
;;      (smtpmail-stream-type starttls)
;;      (smtpmail-smtp-service 587))))

(load "~/.config/doom/email.el")

(defun my-mu4e-set-account ()
  "Set the account for composing a message."
  (let* ((account
          (if mu4e-compose-parent-message
              (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
                (string-match "/\\(.*?\\)/" maildir)
                (match-string 1 maildir))
            (completing-read (format "Compose with account: (%s) "
                                     (mapconcat #'(lambda (var) (car var))
                                                my-mu4e-account-alist "/"))
                             (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
                             nil t nil nil (caar my-mu4e-account-alist))))
         (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
        (mapc #'(lambda (var)
                  (set (car var) (cadr var)))
              account-vars)
      (error "No email account found"))))

(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

(setq org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil \\n:t"
      org-msg-startup "hidestars indent inlineimages"
      org-msg-greeting-fmt "\nHi%s,\n\n"
      org-msg-greeting-name-limit 3
      org-msg-default-alternatives '((new		. (text html))
				     (reply-to-html	. (text html))
				     (reply-to-text	. (text)))
      org-msg-convert-citation t
      org-msg-signature "

#+begin_signature
Thanks,
*Sakib*
/Sent from Emacs/
#+end_signature")

(after! mu4e
  (setq mu4e-update-interval (* 5 60)                            ;; get emails and index every 5 minutes
        mu4e-get-mail-command "mbsync-update ~/.config/mbsyncrc" ;; set a custom sync command with my own script
        mu4e-compose-format-flowed t                             ;; send emails with format=flowed
        mu4e-index-cleanup nil                                   ;; don't do a full cleanup check
        mu4e-index-lazy-check t                                  ;; don't consider up-to-date dirs
        mu4e-notification-support nil                            ;; disable built-in notifications
        mu4e-alert-style 'libnotify                              ;; set notification style for mu4e-alert
        mu4e-alert-email-notification-types  '(subjects))        ;; set notification style for mu4e-alert
  (add-hook 'message-sent-hook #'kill-buffer)                    ;; auto-close message buffer after mail is sent
  (mu4e-alert-enable-notifications))                             ;; enable mu4e-alert

(mu4e t)                                                         ;; check for emails in the background

(xterm-mouse-mode 1)

(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "xdg-open")

(use-package! org-alert
  :config
  (setq alert-default-style 'libnotify
        org-alert-interval 300
        org-alert-notification-title "Org Alert Reminder!"
        org-alert-notify-cutoff 10
        org-alert-notify-after-event-cutoff 10)
  (org-alert-enable))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq org-directory "~/Sync/Notes/"
        org-agenda-files (directory-files-recursively "~/Sync/Notes/agenda/" "\\.org$")
        org-agenda-span 'month
        org-log-done 'time
        org-hide-emphasis-markers t
        org-attach-id-dir "./.attach")
  (add-to-list 'org-agenda-custom-commands '("X" agenda "" nil ("/tmp/agenda.html")))
  (run-at-time 20 600 #'org-store-agenda-views))

(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.4))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
)

(after! org
  (use-package! org-gcal
    :init
    ;; (setq org-gcal-client-id ""
    ;;       org-gcal-client-secret ""
    ;;       org-gcal-file-alist '(("" . "~/org/calendar.org")))
    (load "~/.config/doom/gcal.el")
    (setq org-gcal-token-file nil
          org-gcal-notify-p t)))

(after! org-roam
  (setq! org-roam-directory "~/Sync/Notes/roam/"))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(after! org-roam
  (map! :map doom-leader-map
        :desc "Show graph" "n r g" #'org-roam-ui-mode
        :map org-mode-map
        :localleader
        "m g" #'org-roam-ui-mode ))

(after! org-tree-slide
  (advice-remove 'org-tree-slide--display-tree-with-narrow
                 #'+org-present--hide-first-heading-maybe-a)
  (setq-local cwm-frame-internal-border 100)
  (org-tree-slide-presentation-profile))

(add-hook 'rustic-mode-hook
  (lambda ()
    (if (string= (car (last (string-split (file-name-directory buffer-file-name) "/") 2)) "bin")
      (let* ((bin (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
        (setq-local rustic-run-arguments (concat "--bin " bin))))))

(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))
