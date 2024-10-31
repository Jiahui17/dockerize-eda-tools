# Dockerizing EDA tools

## Prerequisites

1. Download [Vivado 2019.1 installer](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html) (Should be called "Vivado HLx 2019.1: All OS
installer Single-File Download").

2. Download [Intel Modelsim 20.1](https://www.intel.com/content/www/us/en/software-kit/750637/modelsim-intel-fpgas-standard-edition-software-version-20-1.html).


Put the installers in this directory, your directory should look like this:

```
.
├── Dockerfile
├── install_config.txt
├── ModelSimSetup-20.1.0.711-linux.run
├── readme.md
└── Xilinx_Vivado_SDK_2019.1_0524_1430.tar.gz
```

## Build the docker image

```sh
docker build -t myimage .
```

## Run the docker image

```
docker run -it myimage
```
