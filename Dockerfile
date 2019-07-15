FROM continuumio/miniconda:4.6.14

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

RUN conda env create -f environment.yml

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

RUN jupyter serverextension enable --py jupyterlab --sys-prefix

#execute service
CMD ["/bin/bash"]
