# Dockerfile for openssh-server image

This is a **Dockerfile** to build a docker image for **openssh-server** based on **alpine**:3.4.

[![Docker Automated build](https://img.shields.io/docker/automated/carlomendola85/openssh-server.svg)](https://hub.docker.com/r/carlomendola85/openssh-server/)
[![Docker Build Status](https://img.shields.io/docker/build/carlomendola85/openssh-server.svg)](https://hub.docker.com/r/carlomendola85/openssh-server/)
# Environment Variable
The following environment variable are available:
- **SSHD_PORT** - default: 22
  > set this variable to start openssh-server on different port. (useful disabling container network isolation with --net=host)

- **PUB_KEY_ONLY** - default: true
	> use this variable to **force** authentication with **public key**. 
	The key pair is **generated** at each instantiation (docker run), hence see **docker logs** to get private key. 
	Setting this variable to false allow interactive login authentication.

- **ROOT_PWD** - default: alpine
	> this will be the **password** of **root** account to be used at ssh login.
	**Note:** this password will only set from entrypoint script if **$PUB_KEY_ONLY** variable is set to "**false**".
	
# Build docker image
In order to build image to docker registry enter the project directory and exec the command below:
`docker build -t carlomendola85/openssh-server:latest .`

# Docker run examples
If you have just built the image or pulled from docker hub, you can instantiate the openssh-server container with the following command:
`docker run --name sshd -d -e PUB_KEY_ONLY=false -p 22000:22 carlomendola85/openssh-server:latest`

**Note:** bear in mind that if container network isolation is enforced like in the example above you **must** forward external port to container port - see **-p 22000:22**.
As soon as your container is running you can check the container logs as follows:
`docker logs -f sshd`
and take a look at the output
  > Generating public/private rsa key pair. 
  >
  >Created directory '/root/.ssh'.
  >
  >Your identification has been saved in /root/.ssh/id_rsa.
  >
  >Your public key has been saved in /root/.ssh/id_rsa.pub.
  >
  >The key fingerprint is:
  >
  >SHA256:Co73xmqtKi2WXlIko/KHM3ItJ25RXd7V/rUKEpiMLxA root@3e822f6b28fa
  >
  >The key's randomart image is:
  > `omissis`
  >
  >---SAVE YOUR PRIVATE KEY---
  >
  >---BEGIN RSA PRIVATE KEY---
  >
  >`omissis`
  >
  >---END RSA PRIVATE KEY---
  > 
  >chpasswd: password for 'root' changed
  >
  >Server listening on 0.0.0.0 port 22.
  >
  >Server listening on :: port 22.

## Use case scenario
Imagine that you don't want to configure your router to access a service on your private network with dynamic ip address and nat.

Assume you have access to some docker enable external premise where you can istanciate a new container. (with visual studio subscription you can istantiate an azure minimal vm with docker and a static public ip address)

Assume that on your home premises you have an ssh-client enabled device that can open a tunnel to the cloud server and activate a remote port forward. (this openssh-server image has enabled by default "**GatewayPorts**" parameter.)

If a pc on your home network opened a tunnel this way, now you can bypass all the NAT/Firewall configuration just accessing your Cloud public ip address with the remote forwarded port.
  > Example:
  >- On your own raspberry pi you have a service (web server) on port 80
  >- You have deployed a container on a remote cloud infrastructure exposing ports 22000 and 65000.
  >
  >`docker run --name sshd -d -p22000:22 -p65000:65000 carlomendola85/openssh-server:latest`
  >
  > execute a command as follow:
  > `ssh -A -R 65000:192.168.8.1:80 root@yourname.westeurope.cloudapp.azure.com -p22000 -i ~/.ssh/id_container_test_rsa -N `
  > 
  >Now go to work, and from any network access with your web browser
  >`yourname.westeurope.cloudapp.azure.com:65000` 
  >
  >and with a bit of fortune (if you configured correctly azure nat/firewall for port 22000 and 65000) you shall see your raspberrypi's web server.

## That's all folks!
