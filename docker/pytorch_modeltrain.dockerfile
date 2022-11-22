# os is ubuntu18.04, using python2.
FROM dorowu/ubuntu-desktop-lxde-vnc:bionic
# above image's default user is 'ubuntu'.
USER root

#-----------------------------------------------------------------------------------------------------------------------
# set default repo.
RUN echo "\
deb http://mirrors.cloud.tencent.com/ubuntu/ bionic main restricted universe multiverse\n\
deb-src http://mirrors.cloud.tencent.com/ubuntu/ bionic main restricted universe multiverse\n\
deb http://mirrors.cloud.tencent.com/ubuntu/ bionic-security main restricted universe multiverse\n\
deb-src http://mirrors.cloud.tencent.com/ubuntu/ bionic-security main restricted universe multiverse\n\
deb http://mirrors.cloud.tencent.com/ubuntu/ bionic-updates main restricted universe multiverse\n\
deb-src http://mirrors.cloud.tencent.com/ubuntu/ bionic-updates main restricted universe multiverse\n\
deb http://mirrors.cloud.tencent.com/ubuntu/ bionic-proposed main restricted universe multiverse\n\
deb-src http://mirrors.cloud.tencent.com/ubuntu/ bionic-proposed main restricted universe multiverse\n\
deb http://mirrors.cloud.tencent.com/ubuntu/ bionic-backports main restricted universe multiverse\n\
deb-src http://mirrors.cloud.tencent.com/ubuntu/ bionic-backports main restricted universe multiverse\n\
" > /etc/apt/sources.list \
&& rm -rf /etc/apt/sources.list.d/* \
&& apt-get update

# install common.
RUN set -x \
&& apt-get install -y wget \
&& apt-get install -y git \
&& apt-get install -y vim \
&& mkdir ~ && touch ~/.bashrc \
&& echo "alias ll='ls -alF'">>~/.bashrc \
&& echo "end"

# install python3.8.
RUN set -x \
&& apt-get install -y python3-distutils \
&& apt-get install -y python3.8 \
&& ln -sf /usr/bin/python3.8 /usr/bin/python3 \
&& wget https://bootstrap.pypa.io/get-pip.py \
&& python3 get-pip.py \
&& echo "end"

#-----------------------------------------------------------------------------------------------------------------------
# install umd.
RUN set -x \
&& echo "install umd begin" \
&& wget -P /opt "http://10.150.9.95/corex/cuda_10.2/NVIDIA-Linux-x86_64-440.33.01.run" >/dev/null 2>&1 \
&& bash /opt/NVIDIA-Linux-x86_64-440.33.01.run --extract-only \
&& cp NVIDIA-Linux-x86_64-440.33.01/libcuda.so.440.33.01 /usr/lib/x86_64-linux-gnu/ \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.440.33.01 /usr/lib/x86_64-linux-gnu/libcuda.so.1 \
&& ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so \
&& rm -f /opt/NVIDIA-Linux-x86_64-440.33.01.run \
&& rm -rf NVIDIA-Linux-x86_64-440.33.01 \
&& echo "install umd end"

# install cuda10.2.
RUN set -x \
&& echo "install cuda10.2 begin" \
&& apt-get install -y gcc \
&& apt-get install -y libxml2 \
&& wget -P /opt "http://10.150.9.95/corex/cuda_10.2/cuda_10.2.89_440.33.01_linux.run" >/dev/null 2>&1 \
&& bash /opt/cuda_10.2.89_440.33.01_linux.run --toolkit --silent \
&& rm -f /opt/cuda_10.2.89_440.33.01_linux.run \
&& echo "install cuda10.2 end"

# install cudnn7.6.
RUN set -x \
&& echo "install cudnn7.6 begin" \
&& wget -P /opt "http://10.150.9.95/corex/cuda_10.2/cudnn-10.2-linux-x64-v7.6.5.32.tgz" >/dev/null 2>&1 \
&& tar -xzvf /opt/cudnn-10.2-linux-x64-v7.6.5.32.tgz -C /opt >/dev/null 2>&1 \
&& cp /opt/cuda/include/cudnn.h /usr/local/cuda/include \
&& cp /opt/cuda/lib64/libcudnn* /usr/local/cuda/lib64 \
&& echo "install cudnn7.6 end"

# install pytorch1.10.
RUN set -x \
&& echo "install pytorch1.10 begin" \
&& pip3 install http://10.150.9.95/corex/pytorch/torch-1.10.2+cu102-cp38-cp38-linux_x86_64.whl \
&& pip3 install http://10.150.9.95/corex/pytorch/torchvision-0.11.3+cu102-cp38-cp38-linux_x86_64.whl \
&& pip3 install http://10.150.9.95/corex/pytorch/torchaudio-0.10.2+cu102-cp38-cp38-linux_x86_64.whl \
&& echo "install pytorch1.10 end"

#-----------------------------------------------------------------------------------------------------------------------
RUN set -x \
&& apt-get install -y mpv \
&& apt-get install -y ffmpeg \
&& echo

#-----------------------------------------------------------------------------------------------------------------------
RUN set -x \
&& apt-get install -y libgl1 \
&& apt-get install -y libglib2.0-dev \
&& echo

#-----------------------------------------------------------------------------------------------------------------------
RUN set -x \
&& export http_proxy=http://192.168.100.200:3128 \
&& export https_proxy=http://192.168.100.200:3128 \
&& git clone --recursive https://github.com/knote2019/pytorch-model \
&& pip3 install -r pytorch-model/yolov5/requirements.txt \
&& echo
