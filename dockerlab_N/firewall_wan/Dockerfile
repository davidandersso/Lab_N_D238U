FROM ubuntu:latest

RUN apt update && apt install -y \
    iputils-ping \
    bash \
    iproute2 \
    iptables \
    rsyslog \
    procps
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]