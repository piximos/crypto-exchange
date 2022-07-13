#!/bin/sh

defined_envs=$(printf '"${%s}" ' $(env | cut -d= -f1 | grep -E '^CONF\_'))
for file in $(find "${APP_ROOT}" -type f -name '*.css' -o -name '*.js' -o -name '*.html')
  do
      envsubst "$defined_envs" < $file > "${file}.tmp"
      mv "${file}.tmp" $file
  done

exec "$@"
