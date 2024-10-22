FROM ivukotic/ml_base:oct_upgrade

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

#############################
# Python 3 packages
#############################

RUN python3 -m pip --no-cache-dir install \
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
    pyarrow \
    scipy \
    scikit-learn \
    qtpy \
    tqdm \
    seaborn \
    keras \
    keras-tuner \
    elasticsearch \
    gym \
    graphviz \
    JSAnimation \
    ipywidgets \
    jupyterlab-git==0.30 \
    dask-labextension \
    uproot \
    atlasify \
    RISE \
    Cython

RUN python3 -m pip install --upgrade pip
RUN python3 -m ipykernel install --name py312 --display-name "Python 3.12"


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
COPY private_jupyter_notebook_config.py /usr/local/etc/jupyter_notebook_config.py

RUN jupyter server extension enable --py jupyterlab --sys-prefix

RUN git clone https://github.com/maniaclab/ML_platform_tests.git

RUN echo "Done"

#execute
CMD ["/.run"]
