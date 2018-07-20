FROM ubuntu:16.04

# Prepare Ubuntu

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo "XKBMODEL=\"pc105\"\n \
          XKBLAYOUT=\"us\"\n \
          XKBVARIANT=\"\"\n \
          XKBOPTIONS=\"\"" > /etc/default/keyboard

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        curl \
        vim \
        ca-certificates \
        libjpeg-dev \
        libpng-dev \
        sudo \
        apt-utils \
        man \
        tmux \
        less \
        wget \
        iputils-ping \
        zsh \
        htop \
        software-properties-common \
        tzdata \
        locales \
        openssh-server \
        xauth \
        rsync

RUN locale-gen en_US.UTF-8
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8"

# Install Conda

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \     
    rm ~/miniconda.sh
RUN echo "export PATH=/opt/conda/bin:\$PATH" > /etc/profile.d/conda.sh
ENV PATH /opt/conda/bin:$PATH

# Install NLTK

RUN pip install nltk
WORKDIR /opt
RUN python -m nltk.downloader perluniprops nonbreaking_prefixes

# Install PyTorch, TorchVision, TorchText

RUN conda install numpy pyyaml scipy ipython cython mkl pytorch-cpu torchvision-cpu -c pytorch && \
    conda clean -ya 
RUN git clone https://github.com/pytorch/text /tmp/torchtext --depth 1
WORKDIR /tmp/torchtext
RUN python setup.py install

# Install KoNLPy with Mecab

RUN sudo apt install -y g++ openjdk-8-jdk autoconf
RUN pip install konlpy jpype1
RUN curl -fsSL https://raw.githubusercontent.com/konlpy/konlpy/master/scripts/mecab.sh | bash

# Install Champollion

RUN git clone https://github.com/juneoh/champollion /opt/champollion --depth 1
WORKDIR /opt/champollion
ENV CTK /opt/champollion
ENV PATH /opt/champollion/bin:$PATH
RUN echo "export CTK=/opt/champollion\nexport PATH=/opt/champollion/bin:\$PATH" > /etc/profile.d/champollion.sh

# Install FastText

RUN git clone https://github.com/facebookresearch/fasttext /opt/fasttext --depth 1
WORKDIR /opt/fasttext
RUN make
ENV PATH /opt/fasttext:$PATH
RUN echo "alias fasttext=/opt/fasttext/fasttext" > /etc/profile.d/fasttext.sh

# Install gensim

RUN pip install gensim

# Install MUSE

WORKDIR /root
RUN git clone https://github.com/facebookresearch/MUSE --depth 1
WORKDIR /root/MUSE/data
RUN bash get_evaluation.sh

# Install SRILM

COPY srilm-1.7.2.tar.gz /tmp/
RUN mkdir /opt/srilm
RUN tar -xvf /tmp/srilm-1.7.2.tar.gz -C /opt/srilm
WORKDIR /opt/srilm
RUN SRILM=/opt/srilm make
ENV PATH /opt/srilm/bin/i686-m64:$PATH
RUN echo "export PATH=/opt/srilm/bin/i686-m64:\$PATH" > /etc/profile.d/srilm.sh

# Install sample codes

WORKDIR /root
RUN git clone https://github.com/kh-kim/nlp_preprocessing --depth 1
RUN git clone https://github.com/kh-kim/OpenNLMTK --depth 1
RUN git clone https://github.com/kh-kim/simple-nmt --depth 1
RUN git clone https://github.com/kh-kim/subword-nmt --depth 1
RUN mkdir data

# Wrap up

RUN rm -rf /tmp/* /var/lib/apt/lists/*
ENV PYTHONUNBUFFERED=1
WORKDIR /root
