FROM ansibleplaybookbundle/apb-base

LABEL "com.redhat.apb.version"="0.1.0"
LABEL "com.redhat.apb.spec"=\
"dmVyc2lvbjogMS4wCm5hbWU6IGFuZHJvaWQtYXBwCmRlc2NyaXB0aW9uOiBUaGlzIGlzIGEgc2Ft\
cGxlIGFwcGxpY2F0aW9uIGdlbmVyYXRlZCBieSBhcGIgaW5pdApiaW5kYWJsZTogRmFsc2UKYXN5\
bmM6IG9wdGlvbmFsCnRhZ3M6IAogIC0gbW9iaWxlCm1ldGFkYXRhOgogIGRpc3BsYXlOYW1lOiBB\
bmRyb2lkIEFwcAogIGNvbnNvbGUub3BlbnNoaWZ0LmlvL2ljb25DbGFzczogZmEgZmEtYW5kcm9p\
ZApwbGFuczoKICAtIG5hbWU6IGRlZmF1bHQKICAgIGRlc2NyaXB0aW9uOiBTZXRzIHVwIGFuIGFu\
ZHJvaWQgYXBwIHZpYSB0aGUgbW9iaWxlIGNvbnRyb2wgcGFuZWwuIFRoZSBtb2JpbGUgY29udHJv\
bCBwYW5lbCB3aWxsIGJlIGRlcGxveWVkIGlmIG5vdCBwcmVzZW50LgogICAgZnJlZTogVHJ1ZQog\
ICAgbWV0YWRhdGE6IHt9CiAgICBwYXJhbWV0ZXJzOiAKICAgIC0gbmFtZTogYXBwTmFtZQogICAg\
ICByZXF1aXJlZDogVHJ1ZQogICAgICBkZWZhdWx0OiBteWFwcAogICAgICB0eXBlOiBzdHJpbmcK\
ICAgICAgdGl0bGU6IHlvdXIgbmV3IGFwcHMgbmFtZQo="

COPY playbooks /opt/apb/actions
COPY roles /opt/ansible/roles
RUN chmod -R g=u /opt/{ansible,apb}
USER apb