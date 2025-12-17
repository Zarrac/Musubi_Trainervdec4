#!/bin/bash

# Musubi Trainer Installer for Vast.ai / RunPod
# Optimized for RTX 5080/Blackwell (CUDA 12.9) + Python 3.10

# --- Configuration ---
export WORKSPACE="/workspace"
export INSTALL_DIR="$WORKSPACE/SECourses_Musubi_Trainer"
export VENV_DIR="$WORKSPACE/venv"

# Ensure we are in the workspace
cd $WORKSPACE

# 1. Clone the Musubi Trainer Repository
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Cloning SECourses_Musubi_Trainer..."
    git clone --depth 1 https://github.com/FurkanGozukara/SECourses_Musubi_Trainer
else
    echo "Updating SECourses_Musubi_Trainer..."
    cd "$INSTALL_DIR"
    git pull
    cd $WORKSPACE
fi

# 2. Generate the Fixed Requirements File
# This installs PyTorch 2.8 (with CUDA 12.9 support) and Python 3.10 compatible wheels
cat <<EOF > "$INSTALL_DIR/requirements_trainer.txt"
--extra-index-url https://download.pytorch.org/whl/cu129
torch==2.8.0
torchvision
torchaudio
flash_attn @ https://huggingface.co/MonsterMMORPG/Wan_GGUF/resolve/main/flash_attn-2.8.2-cp310-cp310-linux_x86_64.whl ; sys_platform == 'linux'
xformers @ https://huggingface.co/MonsterMMORPG/Wan_GGUF/resolve/main/xformers-0.0.33+c159edc0.d20250906-cp39-abi3-linux_x86_64.whl ; sys_platform == 'linux'
sageattention @ https://huggingface.co/MonsterMMORPG/Wan_GGUF/resolve/main/sageattention-2.2.0-cp39-abi3-linux_x86_64.whl ; sys_platform == 'linux'
psutil
cn2an==0.5.22
cython==3.0.7
descript-audiotools==0.7.2
ffmpeg-python==0.2.0
g2p-en==2.1.0
jieba==0.42.1
json5==0.10.0
keras==2.9.0
librosa==0.10.2.post1
modelscope==1.27.0
munch==4.0.0
numba==0.58.1
numpy==1.26.2
omegaconf>=2.3.0
pandas==2.3.2
tensorboard==2.9.1
textstat>=0.7.10
tokenizers==0.21.0
hf_xet
pydub
WeTextProcessing; sys_platform == 'linux'
gradio==5.45.0
wandb
EOF

# 3. Create and Activate Virtual Environment
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating Virtual Environment..."
    python3 -m venv "$VENV_DIR"
fi

echo "Activating VENV..."
source "$VENV_DIR/bin/activate"

# 4. Install Dependencies
echo "Installing Dependencies..."
pip install --upgrade pip
pip install -r "$INSTALL_DIR/requirements_trainer.txt"

# 5. Install Musubi Tuner (Submodule)
cd "$INSTALL_DIR"
if [ ! -d "musubi-tuner" ]; then
    echo "Cloning musubi-tuner..."
    git clone --depth 1 https://github.com/kohya-ss/musubi-tuner
fi

cd musubi-tuner
git pull
echo "Installing musubi-tuner..."
pip install -e .
cd ..

# 6. Launch the GUI
echo "Installation Complete."
echo "Starting GUI on Localhost:7860..."
echo "Please forward port 7860 via SSH to access."
unset LD_LIBRARY_PATH

# Check if running in background (On-Start) or interactive
if [ -t 0 ]; then
    # Interactive mode (Terminal)
    python gui.py
else
    # Background mode (On-Start Script)
    nohup python gui.py > gui_log.txt 2>&1 &
fi
