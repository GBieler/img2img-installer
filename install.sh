## install system dependencies
apt update
apt-get install psmisc
pip install comfy-cli
cd /workspace
echo y | comfy which
echo y | comfy --skip-prompt --workspace=/workspace/ComfyUI install --nvidia
echo y | comfy set-default /workspace/ComfyUI

# Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
nvm install 20

# ViewComfy
git clone https://github.com/ViewComfy/ViewComfy 
cd /workspace/ViewComfy 
npm install
mv /workspace/img2img-installer/view_comfy.json /workspace/ViewComfy/view_comfy.json

## Installing custom nodes
# IPAdapter plus
echo y | comfy node install ComfyUI_IPAdapter_plus

# controlnet_aux
echo y | comfy node install comfyui_controlnet_aux

## downloading models
cd /workspace/ComfyUI/models/controlnet
wget https://huggingface.co/lllyasviel/sd_control_collection/resolve/7cf256327b341fedc82e00b0d7fb5481ad693210/t2i-adapter_diffusers_xl_lineart.safetensors
wget https://huggingface.co/lllyasviel/sd_control_collection/resolve/7cf256327b341fedc82e00b0d7fb5481ad693210/sai_xl_depth_256lora.safetensors


cd /workspace/ComfyUI/models/clip_vision
wget https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors
mv model.safetensors CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors

mkdir /workspace/ComfyUI/models/ipadapter
cd /workspace/ComfyUI/models/ipadapter
wget https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus_sdxl_vit-h.safetensors

cd /workspace/ComfyUI/models/checkpoints
wget https://huggingface.co/RunDiffusion/Juggernaut-XL-v9/resolve/main/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors


## restarting ComfyUI
cd /workspace/ComfyUI
fuser -k 3000/tcp
comfy launch --background -- --port 3000
comfy run --workflow ../img2img-installer/workflow_api_demo.json
# nohup python main.py --listen --port 3000 > /dev/null 2>&1 &

## start ViewComfy
cd /workspace/ViewComfy
COMFYUI_PORT=3000 NEXT_PUBLIC_VIEW_MODE="true" npm run dev -- --port 8000



