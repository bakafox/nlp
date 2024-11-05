#!/bin/bash

# Простой монитор ресурсов, весь скрипт сгенерирован через локальную llm-ку!

start_time=$(date +%s)
mpstat 1 > /tmp/cpu_usage &

while true; do
    clear

    current_time=$(date +"%Y-%m-%d %H:%M:%S")
    elapsed_time=$(( $(date +%s) - start_time ))
    echo -e "\033[1;36m$(date +"%Y-%m-%d %H:%M:%S")\033[0m"
    echo -e "Since started: $(date -u -d @"$elapsed_time" +%H:%M:%S)\n"

    echo -e "\033[1;31m====== GPU ======\033[0m"
    nvidia-smi --query-gpu=utilization.gpu,utilization.memory,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits | awk -F',' '{printf "\033[1;33mGPU Utilization:\033[0m %s%%\n\033[1;32mVRAM Usage:\033[0m %sMi /%sMi\n\033[1;36mTemperature:\033[0m %s°C\n", $1, $3, $4, $5}'

    echo -e "\n\033[1;34m====== RAM ======\033[0m"
    free -h | awk '/^Mem/ {printf "\033[1;32mRAM Usage:\033[0m %s / %s\n", $3, $2}'

    echo -e "\n\033[1;35m====== CPU ======\033[0m"
    tail -n 1 /tmp/cpu_usage | awk '/all/ {printf "\033[1;33mCPU Utilization:\033[0m %.2f%%\n\n", 100-$12}'

    sleep 1
done

trap "kill $(jobs -p)" EXIT


#!/bin/bash
# watch -n 1 " \
# echo '====== GPU ======\n' && \
# nvidia-smi --query-gpu=utilization.gpu,utilization.memory,memory.total,memory.used,memory.free,temperature.gpu,power.draw --format=csv && \
# echo '\n====== RAM ======\n' && \
# free -h && \
# echo '\n====== CPU ======\n' && \
# mpstat 1 1 \
# "
