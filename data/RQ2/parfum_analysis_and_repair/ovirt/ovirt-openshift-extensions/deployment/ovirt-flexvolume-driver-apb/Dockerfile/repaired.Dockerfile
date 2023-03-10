FROM ansibleplaybookbundle/apb-base

ARG VERSION
ARG RELEASE

LABEL "com.redhat.apb.spec"=\
"dmVyc2lvbjogMS4wCm5hbWU6IG92aXJ0LWZsZXh2b2x1bWUtZHJpdmVyLWFwYgpkZXNjcmlwdGlv\
bjogRGVwbG95IG9WaXJ0J3MgZmxleHZvbHVtZS1kcml2ZXIgYW5kIHZvbHVtZS1wcm92aXNpb25l\
ciAKYmluZGFibGU6IEZhbHNlCmFzeW5jOiBvcHRpb25hbAptZXRhZGF0YToKICBkaXNwbGF5TmFt\
ZTogb3ZpcnQtZmxleHZvbHVtZS1kcml2ZXIgKEFQQikKICBwcm92aWRlckRpc3BsYXlOYW1lOiAi\
UmVkIEhhdCwgSW5jLiIKICBsb25nRGVzY3JpcHRpb246IG92aXJ0LWZsZXh2b2x1bWUtZHJpdmVy\
IGlzIGFuIGltcGxlbWVudGFpb24gb2YgYW4gZXh0ZXJuYWwsIGZsZXggdm9sdW1lIGRyaXZlcgog\
ICAgdGhhdCBwcm92aXNpb24gYW5kIGF0dGFjaGVzIG92aXJ0IHZvbHVtZXMgYXMgcGVyc2lzdGVu\
dCB2b2x1bWVzIHRvIHBvZHMuCnBsYW5zOgogIC0gbmFtZTogZGVmYXVsdAogICAgZGVzY3JpcHRp\
b246IFRoaXMgZGVmYXVsdCBwbGFuIGRlcGxveXMgb3ZpcnQtZmxleHZvbHVtZS1kcml2ZXItYXBi\
CiAgICBmcmVlOiBUcnVlCiAgICBtZXRhZGF0YToge30KICAgIHBhcmFtZXRlcnM6CiAgICAgIC0g\
bmFtZTogYWRtaW5fdXNlcgogICAgICAgIHRpdGxlOiBPcGVuc2hpZnQgQ2x1c3RlciBBZG1pbiBV\
c2VyCiAgICAgICAgdHlwZTogc3RyaW5nCiAgICAgICAgcmVxdWlyZWQ6IFRydWUKICAgICAgICBk\
ZWZhdWx0OiBkZXZlbG9wZXIKICAgICAgLSBuYW1lOiBhZG1pbl9wYXNzd29yZAogICAgICAgIHRp\
dGxlOiBPcGVuc2hpZnQgQ2x1c3RlciBBZG1pbiBQYXNzd29yZAogICAgICAgIHR5cGU6IHN0cmlu\
ZwogICAgICAgIGRpc3BsYXlfdHlwZTogcGFzc3dvcmQKICAgICAgICByZXF1aXJlZDogVHJ1ZQog\
ICAgICAgIGRlZmF1bHQ6IGRldmVsb3BlcgogICAgICAtIG5hbWU6IGVuZ2luZV91cmwKICAgICAg\
ICB0aXRsZTogb1ZpcnQgZW5naW5lIEFkZHJlc3MKICAgICAgICB0eXBlOiBzdHJpbmcKICAgICAg\
ICByZXF1aXJlZDogVHJ1ZQogICAgICAgIGRlZmF1bHQ6IGh0dHBzOi8vbG9jYWxob3N0L292aXJ0\
LWVuZ2luZS9hcGkKICAgICAgLSBuYW1lOiBlbmdpbmVfdXNlcm5hbWUKICAgICAgICB0aXRsZTog\
b1ZpcnQgQWRtaW4gVXNlcgogICAgICAgIHR5cGU6IHN0cmluZwogICAgICAgIHJlcXVpcmVkOiBU\
cnVlCiAgICAgICAgZGVmYXVsdDogYWRtaW5AaW50ZXJuYWwKICAgICAgLSBuYW1lOiBlbmdpbmVf\
cGFzc3dvcmQKICAgICAgICB0aXRsZTogb1ZpcnQgQWRtaW4gUGFzc3dvcmQKICAgICAgICB0eXBl\
OiBzdHJpbmcKICAgICAgICBkaXNwbGF5X3R5cGU6IHBhc3N3b3JkCiAgICAgICAgcmVxdWlyZWQ6\
IFRydWUK"

LABEL   com.redhat.component="ovirt-openshift-extensions" \
        name="ovirt-flexvolume-driver-apb" \
        version="$VERSION" \
        release="$RELEASE" \
        architecture="x86_64" \
        summary="APB to deploy ovirt-volume-provisioner and ovirt-flexvolume-driver" \
        maintainer="Roy Golan <rgolan@redhat.com>"

COPY playbooks /opt/apb/project
COPY roles /opt/apb/project
RUN chmod -R g=u /opt/{ansible,apb}
USER apb