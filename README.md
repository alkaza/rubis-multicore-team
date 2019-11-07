## Instructions
Scripts in this repository are step-by-step instruction, please read and understand them before use (some changes are necessary for different target platforms)

Running commands one-by-one is recommended to be able to resolve issues that might occur, run scripts at your own risk

## Resources
[Matching SM architectures (CUDA arch and CUDA gencode) for various NVIDIA cards](http://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/)

[OpenCV with CUDA for Tegra](https://docs.opencv.org/3.2.0/d6/d15/tutorial_building_tegra_cuda.html)

[Explain Shell](https://explainshell.com/)

[Shell Check](https://www.shellcheck.net/)

## Note to self
```
sudo gedit /etc/default/grub
#GRUB_CMDLINE_LINUX_DEFAULT="nouveau.modeset=0"
sudo update-grub2
```
