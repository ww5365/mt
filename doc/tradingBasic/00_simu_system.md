
帮我在https://github.com/上找一下评价高的开源项目，私募用MT5做执行的，有策略，风控的量化交易系统。

回答：https://chatgpt.com/s/t_69b926b9f5a0819199a3fcf4d6f63d83

MT5-Python-Trading（骨架）: https://github.com/ntungufhadzeni/MT5-Python-Trading/tree/main

metaapi-risk-management（风控）: https://github.com/metaapi/metaapi-risk-management-python-sdk

algorithmic_trading_bot（执行）: https://github.com/jimtin/algorithmic_trading_bot


https://github.com/TheSnowGuru/PyTrader-python-mt4-mt5-trading-api-connector-drag-n-drop

https://github.com/ntungufhadzeni/MT5-Python-Trading



## 20260514
https://gitee.com/xszyou/easy-deal

使用MQL5和Python集成经纪商API与智能交易系统 ： https://www.mql5.com/zh/articles/16012


QuantDinger: https://github.com/brokermr810/QuantDinger

比较：quantDinger  ai-trader  
https://gitcode.csdn.net/69f036c354b52172bc707756.html
https://x.com/huoshan007/status/2046904745722544247


从零搭建量化系统：如何用VNPY+MT5构建跨市场交易机器人（2024实战版）： https://blog.csdn.net/CAT789/article/details/152387267


## 20260911  

再查： mt5 和 开源  相关项目

https://github.com/cyzhh/MT5  ： 智能交易2.0   有点意思


https://github.com/xszyou/Easy-Deal  ： MCP

1. 首选：VeighNa（vn.py）

这是我认为目前最符合你需求的方案。

完全开源，核心采用 MIT License。
Python 技术栈，比较适合自己开发 CTA、趋势、套利、多因子等策略。
有成熟的策略框架、回测、参数优化、行情录制、GUI 交易界面等。
有官方/社区维护的 MT5 Gateway。
MT5 Gateway 基于 MT5 + ZeroMQ 通讯，可以连接 MT5 的模拟盘和真实账户。
支持的 MT5 品种包括 外汇、CFD、期货、股票等。
