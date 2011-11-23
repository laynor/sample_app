;; the variable directory contains the root directory of the rails project
(let ((filelist '("config/routes.rb" "spec/" "app/controllers/" "app/views")))
  (mapcar (lambda (x)
	    (find-file (concat directory x)))
	  filelist))
