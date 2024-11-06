#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Identificador para ficar claro qual versão o bitrise está rodando
echo "Running step.sh 0.0.1"

echo "Updating phase release for: ${package_name}"
if [ -z "$service_account_json_key_content" ] ; then
    echo "Downloading credentials from remote file"
    wget -O "${SCRIPT_DIR}/credentials.json" ${service_account_json_key_path}
else
    echo "Using local content credentials"
    echo "$service_account_json_key_content" > "${SCRIPT_DIR}/credentials.json"
fi

echo "Installing google-api-python-client"
pipenv install google-api-python-client
pipenv run python -c "import googleapiclient; print(googleapiclient.__version__)"

echo "Installing oauth2client"
pipenv install oauth2client
pipenv run python -c "import oauth2client; print(oauth2client.__version__)"

pipenv run python "${SCRIPT_DIR}/rollout_update.py" "${package_name}" "${SCRIPT_DIR}/credentials.json"

rm "${SCRIPT_DIR}/credentials.json"