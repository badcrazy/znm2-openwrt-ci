#!/bin/bash
# 清理插件
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box} 2>/dev/null || true
rm -rf feeds/luci/applications/luci-app-passwall 2>/dev/null || true
rm -rf feeds/packages/net/v2ray-geodata 2>/dev/null || true
rm -rf feeds/packages/net/{chinadns-ng,dns2socks,dns2tcp,ipt2socks,libevent2} 2>/dev/null || true
rm -rf feeds/luci/applications/luci-app-adguardhome
rm -rf feeds/packages/net/adguardhome
./scripts/feeds clean
# 添加额外插件
git clone --depth=1 https://github.com/sirpdboy/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 https://github.com/EasyTier/luci-app-easytier package/luci-app-easytier
# 科学上网插件
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git clone --depth=1 https://github.com/Openwrt-Passwall/openwrt-passwall2 package/luci-app-passwall2
# git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash
# git clone --depth=1 https://github.com/frazy/luci-app-singbox-configs package/luci-app-singbox
# rm -rf package/helloworld
# 移除 openwrt feeds 自带的核心库
# rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
# rm -rf packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
# 移除 openwrt feeds 过时的luci版本
# rm -rf feeds/luci/applications/luci-app-passwall
# rm -rf luci/applications/luci-app-passwall

./scripts/feeds clean
./scripts/feeds update -a
./scripts/feeds install -a
