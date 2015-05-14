;;; rdio.el --- Control Rdio Desktop App from Emacs
;; Copyright 2015 Horace Williams
;;
;; Author: Horace Williams <horacedwilliams@gmail.com>
;; Maintainer: Horace Williams <horacedwilliams@gmail.com>
;; Keywords: rdio
;; URL: 
;; Created: 5/13/2015
;; Version: 0.1.0

;;; Commentary:
;;
;; Pause/play/vol control for Rdio desktop app
;;
;; Currently supports only OSX
;;
;; (rdio-play) -- start playing current song
;; (rdio-pause) -- pause playing current song
;; (rdio-vol-up) -- increase volume
;; (rdio-vol-down) -- decrease volume

(require 'cl-lib)

(defun rdio-using-osx ()
  (string= "darwin" system-type))

(unless (rdio-using-osx)
  (error "Platform not supported"))

(defun rdio-launch ()
  (shell-command "osascript -e 'tell application \"Rdio\" to launch'"))

(defun rdio-quit ()
  (shell-command "osascript -e 'tell application \"Rdio\" to quit'"))

(defun rdio-play ()
  (rdio-launch)
  (shell-command "osascript -e 'tell application \"Rdio\" to play'"))

(defun rdio-pause ()
  (shell-command "osascript -e 'tell application \"Rdio\" to pause'"))

(defun rdio-next-track ()
  (shell-command "osascript -e 'tell application \"Rdio\" to next track'"))

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

(defun rdio-vol-up ()
  (shell-command (format "osascript -e 'tell application \"Rdio\" to set sound volume to %S'" (rdio-adjusted-vol 10))))

(defun rdio-vol-down ()
  (shell-command (format "osascript -e 'tell application \"Rdio\" to set sound volume to %S'" (rdio-adjusted-vol -10))))

(provide 'rdio)
