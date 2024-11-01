# Start from a lightweight Linux base image
FROM ubuntu:20.04

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y \
    --option APT::Immediate-Configure=false \
    build-essential \
    python3 cmake git pkg-config clang \
    coinor-cbc graphviz graphviz-dev wget \
    libboost-all-dev python3-pip \
    libtinfo-dev libtinfo5 \
    lld ccache ninja-build \
    openjdk-21-jdk curl \
    curl gzip libreadline-dev \
    gcc-multilib \
    g++-multilib \
    lib32z1 \
    lib32stdc++6 \
    lib32gcc1 \
    libxt6:i386 \
    libxtst6:i386 \
    expat:i386 \
    fontconfig:i386 \
    libfreetype6:i386 \
    libexpat1:i386 \
    libc6:i386 \
    libgtk-3-0:i386 \
    libcanberra0:i386 \
    libice6:i386 \
    libsm6:i386 \
    libncurses5:i386 \
    zlib1g:i386 \
    libx11-6:i386 \
    libxau6:i386 \
    libxdmcp6:i386 \
    libxext6:i386 \
    libxft2:i386 \
    libxrender1:i386

RUN pip install \
    networkx \
    pygraphviz \
    matplotlib \
    numpy \
    xlsxwriter \
    pulp

ENV VSIM_INSTALLER="/root/vsim_installer.run"
ENV PATH_INSTALL_VSIM="/opt/intelFPGA/20.1"

# Install Modelsim:
COPY "./ModelSimSetup-20.1.0.711-linux.run" $VSIM_INSTALLER
RUN chmod +x "$VSIM_INSTALLER"
RUN /root/vsim_installer.run \
    --mode unattended \
    --unattendedmodeui none \
    --installdir ${PATH_INSTALL_VSIM} \
    --accept_eula 1 && \
    rm $VSIM_INSTALLER

RUN chmod u+w $PATH_INSTALL_VSIM/modelsim_ase/vco

# Fix some 32-bit library stuff:
RUN sed -i 's/linux\_rh[[:digit:]]\+/linux/g' \
  $PATH_INSTALL_VSIM/modelsim_ase/vco
RUN sed -i 's/MTI_VCO_MODE:-""/MTI_VCO_MODE:-"32"/g' \
  $PATH_INSTALL_VSIM/modelsim_ase/vco
RUN sed -i '/dir=`dirname "$arg0"`/a export LD_LIBRARY_PATH=${dir}/lib32' \
  $PATH_INSTALL_VSIM/modelsim_ase/vco

# Download and build the old 32-bit version of libfreetype
RUN \
  wget https://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.4.12.tar.bz2 && \
  tar xjf freetype-2.4.12.tar.bz2 && \
  cd freetype-2.4.12 && \
  ./configure --build=i686-pc-linux-gnu "CFLAGS=-m32" \
  "CXXFLAGS=-m32" "LDFLAGS=-m32" && \
  make clean && make && \
  cd $PATH_INSTALL_VSIM/modelsim_ase && \
  mkdir lib32 && \
  cp /freetype-2.4.12/objs/.libs/libfreetype.so* lib32/ && \
  rm -rf /freetype-2.4.12 /freetype-2.4.12.tar.bz2

# Install Vivado 2019.1.1
ENV XLNX_INSTALLER_TAR="/root/Xilinx_Vivado_SDK_2019.1_0524_1430.tar.gz"
ENV XLNX_INSTALLER_DIR="/Xilinx_Vivado_SDK_2019.1_0524_1430"
ENV XLNX_CONFIG_FILE="/root/install_config.txt"
COPY "./Xilinx_Vivado_SDK_2019.1_0524_1430.tar.gz" $XLNX_INSTALLER_TAR
COPY "./install_config.txt" "$XLNX_CONFIG_FILE"
RUN tar -zxf "$XLNX_INSTALLER_TAR" && \
  rm "$XLNX_INSTALLER_TAR" 
RUN ls "/root" && \
  chmod +x "$XLNX_INSTALLER_DIR/xsetup"
RUN ( \
  cd "$XLNX_INSTALLER_DIR" && \
  ./xsetup \
  --agree XilinxEULA,3rdPartyEULA,WebTalkTerms \
  --config "$XLNX_CONFIG_FILE" \
  --batch INSTALL \
  )
RUN rm -rf "$XLNX_INSTALLER_DIR"
