#!/bin/sh

topdir=`pwd`

cd submodules/externals/ffmpeg
if test -z "`git status | grep neon`" ; then
	echo "Applying patch to ffmpeg"
	cd $topdir
	patch -p0 < ${topdir}/patches/ffmpeg_scalar_product_remove_alignment_hints.patch
fi

cd $topdir/submodules/libilbc-rfc3951 && ./autogen.sh && ./configure && make || ( echo "iLBC prepare stage failed" ; exit 1 )

cd $topdir/submodules/externals/build/libvpx && ./asm_conversion.sh && cp *.asm *.h ../../libvpx/ || ( echo "VP8 prepare stage failed." ; exit 1 )

cd $topdir/submodules/mssilk && ./autogen.sh && ./configure && cd downloads && make || ( echo "SILK audio plugin prepare state failed." ; exit 1 )


# As a memo, the config.h for zrtpcpp is generated using the command
# cmake  -Denable-ccrtp=false submodules/externals/libzrtpcpp
