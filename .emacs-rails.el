;; the variable directory contains the root directory of the rails project
(let ((filelist '("Gemfile" "README.markdown")))
  (mapcar (lambda (x)
	    (find-file (concat directory x)))
	  filelist))
