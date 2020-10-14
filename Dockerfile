FROM ivukotic/ml_base:latest

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

##############################
# Python 2 packages
##############################

RUN pip2 --no-cache-dir install \
        requests \
        plumbum \
        h5py \
        tables \
        ipykernel \
        metakernel \
        # jupyter \
        tensorflow \
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
        uproot \
        Cython
RUN python2 -m ipykernel.kernelspec

#############################
# Python 3 packages
#############################

RUN python3.8 -m pip --no-cache-dir install \
        requests \
        plumbum \
        h5py \
        tables \
        ipykernel \
        metakernel \
        jupyter \
        jupyterlab \
        tensorflow \
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
        uproot \
        Cython
RUN python3.8 -m ipykernel install

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

COPY environment /environment
COPY exec        /.exec
COPY run         /.run
COPY shell       /.shell

RUN chmod 755 .exec .run .shell

RUN jupyter serverextension enable --py jupyterlab --sys-prefix

#execute service
CMD ["/.run"]
