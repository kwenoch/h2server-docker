FROM h2server AS initial

FROM ubuntu:resolute

ARG USER_UID="1000"
ARG USER_GID="1000"
ARG TARGETARCH

ARG USER_HOME="/home/h2server"

ARG H2SERVER_ROOT="/h2server"
ARG H2SERVER_BIN="${H2SERVER_ROOT}/H2Server.exe"

COPY files/payload.tgz /tmp

RUN /usr/bin/apt update && \
    /usr/bin/apt install -y \
        adduser \
        ca-certificates \
        curl \
        debconf \
        file \
        gpg \
        locales \
        passwd \
        pigz \
        screen \
        sed \
        tar \
        wget \
        xz-utils && \
    /usr/bin/sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    /usr/sbin/dpkg-reconfigure --frontend=noninteractive locales && \
    /usr/bin/mkdir /tmp/payload && \
    /usr/bin/pigz -dc /tmp/payload.tgz | /usr/bin/tar -xvf - -C /tmp/payload && \
    /usr/bin/mv /tmp/payload/entrypoint.sh / && \
    /usr/bin/mv /tmp/payload/run_h2server.sh / && \
    /usr/bin/mv /tmp/payload/setenv.sh /usr/bin/setdockerenv && \
    . /usr/bin/setdockerenv && \
    /usr/bin/sh -c /tmp/payload/install_deps.sh && \
    /usr/bin/sh -c /tmp/payload/install_box64+box32.sh && \
    /usr/sbin/userdel ubuntu && \
    /usr/bin/rm -rf /home/ubuntu && \
    /usr/sbin/groupadd -g ${USER_GID} h2server && \
    /usr/sbin/useradd -u ${USER_UID} -g ${USER_GID} -m h2server && \
    /usr/bin/mkdir /proton7 && \
    /usr/bin/pigz -dc /tmp/payload/proton_dist.tgz | /usr/bin/tar -xvf - -C /proton7 && \
    /usr/bin/rm -rf /tmp/payload && \
    /usr/bin/rm -f /tmp/*.tgz && \
    /usr/bin/rm -rf /var/lib/apt/lists/*

ENV USER_UID="${USER_UID}"
ENV USER_GID="${USER_GID}"
ENV TARGETARCH="${TARGETARCH}"

ENV H2SERVER_ROOT="${H2SERVER_ROOT}"
ENV H2SERVER_BIN="${H2SERVER_BIN}"

ENV H2SERVER_ARGS="-live"

EXPOSE 2000/tcp
EXPOSE 2001/tcp
EXPOSE 2002/tcp
EXPOSE 2003/tcp
EXPOSE 2004/tcp
EXPOSE 2005/tcp
EXPOSE 2006/tcp
EXPOSE 2007/tcp
EXPOSE 2008/tcp
EXPOSE 2009/tcp
EXPOSE 2010/tcp
EXPOSE 2011/tcp

CMD ["/entrypoint.sh"]
