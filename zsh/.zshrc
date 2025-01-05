_zcompile() {
    if [[ ${+NO_CACHE} -eq 1 ]]; then
        SHELDON_NO_CACHE=1
    fi

    if [[ $(type sheldon) > /dev/null ]]; then
        if [[ ${+SHELDON_NO_CACHE} -eq 1 || ! -f /tmp/sheldon.cache || $(find /tmp/sheldon.cache -mtime +1) ]]; then
            echo "creating sheldon cache"
            sheldon source > /tmp/sheldon.cache
            zcompile /tmp/sheldon.cache
        fi
        source /tmp/sheldon.cache
    fi
}
_zcompile
