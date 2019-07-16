FROM continuumio/miniconda:4.6.14

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

COPY environment.yml /environment-codas-hep.yml

RUN conda install -c conda-forge jupyterlab=1.0.2 nb_conda_kernels

RUN conda env create -f /environment-codas-hep.yml

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

RUN jupyter serverextension enable --py jupyterlab --sys-prefix

#execute service
CMD ["/bin/bash"]
