# Set the base image to Alpine linux
FROM alpine:latest

# File Author / Maintainer
MAINTAINER Matthieu Foll <follm@iarc.fr>

RUN 	apk --update add g++ make git python perl zlib-dev ncurses-dev ca-certificates dialog gfortran readline-dev musl-utils grep wget curl ca-certificates tar bash && \

	# install libiconv (needed for R, alpine linux has an implementation but R doesn't like it)
	wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz && \
	tar xzf libiconv-1.14.tar.gz && \
	cd libiconv-1.14/ && \
	./configure && \
	make && \
	make install && \
	cd .. && \
	rm -r libiconv-1.14 libiconv-1.14.tar.gz && \

	# Install bedtools 
	git clone https://github.com/arq5x/bedtools2.git && \
	cd bedtools2 &&  \
	make && \
	make install && \
	cd .. && \
	rm -rf bedtools2 && \

	# Install samtools from github repos (htslib needed first)
	git clone git://github.com/samtools/htslib.git && \
	cd htslib && \
	make && \
	make install && \
	cd .. && \
	git clone git://github.com/samtools/samtools.git && \
	cd samtools && \
	make && \
	make install && \
	cd .. && \
	rm -rf htslib samtools && \
	
	# Install R
	wget --no-check-certificate https://cran.us.r-project.org/src/base/R-latest.tar.gz && \
	tar xzf R-latest.tar.gz && \
	cd R-* && \
	./configure --with-x=no && \	
	# next line is needed at the moment and comes from: http://www.openwall.com/lists/musl/2012/09/13/2
	sed -i 's/#define HAVE_LIBC_STACK_END 1/#undef HAVE_LIBC_STACK_END/' src/include/config.h && \
	make && \
	ln -s /R-*/bin/Rscript /usr/local/bin/ && \
	rm -r src/ tests/ doc/  && \
	cd .. && \
	rm R-latest.tar.gz  && \
	
	apk del make git python zlib-dev ncurses-dev ca-certificates dialog readline-dev wget curl ca-certificates tar
	