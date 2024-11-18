## 终端预览

![preview](image.png)

## 一键脚本
```
bash <(curl -fsSL bbr-pi.vercel.app)
```

## 1. TCP 配置相关参数
### **`net.ipv4.tcp_no_metrics_save=1`**
- **功能**：禁止保存 TCP 路由缓存中的 RTT（Round-Trip Time）估算等历史信息。
- **效果**：避免重复使用旧的路由信息，防止潜在性能问题。

### **`net.ipv4.tcp_ecn=0`**
- **功能**：禁用 TCP 的 ECN (Explicit Congestion Notification，显式拥塞通知) 功能。
- **效果**：确保兼容性，部分旧设备或网络中不支持 ECN。

### **`net.ipv4.tcp_frto=1`**
- **功能**：启用 F-RTO（快速恢复超时，Fast Recovery After Timeout）。
- **效果**：减少网络超时后对拥塞窗口的误判，提升恢复性能。

### **`net.ipv4.tcp_mtu_probing=1`**
- **功能**：启用 TCP 的 MTU（Maximum Transmission Unit）探测。
- **效果**：在网络路径 MTU 变化时，动态调整数据包大小以避免分片。

### **`net.ipv4.tcp_rfc1337=1`**
- **功能**：启用基于 RFC 1337 的 TIME-WAIT 状态改进。
- **效果**：减少 TIME-WAIT 引发的连接问题，提高可靠性。

### **`net.ipv4.tcp_sack=1`**
- **功能**：启用 SACK（Selective Acknowledgment，选择性确认）。
- **效果**：允许接收方通知丢失的段，提升数据传输效率。

### **`net.ipv4.tcp_fack=1`**
- **功能**：启用 FACK（Forward Acknowledgment，前向确认）。
- **效果**：结合 SACK 使用，优化拥塞恢复过程。

### **`net.ipv4.tcp_window_scaling=1`**
- **功能**：启用 TCP 窗口扩展（RFC 1323）。
- **效果**：支持超过 64KB 的接收窗口，提升高延迟/高带宽网络的吞吐量。

### **`net.ipv4.tcp_adv_win_scale=1`**
- **功能**：设置 TCP 接收窗口增长因子。
- **效果**：微调窗口扩展机制以适应特定网络条件。

### **`net.ipv4.tcp_moderate_rcvbuf=1`**
- **功能**：动态调整 TCP 接收缓冲区大小。
- **效果**：提高接收效率，减少资源浪费。

---

## 2. 缓冲区配置参数
### **`net.core.rmem_max=33554432`**
- **功能**：设置 TCP 最大接收缓冲区大小（32 MB）。
- **效果**：允许处理更大的传入流量，优化高性能网络应用。

### **`net.core.wmem_max=33554432`**
- **功能**：设置 TCP 最大发送缓冲区大小（32 MB）。
- **效果**：支持更大的传出流量。

### **`net.ipv4.tcp_rmem=4096 87380 33554432`**
- **功能**：设置接收缓冲区的最小值、默认值和最大值。
  - `4096`：最小缓冲区大小（4 KB）。
  - `87380`：默认缓冲区大小（87 KB）。
  - `33554432`：最大缓冲区大小（32 MB）。
- **效果**：提高吞吐量并适应高负载环境。

### **`net.ipv4.tcp_wmem=4096 16384 33554432`**
- **功能**：设置发送缓冲区的最小值、默认值和最大值。
  - `4096`：最小缓冲区大小（4 KB）。
  - `16384`：默认缓冲区大小（16 KB）。
  - `33554432`：最大缓冲区大小（32 MB）。
- **效果**：支持更大的传出数据流量。

### **`net.ipv4.udp_rmem_min=8192`**
- **功能**：设置 UDP 最小接收缓冲区大小（8 KB）。
- **效果**：适应更大的传入数据。

### **`net.ipv4.udp_wmem_min=8192`**
- **功能**：设置 UDP 最小发送缓冲区大小（8 KB）。
- **效果**：提高传输性能。

---

## 3. 队列和拥塞控制相关
### **`net.core.default_qdisc=fq`**
- **功能**：将默认队列调度算法设置为 FQ（Fair Queuing，公平队列）。
- **效果**：优化低延迟网络应用，避免带宽独占。

### **`net.ipv4.tcp_congestion_control=bbr`**
- **功能**：启用 BBR（Bottleneck Bandwidth and RTT，瓶颈带宽和往返时延）拥塞控制算法。
- **效果**：通过动态调整拥塞窗口实现高吞吐量和低延迟，适合现代互联网。


## 项目地址：https://github.com/google/bbr
