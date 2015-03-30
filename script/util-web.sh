function get_headers() {
    local url="${1}"
    local headers=$(curl -sIL "${url}" | grep ':')
    echo "${headers[@]}"
}

function get_header() {
    local needle="^${1}: (.+)$"; shift
    local haystack="${@}"
    grep -Ee "${needle}" <<<"${haystack}" \
        | sed -Ee "s/${needle}/\1/"
}

function get_content() {
    local url="${1}"
    local content=$(curl -sL "${url}")
    echo "${content}"
}

function get_paged_content() {
    headers=$(get_headers $1)
    link_header=$(get_header "Link" "${headers[@]}")

    link_pattern="^<(.+)>.*next.*<(.+)>.+$"

    next=$(sed -Ee "s/${link_pattern}/\1/" <<<"${link_header}")
    last=$(sed -Ee "s/${link_pattern}/\2/" <<<"${link_header}")

    if [ ! -z "${next}" ] && [ next != last ]; then
        printf "%s\n%s" "$(get_content $1)" "$(get_paged_content $next)"
    else
        printf "%s" "$(get_content $1)"
    fi
}

function get_github_repos() {
    local name_pattern='.*"name": "(.+)",'
    repos=($(get_paged_content https://api.github.com/orgs/docker-exec/repos \
                | grep '"name"' \
                | sed -Ee "s/${name_pattern}/\1/" \
                | sort))
    echo "${repos[@]}"
}
