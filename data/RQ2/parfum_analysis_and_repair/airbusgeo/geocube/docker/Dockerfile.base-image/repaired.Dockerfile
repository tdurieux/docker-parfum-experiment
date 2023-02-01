FROM golang:alpine

RUN apk update && \
    apk add --no-cache \
        build-base \
        curl \
        curl-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        linux-headers \
        pkgconf \
        sqlite \
        sqlite-dev \
        tiff-dev \
        unzip \
        zstd-dev


WORKDIR /build

ARG PROJVERSION=7.2.1
RUN mkdir proj && cd proj && \
    curl -f -sL https://github.com/OSGeo/proj.4/releases/download/$PROJVERSION/proj-$PROJVERSION.tar.gz -o proj-$PROJVERSION.tar.gz && \
	mkdir proj && \
	tar  xzf proj-$PROJVERSION.tar.gz -C proj --strip-components 1 && \
    cd proj && \
	#curl -sL http://download.osgeo.org/proj/proj-datumgrid-1.8.zip -o proj-datumgrid-1.8.zip && \
	#unzip -o proj-datumgrid-1.8.zip -d data/ && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-static CFLAGS="-O2" CXXFLAGS="-O2" && \
	make -j8 && \
	make install && \
    cd /build && rm -rf proj && rm proj-$PROJVERSION.tar.gz

ARG GEOSVERSION=3.8.1
RUN mkdir geos && cd geos && \
    curl -f -sL https://download.osgeo.org/geos/geos-$GEOSVERSION.tar.bz2 -o geos.tbz2 && \
    tar xf geos.tbz2 && \
    cd geos-$GEOSVERSION && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS="-O2" CXXFLAGS="-O2" && \
    make -j8 && \
    make install && \
    cd /build && rm -rf geos

ARG GDALVERSION=3.4.1
RUN mkdir gdal && cd gdal && \
    curl -f -sL https://github.com/OSGeo/gdal/releases/download/v$GDALVERSION/gdal-$GDALVERSION.tar.gz -o gdal.tar.gz && \
	mkdir gdal && \
	tar  xzf gdal.tar.gz -C gdal --strip-components 1 && \
    cd gdal && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS="-O2" CXXFLAGS="-O2" \
					--disable-lto \
		--disable-static \
		--enable-shared \
		--disable-all-optional-drivers \
		--without-gnm \
		--without-qhull \
		--without-sqlite3 \
		--without-pcidsk \
		--without-gif \
		--without-pcraster \
		--with-geos \
		--with-curl \
		--with-jpeg \
		--with-libtiff=internal \
		--with-webp \
		--with-zstd \
		--with-geotiff=internal && \
	make -j8 && \
	make install && \
		(for i in \
            # BAG driver
            /usr/local/share/gdal/bag*.xml \
            # SXF driver
            /usr/local/share/gdal/default.rsc \
            # unused
            /usr/local/share/gdal/*.svg \
            # unused
            /usr/local/share/gdal/*.png \
            # GML driver
            /usr/local/share/gdal/*.gfs \
            # GML driver
            /usr/local/share/gdal/gml_registry.xml \
            # NITF driver
            /usr/local/share/gdal/nitf* \
            # NITF driver
            /usr/local/share/gdal/gt_datum.csv \
            # NITF driver
            /usr/local/share/gdal/gt_ellips.csv \
            # PDF driver
            /usr/local/share/gdal/pdf* \
            # PDS4 driver
            /usr/local/share/gdal/pds* \
            # S57 driver
            /usr/local/share/gdal/s57* \
            # VDV driver
            /usr/local/share/gdal/vdv* \
            # DXF driver
            /usr/local/share/gdal/*.dxf \
            # DGN driver
            /usr/local/share/gdal/*.dgn \
            # OSM driver
            /usr/local/share/gdal/osm* \
            # GMLAS driver
            /usr/local/share/gdal/gmlas* \
            # PLScenes driver
            /usr/local/share/gdal/plscenes* \
            # netCDF driver
            /usr/local/share/gdal/netcdf_config.xsd \
            # PCIDSK driver
            /usr/local/share/gdal/pci* \
            # ECW and ERS drivers
            /usr/local/share/gdal/ecw_cs.wkt \
            # EEDA driver
            /usr/local/share/gdal/eedaconf.json \
            # MAP driver / ImportFromOZI()
            /usr/local/share/gdal/ozi_* \
       ;do rm $i; done) && \
    (for i in /usr/local/lib/*; do strip -s $i 2>/dev/null || /bin/true; done) && \
    ldconfig /usr/local/lib && \
    cd /build && rm -rf gdal && rm gdal.tar.gz



ENV GOFLAGS=-mod=vendor
