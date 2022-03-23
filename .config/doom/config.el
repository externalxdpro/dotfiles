(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)

(use-package dashboard
  :init      ;; tweak dashboard config before loading it
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "\nKEYBINDINGS:\
\nFind file               (SPC .)     \
Open buffer list    (SPC b i)\
\nFind recent files       (SPC f r)   \
Open the eshell     (SPC e s)\
\nOpen dired file manager (SPC d d)   \
List of keybindings (SPC h b b)")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "~/.config/doom/doom-emacs-dash.png")  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 5)
                          (projects . 5)
                          (registers . 5)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book"))))

(setq doom-fallback-buffer "*dashboard*")

(setq doom-theme 'doom-one)
(map! :leader
      :desc "Load new theme" "h t" #'counsel-load-theme)

(elcord-mode)

(use-package emojify
  :hook (after-init . global-emojify-mode))

(setq browse-url-browser-function 'eww-browse-url)
(map! :leader
      :desc "Search web for text between BEG/END"
      "s w" #'eww-search-words
      (:prefix ("e" . "evaluate/EWW")
       :desc "Eww web browser" "w" #'eww
       :desc "Eww reload page" "R" #'eww-reload))

(setq display-line-numbers-type t)
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

(require 'org-msg)
(setq org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil"
      org-msg-startup "indent inlineimages"
      org-msg-greeting-fmt "\nHi *%s*,\n\n"
      org-msg-greeting-name-limit 3
      org-msg-signature "
      Regards,

   #+begin_signature
   -- *{your-name}* \\\\
   /Sent from my Emacs/
   #+end_signature")
(org-msg-mode)

(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "firefox")

(setq mu4e-update-interval 300         ;; get emails and index every 5 minutes
      mu4e-compose-format-flowed t     ;; send emails with format=flowed
      mu4e-index-cleanup nil           ;; don't do a full cleanup check
      mu4e-index-lazy-check t)         ;; don't consider up-to-date dirs

(xterm-mouse-mode 1)

(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))
(map! :leader
      :desc "Toggle neotree file viewer" "t n" #'neotree-toggle
      :desc "Open directory in neotree" "d n" #'neotree-dir)

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq org-directory "~/Notes/"
        org-agenda-files '("~/Notes/agenda.org")
        org-log-done 'time))
