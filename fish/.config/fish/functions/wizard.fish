function wizard
    ~/ai/llama.cpp/main -ins \
    -f ~/ai/llama.cpp/prompts/alpaca.txt \
    -t 4 \
    --multiline-input \
    -ngl 32 \
    -m ~/ai/llama.cpp/models/Wizard-Vicuna-13B-Uncensored.ggmlv3.q4_K_S.bin \
    --color \
    -c 2048 \
    --temp 0.7 \
    --repeat_penalty 1.1
end
