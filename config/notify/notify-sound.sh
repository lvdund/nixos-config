#!/usr/bin/env sh
# Notification sound player for dunst.
#
# Why a wrapper: dunst's rule `script` option is the path/name of a single
# executable (wordexp-expanded). It is NOT a shell command line, so
# `script = ffplay -nodisp ... file.mp3` does nothing -- dunst looks for an
# executable literally matching the whole string and never runs it.
# (mako's `on-notify=exec ...` is different: mako runs it via a shell.)
exec ffplay -nodisp -autoexit -v error -nostats \
    /etc/nixos/nixos-config/config/notify/notify.mp3
