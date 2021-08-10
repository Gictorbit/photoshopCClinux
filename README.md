
<div align="center" class="tip" markdown="1" style>

![screenshot](images/Screenshot.png)

![wine version](https://img.shields.io/badge/wine-%E2%96%B25.22-red) ![Tested on arch](https://img.shields.io/badge/Tested%20on-Archlinux-brightgreen) ![GitHub stars](https://img.shields.io/github/stars/Gictorbit/photoshopCClinux) ![rep size](https://img.shields.io/github/repo-size/gictorbit/photoshopCClinux) ![bash](https://img.shields.io/badge/bash-5.0-yellowgreen)
</div>

# Photoshop CC v19 installer for Linux
This bash script helps you to install Photoshop CC version 19 on your Linux machine using wine behind the scenes
and sets up necessary components for the best performance.

## :rocket: Features
* Downloads necessary components and installs them (`vcrun`, `atmlib`, `msxml`...)
* Downloads `photoshop.exe` installer
* Creates photoshop command and a desktop entry
* Wine Dark mode
* Supports graphic cards like (`Intel` and `NVIDIA`)
* Saves the downloaded files in your cache directory
* It's free and you will not need any license key
* Works on any Linux distribution

## :warning: Requirements
1 - Use the 64bit edition of your distro

2 - Make sure the following packages are already installed on your Linux distro:
* `wine`
* `wine64`
* `winetricks`
* `md5sum`


If they are not already installed, you can install them using your package manager, for example in arch linux:
```bash
sudo pacman -S wine winetricks
``` 
3 - Make sure you have enough storage in your `/home` partition, about `5 GiB`
> 1 GiB will be free after installation

If you want you can install photoshop in different directory

4 - Make sure you have an internet connection and about 1.5 Gib traffic to download photoshop and its components

## :computer: Installation

The installer script uses a virtual drive of wine and makes a new `winprefix` for photoshop

First of all, you need to clone the repository with this command:
```bash
git clone https://github.com/Gictorbit/photoshopCClinux.git
cd photoshopCClinux
```

Then you can easily run the `setup.sh` script to install Photoshop CC on your Linux distro:

```bash
chmod +x setup.sh
./setup.sh
```

You can use `-d` to specify the installation path, and `-c` for the cache directory.
For example:
```bash
./PhotoshopSetup.sh -d /mnt/myfiles/photoshop
```

or

```bash
./PhotoshopSetup.sh -d /mnt/myfiles/photoshop -c /mnt/cache
```

When no options are given, the installer script will use the default path, 
The uninstaller script will detect your custom path so there is no problem,
I recommend using the `-d` option  and having the default cache directory.
This feature is currently being tested, and will be added to `setup.sh` later


<div align="center" class="tip" markdown="1" style>

![setup-screenshot](images/setup-screenshot.png)
</div>

During the installation please pay attention to the script messages

> **NOTE:** Make sure OS version in wine is on windows 7

The installer script uses `winetricks` to install necessary components

## :wine_glass: Wineprefix Configuration

If you need to configure the wineprefix of photoshop you can use `winecfg.sh` script just run the command below:
```bash
chmod +x winecfg.sh
./winecfg.sh
```
## :hammer: Tools

<details>
<summary>:sparkles: Liquify Tools</summary>
As you know photoshop has many useful tools like `Liquify Tools`.</br>

If you get some errors while working with these tools,
it may because of your graphics card.</br>

Photoshop uses the `GPU` to process these tools so before using these tools make sure that your graphics card `(NVIDIA or AMD)` is configured correctly in your Linux machine.
</br>The other solution is you can configure photoshop to use your `CPU` for image processing. to do that, follow the steps below:

* Go to edit tab and open `Preferences` or use the keyboard shortcut `[ctrl+K]`
* Go to the `Performance` tab
* In the graphics processor section, uncheck `Use graphics processor`

![](https://user-images.githubusercontent.com/34630603/80861998-117b7a80-8c87-11ea-8f56-079f43dfafd9.png)
</details>

---
<details>
<summary>:camera: Adobe Camera Raw</summary>

Another useful adobe software is `camera raw` if you want to work with it beside photoshop you must install it separately to do this, after photoshop installation run `cameraRawInstaller.sh` script with commands below:
  
```bash
chmod +x cameraRawInstaller.sh
./cameraRawInstaller.sh
```
  
Then restart photoshop, you can open camera raw from 
`Edit >> Preferences >> Camera Raw`

> **_NOTE1:_** The size of camera raw is about 400MB


> **_NOTE2:_** Camera raw performance depends on your graphics card driver and its configuration

</details>

## :hotsprings: Uninstall
To uninstall photoshop you can use the uninstaller script
Run it with commands below:


```bash
chmod +x uninstaller.sh
./uninstaller.sh
```


## :bookmark: License
![GitHub](https://img.shields.io/github/license/Gictorbit/photoshopCClinux?style=for-the-badge)

---
<a href="https://poshtiban.com">
<img src="images/poshtibancom.png" width="25%"> 
</a>
<a href="https://github.com/Gictorbit/illustratorCClinux">
<img src="https://github.com/Gictorbit/illustratorCClinux/raw/master/images/AiIcon.png" width="9%">
</a>
