# Dotnet MVC Dockerfile

This project provide a solution for `how to dockerize the Dotnet MVC`.  
If you work on `Windows` please skip this.

## Setup

### First

Please link to [Windows Docker Machine][1].
Because `Dotnet MVC Images` must be run on Windows Container.
So we need to switch from Linux Container to Windows Container.

Set up the `Windows Server 2019 VM` for hypervisor.
you can use `Vagrant` or `VirtualBox`.

Follow the `Step 1` on `Windows Docker Machine`

```sh
$ git clone https://github.com/StefanScherer/packer-windows
$ cd packer-windows

$ packer build --only=vmware-iso windows_2019_docker.json
$ vagrant box add windows_2019_docker windows_2019_docker_vmware.box
```

### Second

```sh
$ git clone https://github.com/StefanScherer/windows-docker-machine
$ cd windows-docker-machine
$ vagrant up --provider vmware_desktop 2019-box

- or -

$ vagrant up --provider virtualbox 2019-box
```

### Third

Switch to Windows containers.

```sh
docker context use 2019-box
```

### Final Check 

```sh
docker version
Client: Docker Engine - Community
 Version:           19.03.0-beta1
 API version:       1.39 (downgraded from 1.40)
 Go version:        go1.12.1
 Git commit:        62240a9
 Built:             Thu Apr  4 19:15:32 2019
 OS/Arch:           darwin/amd64
 Experimental:      false

Server: Docker Engine - Enterprise
 Engine:
  Version:          18.09.5
  API version:      1.39 (minimum version 1.24)
  Go version:       go1.10.8
  Git commit:       be4553c277
  Built:            04/11/2019 06:43:04
  OS/Arch:          windows/amd64
  Experimental:     false
```

If you see the Docker Engine switch to `windows/amd64`  
you are good to go.

## Project

Create a new folder call `src`, and put your `Dotnet MVC` project into this folder.

```sh
mkdir src
```

You can also using different folder name for free,  
just need to change 

## Build

```sh
docker build -t <tag-name> .
```

## Publish 

```sh
docker run -d -p 3000:80 <tag-name>
```

When you run Windows containers with publish ports then you can use the IP address of the Windows Docker host to access it.

Run following command will give you IP address of the Windows Docker host.

```sh
docker-machine ip

- or -

docker context
```

or If you lazy 

```sh
open http://$(docker-machine ip 2019-box):8080
```


[1]: https://github.com/StefanScherer/windows-docker-machine