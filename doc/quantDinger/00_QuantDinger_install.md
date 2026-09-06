

## 安装参考

https://github.com/brokermr810/QuantDinger/blob/main/docs/README_CN.md


### docker 安装

安装参考：https://blog.csdn.net/xin_yao_xin/article/details/159463946

### 点击桌面小鲸鱼运行docker后简单配置

1. 镜像位置变动： 
Docker → 右上角 Settings（齿轮）  
Resources → Advanced  
Disk image location → 点 Browse 选 D/E/F 盘文件夹（如 E:\Docker\wsl）  
Apply & Restart → 等待迁移完成  

2. 配置国内镜像加速：

setting -》 Docker Engine
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
3. docker命令

docker 和 docker compose 的核心区别在于：
docker 是管理单个容器的“单兵工具”，而 docker compose 是管理多个容器的“集团军司令部”


``` shell
docker --version
docker run hello-world  #验证 Docker 引擎是否已正确安装且能够正常运作
docker ps -a  # 查看所有容器

```

```shell

docker compose pull  # 自动拉取 docker-compose.yml 文件中定义的所有服务所需要的镜像（或者指定的某个服务的镜像）
docker compose up -d # 根据当前目录下的 docker-compose.yml 文件，创建并后台启动所有定义的服务容器。

```


### windows上安装


#### 安装命令
```shell
irm https://raw.githubusercontent.com/OpenByteInc/QuantDinger/main/install.ps1 | iex 
```
这个安装脚本会执行：  
```text
1.环境检查：首先检查系统是否已安装 Docker 和 Docker Compose，这是运行 QuantDinger 的必备条件。
2.下载配置：从 GitHub 下载 docker-compose.yml 等必要的配置文件和模板。
3.交互式配置：脚本会提示你输入一系列配置信息，包括：
    管理员用户名、密码和邮箱。
    前端、移动端和后端服务的端口号。
    Docker 镜像源（可选国内镜像加速）。
    自动生成数据库密码等安全密钥。
4.启动服务：使用 Docker Compose 拉取所需的容器镜像，并在后台启动所有服务。
5.等待与提示：脚本会等待后端服务启动成功，最后在屏幕上输出访问地址和管理员账号信息。
```
#### 安装完成后的两个目录

工作目录： C:\Users\你的用户名\quantdinger   

```text
docker-compose.yml（服务编排定义）
.env（全局环境变量，如端口、数据库密码）
backend.env（后端专属环境变量，如管理员账号）
```


镜像目录：D:\tools\docker\wsl\DockerDesktopWSL\main

```text
 ? Image ghcr.io/openbyteinc/quantdinger-backend:latest  Pulled    94.8s
 ? Image ghcr.io/openbyteinc/quantdinger-mobile:latest   Pulled    1.7s
 ? Image postgres:18.3-alpine                            Pulled    1.8s
 ? Image ghcr.io/openbyteinc/quantdinger-frontend:latest Pulled    1.8s
 ? Image redis:8-alpine                                  Pulled    1.8s
```

#### 安装成功后的信息

```text
QuantDinger is ready.

Web UI:      http://localhost:8888
Mobile H5:   http://localhost:8889
API:         http://127.0.0.1:5000
Directory:   C:\Users\Administrator\quantdinger
Username:    ww5365
Password:    existing administrator password

Useful commands:
  cd C:\Users\Administrator\quantdinger
  docker compose -f docker-compose.yml ps
  docker compose -f docker-compose.yml logs -f backend
  docker compose -f docker-compose.yml pull; docker compose -f docker-compose.yml up -d
```

