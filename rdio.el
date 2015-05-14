;;; rdio.el --- Control Rdio Desktop App from Emacs
;; Copyright 2015 Horace Williams
;;
;; Author: Horace Williams <horacedwilliams@gmail.com>
;; Maintainer: Horace Williams <horacedwilliams@gmail.com>
;; Keywords: rdio osx music player
;; URL: https://github.com/worace/rdio-el
;; Created: 5/13/2015
;; Version: 0.1.0

;;; Commentary:
;;
;; This package provides emacs functions for wrapping
;; common interactions with the Rdio music desktop app,
;; allowing you to control the app directly from your editor.
;;
;; Currently only OSX is supported. If you have an idea of how
;; to support linux and/or windows, I would love to hear any suggestions.
;;
;; Provided functions:
;; rdio-launch -- open the rdio application if not already open
;; rdio-quit -- quit the rdio application
;; rdio-play -- start playing (plays whatever is set as the current track)
;; rdio-pause -- pauses the player
;; rdio-toggle -- toggle play/pause mode
;; rdio-vol-up -- increase volume by 10% of total
;; rdio-vol-down -- decrease volume by 10% of total

(require 'cl-lib)

(defun rdio-using-osx ()
  (string= "darwin" system-type))

(unless (rdio-using-osx)
  (error "Platform not supported"))

;;;###autoload
(defun rdio-launch ()
  (shell-command "osascript -e 'tell application \"Rdio\" to launch'"))

;;;###autoload
(defun rdio-quit ()
  (shell-command "osascript -e 'tell application \"Rdio\" to quit'"))

;;;###autoload
(defun rdio-play ()
  (rdio-launch)
  (shell-command "osascript -e 'tell application \"Rdio\" to play'"))

;;;###autoload
(defun rdio-toggle ()
  (rdio-launch)
  (shell-command "osascript -e 'tell application \"Rdio\" to playpause'"))

;;;###autoload
(defun rdio-pause ()
  (shell-command "osascript -e 'tell application \"Rdio\" to pause'"))

;;;###autoload
(defun rdio-next-track ()
  (shell-command "osascript -e 'tell application \"Rdio\" to next track'"))

;;;###autoload
(defun rdio-prev-track ()
  (shell-command "osascript -e 'tell application \"Rdio\" to previous track'"))

(defun rdio-chomp-end (str)
  "Chomp tailing whitespace from STR."
  (replace-regexp-in-string (rx (* (any " \t\n")) eos)
                            ""
                            str))

(defun rdio-current-vol ()
  (string-to-number (rdio-chomp-end (shell-command-to-string "osascript -e 'tell application \"Rdio\" to get sound volume'"))))

(defun rdio-adjusted-vol
  (adjustment)
  (let ((new-vol (+ adjustment (rdio-current-vol))))
    (cond
     ((> new-vol 100) 100)
     ((< new-vol 0) 0)
     (t new-vol))))

;;;###autoload
(defun rdio-vol-up ()
  (shell-command (format "osascript -e 'tell application \"Rdio\" to set sound volume to %S'" (rdio-adjusted-vol 10))))

;;;###autoload
(defun rdio-vol-down ()
  (shell-command (format "osascript -e 'tell application \"Rdio\" to set sound volume to %S'" (rdio-adjusted-vol -10))))

(provide 'rdio)
