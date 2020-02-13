![screenshot](images/Screenshot.png)
## photohop CC v19 installer for linux
This bash script installs Photoshop CC version 19 on your Linux machine using wine behind the scene
and sets some necessary component up for best performance

### Features
* downloads necessary component and installs them (vcrun,atmlib,msxml...)
* downloads photoshop.exe installer and installs it automatically
* creates photoshop commands and desktop entry
* configures wine for dark mode
* detects various graphic cards like (intel, Nvidia...)
* saves the downloaded files in your cache directory
* It's free and you will not need any license key

### Installation
Installation
for installing photoshop just run the bash script with below command it downloads and installs photoshop include its component and configures wine automatically

```bash
chmod +x PhotoshopSetup.sh
./PhotoshopSetup.sh
```
during installation please pay attention to script messages
