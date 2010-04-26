#!/bin/sh

export GEM_HOME='/var/lib/gems/1.9.1'
export GEM_PATH='/var/lib/gems/1.9.1'
export RUBYLIB='/var/lib/gems/1.9.1/gems'

exec '/usr/bin/ruby' "$@"
