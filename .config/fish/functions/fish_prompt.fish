function fish_prompt --description 'Write out the prompt'
	#Save the return status of the previous command
    set stat $status
    

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    if not set -q __fish_color_blue
        set -g __fish_color_blue (set_color -o blue)
    end

    #Set the color for the status depending on the value
    set status_face (set_color green)"(*'-') >"(set_color normal)
    if test $stat -gt 0
       set status_face (set_color red)"($stat ;-;) >"(set_color normal)
    end

    switch $USER

        case root toor

            if not set -q __fish_prompt_cwd
                if set -q fish_color_cwd_root
                    set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
                else
                    set -g __fish_prompt_cwd (set_color $fish_color_cwd)
                end
            end

            printf '%s@%s %s%s%s# ' $USER (prompt_hostname) "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal"

        case '*'

            if not set -q __fish_prompt_cwd
                set -g __fish_prompt_cwd (set_color $fish_color_cwd)
            end
            printf '[%s] %s%s@%s %s%s%s \n\r' (date "+%H:%M:%S") "$__fish_color_blue" $USER (prompt_hostname) "$__fish_prompt_cwd" "$PWD" $__fish_prompt_normal
            #echo "$status_face"
            printf '%s%s' $status_face (__fish_git_prompt) 
            
    end

end
