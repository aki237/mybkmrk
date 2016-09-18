# mybkmrk - Yet another Crappy emacs package for project management

Simple project manager based on directories.
This package is crappy that you cannot get it from melpa.:P
Try git cloning this package to some directory and add this directory to the list of load-path.
The add some key bindings as you wish.
```lisp
(global-set-key (kbd "C-c C-p") 'mybkmrk/goto-project)        ;; Goto Project
(global-set-key (kbd "C-c C-a") 'mybkmrk/add-new-project)     ;; Add a new project
```
