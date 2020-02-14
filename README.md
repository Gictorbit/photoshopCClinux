![screenshot](images/Screenshot.png)

![GitHub repo size](https://img.shields.io/github/license/Gictorbit/photoshopCClinux?style=flat) ![Tested on arch](https://img.shields.io/badge/Tested%20on-Archlinux-brightgreen)
![GitHub stars](https://img.shields.io/github/stars/Gictorbit/photoshopCClinux?style=sad) ![rep size](https://img.shields.io/github/repo-size/gictorbit/photoshopCClinux) ![bash](https://img.shields.io/badge/bash-5.0.11-yellowgreen)

# photohop CC v19 installer for linux
This bash script installs Photoshop CC version 19 on your Linux machine using wine behind the scene
and sets some necessary component up for best performance

## Features
* downloads necessary component and installs them (`vcrun`,`atmlib`,`msxml`...)
* downloads photoshop.exe installer and installs it automatically
* creates photoshop commands and desktop entry
* configures wine for dark mode
* detects various graphic cards like (`intel`, `Nvidia`...)
* saves the downloaded files in your cache directory
* It's free and you will not need any license key

## Requirements
1- use 64bit edition of your distro

2-make sure below packages are already installed on your Linux distro
* `wine`
* `aria2c`
* `md5sum`

if they are not already installed you can install them using your package manager for example in arch Linux
```bash
sudo pacman -S wine aria2c
``` 
3- make sure you have enogh storage in your `/home` partition about `5 GiB`
> 1 GiB will be free after installation

4- make sure you have internet connection and about 1.5 Gib traffic for downloading photoshop and its components at first time

## Installation
for installing photoshop just run the bash script with below command it downloads and installs photoshop include its component and configures wine automatically

```bash
chmod +x PhotoshopSetup.sh
./PhotoshopSetup.sh
```
during installation please pay attention to script messages

## Uninstall
for uninstall photoshop you can use uninstaller script with below commands
```bash
chmod +x uninstaller.sh
./uninstaller.sh
```


## License
![GitHub](https://img.shields.io/github/license/Gictorbit/photoshopCClinux?style=for-the-badge)
