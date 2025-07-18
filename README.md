# ML platform prebuilt containers

[![Current](https://github.com/ivukotic/ml_platform/actions/workflows/oct_upgrade.yaml/badge.svg)](https://github.com/ivukotic/ml_platform/actions/workflows/oct_upgrade.yaml)
[![Legacy](https://github.com/ivukotic/ml_platform/actions/workflows/main.yaml/badge.svg)](https://github.com/ivukotic/ml_platform/actions/workflows/main.yaml)
[![Conda](https://github.com/ivukotic/ml_platform/actions/workflows/conda.yaml/badge.svg)](https://github.com/ivukotic/ml_platform/actions/workflows/conda.yaml)
[![Julia](https://github.com/ivukotic/ml_platform/actions/workflows/julia.yaml/badge.svg?branch=julia)](https://github.com/ivukotic/ml_platform/actions/workflows/julia.yaml)

At UC Analysis Facility we provide multiple docker images.
Two of them, AB-stable and AB-dev, come from a different [repo](https://github.com/usatlas/analysisbase-dask-uc). The ML platform images come from different branches of this repository. All of them are based on [ML base](https://github.com/ivukotic/ml_base), which is in turn based on [nvidia cuda](https://hub.docker.com/layers/nvidia/cuda/11.8.0-cudnn8-devel-ubuntu20.04/images/sha256-0b25e1f1c6f596a6c92b04cb825714be41b4dc8323ba71205dbae8b11bfa672c) image. Github actions build and upload images to dockerhub/ivukotic and Harbor.

The definitions of the four images can be seen here: [legacy](https://github.com/ivukotic/ml_platform/blob/master/Dockerfile), [current](https://github.com/ivukotic/ml_platform/blob/OctUpgrade/Dockerfile), [conda](https://github.com/ivukotic/ml_platform/blob/anaconda/Dockerfile), [julia](https://github.com/ivukotic/ml_platform/blob/julia/Dockerfile).

## Legacy

Provides ancient python3.6 and python3.8 versions and come with full set of python data analysis packages (tensorflow, keras, visualizations, dask, uproot, jupyter, etc.)

## Current

Provides the same packages as the Legacy image but comes with python 3.12.

## Conda

Unlike Legacy and Current images Conda image is based on a newer [Nvidia Cuda image](https://hub.docker.com/layers/nvidia/cuda/12.8.1-runtime-ubuntu20.04/images/sha256-cf517264dde412fd64e768396ce8c5cc1efa678e0eb03a42c20d602e9d4e03c1).
Despite its name, it does not come with Conda but with [Micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html), which is just a CLI tool to manage Conda enviroments and works in exactly the same way.

## Julia

This image is maintained by [Jerry Ling](mailto:jiling@cern.ch). It comes with Python 3.8 and Julia 1.11.6.
