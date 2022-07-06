FROM ivukotic/ml_base:latest

LABEL maintainer Jerry Ling <jiling@cern.ch>

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

# Julia
#############################
ARG JULIA_VER=1.8.0-rc1
RUN wget "https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-${JULIA_VER}-linux-x86_64.tar.gz" && \
    tar -xvzf julia-${JULIA_VER}-linux-x86_64.tar.gz && \
    rm -rf julia-${JULIA_VER}-linux-x86_64.tar.gz && \
    ln -s /julia-${JULIA_VER}/bin/julia /usr/local/bin/julia

# the build step for IJulia should install Jupyter kernal
RUN julia -e 'using Pkg; Pkg.add(["CUDA", "UnROOT", "FHist", "CairoMakie", "IJulia", "PyCall", "ThreadsX", "LorentzVectorHEP", "JSON3", "CSV", "DataFrames", "KernelAbstractions", "Flux", "CUDAKernels"])' && \
    julia -e 'using Pkg; Pkg.build(["IJulia", "PyCall")' && \
    julia -e 'using Pkg; Pkg.precompile()'

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
