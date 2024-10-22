FROM ivukotic/ml_base:latest

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>


#############################
# Python 3 packages
#############################

RUN pip3 --no-cache-dir install \
        requests \
        h5py \
        tables \
        ipykernel \
        jupyter \
        jupyterlab \
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
        tensorflow-gpu \
        gym \
        baselines \
        pydot \
        uproot \
        JSAnimation
RUN python3 -m ipykernel.kernelspec

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
