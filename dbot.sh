#!/bin/bash

script_name="$(basename "${0}")"; pushd "$(dirname "${0}")" >/dev/null; export script_name
script_path=$(pwd -P); popd >/dev/null; export script_path

. script/util-helper.sh
. script/util-web.sh
. script/util-lookup.sh
. script/util-vars.sh
. script/ops-text.sh
. script/ops-git.sh

while getopts ":t:o:g:i:" o; do
    case "${o}" in
        g)
            arg_global_op=${OPTARG}
            array_contains "${arg_global_op}" "${global_ops[@]}" || usage
            ;;
        t)
            arg_target_type=${OPTARG}
            array_contains "${arg_target_type}" "${dir_types[@]}" || usage
            ;;
        o)
            arg_op=${OPTARG}
            array_contains "${arg_op}" "${ops[@]}" || usage
            ;;
        i)
            arg_image=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${arg_op}" ] && [ -z "${arg_global_op}" ];  then
    usage
elif [ ! -z "${arg_global_op}" ] && [ ! -z "${arg_target_type}" ]; then
    usage
elif [ ! -z "${arg_global_op}" ] && [ ! -z "${arg_op}" ]; then
    usage
elif [ ! -z "${arg_op}" ] && [ ! -z "${arg_image}" ]; then
    usage
fi

if [ ! -f "${config_file}" ]; then
    echo "Unable to find config file: ${config_file}" >&2
    echo "Copy the file '.dbot-placeholder' to '.dbot' and fill out the properties"
    exit 1
fi

if $(array_contains "${arg_op}" "${danger_ops[@]}"); then
    read -r -p "Run dangerous op "${arg_op}"? [y/N] " response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo
    else
        exit 1
    fi
fi

if [ -z "${arg_global_op}" ]; then
    perform_op "${arg_op}" "${arg_target_type}"
else
    perform_op "${arg_global_op}"
fi
