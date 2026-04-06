echo "开始DIY脚本..."
# 替换 feeds.conf.default
[ -f "feeds/6.12.txt" ] && cp -f feeds/6.12.txt feeds.conf.default
# 1. 清理插件
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-adguardhome
rm -rf feeds/packages/net/adguardhome

# 2. 添加额外插件
git clone --depth=1 https://github.com/sirpdboy/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 https://github.com/EasyTier/luci-app-easytier package/luci-app-easytier
git clone --depth=1 https://github.com/Openwrt-Passwall/openwrt-passwall2 package/luci-app-passwall2

# 3. 确保 .config 包含中文配置
if [ -f .config ]; then
    echo "确保中文配置..."
    if ! grep -q "CONFIG_LUCI_LANG_zh-cn=y" .config; then
        echo "CONFIG_LUCI_LANG_zh-cn=y" >> .config
    fi
    if ! grep -q "CONFIG_PACKAGE_luci-i18n-base-zh-cn=y" .config; then
        echo "CONFIG_PACKAGE_luci-i18n-base-zh-cn=y" >> .config
    fi
fi

echo "DIY脚本完成！"
