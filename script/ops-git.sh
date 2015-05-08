#!/bin/bash

function op_rewrite() {
    local target_type="${1}"
    local target="${2}"
    git -C "${target}" add .
    git -C "${target}" commit -m "fix"
    git -C "${target}" checkout "$(git -C "${target}" rev-parse HEAD)"
    git -C "${target}" reset --soft "$(git -C "${target}" rev-list --max-parents=0 HEAD)"
    git -C "${target}" commit --amend --no-edit
    git -C "${target}" tag tmp
    git -C "${target}" checkout master
    git -C "${target}" rebase --onto tmp "$(git -C "${target}" rev-parse HEAD)"
    git -C "${target}" tag -d tmp
}

function op_commit_push() {
    local target_type="${1}"
    local target="${2}"
    git -C "${target}" add .
    git -C "${target}" commit -m "Update"
    git -C "${target}" push
}

function op_fpush() {
    local target_type="${1}"
    local target="${2}"
    git -C "${target}" push --force
}

function op_push_tags() {
    local target_type="${1}"
    local target="${2}"
    git -C "${target}" push --tags
}

function op_clean() {
    local target_type="${1}"
    local target="${2}"
    rm -rf "${workspace_dir}"
}

function op_fmodule() {
    local target_type="${1}"
    local target="${2}"
    op_remodule "${target_type}" "${target}"
    op_rewrite "${target_type}" "${target}"
    op_fpush "${target_type}" "${target}"
}

function op_bump_tag() {
    local target_type="${1}"
    local target="${2}"
    local tag_version
    tag_version="$(get_prop "dexec-${target_type}-tag-version")"
    if [ -d "${target}" ] && [ -d "${target}/.git" ]; then
        local current_major_minor
        current_major_minor=$(git -C "${target}" tag -l \
            | sort \
            | tail -1 \
            | sed -Ee 's/(v[[:digit:]]+\.[[:digit:]]+\.)[[:digit:]]+/\1/')

        local current_patch
        current_patch=$(git -C "${target}" tag -l \
            | sort \
            | tail -1 \
            | sed -Ee 's/v[[:digit:]]+\.[[:digit:]]+\.([[:digit:]]+)/\1/')
        local next_patch
        next_patch=$(($current_patch+1))
        local tag_version
        tag_version="${current_major_minor}${next_patch}"
        echo "tagging ${target} with version ${tag_version}"
        #git -C "${target}" tag "${tag_version}"
    fi

}

function op_tag() {
    local target_type="${1}"
    local target="${2}"
    local tag_version
    tag_version="$(get_prop "dexec-${target_type}-tag-version")"
    if [ -d "${target}" ] && [ -d "${target}/.git" ]; then
        git -C "${target}" tag "${tag_version}"
    fi
}

function op_pushtags() {
    local target_type="${1}"
    local target="${2}"
    if [ -d "${target}" ] && [ -d "${target}/.git" ]; then
        git -C "${target}" push --tags
    fi
}

function op_switchmod() {
    local target_type="${1}"
    local target="${2}"
    if [ -d "${target}" ] && [ -d "${target}/.git" ]; then
        git -C "${target}/image-common" checkout origin/master
        git -C "${target}/image-common" branch -D "$(get_prop dexec-image-common-branch)"
        git -C "${target}/image-common" fetch origin
        git -C "${target}/image-common" checkout "$(get_prop dexec-image-common-branch)"
    fi
}

function op_remodule() {
    local target_type="${1}"
    local target="${2}"
    if [ -d "${target}" ] && [ -d "${target}/.git" ]; then
        git -C "${target}" reset HEAD --hard
        git -C "${target}" clean -f
        git -C "${target}" submodule deinit image-common
        git -C "${target}" rm image-common
        git -C "${target}" rm --cached image-common
        rm -rf "${target}/.git/modules/image-common"
        echo >"${target}/.gitmodules"
        git -C "${target}" add .
        git -C "${target}" commit -m 'remove submodule'
        git -C "${target}" submodule add https://github.com/docker-exec/image-common.git
        git -C "${target}" add .
        git -C "${target}" commit -m 'add submodule'
    fi
}

function op_upmodule() {
    local target_type="${1}"
    local target="${2}"
    if [ -d "${target}" ] && [ -d "${target}/.git" ]; then
        git -C "${target}/image-common" pull
        git -C "${target}" add .
        git -C "${target}" commit -m 'update submodule'
    fi
}

function op_get() {
    local target_type="${1}"
    local target="${2}"
    if [ -d "${target}" ] && [ -d "${target}/.git" ]; then
        git -C "${target}" fetch origin
        git -C "${target}" stash
        git -C "${target}" rebase
        git -C "${target}" stash pop
        git -C "${target}" submodule sync
        git -C "${target}" submodule update --init
    else
        git clone "https://$(get_prop git-username):$(get_prop git-password)@github.com/docker-exec/${target}.git" --recursive
        git -C "${target}" config user.email "$(get_prop git-email)"
        git -C "${target}" config user.name "$(get_prop git-username)"
    fi
}
