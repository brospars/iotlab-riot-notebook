# Copyright (c) Benoit Rospars
# Distributed under the terms of the Modified BSD License.
# Based on minimal notebook from https://github.com/jupyter/docker-stacks
FROM jupyter/minimal-notebook

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID
