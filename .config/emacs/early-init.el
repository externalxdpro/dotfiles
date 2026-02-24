(setq package-enable-at-startup nil)

;; Performance settings
(setq gc-cons-threshold 100000000) ;; 100 MB

;; Improve performance with language servers.
(setq read-process-output-max (* 1024 1024)) ;; 1 MB

;; Improve tree-sitter performance
(setenv "LSP_USE_PLISTS" "true")
(setq lsp-use-plists t)

;; Make scratch buffer initial buffer
(setq inhibit-splash-screen t
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-buffer-menu t)

