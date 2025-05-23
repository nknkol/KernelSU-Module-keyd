#!/system/bin/sh
################################################################################
#  service.sh – 在 Magisk late_start 阶段拉起 keyd 守护进程
################################################################################

# MODDIR 就是模块根目录（/data/adb/modules/<id>）
MODDIR=${0%/*}

# ① 等 /data 挂载完成（保险起见，极少数早期设备需要）
until [ -d /data ]; do
    sleep 1
done

# ② 读取当前要加载的配置名，默认用 “default”
PROFILE=$(getprop keyd.profile default)

# 如果用户还没把自定义配置放到 /data/adb/keyd/，就 fallback 用模块自带默认文件
CONF=/data/adb/keyd/${PROFILE}.conf
[ -f "$CONF" ] || CONF=$MODDIR/system/etc/keyd/default.conf

# ③ 运行 keyd（-d = daemon mode，日志重定向到 /data/adb/keyd/keyd.log）
exec $MODDIR/system/bin/keyd \
        -d \
        -c "$CONF" \
        >> /data/adb/keyd/keyd.log 2>&1