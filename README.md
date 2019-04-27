# Docker ARM Jackett
Docker image dedicated to ARMv7 processors, hosting a Jackett server with WebUI.<br />
<br />
Jackett works as a proxy server: it translates queries from SickChill into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software.<br />
See Jackett repository: https://github.com/Jackett/Jackett<br />
<br />
This image is part of a Docker images collection, intended to build a full-featured seedbox, and compatible with WD My Cloud EX2 Ultra NAS (Docker v1.7.0):

Docker Image | GitHub repository | Docker Hub repository
------------ | ----------------- | -----------------
Docker image (ARMv7) hosting a Transmission torrent client with WebUI while connecting to OpenVPN | https://github.com/ahuh/docker-arm-transquidvpn | https://hub.docker.com/r/ahuh/arm-transquidvpn
Docker image (ARMv7) hosting a qBittorrent client with WebUI while connecting to OpenVPN | https://github.com/ahuh/docker-arm-qbittorrentvpn | https://hub.docker.com/r/ahuh/arm-qbittorrentvpn
Docker image (ARMv7) hosting SubZero with MKVMerge (subtitle autodownloader for TV shows) | https://github.com/ahuh/docker-arm-subzero | https://hub.docker.com/r/ahuh/arm-subzero
Docker image (ARMv7) hosting a SickChill server with WebUI | https://github.com/ahuh/docker-arm-sickchill | https://hub.docker.com/r/ahuh/arm-sickchill
Docker image (ARMv7) hosting a Jackett server with WebUI | https://github.com/ahuh/docker-arm-jackett | https://hub.docker.com/r/ahuh/arm-jackett
Docker image (ARMv7) hosting a NGINX server to secure SickRage, Transmission and qBittorrent | https://github.com/ahuh/docker-arm-nginx | https://hub.docker.com/r/ahuh/arm-nginx

## Installation

### Preparation
Before running container, you have to retrieve UID and GID for the user used to mount your tv shows directory:
* Get user UID:
```
$ id -u <user>
```
* Get user GID:
```
$ id -g <user>
```
<br />
The container will run impersonated as this user, in order to have read/write access to the tv shows directory.<br />
<br />
You also need to create a directory to store the Jackett configuration.

### Run container in background
```
$ docker run --name jackett --restart=always -d \
		--add-host=dockerhost:<docker host IP> \
		--dns=<ip of dns #1> --dns=<ip of dns #2> \
		-d
		-p <webui port>:9117 \
		-v <path to config dir>:/config \
		-v <path to downloads dir (OPTIONAL)>:/downloads \
		-v /etc/localtime:/etc/localtime:ro \
		-e "AUTO_UPDATE=<auto update Jackett if needed at first start [true/false]>"
		-e "PUID=<user uid>" \
		-e "PGID=<user gid>" \
		ahuh/arm-jackett
```
or
```
$ ./docker-run.sh jackett ahuh/arm-jackett
```
(set parameters in `docker-run.sh` before launch)

### Configure Jackett
The container will use volumes directories to store configuration files, and download files (OPTIONAL).<br />
<br />
You have to create these volume directories with the PUID/PGID user permissions, before launching the container:
```
/config
/downloads (OPTIONAL)
```

The container will automatically create a  `Jackett` dir with `ServerConfig.json` file in the configuration dir (only if none was present before).<br />

If you modified the `ServerConfig.json` file, restart the container to reload Jackett configuration:
```
$ docker stop jackett
$ docker start jackett
```

## HOW-TOs

### Get a new instance of bash in running container
Use this command instead of `docker attach` if you want to interact with the container while it's running:
```
$ docker exec -it jackett /bin/bash
```
or
```
$ ./docker-bash.sh jackett
```

### Build image
```
$ docker build -t arm-jackett .
```
or
```
$ ./docker-build.sh arm-jackett
```