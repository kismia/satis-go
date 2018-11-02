#!/bin/sh

envsubst < /opt/satis-go/config.template.yaml > /opt/satis-go/config.yaml

exec "$@"