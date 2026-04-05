#!/bin/bash

# ==================== 禁用无线驱动 ====================
# 删除target.mk中的无线相关包
sed -i 's/DEFAULT_PACKAGES += ath11k-firmware-ipq6018 nss-firmware-ipq60xx kmod-qca-nss-crypto/DEFAULT_PACKAGES += nss-firmware-ipq60xx kmod-qca-nss-crypto/' target/linux/qualcommax/ipq60xx/target.mk

# 确保不包含任何ath11k相关包
echo 'DEFAULT_PACKAGES := $(filter-out ath11k%, $(DEFAULT_PACKAGES))' >> target/linux/qualcommax/ipq60xx/Makefile

# 禁用内核无线子系统
sed -i 's/CONFIG_WLAN=y/CONFIG_WLAN=n/' target/linux/qualcommax/config-6.12
sed -i 's/CONFIG_ATH11K=y/CONFIG_ATH11K=n/' target/linux/qualcommax/config-6.12

# 强制关闭NSS无线加速
sed -i 's/CONFIG_NSS_DRV_PPE_ENABLE=y/CONFIG_NSS_DRV_PPE_ENABLE=n/' target/linux/qualcommax/config-6.12

# 禁用无线模块
for module in \
    kmod-mac80211 kmod-cfg80211 \
    kmod-ath11k kmod-ath10k kmod-ath9k \
    kmod-mt76-core kmod-mt76x02-common kmod-mt76x2
do
    echo "CONFIG_PACKAGE_${module}=n" >> .config
done

# 禁用无线固件
for firmware in \
    ath11k-firmware-ipq6018 \
    ath10k-firmware-qca988x \
    ath10k-firmware-qca9888 \
    ath10k-firmware-qca9984
do
    echo "CONFIG_PACKAGE_${firmware}=n" >> .config
done

# 禁用无线工具
for tool in \
    wpad-openssl hostapd-common iw hostapd-utils
do
    echo "CONFIG_PACKAGE_${tool}=n" >> .config
done

# ==================== 禁用USB驱动 ====================
# 内核级禁用
sed -i 's/CONFIG_USB=y/CONFIG_USB=n/' target/linux/qualcommax/config-6.12
echo "CONFIG_USB_SUPPORT=n" >> .config

# 禁用USB模块
for module in \
    kmod-usb-core kmod-usb-ohci kmod-usb-uhci \
    kmod-usb-xhci kmod-usb-storage kmod-usb-net \
    kmod-usb-net-asix kmod-usb-net-rtl8152 \
    kmod-usb2 kmod-usb3
do
    echo "CONFIG_PACKAGE_${module}=n" >> .config
done

# ==================== 清理并安装插件 ====================
# 正确清理路径（绝对路径）
clean_paths=(
    "${GITHUB_WORKSPACE}/openwrt/feeds/luci/applications/luci-app-adguardhome"
    "${GITHUB_WORKSPACE}/openwrt/feeds/packages/net/adguardhome"
    "${GITHUB_WORKSPACE}/openwrt/package/feeds/luci/luci-app-adguardhome"
    "${GITHUB_WORKSPACE}/openwrt/package/feeds/packages/adguardhome"
)

for path in "${clean_paths[@]}"; do
    if [ -d "$path" ]; then
        rm -rf "$path"
    fi
done

# 安装插件
cd "${GITHUB_WORKSPACE}/openwrt/package" || exit 1
[ ! -d "luci-app-adguardhome" ] && git clone --depth=1 https://github.com/sirpdboy/luci-app-adguardhome
[ ! -d "luci-app-easytier" ] && git clone --depth=1 https://github.com/EasyTier/luci-app-easytier
[ ! -d "luci-app-easytier" ] && git clone --depth=1 https://github.com/EasyTier/luci-app-easytier
# ==================== 更新feeds ====================
cd "${GITHUB_WORKSPACE}/openwrt" || exit 1
./scripts/feeds update -a
./scripts/feeds install -a
