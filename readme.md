# Dockerizing EDA tools

## Getting the required proprietary softwares

Put the installers in this directory, your directory should look like this:
```
.
├── Dockerfile
├── install_config.txt
├── ModelSimSetup-20.1.0.711-linux.run
├── readme.md
└── Xilinx_Vivado_SDK_2019.1_0524_1430.tar.gz
```
### Prerequisite 1: Download Vivado (2019.1)

Download [Vivado 2019.1 installer](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html).

Click 2019.1. Should be called "Vivado HLx 2019.1: All OS installer Single-File Download.


### Prerequisite 2: Download Modelsim (20.1)

Download [Intel Modelsim 20.1](https://www.intel.com/content/www/us/en/software-kit/750637/modelsim-intel-fpgas-standard-edition-software-version-20-1.html).

### Prerequisite 3: Download Gurobi solver and getting an WLS gurobi license

## Build the docker image

```sh
docker build -t crush-image .
```

## Run the docker image

```
docker run -it crush-image
docker run -it -u dynamatic:dynamatic \
  -v ./asplos25summer-crush:/home/dynamatic/asplos25-summer-crush \
  -v $PWD/gurobi1103:/opt/gurobi1103 \
  -v $PWD/gurobi.lic:/opt/gurobi1103/gurobi.lic:ro \
crush-image /bin/bash
```
