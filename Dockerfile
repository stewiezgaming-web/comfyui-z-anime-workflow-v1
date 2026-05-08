# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# build-time tokens for gated downloads — never baked into final image.
# pass via: docker build --build-arg HF_TOKEN=$HF_TOKEN ...
ARG HF_TOKEN=""

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail rgthree-comfy@1.0.2512112053 --mode remote
RUN git clone https://github.com/city96/ComfyUI-GGUF /comfyui/custom_nodes/ComfyUI-GGUF && cd /comfyui/custom_nodes/ComfyUI-GGUF && git checkout 6ea2651e7df66d7585f6ffee804b20e92fb38b8a
RUN comfy node install --exit-on-fail comfyui-lora-manager@0.9.11

# download models into comfyui
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/SeeSee21/Z-Anime/resolve/main/diffusion_models/z-anime-distill-8step-bf16.safetensors' --relative-path models/diffusion_models --filename 'z-anime-distill-8step-bf16.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/lovis93/testllm/resolve/ed9cf1af7465cebca4649157f118e331cf2a084f/ae.safetensors' --relative-path models/vae --filename 'ae.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/SeeSee21/Z-Anime/resolve/main/aio/z-anime-distill-8step-aio-fp8.safetensors' --relative-path models/checkpoints --filename 'z-anime-distill-8step-aio-fp8.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/lovis93/testllm/resolve/ed9cf1af7465cebca4649157f118e331cf2a084f/ae.safetensors' --relative-path models/diffusion_models --filename 'qwen_3_4b-fp8.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Qwen/Qwen3-4B-MLX-bf16/resolve/main/model-00001-of-00002.safetensors' --relative-path models/text_encoders --filename 'qwen_3_4b-bf16.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/SeeSee21/Z-Anime/resolve/main/gguf/z-anime-base-q8_0.gguf' --relative-path models/diffusion_models --filename 'z-anime-base-q8_0.gguf' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done
