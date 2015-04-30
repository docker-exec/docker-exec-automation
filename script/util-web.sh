#!/bin/bash

function get_header() {
    local url="${2}"
    local header="${1}"
    local header_pattern="^${header}: (.+)$"
    curl -sIL "${url}" \
        | sed -E \
            -e "s/${header_pattern}/\1/" \
            -e 'tx' -e 'd' -e ':x'
}

function get_content() {
    local url="${1}"
    curl -sL "${url}"
}

function get_paged_content() {
    local url="${1}"
    local link_pattern="^<(.+)>.*\"(.+)\".*<(.+)>.+$"

    local link_header
    local link_next
    local link_relation

    link_header=$(get_header "Link" "${url}")
    link_next=$(sed -Ee "s/${link_pattern}/\1/" <<<"${link_header}")
    link_relation=$(sed -Ee "s/${link_pattern}/\2/" <<<"${link_header}")

    if [ ! -z "${link_next}" ] && [ "${link_relation}" = "next" ]; then
        printf "%s\n%s" "$(get_content "${url}")" "$(get_paged_content "${link_next}")"
    else
        printf "%s" "$(get_content "${url}")"
    fi
}

function get_github_repos() {
    local name_pattern='.*"name": "(.+)",'
    get_paged_content https://api.github.com/orgs/docker-exec/repos \
                | grep '"name"' \
                | sed -Ee "s/${name_pattern}/\1/" \
                | sort
}
