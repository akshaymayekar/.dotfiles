#### ==== editor ====
abbr -a nv nvim
abbr -a pc 'open -a /Applications/PyCharm\ CE.app/Contents/MacOS/pycharm'

#### ==== shell ====
abbr -a cls clear
abbr -a make gmake

#### ==== ls ====
abbr -a l 'eza -lah --icons --git'
abbr -a ll 'eza -lh --icons --git'
abbr -a la 'eza -lah --icons --git -a'
abbr -a lt 'eza --tree --icons --git'

#### ==== git ====
abbr -a g git
abbr -a ga 'git add'
abbr -a gaa 'git add --all'
abbr -a gst 'git status'
abbr -a gd 'git diff'
abbr -a gc 'git commit'
abbr -a gcmsg 'git commit -m'
abbr -a gco 'git checkout'
abbr -a gsw 'git switch'
abbr -a gb 'git branch'
abbr -a gp 'git push'
abbr -a gpl 'git pull'
abbr -a gf 'git fetch'
abbr -a gm 'git merge'
abbr -a grb 'git rebase'
abbr -a glog 'git log --oneline --decorate --graph'
abbr -a gloga 'git log --oneline --decorate --graph --all'
abbr -a gg 'git gui'

#### ==== docker ====
abbr -a d docker
abbr -a dc docker-compose
abbr -a dps 'docker ps'
abbr -a dpsa 'docker ps -a'
abbr -a dex 'docker exec -it'
abbr -a dlogs 'docker logs -f'
abbr -a dprune 'docker system prune -f'
