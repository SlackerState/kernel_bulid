export ARCH=arm64
export SUBARCH=arm64
export DTC_EXT=/home/slacker/tools/dtc
# toolgcc中bin文件夹的位置 
export CROSS_COMPILE=/home/slacker/tools/toolgcc/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/home/slacker/tools/toolgcc/arm/bin/arm-linux-androideabi-
# 添加环境变量
export PATH=/home/slacker/tools/toolgcc/bin:/home/slacker/tools/toolclang/clang-r428724/bin:/home/slacker/tools/toolgcc/arm/bin:$PATH
ANYKERNEL3_DIR=$PWD/sm6150/AnyKernel3
FINAL_KERNEL_ZIP=kernel-phoenix.zip
IMAGE_GZ=$PWD/sm6150/out/arch/arm64/boot/Image.gz
DTB=$PWD/sm6150/out/arch/arm64/boot/dts/qcom/sdmmagpie.dtb
DTBO_IMG=$PWD/sm6150/out/arch/arm64/boot/dtbo.img


# 进入代码文件夹
cd /home/slacker/k30/sm6150
ARCH=arm64 make CC=clang HOSTCC=gcc HOSTCXX=clang++ AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi- LD=ld.lld vendor/phoenix_ztc1997_defconfig
#ARCH=arm64 make CC=clang HOSTCC=gcc HOSTCXX=clang++ AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi- LD=ld.lld phoenix_defconfig
ARCH=arm64 make CC=clang HOSTCC=gcc HOSTCXX=clang++ AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi- LD=ld.lld -j$(nproc --all)



echo "**** Verify target files ****"
if [ ! -f "$IMAGE_GZ" ]; then
    echo "!!! Image.gz not found"
    exit 1
fi
if [ ! -f "$DTB" ]; then
    echo "!!! dtb not found"
    exit 1
fi
if [ ! -f "$DTBO_IMG" ]; then
    echo "!!! dtbo.img not found"
    exit 1
fi

echo "**** Moving target files ****"
mv $IMAGE_GZ $ANYKERNEL3_DIR/Image.gz
mv $DTB $ANYKERNEL3_DIR/dtb
mv $DTBO_IMG $ANYKERNEL3_DIR/dtbo.img

echo "**** Time to zip up! ****"
cd $ANYKERNEL3_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x .git README.md *placeholder

echo "**** Removing leftovers ****"
cd ..
rm $ANYKERNEL3_DIR/Image.gz
rm $ANYKERNEL3_DIR/dtb
rm $ANYKERNEL3_DIR/dtbo.img

mv -f $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP out/

echo "Check out/$FINAL_KERNEL_ZIP"
