function op_printwd() {
    local target_type="${1}"
    local target="${2}"
    if [ "${target}" = "docker-exec-bot" ]; then
        pwd -P
    elif [ -d "${target}" ]; then
        pushd "${target}" >/dev/null
        pwd -P
        popd >/dev/null
    else
        echo "Folder ${target} does not exist"
        return 1
    fi
}

function op_upweb() {
    local target_type="${1}"
    local target="docker-exec.github.io"

    pushd "${workspace_dir}" >/dev/null

    if [ ! -d "${target}" ]; then
        op_get "${target_type}" "${target}"
    fi

    sed -E \
        -e 's/<title>Docker Exec by docker-exec<\/title>/<title>Docker Exec<\/title>/' \
        -e 's/<li class="single"><a href="https:\/\/github.com\/docker-exec\/docker-exec.github.io">View On <strong>GitHub<\/strong><\/a><\/li>/<li class="single"><a href="https:\/\/github.com\/docker-exec\/dexec">View On <strong>GitHub<\/strong><\/a><\/li>/' \
        -e 's/<p class="view"><a href="https:\/\/github.com\/docker-exec">View the Project on GitHub <small>docker-exec<\/small><\/a><\/p>/<p class="view"><a href="https:\/\/github.com\/docker-exec\/dexec">View the Project on GitHub<\/a><\/p>/' \
        <"${target}/index.html" \
        >"${target}/index.html_tmp" \
    && mv "${target}/index.html_tmp" "${target}/index.html"

    popd >/dev/null
    echo "Index updated"
}

function op_uplicense() {
    local target_type="${1}"
    local target="${2}"
    sed -E \
        -e "s/{{year}}/$(date +"%Y")/g" \
        -e "s/{{author}}/$(get_prop copyright-holder)/g" \
        <"${script_path}/template/LICENSE" \
        >"${target}/LICENSE"
    echo "LICENSE updated"
}

function op_upreadme() {
    local target_type="${1}"
    local target="${2}"

    if [ "${target_type}" = "all" ] || [ "${target_type}" = "image" ]; then
        echo "Unable to update README.md for types 'all' or 'image'"
        return 1
    elif [ "${target}" = "docker-exec-bot" ]; then
        sed -E \
            -e "s/{{global-ops}}/$(concatenate_array '|' "${global_ops[@]}")/g" \
            -e "s/{{ops}}/$(concatenate_array '|' "${ops[@]}")/g" \
            -e "s/{{types}}/$(concatenate_array '|' "${dir_types[@]}")/g" \
            <"${script_path}/template/README.${target_type}.md" \
            >"${script_path}/README.md"
    else
        if grep -qEe "/tmp/dexec/image-common/dexec-script.sh" "${target}/Dockerfile"; then
            sed -E \
                -e "s/{{image-name}}/${target}/g" \
                -e "s/{{image-full-name}}/$(lookup_full_name ${target})/g" \
                -e "s/{{file-extension}}/$(lookup_extension ${target})/g" \
                -e '/{{start-compiled-only}}/,/{{end-compiled-only}}/d' \
                <"${script_path}/template/README.${target_type}.md" \
                >"${target}/README.md"
        else
            sed -E \
                -e "s/{{image-name}}/${target}/g" \
                -e "s/{{image-full-name}}/$(lookup_full_name ${target})/g" \
                -e "s/{{file-extension}}/$(lookup_extension ${target})/g" \
                -e '/{{start-compiled-only}}/d' \
                -e '/{{end-compiled-only}}/d' \
                <"${script_path}/template/README.${target_type}.md" \
                >"${target}/README.md"
        fi
        echo "README.md updated"
    fi
}
