

## 安装参考




### docker 安装

参考：https://blog.csdn.net/xin_yao_xin/article/details/159463946


### key生成
随机字符串（例如 64个十六进制数），git bash中运行： 生成 64 个十六进制字符（相当于 32 字节 = 256 位）
echo "SECRET_KEY=$(openssl rand -hex 32)" 

