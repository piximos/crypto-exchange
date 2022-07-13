#!/bin/sh

if [ -n "${PACKAGE_JSON_PATH}" ]; then
  direct_dependencies="$(jq '[(.devDependencies|keys),(.dependencies|keys)]|flatten' "${PACKAGE_JSON_PATH}")"
fi
table_header="| Severity | PkgName | InstalledVersion | FixedVersion | \n |---|---|---|---|"
output_direct=""
output_indirect=""

while read -r entry; do

  severity="$(echo "${entry}" | jq -r '.Severity')"
  pkg_name="$(echo "${entry}" | jq -r '.PkgName')"
  installed_version="$(echo "${entry}" | jq -r '.InstalledVersion')"
  fixed_version="$(echo "${entry}" | jq -r '.FixedVersion')"

  if [ -n "${PACKAGE_JSON_PATH}" ]; then
    if [ "$(echo "${direct_dependencies}" | grep -e "\"${pkg_name}\"" || false)" ]; then
      output_direct="${output_direct} \n | **${severity}** | ${pkg_name} | \`${installed_version}\` | \`${fixed_version}\` |"
    else
      output_indirect="${output_indirect} \n | **${severity}** | ${pkg_name} | \`${installed_version}\` | \`${fixed_version}\` |"
    fi
  else
    output_direct="${output_direct} \n | **${severity}** | ${pkg_name} | \`${installed_version}\` | \`${fixed_version}\` |"
  fi

done < <(jq '.Results[].Vulnerabilities[]' -c "${INPUT_FILE}")

if [ -n "${PACKAGE_JSON_PATH}" ] && [ "${output_direct}" || "${output_indirect}" ]; then
  echo "# :warning: These following vulnerabilities were found" >"${OUTPUT_FILE}"
  if [ "${output_direct}" ]; then
    echo -e "## List of **_direct_** dependencies with vulnerabilities \n ${table_header} ${output_direct}" >>"${OUTPUT_FILE}"
  fi
  if [ "${output_indirect}" ]; then
    echo -e "## List of **_indirect_** dependencies with vulnerabilities \n ${table_header} ${output_indirect}" >>"${OUTPUT_FILE}"
  fi
elif [ -z ${PACKAGE_JSON_PATH} ] && [ "${output_direct}" ]; then
  echo -e "## List of dependencies with vulnerabilities \n ${table_header} ${output_direct}" >>"${OUTPUT_FILE}"
else
  echo "# :white_check_mark: Congratulations! No vulnerabilities were found" >"${OUTPUT_FILE}"
fi
