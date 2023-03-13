FROM curlimages/curl

USER root

RUN apk add jq

# curl_user
USER 100
