#!/bin/bash

usage () {
	echo "Usage: $0 [-m model] [-d directory] [-h]"
	echo "  -m, --model     MODEL        Specify the ollama model to use                 (default: llama2:13b)"
	echo "  -d, --directory DIRECTORY    Specify the directory for the model to read."
	echo "  -h, --help                   Show this help message."
}

SHORT="m:d:h"
LONG="model:,directory:,help"
PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")

if [[ $? -ne 0 ]]; then
    exit 2
fi

eval set -- "$PARSED"

model="llama2:13b"
directory=""

while true; do
    case "$1" in
        -m|--model)
            model="$2"
            shift 2
            ;;
        -d|--directory)
            directory="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Error"
            exit 3
            ;;
    esac
done

if [ -z "$directory" ]; then
    echo "Error: Directory is required."
    usage
    exit 1
fi

echo "Model:     $model"
echo "Directory: $directory"

sudo systemctl start docker
docker run -d --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:rocm
sudo docker exec -it ollama ollama run $model

sudo docker rm -f ollama
