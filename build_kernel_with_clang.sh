#!/bin/bash
# Build kernel with clang 12 for arm64 android device
# Use Proton clang 12 and gcc 9.2
TARGET_ARCH=arm64
KERNEL_NAME=Image.gz-dtb
CODE_NAME=sakura
CLANG_DIR=/home/peng/proton-clang-12/bin

if [ ! -d $CLANG_DIR ]
then
    echo "Clang12 not found!"
fi

export ARCH=$TARGET_ARCH
export PATH="$CLANG_DIR:$PATH"
echo PATH=$PATH
echo "Env set done!"

#make mrproper
#echo "Clean done!"

make "$CODE_NAME"_defconfig

if [ -e .config ]
then
    echo "Start build..."
    make -j10 ARCH="$TARGET_ARCH" \ CC=clang \ CLANG_TRIPLE=aarch64-linux-gnu- \ CROSS_COMPILE="/home/peng/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-" \ AR=llvm-ar \ OBJCOPY=llvm-objcopy \ OBJDUMP=llvm-objdump \ STRIP=llvm-strip \ NM=llvm-nm
else
    echo "config file generated error!"
    exit
fi

if [ -e arch/$TARGET_ARCH/boot/$KERNEL_NAME ]
then
    echo "Build compiled!"
    # build_package
else
    echo "Build error!"
fi
