FROM nvidia/cuda:12.8.1-runtime-ubuntu20.04
#FROM ubuntu:20.04

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    curl \
    git \
    jq \
    vim \
    wget \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*


RUN python3 -m pip --no-cache-dir install \
    jupyter \
    jupyterlab

RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj -C /bin/ --strip-components=1 bin/micromamba \
    && micromamba shell init --shell=bash -p /opt/conda

COPY environment-codas-hep.yml environment-dl-minicourse.yml environment.yml /

# Select one named environment
RUN micromamba create -f environment.yml -y \
    && micromamba create -f environment-dl-minicourse.yml -y \
    # && micromamba create -f environment-codas-hep.yml -y \
    && micromamba clean -a

RUN curl -OL https://raw.githubusercontent.com/maniaclab/ci-connect-api/master/resources/provisioner/sync_users_debian.sh \
    && chmod +x sync_users_debian.sh

COPY environment /environment
COPY exec        /.exec
COPY run         /.run
COPY shell       /.shell

RUN chmod 755 .exec .run .shell
RUN mkdir /workspace

COPY private_jupyter_notebook_config.py /usr/local/etc/jupyter_notebook_config.py

RUN jupyter serverextension enable --py jupyterlab --sys-prefix

RUN git clone https://github.com/ivukotic/ML_platform_tests.git

ENTRYPOINT [ "/.run" ]