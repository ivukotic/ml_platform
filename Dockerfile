FROM nvidia/cuda:11.1-runtime-ubuntu20.04
#FROM ubuntu:20.04

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    curl \
    git \
    jq \
    vim \
    wget \
 && rm -rf /var/lib/apt/lists/*

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

RUN git clone https://github.com/ivukotic/ML_platform_tests.git

COPY private_jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
COPY environment.sh .exec run.sh .shell /
RUN chmod 755 /.exec /run.sh /.shell \
 && mkdir /workspace

RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

ENTRYPOINT ["/run.sh"]
CMD ["/bin/bash"]
