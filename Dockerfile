FROM ubuntu:16.04
MAINTAINER Thomas Sablik

RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends \
    wget \
    bzip2 \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    git \
    mercurial \
    subversion \
    ca-certificates \
    graphviz \
#    curl \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

#RUN curl -L https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh | /bin/bash

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh \
    && wget --quiet https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh -O ~/anaconda.sh \
    && /bin/bash ~/anaconda.sh -b -p /opt/conda \
    && rm ~/anaconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda update -n base conda
RUN conda install -c caffe2 caffe2
RUN conda install pydot

EXPOSE 8888
RUN useradd -ms /bin/bash deeplearning
USER deeplearning
WORKDIR /home/deeplearning
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--port=8888"]
