set -l cache_home $XDG_CACHE_HOME
if test -z "$cache_home"
    set cache_home ~/.cache
end
set -l cache_templates "$cache_home/gitignore_templates"

complete -c gitignore -a (cat "$cache_templates" | tr '\n' ' ') -f
