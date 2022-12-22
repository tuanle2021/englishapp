FROM ubuntu:22.04

RUN apt update -y && \
        apt install -y nodejs \
        npm \
        curl \
        openssh-server

RUN mkdir -p /app

WORKDIR /app

COPY . .

RUN mkdir -p -m 755 /var/run/sshd

CMD /usr/sbin/sshd -D
