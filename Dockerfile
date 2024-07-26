# mosdns v5
FROM --platform=${TARGETPLATFORM} golang:alpine as builder
ARG CGO_ENABLED=0
ARG TAG
ARG REPOSITORY

WORKDIR /root
RUN apk add --update git \
	&& git clone https://github.com/${REPOSITORY} mosdns \
	&& cd ./mosdns \
	&& git fetch --all --tags \
	&& git checkout tags/${TAG} \
	&& go build -ldflags "-s -w -X main.version=${TAG}" -trimpath -o mosdns

FROM --platform=${TARGETPLATFORM} alpine:latest
LABEL maintainer="Sgit <github.com/Sagit-chu>"

COPY --from=builder /root/mosdns/mosdns /usr/bin/

RUN apk add --no-cache ca-certificates \
	&& mkdir /etc/mosdns
ADD entrypoint.sh /entrypoint.sh
ADD config.yaml /config.yaml
ADD hosts /hosts
ADD rule /rule
# ADD https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat /geoip.dat
# ADD https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat /geosite.dat

# ADD https://raw.githubusercontent.com/IceCodeNew/4Share/master/geoip_china/china_ip_list.txt /geoip_cn.txt
# ADD https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt /geosite_category-ads-all.txt
# ADD https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt /geosite_geolocation-!cn.txt
# ADD https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt /geosite_cn.txt

ADD https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt /geosite_geolocation_noncn.txt
ADD https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt /gfw.txt
ADD https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt /geosite_cn.txt
ADD https://raw.githubusercontent.com/Hackl0us/GeoIP2-CN/release/CN-ip-cidr.txt /geoip_cn.txt

ADD mos_rule_update.sh /usr/local/bin/mos_rule_update.sh
RUN chmod +x /usr/local/bin/mos_rule_update.sh

# 添加 crontab 文件到 /etc/cron.d/
RUN echo "0 2 * * * /usr/local/bin/mos_rule_update.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/mos_rule_update \
    && chmod 0644 /etc/cron.d/mos_rule_update \
    && crontab /etc/cron.d/mos_rule_update

# 创建日志文件以便 cron 能够写入日志
RUN touch /var/log/cron.log

VOLUME /etc/mosdns
EXPOSE 53/udp 53/tcp
RUN chmod +x /entrypoint.sh
CMD ["sh", "/entrypoint.sh"]
