FROM ubuntu:16.04
MAINTAINER Thomas Sablik

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libgoogle-glog-dev \
    libgtest-dev \
    libiomp-dev \
    libleveldb-dev \
    liblmdb-dev \
    libopencv-dev \
    libopenmpi-dev \
    libsnappy-dev \
    libprotobuf-dev \
    openmpi-bin \
    openmpi-doc \
    protobuf-compiler \
#     python-dev \
#     python-pip \
    python3-dev \
    python3-pip \
    libgflags-dev \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# RUN pip install --upgrade pip
# RUN pip install setuptools
# RUN pip install \
#     future \
#     numpy \
#     protobuf \
#     jupyter

RUN pip3 install --upgrade pip
RUN pip3 install setuptools
RUN pip3 install \
    future \
    numpy \
    protobuf \
    jupyter

RUN git clone --recursive https://github.com/caffe2/caffe2.git && cd caffe2 \
    && mkdir build && cd build \
    && cmake -DUSE_CUDA=OFF -DUSE_MPI=OFF -DPYTHON_INCLUDE_DIR=$(python3 -c 'from distutils import sysconfig; print(sysconfig.get_python_inc())') -DPYTHON_EXECUTABLE=$(which python3) .. \
    && make install

EXPOSE 8888
RUN useradd -ms /bin/bash deeplearning
USER deeplearning
WORKDIR /home/deeplearning
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--port=8888"]
