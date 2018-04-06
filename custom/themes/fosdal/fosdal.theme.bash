#!/usr/bin/env bash
SCM_THEME_PROMPT_PREFIX=" ${normal}(scm:"
SCM_THEME_PROMPT_DIRTY=" ${red}⨯"
SCM_THEME_PROMPT_CLEAN=" ${green}•"
SCM_THEME_PROMPT_SUFFIX="${normal})"

GIT_THEME_PROMPT_PREFIX=" ${normal}(git:"
GIT_THEME_PROMPT_DIRTY=" ${red}⨯"
GIT_THEME_PROMPT_CLEAN=" ${green}•"
GIT_THEME_PROMPT_SUFFIX="${normal})"

function setPrompt() {
    status=$?
    status_msg=""
    if [[ "${status}" -ne 0 ]]; then
      status_msg=" ${red}[code: ${status}]"
    fi
    setElapsed
    export PS1="${yellow}${green}\u@\h:\w$(scm_prompt_info)${elapsed}${status_msg}${yellow}\n> ${normal}"
}

function startTimer {
    timer=${timer:-$SECONDS}
}

function setElapsed {
    elapsed=" ${cyan}$(format_time $(($SECONDS - $timer)))${normal}"
    unset timer
}

function format_time () {
    num=$1
    if((num<1));then
        echo ""
    else
        if ((num<60)); then
            result=$(printf "%ss" $num)
        elif ((num<3600)); then
            result=$(printf "%sm" $(bc <<< "scale=1;$num/60"))
        elif ((num<86400)); then
            result=$(printf "%sh" $(bc <<< "scale=1;$num/60/60"))
        else
            result=$(printf "%sd" $(bc <<< "scale=1;$num/60/60/24"))
        fi
        echo "Δ${result/\.0/}"
    fi
}

trap 'startTimer' DEBUG

safe_append_prompt_command setPrompt
safe_append_prompt_command 'history -a'
