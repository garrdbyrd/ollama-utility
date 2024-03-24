# ollama utility script(s)

This is a collective a script(s) that I am working on to interact with ollama more easily.


# Notes
I am testing on my personal computer, which uses an AMD RX 7600XT. Thus, I will be interacting with docker/ollama using the AMD-appropriate commands. Mainly the following

```
docker run -d --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:rocm
```

which can just be replaced with the following for NVIDIA (as of 2024-03-24).

```
sudo docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

This is only tested on my personal computer, which uses **Arch Linux**. It is not tested for any other operating system.