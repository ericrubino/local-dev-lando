# Local Dev #

This set of scripts should get your local development environment on a USPS OIG laptop or dev VM up to a shared baseline.

Once complete, you are free to install additional dev tools in WSL2 or Windows.

[TOC]

## Instructions ##

### Step 1: Clone the repository ###

First, either clone or download this repository to a directory on your machine.

#### Option 1: Clone ####

    https://github.com/ericrubino/local-dev-lando

Using the clone method, you can update to the latest scripts anytime by running "git pull".

#### Option 2: Download ####

If you do not have Git on your machine, click "..." at the top right of this repository's page on BitBucket and
choose "Download repository". Then, simply extract it to a location on your hard drive.

### Step 2: Run the script ###

1. Open a powershell prompt (Type "powershell" in the Start menu and press Enter when the command appears)
2. cd into the local-dev repository folder
3. Run ".\local-dev.ps1" and answer all prompts as they appear

The following options can be passed to the script to limit the number of prompts during the operation:

- `-quiet` - Suppress all possible prompts and assume defaults based on the other provided flags
- `-windowsLando` - Install the Windows version of Lando and Docker instead of the WSL2 version (NOT RECOMMENDED)
- `-ddev` - Install ddev within WSL2 in addition to Lando
- `-powerToys` - Install PowerToys in Windows (requires admin authentication)
- `-resetWsl` - Delete the existing Ubuntu WSL instance and start from scratch
- `-oigLaptop` - Apply the networking fixes required on an OIG laptop for WSL to connect to the Internet
- `-fullName "My Name"` - Will be used as the author name for git commits
- `-email "me@heremcom"` - Will be used as the author email for git commits

During WSL installation, you will be prompted to create a username and password. This does not have to match your Windows login information.

Once the above completes and you see your command prompt, simply press Ctrl+D or type exit and then press Enter in the main window to continue the script.

Watch out for errors during the process!

![If you got errors, you're gonna have a bad time](https://i.imgflip.com/6vmiiy.jpg)

### Step 3: Develop!

#### Open a WSL window

In the bottom left, click the green icon and choose "New WSL Window" to connect to your WSL instance.

VS Code is now connected to WSL!

#### Open a project

You can check out your projects and run your local dev tools within the terminal.

Tip: Do not store your site files in a folder that is shared with Windows, or file access will slow down
immensely. VS Code has access to all files within WSL2, so choose a location such as /home/[your name]/dev
to store your projects in.

### Step 4: Troubleshooting ###
If you don't see your user account, open powershell and start WSL and your user account will then get setup

### after script install config lando so docker desktop won't install
in your home directory /home/youraccount
mkdir .lando
cd .lando
Now we need to create the config file. I just use nano as it's quick and easy for small text files. So I suggest you do this: nano config.yml
setup:
  buildEngine: false

### install lando update
run install
/bin/bash -c "$(curl -fsSL https://get.lando.dev/setup-lando.sh)"

restart your dev vm next and then start VS Code, connect to WSL

