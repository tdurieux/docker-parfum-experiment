FROM dockcross/base:latest

ENV ARCH=mips
ENV SUBARCH=mips
ENV DEBIAN_ARCH=mips64el
ENV CROSS_TRIPLET=mips64el-linux-gnuabi64