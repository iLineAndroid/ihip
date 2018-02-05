#!/bin/bash

ROOT_DIR=$PWD
export ARCH=arm
export CROSS_COMPILE=${ROOT_DIR}/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
JAVA_HOME=/usr/local/jdk/jdk1.6.0_45
export JRE_HOME=$JAVA_HOME/jre  
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH    
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH 
KERNEL_DIR=${ROOT_DIR}/kernel_imx
UBOOT_DIR=${ROOT_DIR}/bootable/bootloader/uboot-imx
