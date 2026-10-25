# Getting started with RCP

This repository helps you submit jobs to the [RCP CaaS cluster](https://wiki.rcp.epfl.ch/en/home/CaaS).

The RCP Wiki gives you a [Quick start guide](https://wiki.rcp.epfl.ch/home/CaaS/Quick_Start), which you can follow. However, we provide a base image for bindcraft (and hopefully more later) meaning that you do not necessarily have to build your own image. The setup guide does not cover building your own image and defers to the RCP wiki. 

> [!IMPORTANT]
> **Network requirement**: You must be on the EPFL WiFi or connected to the VPN.

> [!IMPORTANT]
> Using the cluster creates costs. Please be mindful of the resources you use. **Do not forget to stop your jobs when not used!**

> [!IMPORTANT]
> The guide code here is for use in Linux. If you are using Windows, change the \ to `, or just write in a single line.

Content overview:
- [Setup Guide](#setup-guide)
  - [1. Setup Tools on Your Machine](#1-setup-tools-on-your-machine)
  - [2. Login to the Cluster](#2-login-to-the-cluster)
- [Launching jobs](#launching-jobs)
- [Using VS Code](#using-vs-code)

## Setup Guide

#### 1. Setup Tools on Your Machine

#### Install kubectl

Download and install kubectl v1.30.11 (matching the cluster version):

```bash
# macOS with Apple Silicon
curl -LO "https://dl.k8s.io/release/v1.30.11/bin/darwin/arm64/kubectl"

# Linux (AMD64)
# curl -LO "https://dl.k8s.io/release/v1.30.11/bin/linux/amd64/kubectl"

# Install
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown root: /usr/local/bin/kubectl
``` 

See https://kubernetes.io/docs/tasks/tools/install-kubectl/ for other platforms.

#### Setup kubeconfig

Download the kube config file to `~/.kube/config`:

```bash
curl https://wiki.rcp.epfl.ch/public/files/kube-config.yaml -o ~/.kube/config && chmod 600 ~/.kube/config
```

#### Install run:ai CLI

Download and install the run:ai CLI:

```bash
# macOS with Apple Silicon
wget --content-disposition https://rcp-caas-prod.rcp.epfl.ch/cli/darwin

# Linux (replace 'darwin' with 'linux')
# wget --content-disposition https://rcp-caas-prod.rcp.epfl.ch/cli/linux

# Install
chmod +x ./runai
sudo mv ./runai /usr/local/bin/runai
sudo chown root: /usr/local/bin/runai
```

### 2. Login to the Cluster

#### Login to run:ai

```bash
runai login
```

#### Verify access

```bash
# List available projects
runai list projects

# Set your default project
runai config project make-dlai-{GASPARD-USERNAME}
```

#### Verify Kubernetes connection

```bash
kubectl get nodes
```

You should see the RCP cluster nodes listed.

## Launching jobs
### UID / GID
To have access to your files in the jumphost you need to provide your UID and GID
These can me found by connecting to jumphost and writing the command `id -u` to get UID and `id -g` to get GID.
These values need to be passed to the commands below.

You then need to add these values to your env using:
 ```bash
export NB_UID=... #uid value
export NB_GID=... #gid value
 ```

### Interactive

Jobs can be started interactively with the following command:
```bash
runai submit --name JOB_NAME \
  -i registry.rcp.epfl.ch/dlai-bindcraft/bindcraft:latest \
  -g 1 --existing-pvc claimname=make-dlai-scratch,path=/scratch \
  --run-as-user --run-as-uid "${NB_UID}" --run-as-gid "${NB_GID}" \
  --interactive --attach
```

Once inside the container you can activate the conda environment and start a bindcraft job:
```bash
pixi run python ./bindcraft.py \
  --settings '/scratch/{YOUR_GASPARD}/path/to/target.json' \
  --filters './settings_filters/default_filters.json' \
  --advanced './settings_advanced/default_4stage_multimer.json'
```

Make sure to replace the settings path with the path to your `target.json` file. 

### Background

If you want jobs to run in the background you can run with:
```bash
runai submit --name JOB_NAME -i registry.rcp.epfl.ch/dlai-bindcraft/bindcraft:latest \
  -g 1 --existing-pvc claimname=make-dlai-scratch,path=/scratch \
  --run-as-user --run-as-uid "${NB_UID}" --run-as-gid "${NB_GID}" -- \
  pixi run python ./bindcraft.py \
    --settings '/scratch/{YOUR_GASPARD}/path/to/target.json' \
    --filters './settings_filters/default_filters.json' \
    --advanced './settings_advanced/default_4stage_multimer.json'
```

Make sure to replace the settings path with the path to your `target.json` file. 

### Using jumphost

Open a terminal and type:

```bash
ssh {YOUR_GASPARD}@jumphost.rcp.epfl.ch
```

The first time, you will be asked to confirm the host's fingerprint. Type yes and press Enter. Then enter your GASPAR password. Nothing appears on the screen while you type it. This is normal: type it and press Enter. Once you are connected, check where you are:

```bash
pwd
```

You should see:

/home/{YOUR_GASPARD}

This is your personal folder. To list what is in it:

```bash
ls -la
```

More information will follow regarding the folder architecture, especially for Binder Challengers!

### Using jumphost with VS Code

If you are comfortable with the terminal, you can work directly in your space on the cluster. VS Code makes it easier to upload, download and visualize your files.

- One-time setup

Install VS Code if you don't have it.
In VS Code, open the Extensions panel and install Remote - SSH.
Open a new VS Code window and click Connect to...
Choose Connect to Host..., then + Add New SSH Host...
Type:

```bash
ssh {YOUR_GASPARD}@jumphost.rcp.epfl.ch
```

Save it to the suggested SSH config file.

- Each time you connect

Open a new VS Code window and click Connect to....
Choose Connect to Host... and select jumphost.rcp.epfl.ch from the list. Do not choose + Add New SSH Host... again.
Enter your GASPAR password when asked.
Choose Open Folder to browse your files on the cluster. You can drag and drop files in and out of the file panel. It is easy to visualise your .pdb files using ProteinViewer extension.

### Copy files without VS Code (optional)

Run these from your own computer, not from inside the jumphost.

Upload a file:

```bash
scp my_file.pdb {YOUR_GASPARD}@jumphost.rcp.epfl.ch:/home/<gaspar-username>/
```

Download a file:

```bash
scp {YOUR_GASPARD}@jumphost.rcp.epfl.ch:/home/<gaspar-username>/results.csv .
```

The . at the end means "into the current folder on my computer".

### Job management

```bash
runai list jobs
runai describe job <name>
runai logs <name>
runai logs <name> --pod <name>-0-<n>   # specific retry pod
runai delete job <name>
```

### Basic commands

- pwd	Shows the folder you are in
- ls	Lists the files in the current folder
- cd <folder>	Moves into a folder
- cd ..	Goes back up one folder
- mkdir <name>	Creates a new folder
- exit	Disconnects from the jumphost

It will be very beneficial to learn these commands and some more to be comfortable while interacting with your terminal. You can find some useful resources in our drive, in "Learning_Resources___Computational" document.

## Credits

This guide builds upon https://github.com/LTS4/rcp-lts4-guidelines/blob/update-from-rcp/README.md

Special thanks to Noa Emien Etté for this guide and Stanislavs Dubrovskis for his help.

If you encounter any problems or have some questions regarding how to use the cluster, you can always contact Tuna Karasu.
