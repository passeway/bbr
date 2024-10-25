#!/bin/bash

tcp_tune() {
    # 备份原有的 sysctl.conf
    cp /etc/sysctl.conf /etc/sysctl.conf.bak.$(date +%Y%m%d_%H%M%S)

    # 要删除的 TCP 配置项
    tcp_params=(
        "net.ipv4.tcp_no_metrics_save"
        "net.ipv4.tcp_ecn"
        "net.ipv4.tcp_frto"
        "net.ipv4.tcp_mtu_probing"
        "net.ipv4.tcp_rfc1337"
        "net.ipv4.tcp_sack"
        "net.ipv4.tcp_fack"
        "net.ipv4.tcp_window_scaling"
        "net.ipv4.tcp_adv_win_scale"
        "net.ipv4.tcp_moderate_rcvbuf"
        "net.ipv4.tcp_rmem"
        "net.ipv4.tcp_wmem"
        "net.core.rmem_max"
        "net.core.wmem_max"
        "net.ipv4.udp_rmem_min"
        "net.ipv4.udp_wmem_min"
        "net.core.default_qdisc"
        "net.ipv4.tcp_congestion_control"
    )

    # 删除现有的 TCP 配置
    for param in "${tcp_params[@]}"; do
        sed -i "/$param/d" /etc/sysctl.conf
    done

    # 应用新的 TCP 优化配置
    cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_ecn=0
net.ipv4.tcp_frto=1
net.ipv4.tcp_mtu_probing=1
net.ipv4.tcp_rfc1337=1
net.ipv4.tcp_sack=1
net.ipv4.tcp_fack=1
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_adv_win_scale=1
net.ipv4.tcp_moderate_rcvbuf=1
net.core.rmem_max=33554432
net.core.wmem_max=33554432
net.ipv4.tcp_rmem=4096 87380 33554432
net.ipv4.tcp_wmem=4096 16384 33554432
net.ipv4.udp_rmem_min=8192
net.ipv4.udp_wmem_min=8192
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

    # 只使用 sysctl -p 重新加载配置文件
    if sysctl -p > /dev/null 2>&1; then
        echo "TCP 优化配置已成功应用，并已开启 BBR"
    else
        echo "应用 TCP 优化配置时发生错误，恢复之前的配置"
        cp /etc/sysctl.conf.bak.$(date +%Y%m%d_%H%M%S) /etc/sysctl.conf
        sysctl -p > /dev/null 2>&1  # 恢复配置
    fi
}

# 调用函数
tcp_tune
