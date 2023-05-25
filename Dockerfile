FROM alpine

RUN apk --no-cache add bash
RUN apk --no-cache add aws-cli

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]