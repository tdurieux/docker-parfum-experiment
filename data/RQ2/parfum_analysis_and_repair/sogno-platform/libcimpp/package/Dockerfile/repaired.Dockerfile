FROM ubuntu:latest

LABEL \
	org.label-schema.schema-version = "2.1.0" \
	org.label-schema.name = "libcimpp" \
	org.label-schema.license = "MPL" \
	org.label-schema.vendor = "Institute for Automation of Complex Power Systems, RWTH Aachen University" \
	org.label-schema.author.name = "Lukas Razik" \
	org.label-schema.author.email = "lrazik@eonerc.rwth-aachen.org" \
	org.label-schema.vcs-url = "https://github.com/rwth-acs/libcimpp"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
	apt-get --no-install-recommends -y install \
			cmake \
			curl \
			doxygen \
			git \
			graphviz \
			g++ \
			libxml2-dev \
			make \
			python3-pip \
			rpm && rm -rf /var/lib/apt/lists/*; # Toolchain













RUN pip3 install --no-cache-dir xmltodict chevron

RUN curl -f -L https://github.com/RWTH-ACS/arabica/releases/download/release%2Fv0.1.0/libarabica-2016-Linux.deb > libarabica.deb
RUN dpkg -i libarabica.deb

entrypoint [ "package/entrypoint.sh" ]
