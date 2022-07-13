#!/usr/bin/env sh

set -eu

if [ "${VERBOSE}" = "true" ]; then
  set -x
fi

_major="0"
_minor="0"
_patch="0"

while read -r commit_message; do
  if [[ "${commit_message}" =~ ${MAJOR_IDENTIFIER} ]]; then
    _major=$((_major + 1))
    _minor="0"
    _patch="0"
  elif [[ "${commit_message}" =~ ${MINOR_IDENTIFIER} ]]; then
    _minor=$((_minor + 1))
    _patch="0"
  else
    _patch=$((_patch + 1))
  fi
done < <(git log --pretty=%B "${SUB_PATH}" | sed '/^\s*$/d' | tac)

echo "current version: ${_major}.${_minor}.${_patch}"
echo "::set-output name=semver::${_major}.${_minor}.${_patch}"
exit 0
