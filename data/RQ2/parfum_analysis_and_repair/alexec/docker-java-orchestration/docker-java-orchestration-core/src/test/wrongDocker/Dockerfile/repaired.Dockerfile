WRONG wrong command

FROM badPlacedFromWithoutVersion

FROM badPlacedWithUpperCaseFromWithVersion:0.0.0

FROM badplacedfromwithversionandlowercase:0.0.0-snap

FROM badplacedfromwithoutversionandlowercase:

FROM badplacedfromwithlatestversionandlowercase:latest

RUN apt-get update && apt-get install --no-install-recommends -y bzr cvs git mercurial subversion && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y bzr cvs git mercurial subversion this line is too long and we must split it && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y bzr cvs git mercurial subversion this line is too long and we split it \
but not enougth && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y bzr cvs git mercurial subversion \
this line is too long \
but we split it && rm -rf /var/lib/apt/lists/*;

