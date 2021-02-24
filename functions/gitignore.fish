function gitignore -d "Create .gitignore easily using gitignore.io"
    function __gitignore_run -a msg _command
        echo "Working..."
        fish --command "$_command"
        printf " ✓ $msg\n"
    end

    set -l output ".gitignore"
    set -l templates
    set -l update 0
    set -l cache_home $XDG_CACHE_HOME
    set -l gitignoreio_url "https://www.toptal.com/developers/gitignore/api/"

    if test -z "$cache_home"
        set cache_home ~/.cache
    end

    set -l cache_templates "$cache_home/gitignore_templates"

    argparse 'h/help' 'u/update' 'o/output=' -- $argv
    or return

    if set -q _flag_help
        printf "Usage: gitignore [--update] template [templates...] \n"
        printf "                 [--output=<file>] [--help]\n\n"

        printf "     -u --update              Update templates file\n"
        printf "     -o --output=<file>       Write output to <file>\n"
        printf "     -h --help                Show this help\n"
        return
    end
    if set -q _flag_update
        set update 1
    end
    if set -q _flag_output
        set output $_flag_output
    end
    if set -q argv[1]
        set templates $templates "$argv[1]"
    end

    if test ! -s $cache_templates -o $update -ne 0
        if not __gitignore_run "Update templates" "
            curl --max-time 10 -sS '$gitignoreio_url/list' | tr ',' ' ' | tr '\n' ' ' > $cache_templates
            "
            echo "gitignore: can not fetch templates list from gitignore.io." > /dev/stderr
            return 1
        end
    end

    if test ! -s $cache_templates
        echo "gitignore: can not read templates list." > /dev/stderr
        return 1
    end

    if not set -q templates[1]
        return
    end

    set templates (printf ',%s' $templates | cut -c2-)

    if not __gitignore_run "Fetch template" "
        curl --max-time 10 -sS '$gitignoreio_url$templates' > $output
        "
        echo "gitignore: can not fetch template from gitignore.io." > /dev/stderr
        return 1
    end
end
