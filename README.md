# sfe-exo-wsl-setup
 Automated Powershell Script to Setup Exo-Explore in WSL on Windows 10/11



1. Clone Repo or Download PS1 (add a ps command to download and run the ps1 file?)

2. ```powershell -ExecutionPolicy Bypass -File .\00-set-exo-wsl-full.ps1```








Goal:
I want a single run power shell .PS1 file that will allow any windows user to get exo/exo-explore running in WSL and discoverable by other WSL machines on the LAN.

Return:
A complete one-shot-it.ps1 that accomplishes our goal.
The script needs to enable features in windows necessary for WSL. Install WSL if it's not installed. Create a WSL user if first time running. (If this is not possible tell user to install and setup WSL before continuing). Script needs to install cuda drivers and toolkits required for exo-explore. It needs to clone exo-explore repo and install it. Needs to run exo-explore 

Warning:
User must have poweshell open as admin
VmSwitch is deprecated so we need to forward exo-explore ports from windows to the WSL (see attached working IP forward test)
we need to prompt the user for password when WSL requires it (sudo commands)
script should handle edges cases where WSL is not enabled/installed, when multiple distros are installed, etc

Context:
We have multiple windows PCs with Nvidia graphics cards that are mostly idle. We need to keep windows running for drafters when they come in so we'd like to utilize WSL to give us access to the GPU VRAM while they're idle to pool together and run some LLM models locally. It has become cumbersome to do the setup and install on each machine so we'd like have a foolproof script to run and setup any new machine we build or have come into the office. If we get this working in a robust way we'd love to share it with the community so any windows PC users can contribute to the exo/exo-explore ecosystem! See below for what I have currently mostly working.