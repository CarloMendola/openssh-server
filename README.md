# Dockerfile for openssh-server image

This is a **Dockerfile** to build a docker image for **openssh-server** based on **alpine**:3.4.

# Environment Variable
The following environment variable are available:
- **SSHD_PORT** - default: 22
  > set this variable to start openssh-server on different port. (useful disabling container network isolation with --net=host)

- **PUB_KEY_ONLY** - default: true
	> use this variable to **force** authentication with **public key**. 
	The key pair is **generated** at each instantiation (docker run), hence see **docker logs** to get public key. 
	Setting this variable to false allow interactive login authentication.

- **ROOT_PWD** - default: alpine
	> this will be the **password** of **root** account to be used at ssh login.
	**Note:** this password will only set from entrypoint script if **$PUB_KEY_ONLY** variable is set to "**false**".
	
# Build docker image
In order to build image to docker registry enter the project directory and exec the command below:
`docker build -t carlomendola85/openssh-server:1.0 .`

# Docker run examples
If you have just built the image or pulled from docker hub, you can instantiate the openssh-server container with the following command:
`docker run --name sshd -d -e PUB_KEY_ONLY=false -p 22000:22 carlomendola85/openssh-server:1.0`

**Note:** bear in mind that if container network isolation is enforced like in the example above you **must** forward external port to container port - see **-p 22000:22**.
As soon as your container is running you can check the container logs as follows:
`docker logs -f sshd`
and take a look at the output
  >==========================================================
Generating public/private rsa key pair.
Created directory '/root/.ssh'.
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:Co73xmqtKi2WXlIko/KHM3ItJ25RXd7V/rUKEpiMLxA root@3e822f6b28fa
The key's randomart image is:
+---[RSA 2048]----+
| . |
| E  . . .  |
| o ...ooo. . . |
|. +....+... . .|
|o  oo . S .  .o|
|..o= o o . . ..|
|.o@o*oo . . .  |
|o*=O..+  . |
|o=ooo+.  |
+----[SHA256]-----+
===================SAVE YOUR PUBLIC KEY===================
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMIYVIRkvAfL/tyIORePn6MiT/XBARCArrsjGLgSQq/0cxgZQv/t2zS7Om3Iy74+gdfglhY/Qi5dHzBZ7K2UEeKBWPngmHB+9ZJ3zukR0CUJLfThdp5AesPsiezPmdjBzJ74UXlYmDu42HjKhqhBySsEOwJTicO84kibt8ghaFU/y7w3fUiHdWbJ88h8+YOtDSBFwWVJb7y+Y4fNWKS40gqiUxvtcHYcMe7WMs/ucDIdBh/fqYlevc6R04eAd6h/KICCz0VXTeJFGqZ7o4iAEPl1m5GnkJXVzKqwcGYtE6koKPhxH5okkRLsWNAGARSoS2aEA4avKXBAr2ulj84Fur root@3e822f6b28fa
==========================================================
chpasswd: password for 'root' changed
Server listening on 0.0.0.0 port 22.
Server listening on :: port 22.

## That's all folks!

