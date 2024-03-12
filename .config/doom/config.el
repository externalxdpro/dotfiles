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

(setq company-selection-wrap-around t)

;; Have snippets come up before keywords
(setq +lsp-company-backends '(:separate company-yasnippet company-capf))

(after! company
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (define-key company-active-map (kbd "TAB") 'company-complete-selection)
  (define-key company-active-map (kbd "C-SPC") 'company-abort)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "<return>") nil)

  (company-prescient-mode 1))

(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"                "n" #'dap-next
      :desc "dap step in"             "i" #'dap-step-in
      :desc "dap step out"            "o" #'dap-step-out
      :desc "dap continue"            "c" #'dap-continue
      :desc "dap hydra"               "h" #'dap-hydra
      :desc "dap debug"               "s" #'dap-debug
      :desc "dap debug restart"       "r" #'dap-debug-restart
      :desc "dap disconnect"          "k" #'dap-disconnect
      :desc "dap delete all sessions" "K" #'dap-delete-all-sessions

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent" "r" #'dap-debug-recent
      :desc "dap debug last"   "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)

(after! dap-mode
  (setq dap-python-debugger 'debugpy)
  (require 'dap-netcore)

  (require 'dap-codelldb)
  (setq dap-auto-configure-features '(sessions locals controls tooltip))
  (dap-register-debug-template
   "LLDB::Run C++"
   (list :type "lldb"
         :request "launch"
         :name "LLDB::Run C++"
         :miDebuggerPath "/usr/bin/lldb-mi"
         :cwd "${workspaceFolder}"
         :program "${fileDirname}/${fileBasenameNoExtension}"))
  (dap-register-debug-template
   "LLDB::Run Rust"
   (list :type "lldb"
         :request "launch"
         :name "LLDB::Run Rust"
         :miDebuggerPath "~/.cargo/bin/rust-lldb"
         :cwd "${workspaceFolder}"
         :program "${workspaceFolder}/target/debug/${fileBasenameNoExtension}"))
)

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

(setq doom-theme 'doom-one)

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

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 15)
      doom-variable-pitch-font (font-spec :family "Avenir Next LT Pro" :size 17)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 24)
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
  (setq lsp-ui-peek-always-show t)
  (setq lsp-inlay-hint-enable t))

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

(setq org-msg-signature "
      Regards,

   #+begin_signature
   -- *{your-name}* \\\\
   /Sent from my Emacs/
   #+end_signature")

(after! mu4e
  (setq mu4e-update-interval (* 5 60)                       ;; get emails and index every 5 minutes
    mu4e-get-mail-command "mbsync -a -c ~/.config/mbsyncrc" ;; set a custom sync command
    mu4e-compose-format-flowed t                            ;; send emails with format=flowed
    mu4e-index-cleanup nil                                  ;; don't do a full cleanup check
    mu4e-index-lazy-check t))                               ;; don't consider up-to-date dirs

(mu4e t)        ;; check for emails in the background

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
  (setq org-directory "~/nc/Notes/"
        org-agenda-files (directory-files-recursively "~/nc/Notes/agenda/" "\\.org$")
        org-log-done 'time
        org-hide-emphasis-markers t))

(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.4))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
)

(after! org-tree-slide
  (advice-remove 'org-tree-slide--display-tree-with-narrow
                 #'+org-present--hide-first-heading-maybe-a)
  (setq-local cwm-frame-internal-border 100)
  (org-tree-slide-presentation-profile))

(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))
