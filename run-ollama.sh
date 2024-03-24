#!/bin/bash

usage () {
	echo "Usage: $0 [-m model] [-d directory] [-h]"
	echo "  -m MODEL        Specify the ollama model to use                 (default: llama2:13b)"
	echo "  -d DIRECTORY    Specify the directory for the model to read."
	echo "  -h              Show this help message."
}

model="llama2:13b"
directory=""
show_help=0

while getopts "m:d:h" opt; do
    case ${opt} in
        m )
            model=$OPTARG
            ;;
		d )
            directory=$OPTARG
            ;;
        h )
            usage
            exit 0
            ;;
        \? ) # Invalid option or missing argument
            echo "Invalid option or missing argument."
            usage
            exit 1
            ;;
    esac
done

if [ -z "$directory" ]; then
    echo "Error: Directory is required."
    usage
    exit 1
fi

echo "Model: $model"
echo "Directory: $directory"

sudo systemctl start docker
docker run -d --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:rocm
sudo docker exec -it ollama ollama run $model

sudo docker rm -f ollama
