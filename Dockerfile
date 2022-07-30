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
ARG JULIA_MAJOR=1
ARG JULIA_MINOR=8
ARG JULIA_PATCH=0-rc3
ARG JULIA_VER=$JULIA_MAJOR.$JULIA_MINOR.$JULIA_PATCH
ENV JULIA_NUM_THREADS auto
# this is where we install default packages
ENV JULIA_PKGDIR=/opt/julia
RUN mkdir /opt/julia-${JULIA_VER} && \
    wget "https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-${JULIA_VER}-linux-x86_64.tar.gz" && \
    tar -xvzf julia-${JULIA_VER}-linux-x86_64.tar.gz  -C /opt/julia-${JULIA_VER} --strip-components=1 && \
    rm -rf julia-${JULIA_VER}-linux-x86_64.tar.gz && \
    ln -s /opt/julia-${JULIA_VER}/bin/julia /usr/local/bin/julia

RUN mkdir $JULIA_PKGDIR
# the build step for IJulia should install Jupyter kernal
RUN export JUPYTER_DATA_DIR=/usr/local/share/jupyter/ && \
    export JULIA_LOAD_PATH="$JULIA_PKGDIR:" && \
    export JULIA_DEPOT_PATH=$JULIA_PKGDIR && \
    julia -e 'using Pkg; Pkg.add(["CUDA", "CairoMakie", "PyCall", "KernelAbstractions", "CUDAKernels"])' && \
    julia -e 'using Pkg; Pkg.add("IJulia")' && \
    julia -e 'using Pkg; Pkg.precompile()'

# setup for end users
RUN echo 'target = joinpath(homedir(), ".julia", "environments", "v$(string(VERSION)[1:3])")\n\
if !isfile(joinpath(target, "Project.toml"))\n\
    mkpath(target)\n\
    touch(joinpath(target, "Project.toml"))\n\
end' >> /opt/julia-${JULIA_VER}/etc/julia/startup.jl
ENV JULIA_LOAD_PATH=":$JULIA_PKGDIR/environments/v$JULIA_MAJOR.$JULIA_MINOR"
ENV JULIA_DEPOT_PATH=":$JULIA_PKGDIR"

RUN curl -OL https://raw.githubusercontent.com/maniaclab/ci-connect-api/master/resources/provisioner/sync_users_debian.sh
RUN chmod +x sync_users_debian.sh

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

RUN git clone https://github.com/ivukotic/ML_platform_tests.git

#execute service
CMD ["/.run"]
