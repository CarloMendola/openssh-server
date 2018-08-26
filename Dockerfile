FROM alpine:3.8

ENV SSHD_PORT=22
ENV ROOT_PWD=alpine
ENV PUB_KEY_ONLY=true

COPY entrypoint.sh /

RUN apk update && apk add openssh-server openssh-client bash-completion && chmod 777 /entrypoint.sh && rm  -rf /tmp/* /var/cache/apk/*

RUN cat /dev/null > /var/log/btmp && chown root:utmp /var/log/btmp && chmod 600 /var/log/btmp


ENTRYPOINT [ "/entrypoint.sh" ]
