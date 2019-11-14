# Copyright (c) Benoit Rospars
# Distributed under the terms of the Modified BSD License.
# Based on minimal notebook from https://github.com/jupyter/docker-stacks
FROM jupyter/minimal-notebook

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cmake \
    curl \
    git \
    build-essential \
    vim \
    emacs \
    python-setuptools \
    python-argparse \
    mosquitto-clients \
    socat \
    g++-multilib \
    net-tools \
    openssh-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install ARM GNU Embedded toolchain
ARG ARM_GCC_URL="https://developer.arm.com/-/media/Files/downloads/gnu-rm"
ARG ARM_GCC_VERSION="7-2018q2"
ARG ARM_GCC_ARCHIVE="gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2"
ARG ARM_GCC_ARCHIVE_URL="${ARM_GCC_URL}/${ARM_GCC_VERSION}/${ARM_GCC_ARCHIVE}"

RUN cd /opt && wget -nv -O - "${ARM_GCC_ARCHIVE_URL}" | tar -jxf -

ENV PATH="/opt/gcc-arm-none-eabi-7-2018-q2-update/bin:${PATH}"

USER $NB_UID

# IoT-LAB CLI tools & Python tools
RUN pip install iotlabwscli \
                # iotlabsshcli \ @ todo fix install
                iotlabcli \
                aiocoap \
                paho-mqtt \
                pyserial

RUN mkdir ~/work/.ssh && ln -s ~/work/.ssh ~/.ssh

    
