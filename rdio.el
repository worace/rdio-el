;;; rdio.el --- Control Rdio Desktop App from Emacs
;;
;; Copyright 2015 Horace Williams
;;
;; Filename: rdio.el
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

;;; Code:
(require 'cl-lib)

(defun rdio-using-osx ()
  (string= "darwin" system-type))

(unless (rdio-using-osx)
  (error "Platform not supported"))

;;;###autoload
(defun rdio-launch ()
  (interactive)
  (shell-command "osascript -e 'tell application \"Rdio\" to launch'"))

;;;###autoload
(defun rdio-quit ()
  (interactive)
  (shell-command "osascript -e 'tell application \"Rdio\" to quit'"))

;;;###autoload
(defun rdio-play ()
  "Start rdio player; will launch rdio if it isn't already running"
  (interactive)
  (rdio-launch)
  (shell-command "osascript -e 'tell application \"Rdio\" to play'"))

;;;###autoload
(defun rdio-toggle ()
  "Toggle play/pause mode of rdio player; will start rdio if it isn't already running"
  (interactive)
  (rdio-launch)
  (shell-command "osascript -e 'tell application \"Rdio\" to playpause'"))

;;;###autoload
(defun rdio-pause ()
  "Pause rdio player"
  (interactive)
  (shell-command "osascript -e 'tell application \"Rdio\" to pause'"))

;;;###autoload
(defun rdio-next-track ()
  "Go to next track"
  (interactive)
  (shell-command "osascript -e 'tell application \"Rdio\" to next track'"))

;;;###autoload
(defun rdio-prev-track ()
  "Go to previous track"
  (interactive)
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
  "Decrease rdio volume by 10%"
  (interactive)
  (shell-command (format "osascript -e 'tell application \"Rdio\" to set sound volume to %S'" (rdio-adjusted-vol 10))))

;;;###autoload
(defun rdio-vol-down ()
  "Increase rdio volume by 10%"
  (interactive)
  (shell-command (format "osascript -e 'tell application \"Rdio\" to set sound volume to %S'" (rdio-adjusted-vol -10))))

(provide 'rdio)

;;; rdio.el ends here
