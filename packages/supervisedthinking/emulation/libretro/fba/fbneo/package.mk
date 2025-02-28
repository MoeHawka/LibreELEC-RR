# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="fbneo"
PKG_VERSION="18d2dd4aead84e39cc9dae704a5ab84b796faeb5"
PKG_SHA256="d7d6ba3763e2519c39c1583476532283d2dcbcef3cdf43966736ef60cde9aaeb"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/libretro/FBNeo"
PKG_URL="https://github.com/libretro/FBNeo/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A libretro port of FinalBurn Neo for Romset v1.0.0.02"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-gold +lto -sysroot"

PKG_LIBNAME="fbneo_libretro.so"
PKG_LIBPATH="src/burner/libretro/${PKG_LIBNAME}"

PKG_MAKE_OPTS_TARGET="-C src/burner/libretro/ GIT_VERSION=${PKG_VERSION:0:7}"

pre_configure_target() {
  if [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=armv"

    # ARM NEON Support
    if target_has_feature neon; then
      PKG_MAKE_OPTS_TARGET+="-neon"
    fi
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
    cp -v ${PKG_LIBPATH} ${INSTALL}/usr/lib/libretro/
}

post_makeinstall_target() {
  # Copy metadata for manual content scanning
  mkdir -p ${INSTALL}/usr/share/retroarch/database/fbneo
    cp ${PKG_BUILD}/dats/*.dat ${INSTALL}/usr/share/retroarch/database/fbneo

  mkdir -p ${INSTALL}/usr/share/retroarch/bios/fbneo
    cp ${PKG_BUILD}/metadata/hiscore.dat ${INSTALL}/usr/share/retroarch/bios/fbneo
}
