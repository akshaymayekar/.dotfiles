function killport --description 'Find and kill processes running on a given port'
    if test -z "$argv[1]"
        echo "Usage: killport <port>"
        return 1
    end

    set -l port $argv[1]
    set -l pids (lsof -ti :$port)

    if test -z "$pids"
        echo "No processes found on port $port"
        return 0
    end

    echo "Processes on port $port:"
    lsof -i :$port

    read -l -P "Kill these processes? (y/n) " confirm

    if test "$confirm" = "y"
        echo $pids | xargs kill -9
        echo "Killed processes on port $port"
    else
        echo "Cancelled"
    end
end
