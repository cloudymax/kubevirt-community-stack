#!/bin/bash

set -Eeuo pipefail

trap - SIGINT SIGTERM ERR EXIT

# Verify that all required system deps are installed
[[ ! -x "$(command -v date)" ]] && echo "💥 date command not found." && exit 1
[[ ! -x "$(command -v bc)" ]] && echo "💥 bc command not found." && exit 1
[[ ! -x "$(command -v mkpasswd)" ]] && echo "💥 gettext-base command not found." && exit 1
[[ ! -x "$(command -v whois)" ]] && echo "💥 whois command not found." && exit 1
[[ ! -x "$(command -v git)" ]] && echo "💥 git command not found." && exit 1
[[ ! -x "$(command -v cloud-init)" ]] && echo "💥 cloud-init command not found." && exit 1
[[ ! -x "$(command -v wget)" ]] && echo "💥 wget command not found." && exit 1
[[ ! -x "$(command -v curl)" ]] && echo "💥 curl command not found." && exit 1
[[ ! -x "$(command -v yq)" ]] && echo "💥 yq command not found." && exit 1
[[ ! -x "$(command -v golang-petname)" ]] && echo "💥 golang-petname command not found." && exit 1
[[ ! -x "$(command -v kubectl)" ]] && echo "💥 kubectl command not found." && exit 1

# Default Variable Declarations
export ENVSUBST="false"
export USER_DATA_SECRET_PATH=""
export USER_DATA_PATH="user-data.yaml"
export SALT="saltsaltlettuce"
export QUIET="false"
export NETWORK_DATA_SECRET_PATH=""
export NETWORK_DATA_PATH="network-data.yaml"
export NETWORK_DATA_PRESENT="false"
export SECRETGEN="false"
export FORCE="false"
export ARGO_ENABLED="false"
export ARGO_APP_NAME="none"
export ARGO_SYNC="none"
export ARGO_COMPARE="none"
export CLOUDBASE="false"

# Parse and validate user inputs.
parse_params() {
        while :; do
                case "${1-}" in
                -h | --help) usage ;;
                -v | --verbose) set -x ;;
                -e | --envsubst)
                       export ENVSUBST="${2-}"
                        shift
                        ;;
                -q | --quiet)
                        export QUIET="${2-}"
                        shift
                        ;;
                -s | --salt)
                        export SALT="${2-}"
                        shift
                        ;;
                -u | --userdata)
                        export USER_DATA_SECRET_PATH="${2-}"
                        shift
                        ;;
                -n | --networkdata)
                        export NETWORK_DATA_SECRET_PATH="${2-}"
                        export NETWORK_DATA_PRESENT="true"
                        shift
                        ;;
                -k | --kubernetes)
                        export SECRETGEN="${2-}"
                        shift
                        ;;
                -f | --force)
                        export FORCE="${2-}"
                        shift
                        ;;
                -a | --argo)
                        export ARGO_ENABLED="${2-}"
                        shift
                        ;;
                -aa | --argo-app)
                        export ARGO_APP_NAME="${2-}"
                        shift
                        ;;
                -as | --argo-sync)
                        export ARGO_SYNC="${2-}"
                        shift
                        ;;
                -ac | --argo-compare)
                        export ARGO_COMPARE="${2-}"
                        shift
                        ;;
                -cb | --cloudbase)
                        export CLOUDBASE="${2}"
                        shift
                        ;;
               -?*) die "Unknown option: $1" ;;
                *) echo "${2-}" && break ;;
                esac
                shift
        done
    }

# help text
usage(){
        cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-u <path to file>] [-e] [-s <string>] [-wg <path to file>]

💁 This script will quickly modify a cloud-init user-data template that can be used to provision virtual-machines, metal, and containers.

Available options:

-h, --help              Print this help and exit

-v, --verbose           Print script debug info

-q, --quiet             Only print final userdata [true/false]

-u, --userdata          Path to cloud-init user-data file [string]

-n, --networkdata       Path to cloud-init networkdata file [true/false]

-e, --envsubst          Enable usage of envsubst, disabled by default [true/false]

