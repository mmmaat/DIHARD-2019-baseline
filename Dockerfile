# start from the official CUDA image (based on Ubuntu 16.04)
FROM nvidia/cuda:9.0-cudnn7-devel

# language agnostic locales
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# install software dependencies for kaldi
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        autoconf \
        automake \
        g++ \
        git \
        libatlas3-base \
        libtool \
        make \
        python2.7 \
        python3 \
        sox \
        subversion \
        unzip \
        wget \
        zlib1g-dev

# install Kadli
RUN git clone https://github.com/kaldi-asr/kaldi.git /kaldi \
        && cd /kaldi/tools \
        && ./extras/check_dependencies.sh \
        && make -j4 \
        && cd /kaldi/src \
        && ./configure --shared \
        && sed -i "s/\-g # -O0 -DKALDI_PARANOID.*$/-O3 -DNDEBUG/" kaldi.mk \
        && make depend -j4 \
        && make -j4

# copy the dihard 2019 baseline into docker /baseline directory
WORKDIR /baseline
COPY . .
