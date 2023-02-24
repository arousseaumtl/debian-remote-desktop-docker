FROM debian AS builder

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -y \
        golang \
        git \
    && git clone https://github.com/geek1011/easy-novnc \
    && cd ./easy-novnc \
    && go build -o /usr/bin/easy-novnc ./

FROM debian

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        xvfb \
        xfce4 \
        supervisor \
        x11vnc \
        sudo \
        dbus-x11 \
    && groupadd user \
    && useradd -m -g user -s /bin/bash user \
    && echo "user:user" | /usr/sbin/chpasswd \
    && echo "user    ALL=(ALL) ALL" >> /etc/sudoers

COPY conf/supervisord.conf /etc/
COPY --from=builder /usr/bin/easy-novnc /usr/bin/easy-novnc

WORKDIR /home/user

EXPOSE 5900

USER user

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
