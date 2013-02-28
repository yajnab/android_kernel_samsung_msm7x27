# Gluon Kernel Compiler
red='tput setaf 1'
green='tput setaf 2'
yellow='tput setaf 3'
blue='tput setaf 4'
violet='tput setaf 5'
cyan='tput setaf 6'
white='tput setaf 7'
normal='tput sgr0'
bold='setterm -bold'

$yellow
MODULES=./gluon_works/bootimage/boot/lib/modules
TOOLCHAIN=../../../../../../arm-2011.03/bin/arm-none-eabi
$blue
echo " ========================================================================== "
echo " **************************** GLUON KERNEL ******************************** "
echo " ========================================================================== "
$cyan
echo " ========================================================================== "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Gluon Works ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo " ========================================================================== "
$red
echo " ========================================================================== "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DEVELOPER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
$cyan
echo " %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Yajnab %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "
$red
echo " =============================XDA-DEVELOPERS=============================== "
echo " ===========================Github.com/Yajnab ============================= "
echo " ========================================================================== "
$yellow
$bold
echo " ========================================================================== "
echo " ========================= COMPILING GLUON KERNEL ========================= "
echo " ========================================================================== "
$normal


if [ -n VERSION ]; then
echo "Release version is 0"
echo "0" > .version
else
echo "Release version is $VERSION"
echo $VERSION > .version

fi


$cyan
echo "Cleaning"
$violet
make clean
clear
$cyan
echo " Making config"
$violet
make gluon_beni_defconfig
clear


$cyan
echo "Making the zImage-the real deal"
$violet
make -j16
clear
$cyan 
mkdir gluon_works/bootimage/source_img
echo "Processing the Bootimage"
cp input_bootimage/boot.img gluon_works/bootimage/source_img/boot.img
echo "Extraction of the Boot.img"
$violet

cd gluon_works/bootimage
rm -rf unpack
rm -rf output
rm -rf boot
clear
mkdir unpack
mkdir output
mkdir boot
tools/unpackbootimg -i source_img/boot.img -o unpack
cd boot
gzip -dc ../unpack/boot.img-ramdisk.gz | cpio -i
cd ../../../
$cyan
echo "Copying output files"
$violet
mv arch/arm/boot/zImage boot.img-zImage

cp boot.img-zImage gluon_works/bootimage/unpack	
rm boot.img-zImage

find -name '*.ko' -exec cp -av {} $MODULES/ \;

clear

$cyan
echo "Stripping Modules"
$violet
cd $MODULES
for m in $(find . | grep .ko | grep './')
do echo $m
$TOOLCHAIN-strip --strip-unneeded $m
done
clear
cd ../../../

clear
$red
echo " Making boot.img"
$violet
tools/mkbootfs boot | gzip > unpack/boot.img-ramdisk-new.gz
rm -rf ../../output/boot.img
tools/mkbootimg --kernel unpack/boot.img-zImage --ramdisk unpack/boot.img-ramdisk-new.gz -o ../../output/boot.img --base `cat unpack/boot.img-base`	
rm -rf unpack
rm -rf output
rm -rf boot
cd ../../
$white
echo "Making Flashable Zip"
cd out
zip kernel#$VERSION.zip ../gluon_works/flash/META-INF ../output/boot.img
cd ../



$blue
echo "Cleaning"
$violet
make clean
rm -rf gluon_works/bootimage/unpack
rm -rf gluon_works/bootimage/output
rm -rf gluon_works/bootimage/boot
rm -rf gluon_works/bootimage/source_img
clear
$white
echo " ============================= F.I.N.I.S.H ! =============================="
$red
echo " ===========================Flash it and Enjoy============================= "
$blue
echo " ===========Don't seek readymade goodies, try to make something new======== "
$cyan
echo " ===============================Gluon Works================================ "
$red
echo " =================================Credits================================== "
echo "~~~~~~~~~~~~~~~~~~~~~~~~Dr.Nachiketa Bandyopadhyay(My Father)~~~~~~~~~~~~~~ "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~My Computer~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~Samsung Galaxy Fit(Beni)~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "~~~~~~~~~~~~~~~~~~~~Darshana Chatterjee(My Most speacial friend)~~~~~~~~~~~ "
echo "=========================================================================== "
$violet
echo "**********************Vishwanath Patil(He taught me all)******************* "
echo "****************************Aditya Patange(Adipat)************************* "
echo "*************************Sarthak Acharya(sakindia123)********************** "
echo "******************************Teguh Soribin(tjstyle)*********************** "
echo "******************************Yanuar Harry(squadzone)********************** "
echo "***********************************faux123********************************* "
echo "******************************Linux Torvalds(torvalds)********************* "
echo "=========================================================================== "

$normal


