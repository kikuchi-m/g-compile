(defvar g-compile-repository-dir "")
(defvar g-compile-projects '())

(defun g-compile-gen-ninja (&optional all v)
  (format "ninja %s -C %s"
          (if all "" (mapconcat 'identity g-compile-projects " "))
          (format "out/%s" (if v v "Debug"))))

(defun g-compile-ninja (&optional all v)
  (interactive)
  (compile (format "cd %s &&  %s"
                   g-compile-repository-dir
                   (g-compile-gen-ninja all v))))

(defun g-compile-runhooks (&optional all v)
  (interactive "P")
  (compile (format "cd %s && gclient runhooks && %s"
                   g-compile-repository-dir
                   (g-compile-gen-ninja all v))))

(defun g-compile-set-repository (&optional dir)
  (interactive (list (read-directory-name "Repository dir: " nil nil t)))
  (setq g-compile-repository-dir dir))

(defun g-compile-projects-prompt (&optional ini)
  (read-string "Projects (space separated): " (if ini ini) ""))

(defun g-compile-add-projects (&optional projects)
  (interactive)
  (let* ((input
          (if (called-interactively-p 'interactive)
              (g-compile-projects-prompt)
            (if projects projects "")))
         (proj (split-string input " " t)))
    (message "-> %s" proj)
    (setq g-compile-projects (append proj g-compile-projects))))

(defun g-compile-reset-projects (&optional projects)
  (interactive)
  (defun --reset () (setq g-compile-projects nil))
  (g-compile-add-projects
   (if (called-interactively-p 'interactive)
       (let ((ini (mapconcat 'identity g-compile-projects " ")))
         (--reset)
         (g-compile-projects-prompt ini))
     (--reset)
     projects)))

(provide 'g-compile)

















