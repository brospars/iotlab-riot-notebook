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
    openssh-client \
    bsdmainutils && \
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
RUN pip install iotlabwscli==0.2.0 \
                iotlabcli==3.2.0 \
                aiocoap==0.3 \
                paho-mqtt==1.5.0 \
                pyserial \
                cbor==1.0.0 \
                ed25519==1.5 \
                asynchttp==0.0.4 \
                asyncssh==2.2.0 \
                azure-iot-device==2.1.1 \
                ipympl==0.5.6 \
                ipywidgets==7.5.1 \
                jupyterlab==2.0.1 \
                matplotlib==3.2.1 \
                numpy==1.18.2 \
                pandas==1.0.3 \
                pycayennelpp==1.3.0 \
                python-cayennelpp==0.0.4 \
                scapy==2.4.3 \
                seaborn==0.10.0 \
                scikit-learn==0.22.2 \
                scipy==1.4.1

# IoT-LAB Plot OML tools
RUN pip install --no-cache git+https://github.com/iot-lab/oml-plot-tools.git@0.7.0

# Add Jupyterlab interactive extensions
RUN conda install -c conda-forge nodejs
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager --minimize=False
RUN jupyter labextension install jupyter-matplotlib --minimize=False
RUN jupyter nbextension enable --py widgetsnbextension

RUN mkdir ~/work/.ssh && ln -s ~/work/.ssh ~/.ssh

    
