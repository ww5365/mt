

## 一、docker和 QuantDinger安装

qantDinger参考：
https://github.com/brokermr810/QuantDinger/blob/main/docs/README_CN.md

说明：
1. v5.0版本变动挺大的，windows 支持docker + linux 环境的一键部署
2. v4.0.2版本之后，看似是不支持MT5了



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

docker compose ps
docker compose logs -f backend
docker compose restart backend
docker compose up -d --build backend   # 仅后端改代码后
docker compose down

docker compose stop backend   # 把backend停掉
docker compose rm -f backend  # 删除容器中backend
docker compose up -d frontend # 仅启动frontend

```


### 1.3 windows上安装quantDinger-v5.0.7 版本


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

```


### 1.4 windows上安装quantDinger-v4.0.2 版本

主要目的是：支持MT5的实盘交易 ： 实现本地部署 + MT5终端


本地部署：quantDinger 后端源码    
docker： front end/ redis/ postgres  镜像

前置：安装 **Docker Desktop** + **git**（不需要 Node.js）。


####  一键部署
在 **PowerShell** 中：

```powershell
git clone https://github.com/brokermr810/QuantDinger.git
Set-Location QuantDinger
Copy-Item backend_api_python\env.example -Destination backend_api_python\.env

# 生成并写入 SECRET_KEY： 我直接执行python脚本，把结果手动拷贝到.env中SECRET_KEY字段
$key = & python -c "import secrets; print(secrets.token_hex(32))" 2>$null
if (-not $key) { $key = & py -c "import secrets; print(secrets.token_hex(32))" 2>$null }
(Get-Content backend_api_python\.env) -replace '^SECRET_KEY=.*$', "SECRET_KEY=$key" | Set-Content backend_api_python\.env -Encoding utf8

# 源码 + 拉取镜像 部署服务
docker compose pull # 
docker compose up -d  # 一键把整套本地栈拉起来——Postgres、Redis、backend（本仓库源码构建）、frontend（默认拉 GHCR 预构建镜像），并配好网络、端口、卷和健康检查

# 默认使用：docker-compose.yml 配置  环境变量可以被根目录下的: .env 覆盖
根目录：cp .env.example .env   修改.env 中 BUILD_REGION=cn 加速up命令 

```

**验证**
- Web：`http://localhost:8888`
- API：`http://localhost:5000/api/health`
- 默认账号：`quantdinger` / `.env` 里的 `ADMIN_PASSWORD`

**可选**
- 拉镜像慢：根目录 `.env` 加 `IMAGE_PREFIX=docker.m.daocloud.io/library/`，或配 Docker Desktop 代理
- 改后端后重建：`docker compose up -d --build backend`
- 本地改UI：克隆 Vue 到 `./QuantDinger-Vue/`，再 `docker compose -f docker-compose.yml -f docker-compose.build.yml up -d --build`

说明：文档里的「源码安装」是 **克隆仓库 + Compose 起栈**（后端从源码构建，前端默认拉 GHCR 镜像），不是纯本机 Python 无 Docker 安装。


####  windows原生backend + dokcer（DB/redis/frontend） + mt5 terminal

##### docker中仅启动db和redis
docker compose up -d postgres redis # 只启动db redis
docker compose stop backend frontend # backend, frontend 如果启动了，就关闭

##### 改后端.env
编辑 backend_api_python/.env

```text
SECRET_KEY=你的随机密钥
DB_TYPE=postgresql
DATABASE_URL=postgresql://quantdinger:quantdinger123@127.0.0.1:5432/quantdinger
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
CACHE_ENABLED=true
ALLOW_LOCAL_DESKTOP_BROKERS=true
FRONTEND_URL=http://localhost:8888
PYTHON_API_HOST=0.0.0.0
PYTHON_API_PORT=5000
```
注：env.example 里默认是 postgres / redis（给全 Docker 用的），原生跑必须改成 127.0.0.1


##### windows原生安装backend

git bash中运行下面命令：

```text
cd D:\workspace\myfiles\github\QuantDinger-4.0.2\backend_api_python

py -m venv .venv
# .\.venv\Scripts\Activate.ps1  这是powershell中
source .venv/Scripts/activate  # 这是gitbash中，which python/pip 查看环境的路径
py -m pip install -U pip
pip install -r requirements.txt
pip install -r requirements-windows.txt   # 需要 MT5 时

python run.py # 运行

```

自检：http://localhost:5000/api/health


##### frontend适配

1. backend是v4.0.2版本，所以frontend也要适配：v4.0.2版本
2. 将容器中frontend的backendurl指向本地后端服务

因为之前已经在docker中装过frontend，所以复用

```text
修改：根目录.env
BACKEND_URL=http://host.docker.internal:5000 
FRONTEND_TAG=v4.0.2

修改完.env后，需要强制重建frontend让.env生效：
docker compose stop frontend
docker compose pull frontend
docker compose up -d --force-recreate frontend
```




####  MT5实盘配置

前端：券商账户->添加交易所账户->metaTrader 5
346150758
XMGlobal-MT5 10

使用git bash 的curl命令来访问后端：

```shell
TOKEN=$(curl -s -X POST http://127.0.0.1:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"ww5365","password":"quantDinger的密码"}' \
  | sed -n 's/.*"token"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

echo "TOKEN length: ${#TOKEN}"

# 连接mt5
curl -s -X POST http://127.0.0.1:5000/api/mt5/connect \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"login":346150758,"password":"mt5账号的密码","server":"XMGlobal-MT5 10"}'

# 查看状态
curl -s http://127.0.0.1:5000/api/mt5/status \
  -H "Authorization: Bearer $TOKEN"

# 查品种列表
curl -s "http://127.0.0.1:5000/api/mt5/symbols" \
  -H "Authorization: Bearer $TOKEN"
  
#  市价下单

curl -X POST http://localhost:5000/api/mt5/order \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"symbol": "GOLD#", "side": "buy", "volume": 0.1}'


```

todo:

1. mt5实盘， 还没有对接MT5 terminal的数据， 现在使用：（Tiingo/TwelveData/yfinance） 还抓取不到
2. 前端 也需要本地话部署
3. agent Gateway mcp  cursor




