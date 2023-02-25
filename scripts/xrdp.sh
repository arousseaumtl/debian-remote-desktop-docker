#!/bin/bash

start_xrdp() {
    rm -rf /var/run/xrdp-sesman.pid
    rm -rf /var/run/xrdp.pid
    rm -rf /var/run/xrdp/xrdp-sesman.pid
    rm -rf /var/run/xrdp/xrdp.pid
    xrdp-sesman
    exec xrdp -n
}

stop_xrdp() {
    xrdp --kill
    xrdp-sesman --kill
    exit 0
}


trap "stop_xrdp" SIGKILL SIGTERM SIGHUP SIGINT EXIT
start_xrdp
