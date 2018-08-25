#!/bin/bash
if [ ! -f /root/.ssh/id_rsa ]; then
  echo "==========================================================" && ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -N "" && echo "===================SAVE YOUR PUBLIC KEY===================" && cat /root/.ssh/id_rsa.pub && echo "==========================================================" && printf "Port $SSHD_PORT \r\n" > /etc/ssh/sshd_config && printf "AuthorizedKeysFile /root/.ssh/id_rsa.pub \r\n" >> /etc/ssh/sshd_config && if [ $PUB_KEY_ONLY == false ]; then echo "root:$ROOT_PWD" | chpasswd ; fi && if [ $PUB_KEY_ONLY == true ]; then printf "ChallengeResponseAuthentication no \r\nPasswordAuthentication no \r\n" >> /etc/ssh/sshd_config; else printf "PasswordAuthentication yes \r\nPermitRootLogin yes \r\nChallengeResponseAuthentication yes \r\n" >> /etc/ssh/sshd_config; fi
fi
if [[ ! -z "$@" ]]; then 
  exec "$@"
else
  exec /usr/sbin/sshd -D -f /etc/ssh/sshd_config -e -h /root/.ssh/id_rsa
fi
