

## 安装参考

https://github.com/brokermr810/QuantDinger/blob/main/docs/README_CN.md


### docker 安装

参考：https://blog.csdn.net/xin_yao_xin/article/details/159463946

配置国内镜像加速：

``` json
{
	"builder": {
		"gc": {
			"defaultKeepStorage": "20GB",
			"enabled": true
		}
	},
	"experimental": false,
	"features": {
		"buildkit": true
	},
	"registry-mirrors": [
		"https://docker.m.daocloud.io",
		"https://mirror.aliyuncs.com",
		"https://hub-mirror.c.163.com"
	]
}

```


### key生成
随机字符串（例如 64个十六进制数），git bash中运行： 生成 64 个十六进制字符（相当于 32 字节 = 256 位）
echo "SECRET_KEY=$(openssl rand -hex 32)" 

### 
docker compose pull 的功能很简单：自动拉取 docker-compose.yml 文件中定义的所有服务所需要的镜像（或者指定的某个服务的镜像）

docker compose up -d 的作用是：根据当前目录下的 docker-compose.yml 文件，创建并后台启动所有定义的服务容器。
