#!/bin/bash



# ./mk.sh [kernel]/[uboot]
ROOT_DIR=$PWD
TARGET=$1
OPERATION=$2
KERNEL_DIR=${ROOT_DIR}/kernel_imx
RAMDISK=${ROOT_DIR}/out/target/product/sabresd_6dq/ramdisk.img
OUT=${ROOT_DIR}/out/target/product/sabresd_6dq
export CPUS=`grep -c processor /proc/cpuinfo`

if [ $TARGET == "kernel" ]; then
	export ARCH=arm
	export CROSS_COMPILE=${ROOT_DIR}/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
	if [ $OPERATION == "menuconfig" ]; then
		cp ${KERNEL_DIR}/arch/arm/configs/imx6_android_defconfig ${KERNEL_DIR}/.config
		make -C ${KERNEL_DIR} menuconfig
	elif [ $OPERATION == "distclean" ]; then
		make -C ${KERNEL_DIR} distclean		
	elif [ $OPERATION == "boot.img" ]; then
		if [ ! -f "$RAMDISK" ]; then
			echo "Firstly make ramdisk.img"
			source env.sh
			source build/envsetup.sh
			lunch sabresd_6dq-eng
			make ramdisk -j${CPUS}
			make -C ${KERNEL_DIR} uImage -j${CPUS}
			cp -a ${KERNEL_DIR}/arch/arm/boot/zImage  $OUT/kernel
			cp -a ${KERNEL_DIR}/arch/arm/boot/uImage  $OUT/uImage
			CMDLINE="console=ttymxc0,115200 androidboot.console=ttymxc0 vmalloc=400M init=/init video=mxcfb0:dev=lcd,AT070-WVGA,if=RGB24,bpp=32 video=mxcfb1:dev=hdmi,1920x1080M@60,if=RGB24,bpp=32 video=mxcfb2:off fbmem=10M,28M  fec_mac=1E:ED:19:27:1A:B3 androidboot.hardware=freescale"
			$ROOT_DIR/prebuilts/tools/linux-x86/bin/mkbootimg --kernel $OUT/kernel --ramdisk $OUT/ramdisk.img --base 0x10800000 --cmdline "${CMDLINE}" --board mx6q_sabresd -o $OUT/boot.img
			echo "make bootimage done"
		else
			make -C ${KERNEL_DIR} uImage -j${CPUS}
			cp -a ${KERNEL_DIR}/arch/arm/boot/zImage  $OUT/kernel
			cp -a ${KERNEL_DIR}/arch/arm/boot/uImage  $OUT/uImage
			CMDLINE="console=ttymxc0,115200 androidboot.console=ttymxc0 vmalloc=400M init=/init video=mxcfb0:dev=lcd,AT070-WVGA,if=RGB24,bpp=32 video=mxcfb1:dev=hdmi,1920x1080M@60,if=RGB24,bpp=32 video=mxcfb2:off fbmem=10M,28M  fec_mac=1E:ED:19:27:1A:B3 androidboot.hardware=freescale"
			$ROOT_DIR/prebuilts/tools/linux-x86/bin/mkbootimg --kernel $OUT/kernel --ramdisk $OUT/ramdisk.img --base 0x10800000 --cmdline "${CMDLINE}" --board mx6q_sabresd -o $OUT/boot.img
			echo "make bootimage done"
		fi
	fi
elif [ $TARGET == "uboot" ]; then
	if [ $OPERATION == "distclean" ]; then
		export ARCH=arm
		export CROSS_COMPILE=${ROOT_DIR}/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
		UBOOT_DIR=${ROOT_DIR}/bootable/bootloader/uboot-imx
		make -C ${UBOOT_DIR} distclean
	elif [ $OPERATION == "android" ]; then
		export ARCH=arm
		export CROSS_COMPILE=${ROOT_DIR}/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
		UBOOT_DIR=${ROOT_DIR}/bootable/bootloader/uboot-imx
		make -C ${UBOOT_DIR} distclean
		make -C ${UBOOT_DIR}  mx6q_sabresd_android_config
		make -C ${UBOOT_DIR}  -j${CPUS}
		cp -a ${UBOOT_DIR}/u-boot.bin  $OUT/u-boot.bin
		cp -a ${UBOOT_DIR}/u-boot.bin  $OUT/u-boot-6dl.bin
		cp -a ${UBOOT_DIR}/u-boot.bin  $OUT/u-boot-6q.bin
		echo "make uboot done,uboot_dir=${UBOOT_DIR}"
	elif [ $OPERATION == "linux" ]; then
		export ARCH=arm
		export CROSS_COMPILE=${ROOT_DIR}/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
		UBOOT_DIR=${ROOT_DIR}/bootable/bootloader/uboot-imx
		make -C ${UBOOT_DIR} distclean
		make -C ${UBOOT_DIR}  mx6q_sabresd_config
		make -C ${UBOOT_DIR}  -j${CPUS}
		cp -a ${UBOOT_DIR}/u-boot.bin  $OUT/u-boot.bin
		cp -a ${UBOOT_DIR}/u-boot.bin  $OUT/u-boot-6dl.bin
		cp -a ${UBOOT_DIR}/u-boot.bin  $OUT/u-boot-6q.bin
		echo "make uboot done,uboot_dir=${UBOOT_DIR}"
	fi
elif [ $TARGET == "test" ]; then
	echo "out=$OUT" 
else
	echo "please order the target 'uboot' or 'kernel'"	
fi