-s, --salt              Salt to use when encrypting passwords [string]

-cb, --cloudbase        Use cloudbase-init syntax

Optional Kubernetes settings:

-k, --kubernetes        Create kubernetes secrets from user and network data [true/false]

-f, --force             Force-replce existing kubernetes secrets [true/false]

Optional ArgoCD settings:

-a, --argo              Enable ArgoCD secret annotations

-aa, --argo-app         Set ArgoCD ownership annotations on generated secrets

-as, --argo-sync        Set ArgoCD sync annotations on generated secrets

-ac, --argo-compare     Set ArgoCD comparison annotations on generated secrets

EOF
        exit
}

# Run envsubst against the user-data file
#
# Note:
# This function will use all existing env vars to replace matching variable
# declarations. This can cause issues where a plain-text command uses a variable.
#
# Scripts that use a plain-text varibales that should NOT be templated
# should be passed to the write_files section from a URL or as base64
run_envsubst(){
    if [ "${ENVSUBST}" == "true" ]; then
        log "running envsubst against $USER_DATA_PATH"
        envsubst < "${USER_DATA_PATH}" > /tmp/tmp.yaml
        mv /tmp/tmp.yaml "${USER_DATA_PATH}"

        # if network data is present run envsubst on it
        if [ "${NETWORK_DATA_PRESENT}" == "true" ]; then
            log "running envsubst against $NETWORK_DATA_PATH"
            envsubst < "${NETWORK_DATA_PATH}" > tmp.yaml
            mv tmp.yaml "${NETWORK_DATA_PATH}"
        fi
    fi

    random_hostname
}

random_hostname(){
     if [ "${CLOUDBASE}" == "true" ]; then
        CHECK=$(yq '.set_hostname' $USER_DATA_PATH | tr '[:lower:]' '[:upper:]')
     else
        CHECK=$(yq '.hostname' $USER_DATA_PATH | tr '[:lower:]' '[:upper:]')
     fi

     if [ ${CHECK} == "RANDOM" ]; then
        log "Generating a random hostname."
        export HOSTNAME=$(golang-petname)

        if [ "${CLOUDBASE}" == "true" ]; then
            yq -i '.set_hostname = env(HOSTNAME)' $USER_DATA_PATH
        else
            yq -i '.hostname = env(HOSTNAME)' $USER_DATA_PATH
        fi
        log "Nice to meet you, $HOSTNAME"
     fi
}

# Hash and insert passwd field for each specified user
admin_password(){
    read -ra users <<< $(yq '.users[].name' $USER_DATA_PATH |xargs)
    export COUNT=0

    # Get the list of users
    for user in "${users[@]}"; do
        CHECK=$(yq '.users[env(COUNT)].passwd' $USER_DATA_PATH | tr '[:lower:]' '[:upper:]')

        # Check if we need to generate a random password
        if [ "${CHECK}" == "RANDOM" ]; then
            log "Generating a random password for user: ${user}."
            export PASSWORD=$(random_password)
        else
            # If passwd is empty, its probably a env var
            if [ -z "${CHECK}" ]; then
                log "Looking for password of user: $user in env vars"
                CAP_USER=$(echo "${user}" | tr '[:lower:]' '[:upper:]')
                export PASSWORD=$(env |grep "${CAP_USER}_PASSWORD" |cut -d '=' -f2)

                # If we still cant find it, throw and error and exit
                if [ -z $PASSWORD ]; then
                    log "No password found for user $user in env vars. Exiting."
                    exit 1
                fi
            fi
        fi

        # If user kubernetes
        if [ "$SECRETGEN" == "true" ]; then
            bash ./secretgen.sh \
                --secretname "${user}-credentials" \
                --username "${user}" \
                --password "${PASSWORD}" \
                --quiet "${QUIET}" \
                --force "${FORCE}" \
                --argo "${ARGO_ENABLED}" \
                --argo-app "${ARGO_APP_NAME}" \
                --argo-sync "${ARGO_SYNC}" \
                --argo-compare "${ARGO_COMPARE}"
        fi

        # If not using cloudbse syntax, add the hashed password to the userdata
        if [ "${CLOUDBASE}" == "true" ]; then
            log "Setting password for user: $user"
            yq -i '.users[env(COUNT)].passwd = env(PASSWORD)' $USER_DATA_PATH
        else
            log "Setting hashed password for user: $user"
            export HASHED_PASSWORD=$(mkpasswd --method=SHA-512 --rounds=4096 "${PASSWORD}" -s "${SALT}")
            yq -i '.users[env(COUNT)].passwd = env(HASHED_PASSWORD)' $USER_DATA_PATH
        fi

        export COUNT=$(($COUNT + 1))
    done
}

