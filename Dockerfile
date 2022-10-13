FROM hub.opensciencegrid.org/usatlas/ml_base:centos7

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

#############################
# Upgrade Git
#############################

RUN yum remove git  -y
RUN yum install https://repo.ius.io/ius-release-el7.rpm -y
RUN yum install git236 -y

#############################
# User utilities
#############################

RUN yum install -y \
        htop \
        emacs-nox \
        ncdu

#############################
# Python 3 packages
#############################


ENV VIRTUAL_ENV=/jupyter
RUN source scl_source enable rh-python38; python3.8 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python3.8 -m pip install --upgrade pip setuptools wheel

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
        pyarrow \
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

COPY environment /environment
COPY exec        /.exec
COPY run         /.run
COPY shell       /.shell

RUN chmod 755 .exec .run .shell

RUN mkdir /workspace
COPY private_jupyter_notebook_config.py /usr/local/etc/jupyter_notebook_config.py

RUN jupyter serverextension enable --py jupyterlab --sys-prefix

# Install HTCondor
RUN yum install yum-plugin-priorities -y
RUN yum install https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el7-release-latest.rpm -y
RUN yum install condor -y 
COPY condor/10-base.conf /etc/condor/config.d/10-base.conf

# Configure the profile
COPY profile.d/jupyter.sh /etc/profile.d/jupyter.sh
COPY profile.d/quota.sh /etc/profile.d/quota.sh

RUN git clone https://github.com/LincolnBryant/ML_platform_tests.git

#execute service
CMD ["/.run"]
