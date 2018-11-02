FROM golang:1.11.1-alpine3.8 AS builder

RUN apk add --update --no-cache alpine-sdk

COPY . /go/src/github.com/benschw/satis-go

WORKDIR /go/src/github.com/benschw/satis-go

RUN go build -o /opt/satis-go/satis-go .

FROM composer/satis

ENV SATIS_GO_BIND 0.0.0.0:8080
ENV SATIS_GO_DB_PATH /opt/satis-go/data
ENV SATIS_GO_REPOUI_PATH /usr/share/nginx/htlm
ENV SATIS_GO_REPO_NAME "My Satis"
ENV SATIS_GO_REPO_HOST http://localhost:8080
ENV PATH="/satis/bin:${PATH}"

WORKDIR /opt/satis-go/

RUN apk add --update --no-cache gettext
ADD entrypoint.sh /entrypoint.sh
ADD config.template.yaml ./config.template.yaml
COPY --from=builder /opt/satis-go/satis-go .

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/opt/satis-go/satis-go"]



