function v
    if test (count $argv) -eq 0
        nvim (rg --files | fzf)
    else
        nvim $argv
    end
end
