function perform_op() {
    local target_op="${1}"
    local target_type="${2}"
    local target_dirs="${target_type}_dirs[@]"

    local all_dirs=($(get_github_repos))
    local dexec_dirs=($(get_dirs_excluding "^(base-|image-|docker-exec|dexec)" "${all_dirs[@]}"))
    local image_dirs=($(get_dirs_including "^image-" "${all_dirs[@]}"))
    local base_dirs=($(get_dirs_including "^base-" "${all_dirs[@]}"))
    local web_dirs=('docker-exec.github.io')
    local dbot_dirs=('docker-exec-bot')

    mkdir -p "${workspace_dir}"

    if $(array_contains "${target_op}" "${global_ops[@]}"); then
        echo "running global op: ${target_op}"
        "op_${target_op}" "${target_type}" "${target}"
    else
        for target in "${!target_dirs}"; do
            if [ "${target}" = "docker-exec-bot" ]; then
                if $(array_contains "${target_op}" "${git_ops[@]}"); then
                    echo "Unable to run get on ${target}. Use git instead" >&2
                else
                    echo "running dbot op: ${target_op}"
                    "op_${target_op}" "${target_type}" "${target}"
                fi
            else
                pushd "${workspace_dir}" >/dev/null
                echo "Executing ${target_op} on ${target}"
                "op_${target_op}" "${target_type}" "${target}"
                popd >/dev/null
            fi
        done
    fi
}

function get_dirs_excluding() {
    local excluding_pattern="${1}"; shift
    local to_filter=("${@}")
    for candidate_dir in "${to_filter[@]}"; do
        echo "${candidate_dir}";
    done | grep -Eve "${excluding_pattern}"
}

function get_dirs_including() {
    local including_pattern="${1}"; shift
    local to_filter=("${@}")
    for candidate_dir in "${to_filter[@]}"; do
        echo "${candidate_dir}";
    done | grep -Ee "${including_pattern}"
}

function array_contains() {
    local needle="${1}"; shift
    local haystack=("${@}")
    for item in "${@}"; do [[ "${item}" == "${needle}" ]] && return 0; done
    return 1
}

function concatenate_array() {
    local separator=${1}; shift
    local source_list=(${@})
    IFS=${separator}
    local concatenated="${source_list[*]}";
    IFS=$' \t\n'
    echo ${concatenated}
}

function get_prop() {
    local target_prop="${1}"
    grep -Eoe "^${target_prop}=(.*)$" ${script_path}/${config_file} | sed -Ee "s/^${target_prop}=(.*)$/\1/"
}

function usage() {
    echo "Usage:" >&2
    echo "    $0 -t <type> -o <operation>" >&2
    echo "    $0 -g <global operation>" >&2
    echo >&2
    echo "Options:" >&2
    echo "    -i <image>" >&2
    echo "    -t $(concatenate_array '|' "${dir_types[@]}")" >&2
    echo "    -o $(concatenate_array '|' "${ops[@]}")" >&2
    echo "    -g $(concatenate_array '|' "${global_ops[@]}")" >&2
    exit 1
}
