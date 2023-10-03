# Use the official Ubuntu base image
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Update package lists and install packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    clang \
    cmake \
    bison \
    flex \
    libreadline-dev \
    gawk \
    tcl-dev \
    libffi-dev \
    git \
    graphviz \
    xdot \
    pkg-config \
    python3 \
    libeigen3-dev \
    libboost-all-dev \
    libboost-system-dev \
    libboost-python-dev \
    libboost-filesystem-dev \
    zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone the Yosys repository into /usr/src
WORKDIR /usr/src
RUN git clone https://github.com/YosysHQ/yosys.git
# Build and install Yosys
WORKDIR /usr/src/yosys
RUN make clean
RUN make -j$(nproc)
RUN make install

# Clone the prjtrellis repository into /usr/src
WORKDIR /usr/src
RUN git clone --recursive https://github.com/YosysHQ/prjtrellis
# Build prjtrellis
WORKDIR /usr/src/prjtrellis/libtrellis
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local .
RUN make -j$(nproc)
RUN make install

# Clone the nextpnr repository into /usr/src
WORKDIR /usr/src
RUN git clone https://github.com/YosysHQ/nextpnr.git
# Build nextpnr-ecp5
WORKDIR /usr/src/nextpnr
RUN cmake . -DARCH=ecp5 -DTRELLIS_INSTALL_PREFIX=/usr/local
RUN make
RUN make install



# Start a shell session by default
CMD ["/bin/bash"]