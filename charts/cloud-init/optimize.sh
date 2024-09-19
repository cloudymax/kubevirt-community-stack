#!/bin/bash
set -Eeuo pipefail

trap - SIGINT SIGTERM ERR EXIT
[[ ! -x "$(command -v date)" ]] && echo "💥 date command not found." && exit 1

# Generic logging method to rerutn a timestamped string
log() {
    echo >&2 -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${1-}"
}

export USER_DATA_SECRET_PATH="./manifests.yaml"
export USER_DATA_PATH="./user-data.yaml"
export SALT="saltsaltlettuce"

admin_password(){
    read -ra users <<< $(yq '.users[].name' $USER_DATA_PATH |xargs)
    export COUNT=0

    for user in "${users[@]}"; do
        CHECK=$(yq '.users[env(COUNT)].passwd' $USER_DATA_PATH)
        if [ "${CHECK}" != "null" ]; then
            log "Setting hashed password for user: $user\n"
            export HASHED_PASSWORD=$(mkpasswd --method=SHA-512 --rounds=4096 $ADMIN_PASSWORD -s "${SALT}")
            yq -i '.users[env(COUNT)].passwd = env(HASHED_PASSWORD)' $USER_DATA_PATH
            export COUNT=$(($COUNT + 1))
        fi
    done
}

download_files(){
    read -ra urls <<< $(yq '.write_files[].url' user-data.yaml |xargs)
    export COUNT=0

    for url in "${urls[@]}"; do
        if [ "${url}" != "null" ]; then
            log "Downloading and compressing file: $(basename $url)"
            export B64GZ_STRING=$(curl -s "${url}" |gzip |base64 -w0)
            yq -i '.write_files[env(COUNT)].content = env(B64GZ_STRING)' $USER_DATA_PATH
            yq -i '.write_files[env(COUNT)].encoding = "gz+b64"' $USER_DATA_PATH
            yq -i 'del(.write_files[env(COUNT)].url)' $USER_DATA_PATH
            check_size
            export COUNT=$(($COUNT + 1))
        fi
    done
}

check_size(){
    export SIZE=$(stat -c%s $USER_DATA_PATH)
    export REMAINDER=$((16000 - $SIZE))
    export FULL=$(echo "scale=2; 100-(($REMAINDER/16000)*100)" |bc -l)
    log "user-data file is $SIZE bytes - $FULL% of 16Kb limit.\n"
    if [[ $SIZE -gt 16000 ]]; then
        echo "Warn: user-data file exceeds the 16KB limit"
    fi
}

log "Starting Cloud-Init Optomizer"
cp $USER_DATA_SECRET_PATH $USER_DATA_PATH
check_size
admin_password
download_files
log "Done."