random_password(){
    INPUT=$(golang-petname --words 2)
    OUTPUT=""
    LENGTH=${#INPUT}

    for (( i=0; i<LENGTH; i++ )); do
      char="${INPUT:$i:1}"
      if (( RANDOM % 8 == 0 )); then
        # Convert to uppercase
        OUTPUT+="$(echo "$char" | tr '[:lower:]' '[:upper:]')"
      else
        # Convert to lowercase
        OUTPUT+="$(echo "$char" | tr '[:upper:]' '[:lower:]')"
      fi
    done

    echo "$OUTPUT-$RANDOM"
}


# Download, gzip, then b64 encode files from specified URLs
download_files(){
    read -ra urls <<< $(yq '.write_files[].url' "${USER_DATA_PATH}" |xargs)
    export COUNT=0

    for url in "${urls[@]}"; do
        if [ "${url}" != "null" ]; then
            log "Downloading and compressing file: $(basename $url)"
            export B64GZ_STRING=$(curl -s "${url}" |gzip |base64 -w0)
            yq -i '.write_files[env(COUNT)].content = env(B64GZ_STRING)' $USER_DATA_PATH
            yq -i '.write_files[env(COUNT)].encoding = "gz+b64"' $USER_DATA_PATH
            yq -i 'del(.write_files[env(COUNT)].url)' $USER_DATA_PATH
            check_size
        fi
        export COUNT=$(($COUNT + 1))
    done
}

# Check the size of the user-data file against ec2 16Kb limit
check_size(){
    log "Checking the size of the user-data file..."
    export SIZE=$(stat -c%s $USER_DATA_PATH)
    export REMAINDER=$((16000 - $SIZE))
    export FULL=$(echo "scale=2; 100-(($REMAINDER/16000)*100)" |bc -l)
    log "user-data file is $SIZE bytes - $FULL% of 16Kb limit."
    if [[ $SIZE -gt 16000 ]]; then
        echo "Warn: user-data file exceeds the 16KB limit"
    fi
}

# Validate user-data is properly formatted
validate(){
    log "Linting the user-data file..."
    CONFIG_VALID=$(cloud-init schema --config-file $USER_DATA_PATH)
    log "$CONFIG_VALID"
}

# Add wireguard configs from file or in-cline config
wireguard(){
    read -ra interfaces <<< $(yq '.wireguard.interfaces[].name' "${USER_DATA_PATH}" |xargs)
    export COUNT=0

    for interface in "${interfaces[@]}"; do
        # Get if source is file or content
        if [ "${interface}" != "null" ]; then
            SOURCE=$(yq '.wireguard.interfaces[env(COUNT)].source' "${USER_DATA_PATH}")

            # if the config is in a file
            if [ "$SOURCE" == "file" ]; then
                export WG_PATH=$(yq '.wireguard.interfaces[env(COUNT)].path' "${USER_DATA_PATH}")
                export OUTPUT=$(/bin/cat "${WG_PATH}")

                log "Adding wireguard interface ${interface}"
                yq -i '.wireguard.interfaces[env(COUNT)].content = strenv(OUTPUT)' $USER_DATA_PATH
                yq -i '.wireguard.interfaces[env(COUNT)] |= (del(.source))' $USER_DATA_PATH
                yq -i '.wireguard.interfaces[env(COUNT)] |= (del(.path))' $USER_DATA_PATH
            fi

            # if the config is from a secret
            if [ "$SOURCE" == "secret" ]; then
                export WG_NAME=$(yq '.wireguard.interfaces[env(COUNT)].name' "${USER_DATA_PATH}")
                export WG_PATH="/secrets/${WG_NAME}.conf"
                export OUTPUT=$(/bin/cat "${WG_PATH}")

                log "Adding wireguard interface ${interface}"
                yq -i '.wireguard.interfaces[env(COUNT)].content = strenv(OUTPUT)' $USER_DATA_PATH
                yq -i '.wireguard.interfaces[env(COUNT)] |= (del(.source))' $USER_DATA_PATH
                yq -i '.wireguard.interfaces[env(COUNT)] |= (del(.path))' $USER_DATA_PATH
            fi

            # if the config is in-line content
            if [ "$SOURCE" == "content" ]; then
                export CONTENT=$(yq '.wireguard.interfaces[env(COUNT)].content' "${USER_DATA_PATH}")

                log "Adding wireguard interface ${interface}"
                yq -i '.wireguard.interfaces[env(COUNT)].content = strenv(CONTENT)' $USER_DATA_PATH
                yq -i '.wireguard.interfaces[env(COUNT)] |= (del(.source))' $USER_DATA_PATH
            fi
        fi

        export COUNT=$(($COUNT + 1))
    done
}

# Generic logging method to return a timestamped string
log() {
    if [ "${QUIET}" == "true" ]; then
        echo >&2 -e "{ \"date\": \"$(date +"%Y-%m-%d %H:%M:%S")\", \"message\": \"${1-}\"}" >> /tmp/log.txt
    fi

    if [ "${QUIET}" == "false" ]; then
        echo >&2 -e "{\"date\": \"$(date +"%Y-%m-%d %H:%M:%S")\", \"message\": \"${1-}\"}"
    fi
}

# kill on error
die() {
        local MSG=$1
        local CODE=${2-1}
        # Bash parameter expansion - default exit status 1.
        # See https://wiki.bash-hackers.org/syntax/pe#use_a_default_value
        log "${MSG}"
        exit "${CODE}"
}


# Main Application Loop
main(){
    # Check and validate inputs
    parse_params $@

    log "Starting Cloud-Init Optomizer"

    # Copy read-only files to editable versions
    cp $USER_DATA_SECRET_PATH $USER_DATA_PATH
    if [[ ! -z "$NETWORK_DATA_SECRET_PATH" ]]; then
        cp $NETWORK_DATA_SECRET_PATH $NETWORK_DATA_PATH
    fi

    # Check the initial size of the cloud-init config
    check_size

    # Replace all $VAR definitions with matching ENV vars
    run_envsubst

    # Insert wireguard configurations into cloud-init file
    wireguard

    # Hash/encrypt password from secret or input
    admin_password

    # Download, compress, and encode files specified in write_files section
    download_files

    # Lint the resulting cloud-init file
    validate

    # Do a final size check of our modified config file
    check_size

    # use `raw log.json |yq -p=json '.message |fromyaml' |jq` to re-expand log line
    #RENDER="$(cat $USER_DATA_PATH |yq -o=json '.' |jq tojson)"
    #log "${RENDER:1:-1}"

    # call secretgen to create a kubernetes cloudInit NoCloud secret containing
    # the userdata and network data
    if [ "$SECRETGEN" == "true" ]; then
        bash ./secretgen.sh \
            --secretname "${SECRET_NAME}" \
            --userdata "${USER_DATA_PATH}" \
            --networkdata "${NETWORK_DATA_PATH}" \
            --quiet "${QUIET}" \
            --force "${FORCE}" \
            --argo "${ARGO_ENABLED}" \
            --argo-app "${ARGO_APP_NAME}" \
            --argo-sync "${ARGO_SYNC}" \
            --argo-compare "${ARGO_COMPARE}"
    else
        # Move the final file to the output directory
        #log "Optimized file saved to /output/user-data.yaml"
        #cp $USER_DATA_PATH /ouput/user-data.yaml
        log "Printing final userdata."
        cat $USER_DATA_PATH |yq
    fi
}

main $@
