#!/bin/sh

# Exodus uninstaller

# uninstall
# legacy nikki packages are removed as well
if [ -x "/bin/opkg" ]; then
	opkg list-installed 'luci-i18n-exodus-*' | cut -d ' ' -f 1 | xargs opkg remove
	opkg list-installed 'luci-i18n-nikki-*' | cut -d ' ' -f 1 | xargs opkg remove
	opkg remove luci-app-exodus luci-app-nikki
	opkg remove exodus nikki
	opkg remove mihomo-meta mihomo-alpha
elif [ -x "/usr/bin/apk" ]; then
	apk list --installed --manifest 'luci-i18n-exodus-*' | cut -d ' ' -f 1 | xargs apk del
	apk list --installed --manifest 'luci-i18n-nikki-*' | cut -d ' ' -f 1 | xargs apk del
	# apk refuses the whole list when one of its packages is not installed, one by one
	for package in luci-app-exodus luci-app-nikki exodus nikki mihomo-meta mihomo-alpha; do
		apk del "$package" 2> /dev/null
	done
fi
# remove the core, since 1.31.0 it belongs to no package
rm -f /usr/libexec/mihomo
[ -L /usr/bin/mihomo ] && rm -f /usr/bin/mihomo
# remove config
rm -f /etc/config/nikki
# remove files
rm -rf /etc/nikki
# remove log
rm -rf /var/log/nikki
# remove temp
rm -rf /var/run/nikki
# remove legacy upstream feed
if [ -f "/etc/opkg/customfeeds.conf" ] && grep -q "nikkinikki" "/etc/opkg/customfeeds.conf"; then
	sed -i '/nikkinikki/d' "/etc/opkg/customfeeds.conf"
fi
if [ -f "/etc/apk/repositories.d/customfeeds.list" ] && grep -q "nikkinikki" "/etc/apk/repositories.d/customfeeds.list"; then
	sed -i '/nikkinikki/d' "/etc/apk/repositories.d/customfeeds.list"
fi
rm -f /etc/apk/keys/nikki.pem

echo "success"
