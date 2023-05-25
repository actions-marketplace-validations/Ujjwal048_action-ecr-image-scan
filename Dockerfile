FROM alpine

RUN apk --no-cache add bash
RUN apk --no-cache add aws-cli
RUN apk --no-cache add jq

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]