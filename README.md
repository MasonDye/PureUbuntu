 ![PureUbuntuLogo](https://raw.githubusercontent.com/MasonDye/PureUbuntu/main/pterodactyl-ubuntu.png) 
# PureUbuntu - Egg
Run Linux Ubuntu on pterodactyl &amp; Wings &amp; Docker

This is a complete implementation that grants full root access to Linux servers on Pterodactyl using this Egg.

## How to use:
  Download the `pterodactyl-egg-linux-ubuntu.json` file
  Open your pterodactyl console and open nests --> import egg

## Principle:
Simple Pterodactyl Egg written with Docker base image for Ubuntu 22.04, including a comprehensive selection of commonly used software packages.

## Root Privileges:
Full Linux permissions are obtained for Docker containers through modification of Pterodactyl Wings, granting privileged access.

# Edit & Build Wings

This step is not  **mandatory** , but if you require root permissions, you will need to perform it.
Wings itself has strict requirements for container permissions, but we can relax its original restrictions by modifying the source code.

-  **Step 1**
 clone wings repo ` git clone https://github.com/pterodactyl/wings.git `
-  **Step 2**
 open repo folder `wings/environment/docker`.
- **Step 3**
edit `container.go` ,find to 250 line.
```
                //SecurityOpt:    []string{"no-new-privileges"},
                ReadonlyRootfs: false,
                CapDrop: []string{
                        "setpcap", "mknod", "audit_write", "net_raw", "dac_override",
                        "fowner", "fsetid", "net_bind_service", "sys_chroot", "setfcap",
                },
                NetworkMode: networkMode,
                UsernsMode:  container.UsernsMode(cfg.Docker.UsernsMode),
                Privileged:   true,
```
Delete line : `SecurityOpt:    []string{"no-new-privileges"},`
Edit line : `ReadonlyRootfs: true, --> ReadonlyRootfs: false,`
Add line : `Privileged:   true,`

- **Step 4 - Build**
  go build
  
