
<div align="center" class="tip" markdown="1" style>

![screenshot](images/Screenshot.png)

![wine version](https://img.shields.io/badge/wine-%E2%96%B25.22-red) ![Tested on arch](https://img.shields.io/badge/Tested%20on-Archlinux-brightgreen) ![GitHub stars](https://img.shields.io/github/stars/Gictorbit/photoshopCClinux) ![rep size](https://img.shields.io/github/repo-size/gictorbit/photoshopCClinux) ![bash](https://img.shields.io/badge/bash-5.0-yellowgreen)
</div>

# Photoshop CC v19 installer for Linux
This bash script helps you to install Photoshop CC version 19 on your Linux machine using wine behind the scene
and sets some necessary components up for the best performance

## :rocket: Features
* downloads necessary components and installs them (`vcrun`, `atmlib`, `msxml`...)
* downloads `photoshop.exe` installer
* creates photoshop command and a desktop entry
* wine dark mode
* supports graphic cards like (`intel`, `Nvidia`)
* saves the downloaded files in your cache directory
* It's free and you will not need any license key
* works on any Linux distribution

## :warning: Requirements
1- use a 64bit edition of your distro

2-make sure the following packages are already installed on your Linux distro
* `wine`
* `wine64`
* `winetricks`
* `md5sum`


if they are not already installed you can install them using your package manager for example in arch Linux
```bash
sudo pacman -S wine winetricks
``` 
3- make sure you have enough storage in your `/home` partition about `5 GiB`
> 1 GiB will be free after installation

also you can install photoshop in diffrent directory

4- make sure you have an internet connection and about 1.5 Gib traffic to download photoshop and its components

## :computer: Installation

the installer scripts use a virtual drive of wine and makes a new `winprefix` for photoshop

first of all, you need to clone the repository with this command:
```bash
git clone https://github.com/Gictorbit/photoshopCClinux.git
cd photoshopCClinux
```
then you can easily run `setup.sh` script to install photoshop cc on your Linux distro

```bash
chmod +x setup.sh
./setup.sh
```

you can use `-d` to specify the installation path, and `-c` for the cache directory.
for example:
```bash
./PhotoshopSetup.sh -d /mnt/myfiles/photoshop
```
or
```bash
./PhotoshopSetup.sh -d /mnt/myfiles/photoshop -c /mnt/cache
```
when no options are given, the installer script will use the default path, 
the uninstaller script and others will detect your custom path so there is no problem,
I recommend using the `-d` option  and having the default cache directory.
this feature is currently being tested, and will be added to `setup.sh` later


<div align="center" class="tip" markdown="1" style>

![setup-screenshot](images/setup-screenshot.png)
</div>

during installation please pay attention to the script messages

> **NOTE :** make sure OS version in wine is on windows 7

installer script use `winetricks` to install necessary components

## :wine_glass: wineprefix Configuration
if you need to configure the wineprefix of photoshop you can use `winecfg.sh` script just run the command below
```bash
chmod +x winecfg.sh
./winecfg.sh
```
## :hammer: Tools

<details>
<summary>:sparkles: Liquify Tools</summary>
as you know photoshop has many useful tools like `Liquify Tools`.</br>

if you get some errors while working with these tools,
It may because of the graphics card.</br>

photoshop uses the `GPU` to process these tools so before using these tools make sure that your graphics card `(Nvidia, AMD)` is configured correctly in your Linux machine.
</br>The other solution is you can configure photoshop to use your `CPU` for image processing. to do that, follow the steps below:

* go to edit tab and open `preferences` or `[ctrl+K]`
* then go to the `performance` tab
* in the graphics processor settings section, uncheck `Use graphics processor`

![](https://user-images.githubusercontent.com/34630603/80861998-117b7a80-8c87-11ea-8f56-079f43dfafd9.png)
</details>

---
<details>
<summary>:camera: Adobe Camera Raw</summary>

another useful adobe software is `camera raw` if you want to work with it beside photoshop you must install it separately to do this, after photoshop installation run `cameraRawInstaller.sh` script with commands below:
```bash
chmod +x cameraRawInstaller.sh
./cameraRawInstaller.sh
```
then restart photoshop.you can open it from 
`Edit >>Preferences >> Camera Raw`

> **_NOTE1:_** the size of camera raw installation file is about 400MB


> **_NOTE2:_** camera raw performance depends on your graphic card driver and its configuration

</details>

## :hotsprings: Uninstall
to uninstall photoshop you can use the uninstaller script with commands below

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
