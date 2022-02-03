FROM nvidia/cuda:10.1-runtime-ubuntu18.04

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

COPY environment-codas-hep.yml environment-dl-minicourse.yml environment .exec .run .shell /

RUN apt-get update && apt-get install -y wget git

RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
        bash ~/miniconda.sh -b -p /opt/conda

RUN . /opt/conda/etc/profile.d/conda.sh && \
        conda config --add channels conda-forge && \
        conda install jupyterlab nb_conda_kernels

RUN . /opt/conda/etc/profile.d/conda.sh && \
        chmod 755 /.exec /.run /.shell && \
        conda activate base && \
        jupyter serverextension enable --py jupyterlab --sys-prefix

RUN . /opt/conda/etc/profile.d/conda.sh && \
        conda env create -f /environment-codas-hep.yml

COPY private_jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
RUN git clone https://github.com/ivukotic/ML_platform_tests.git

RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

CMD ["/.run"]
