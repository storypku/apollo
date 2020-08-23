#!/usr/bin/env bash
# Fail on error
set -e

TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "${TOP_DIR}/scripts/apollo.bashrc"

DATA_DIR="${TOP_DIR}/data"
RESULT_RAW_TXT="${DATA_DIR}/result_raw.py"
RESULT_FILE_LIST="${DATA_DIR}/result.files.txt"
RESULT_TXT="${DATA_DIR}/result_deps.py"

function preprocess() {
    local tmpfile=$(mktemp /tmp/py3_deps.XXXXXX)
    find ${TOP_DIR}/{modules,cyber} -name "*.py" -exec \
        grep -l "import " {} > "${RESULT_FILE_LIST}" +

    find ${TOP_DIR}/{modules,cyber} -name "*.py" -exec \
        grep -h "import " {} > "${tmpfile}" +
    sed -i 's/^[ \t]*//' "${tmpfile}"
    sort -u "${tmpfile}" | egrep "^(from|import) " \
        | grep -Ev "(cyber|modules|fueling)" > "${RESULT_RAW_TXT}"
    sed -i '/google.protobuf/d' "${RESULT_RAW_TXT}"
    sed -i '/secure_upgrade_export/d' "${RESULT_RAW_TXT}"
    rm -f "${tmpfile}"
}

function process() {
    awk -F'[ .]' '{print "import", $2}' "${RESULT_RAW_TXT}" | sort -u > "${RESULT_TXT}"
}

preprocess
process
