function llama
    ~/ai/llama.cpp/main -ins \
    -f ~/ai/llama.cpp/prompts/alpaca.txt \
    -t 4 \
    -ngl 32 \
    -m ~/ai/llama.cpp/models/luna-ai-llama2-uncensored.ggmlv3.q6_K.bin \
    --multiline-input \
    -c 2048 \
    --color \
    -s 42
end
