function qq --description 'Ask a quick question to a local Ollama model'
    argparse 'm/model=' -- $argv
    or return 1

    set -l model (string join '' $_flag_model)
    if test -z "$model"
        set model llama3.2
    end

    if test -z "$argv"
        echo "Usage: qq [--model <model>] <question>"
        return 1
    end

    if not curl -s http://localhost:11434 > /dev/null 2>&1
        echo "Ollama is not running. Start it with: ollama serve"
        return 1
    end

    set -l question (string join ' ' $argv)
    set -l payload (jq -n --arg m "$model" --arg q "$question" \
        '{model: $m, system: "Be concise and to the point. No fluff.", prompt: $q, stream: false}')

    curl -s http://localhost:11434/api/generate \
        -H 'Content-Type: application/json' \
        -d "$payload" \
    | jq -r '.response'
end
