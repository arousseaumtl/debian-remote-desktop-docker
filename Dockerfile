FROM debian:latest AS novnc

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -y \
        golang \
        git \
    && git clone https://github.com/geek1011/easy-novnc \
    && cd ./easy-novnc \
    && go build -o /usr/bin/easy-novnc ./

FROM debian:latest

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        xvfb \
        xfce4 \
        xfce4-goodies \
        supervisor \
        x11vnc \
        sudo \
        dbus-x11 \
        xrdp \
        xorgxrdp \
        git \
        make \
        autoconf \
        libtool \
    && groupadd user \
    && useradd -m -g user -s /bin/bash user \
    && echo "user:user" | /usr/sbin/chpasswd \
    && echo "user    ALL=(ALL) ALL" >> /etc/sudoers

COPY conf/supervisord.conf /etc/
COPY conf/xrdp.ini /etc/xrdp/
COPY scripts/xrdp.sh /scripts/
COPY --from=novnc /usr/bin/easy-novnc /usr/bin/easy-novnc

WORKDIR /home/user

EXPOSE 5900
EXPOSE 3389
EXPOSE 8080

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
