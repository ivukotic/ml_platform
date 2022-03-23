FROM ivukotic/ml_base:latest

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

#############################
# Python 3 packages
#############################

RUN python3.8 -m pip --no-cache-dir install \
        requests \
        plumbum \
        bokeh \
        jupyter_bokeh \
        h5py \
        tables \
        ipykernel \
        metakernel \
        jupyter \
        jupyterlab \
        tensorflow \
        tensorflow_datasets \
        imageio \
        matplotlib \
        numpy \
        pandas \
        Pillow \
        scipy \
        sklearn \
        qtpy \
        tqdm \
        seaborn \
        keras \
        elasticsearch \
        gym \
        graphviz \
        JSAnimation \
        ipywidgets \
        jupyterlab-git \
        dask-labextension \
        uproot \
        RISE \
        Cython
RUN python3.8 -m ipykernel install

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

RUN curl -OL https://raw.githubusercontent.com/maniaclab/ci-connect-api/master/resources/provisioner/sync_users_debian.sh
RUN chmod +x sync_users_debian.sh

COPY environment /environment
COPY exec        /.exec
COPY run         /.run
COPY shell       /.shell

RUN chmod 755 .exec .run .shell


RUN mkdir /workspace
COPY private_jupyter_notebook_config.py /usr/etc/jupyter_notebook_config.py

RUN jupyter serverextension enable --py jupyterlab --sys-prefix

RUN git clone https://github.com/ivukotic/ML_platform_tests.git

#execute service
CMD ["/.run"]
