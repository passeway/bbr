#!/bin/bash

tcp_tune() {
    # 备份原有的 sysctl.conf
    backup_file="/etc/sysctl.conf.bak.$(date +%Y%m%d_%H%M%S)"
    cp /etc/sysctl.conf "$backup_file"

    if [ ! -f "$backup_file" ]; then
        echo "备份失败，无法继续执行"
        exit 1
    fi

    echo "备份已创建：$backup_file"

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

    echo "正在删除现有 TCP 配置..."
    for param in "${tcp_params[@]}"; do
        sed -i -e "/$param/d" /etc/sysctl.conf
        echo "已删除 $param"
    done

    echo "应用新的 TCP 优化配置..."
    cat >> /etc/sysctl.conf <<EOF
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
    echo "新配置已写入 /etc/sysctl.conf"

    echo "重新加载 sysctl 配置..."
    if sysctl -p; then
        echo "sysctl 配置加载成功"
        if sysctl net.ipv4.tcp_congestion_control | grep -q "bbr"; then
            echo "BBR 拥塞控制算法已成功启用"
        else
            echo "BBR 启用失败，请检查配置"
            exit 1
        fi
    else
        echo "应用 TCP 优化配置时发生错误，正在恢复之前的配置..."
        cp "$backup_file" /etc/sysctl.conf
        sysctl -p
        echo "配置已恢复至备份版本"
        exit 1
    fi
}

# 调用函数
tcp_tune
