## TODO compare to official docker file at: https://github.com/ethereum/solidity/pull/1437/files

FROM ubuntu:14.04

WORKDIR "/home"
RUN sudo apt-get -y update
RUN sudo apt-get -y install language-pack-en-base wget unzip
RUN sudo dpkg-reconfigure locales
RUN sudo apt-get -y install software-properties-common
RUN sudo add-apt-repository -y ppa:george-edison55/cmake-3.x

### need to update apt to ignore gpg checks
### ubuntu 14.04 is using some old ass TLS encryption that dosen't share a cyper with modern repositories
### https://askubuntu.com/questions/74345/how-do-i-bypass-ignore-the-gpg-signature-checks-of-apt
#RUN wget --no-check-certificate -O - http://llvm.org/apt/llvm-snapshot.gpg.key | sudo apt-key add -
#RUN sudo add-apt-repository "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.7 main"

## these repos seem to no longer exist
# RUN sudo add-apt-repository -y ppa:ethereum/ethereum-qt
# RUN sudo add-apt-repository -y ppa:ethereum/ethereum
# RUN sudo add-apt-repository -y ppa:ethereum/ethereum-dev


RUN sudo apt-get -y update
RUN sudo apt-get -y upgrade

RUN sudo apt-get -y install build-essential git cmake libboost-all-dev libgmp-dev \
libleveldb-dev libminiupnpc-dev libreadline-dev libncurses5-dev libcurl4-openssl-dev \
libmicrohttpd-dev libjsoncpp-dev libargtable2-dev \
libedit-dev mesa-common-dev ocl-icd-libopencl1 opencl-headers \
ocl-icd-dev qtbase5-dev qt5-default qtdeclarative5-dev libqt5webkit5-dev

## these are failing to install and will need to be manually compiled
# libqt5webengine5-dev libcryptopp-dev libv8-dev libjson-rpc-cpp-dev llvm-3.7-dev libgoogle-perftools-dev

RUN git clone https://github.com/ethereum/cpp-ethereum-cmake
WORKDIR "/home/cpp-ethereum-cmake"
RUN git checkout 412c066ef83525c6d48217398fc200964df5737f

WORKDIR "/home/"
RUN git clone https://github.com/ethereumproject/cpp-ethereum.git
WORKDIR "/home/cpp-ethereum"
RUN git checkout tags/foundationwallet


## Manually build cryptopp 562
WORKDIR "/home/"
RUN mkdir cryptopp562
WORKDIR "/home/cryptopp562"
RUN wget --no-check-certificate https://cryptopp.com/cryptopp562.zip
RUN unzip cryptopp562.zip
RUN make
RUN sudo make install

WORKDIR "/home/"
COPY . /home/solidity
# RUN git clone https://github.com/ethereum/solidity.git
WORKDIR "/home/solidity"
# RUN git checkout tags/v0.1.2
RUN mkdir build
WORKDIR "/home/solidity/build"

RUN cmake ../
## TODO can run other makes? like `make solc`
RUN make
