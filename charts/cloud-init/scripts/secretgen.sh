#!/bin/bash

set -Eeuo pipefail

export KUBECONFIG=/kube/config
export USER_DATA_PATH=""
export NETWORK_DATA_PATH=""
export NETWORK_DATA_PRESENT="false"
export QUIET="false"
export FORCE="false"

# Parse and validate user inputs.
parse_params() {
        while :; do
                case "${1-}" in
                -h | --help) usage ;;
                -v | --verbose) set -x ;;
                -q | --quiet)
                        export QUIET="${2-}"
                        shift
                        ;;
                -u | --userdata)
                        export USER_DATA_PATH="${2-}"
                        shift
                        ;;
                -n | --networkdata)
                        export NETWORK_DATA_PATH="${2-}"
                        shift
                        ;;
                -s | --secretname)
                        export SECRET_NAME="${2-}"
                        shift
                        ;;
                -un | --username)
                        export USERNAME="${2-}"
                        shift
                        ;;
                -p | --password)
                        export PASSWORD="${2-}"
                        shift
                        ;;
                -f | --force)
                        export FORCE="${2-}"
                        shift
                        ;;
               -?*) die "Unknown option: $1" ;;
                *) break ;;
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

-q, --quiet             Only print final userdata

-u, --userdata          Path to cloud-init user-data file (required)

-n, --networkdata       Path to cloud-init networkdata file (optional)

EOF
        exit
}

# Find if the networkdata file exists
detect_networkdata(){
    if [[ ! -z "$NETWORK_DATA_PATH" ]]; then
        if [ -f "$NETWORK_DATA_PATH" ]; then
            export NETWORK_DATA_PRESENT="true"
        fi
    fi
}

secret_exists(){
    export SECRET_EXISTS=$(kubectl get secret ${SECRET_NAME} -o yaml |grep -o "${SECRET_NAME}" |wc -l)

    if [ "${SECRET_EXISTS}" -gt 0 ]; then
        log "Kubernetes secret: ${SECRET_NAME} exists and and FORCE is set to $FORCE"
        if [ "${FORCE}" == "true" ]; then
            log "Kubernetes secret: ${SECRET_NAME} will be replaced."

            RESULT=$(kubectl patch secret ${SECRET_NAME} -p '{"metadata":{"finalizers":null}}' --type=merge)
            log "$RESULT"

            RESULT=$(kubectl delete secret ${SECRET_NAME})
            log "$RESULT"
        else
            log "Kubernetes secret: ${SECRET_NAME} will not be replaced."
            exit 0
        fi
    fi
}

cretae_userdata_secret(){
    if [ "$NETWORK_DATA_PRESENT" == "true" ]; then
        log "Creating kubernetes secret ${SECRET_NAME} from ${USER_DATA_PATH} & ${NETWORK_DATA_PATH}"
        RESULT=$(kubectl create secret generic ${SECRET_NAME} \
            --from-file=userdata="${USER_DATA_PATH}" \
            --from-file=networkdata="${NETWORK_DATA_PATH}")
        log "$RESULT"
    else
        log "Creating kubernetes secret ${SECRET_NAME} from ${USER_DATA_PATH}"
        RESULT=$(kubectl create secret generic ${SECRET_NAME} --from-file=userdata="${USER_DATA_PATH}")
        log "$RESULT"
    fi
    annotate_secret
}

cretae_credential_secret(){
    log "Creating kubernetes secret ${SECRET_NAME} as user credentials for $USERNAME"
    RESULT=$(kubectl create secret generic ${SECRET_NAME} \
        --from-literal=username="${USERNAME}" \
        --from-literal=password="${PASSWORD}")
    log "$RESULT"
    annotate_secret
}

annotate_secret(){
    log "Adding argocd tracking annotation."
    RESULT=$(kubectl annotate --overwrite secret ${SECRET_NAME} \
        argocd.argoproj.io/tracking-id="${ARGOCD_APP_NAME}:v1/Secret:${NAMESPACE}/${SECRET_NAME}")
    log "$RESULT"

    log "Adding argocd sync options."
    RESULT=$(kubectl annotate --overwrite secret ${SECRET_NAME} \
        argocd.argoproj.io/sync-options="Prune=false,Delete=false")
    log "$RESULT"

    log "Adding argocd comparison options."
    RESULT=$(kubectl annotate --overwrite secret ${SECRET_NAME} \
        argocd.argoproj.io/compare-options="IgnoreExtraneous")
    log "$RESULT"
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

main(){
    parse_params $@
    secret_exists
    if [[ ! -z "$USER_DATA_PATH" ]]; then
        detect_networkdata
        cretae_userdata_secret
    else
        cretae_credential_secret
    fi
}

main $@
