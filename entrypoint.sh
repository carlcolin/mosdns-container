#!/bin/sh
if [ ! -f /etc/mosdns/config.yaml ]; then
	mkdir -p /etc/mosdns/
	cp -u /config.yaml /etc/mosdns/config.yaml
fi
if [ ! -f /etc/mosdns/hosts ]; then
	cp -u /hosts /etc/mosdns/hosts
fi
if [ ! -d /etc/mosdns/rule ]; then
    cp -u -r /rule /etc/mosdns/
fi
# cp -u /geosite.dat /etc/mosdns/geosite.dat
# cp -u /geoip.dat /etc/mosdns/geoip.dat

# cp -u /geoip_cn.txt /etc/mosdns/geoip_cn.txt
# cp -u /geosite_category-ads-all.txt /etc/mosdns/geosite_category-ads-all.txt
# cp -u /geosite_geolocation-!cn.txt /etc/mosdns/geosite_geolocation-!cn.txt
# cp -u /geosite_cn.txt /etc/mosdns/geosite_cn.txt

cp -u /geosite_geolocation_noncn.txt /etc/mosdns/geosite_geolocation_noncn.txt
cp -u /gfw.txt /etc/mosdns/gfw.txt
cp -u /geosite_cn.txt /etc/mosdns/geosite_cn.txt
cp -u /geoip_cn.txt /etc/mosdns/geoip_cn.txt
/usr/bin/mosdns start --dir /etc/mosdns
