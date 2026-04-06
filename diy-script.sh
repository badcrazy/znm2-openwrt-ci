#!/bin/bash
# diy.sh - 简化的中文支持版本

echo "开始DIY脚本..."

# 1. 清理插件
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-adguardhome
rm -rf feeds/packages/net/adguardhome

# 2. 添加额外插件
git clone --depth=1 https://github.com/sirpdboy/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 https://github.com/EasyTier/luci-app-easytier package/luci-app-easytier
git clone --depth=1 https://github.com/Openwrt-Passwall/openwrt-passwall2 package/luci-app-passwall2

# 3. 强制中文支持 - 关键步骤
echo "强制启用中文支持..."

# 确保.config文件存在且包含中文配置
if [ -f .config ]; then
    # 添加中文语言包配置（如果不存在）
    if ! grep -q "CONFIG_LUCI_LANG_zh-cn=y" .config; then
        echo "CONFIG_LUCI_LANG_zh-cn=y" >> .config
    fi
    
    # 确保基本的中文包被选中
    for lang_pkg in \
        luci-i18n-base-zh-cn \
        luci-i18n-firewall-zh-cn \
        luci-i18n-package-manager-zh-cn \
        luci-i18n-upnp-zh-cn \
        luci-i18n-autoreboot-zh-cn \
        luci-i18n-cpufreq-zh-cn \
        luci-i18n-adguardhome-zh-cn \
        luci-i18n-passwall2-zh-cn
    do
        if ! grep -q "CONFIG_PACKAGE_${lang_pkg}=y" .config; then
            echo "CONFIG_PACKAGE_${lang_pkg}=y" >> .config
        fi
    done
    
    # 删除可能冲突的英文配置
    sed -i '/CONFIG_LUCI_LANG_en=y/d' .config
else
    echo "错误：.config 文件不存在！"
    exit 1
fi

# 4. 修复插件的中文目录链接
echo "修复插件的中文目录..."

# 修复所有luci-app的中文目录
find package/ feeds/ -name "luci-app-*" -type d 2>/dev/null | while read app_dir; do
    if [ -d "$app_dir/po" ]; then
        # 创建 zh-cn 和 zh_Hans 的相互链接
        if [ -d "$app_dir/po/zh_Hans" ] && [ ! -L "$app_dir/po/zh-cn" ]; then
            ln -sf zh_Hans "$app_dir/po/zh-cn"
            echo "为 $(basename $app_dir) 创建 zh-cn 链接"
        fi
        if [ -d "$app_dir/po/zh-cn" ] && [ ! -L "$app_dir/po/zh_Hans" ]; then
            ln -sf zh-cn "$app_dir/po/zh_Hans"
            echo "为 $(basename $app_dir) 创建 zh_Hans 链接"
        fi
    fi
done
echo "DIY脚本执行完成！"
