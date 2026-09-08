

## 一、docker和 QuantDinger安装

qantDinger参考：
https://github.com/brokermr810/QuantDinger/blob/main/docs/README_CN.md


### 1.1 docker 安装

安装参考：https://blog.csdn.net/xin_yao_xin/article/details/159463946

### 1.2 点击桌面小鲸鱼运行docker后简单配置

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


### 1.3 windows上安装quantDinger


#### 1.3.1 安装命令
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
#### 1.3.2 安装完成后的两个目录

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

#### 1.3.3 安装成功后的信息

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


docker compose -f docker-compose.yml ps  : 命令的解读
```text

**命令含义**：查看当前 `docker-compose.yml` 文件定义的所有容器的**运行状态**。

**输出结果核心解读**：

1. **全部健康运行**：列出的 10 个容器均处于 `Up`（运行中）且 `healthy`（健康检查通过）状态，部署完全成功。
2. **架构组成**：这是一个完整的量化交易后端集群，包含：
   - **用户端**：`frontend`（网页端，端口8888）和 `mobile`（手机H5端，端口8889）。
   - **核心服务**：`backend`（API后端，端口5000）。
   - **数据库与缓存**：`postgres`（数据库，端口5432）和 2 个 `redis`（一个做主缓存，一个做任务队列）。
   - **后台任务**：`celery-worker`、`trading-worker`（交易执行）、`scheduler-worker`（调度）等多个工作进程，共用后端镜像。
3. **端口映射**：只有 Web、API、DB、Redis 映射到了本机（`127.0.0.1`），其余工作进程仅在容器内部通信，不暴露到宿主机，保证了安全性。

**结论**：你已经在本地成功跑起了 QuantDinger 的全套服务，现在可以直接访问 `http://localhost:8888` 登录使用了。
```

docker compose -f docker-compose.yml pull; docker compose -f docker-compose.yml up -d

```text
这个命令是服务更新/重启命令，用于将 QuantDinger 升级到最新版本，或者修复运行中的异常，而不会丢失你的账号、密码和交易数据。

1. docker compose -f docker-compose.yml pull
强制从 GitHub 重新拉取所有服务的最新镜像（backend、frontend、postgres 等）。如果你的镜像已经是最新版，它会跳过下载。

2. docker compose -f docker-compose.yml up -d
基于刚拉取（或已有的）镜像，重新创建并启动所有容器。
-d 表示在后台运行（Detach 模式），不占用当前命令行窗口。

⚠️ 执行后会发生什么？
1.旧容器被销毁，新容器被创建（重启耗时约十几秒）。
2.配置和数据不会丢失：因为数据库（Postgres）和 Redis 的数据存储在 Docker 的数据卷（Volume）中，独立于容器本身，所以重启后你之前设置的账号、策略数据都在。
3.访问地址不变：依然是 http://localhost:8888。



## 


