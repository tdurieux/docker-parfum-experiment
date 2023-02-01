FROM pandoc/core:2.18.0

ENTRYPOINT ["/usr/bin/env"]

RUN apk add --no-cache git py3-pip && python3 -m pip install pandocfilters

CMD /manpages/tool/update-man-pages.sh
