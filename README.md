# Musubi Trainer for Vast.ai (RTX 5080 / Blackwell Support)

This repository contains an automated installer for the **Musubi Trainer**. 
It is specifically engineered to resolve compatibility issues between **Python 3.10** (required for pre-compiled wheels) and **RTX 5080/5090 GPUs** (which require CUDA 12.9+).

## ⚠️ Important Prerequisites

To use this on Vast.ai (or RunPod), you **must** select a specific Docker image that supports Python 3.10. Do not use the default "latest" images.

**Recommended Image:** `2.8.0-cuda-12.9.1-py310-24.04`

## 🚀 One-Click Installation (Vast.ai)

1. **Rent a Machine:**
   - Filter for your GPU (e.g., RTX 5080).
   - Click **Rent**.
   - Click **Edit Image & Configuration**.

2. **Select Image:**
   - Scroll to "Select Image".
   - Choose **"Docker Image"** (Custom).
   - Enter: `vastai/pytorch:2.8.0-cuda-12.9.1-py310-24.04`
   *(Or just search `2.8.0-cuda-12.9.1-py310` in the "pytorch" section)*.

3. **On-Start Script:**
   - Copy the raw content of `install.sh` from this repository.
   - Paste it into the **On-Start Script** box in the Vast configuration.
   - Set Disk Space to at least **100GB**.

4. **Launch:**
   - Start the machine.
   - Wait ~3-15 minutes for installation to complete.

## 🔗 How to Connect

For security, this installer binds the GUI to `localhost`. You must use SSH Tunneling.

1. On your local computer, open a terminal (PowerShell/CMD).
2. Run the SSH command provided by Vast, but add the forwarding flag:
   ```bash
   ssh -p <VAST_PORT> -L 7860:localhost:7860 root@<VAST_IP>
