# 全书目录

## 前言

Claude Code 是 Anthropic 推出的 AI 编程助手 CLI 工具。它不仅是一个产品，更是一部关于如何构建生产级 AI Agent 系统的教科书。本书从源码出发，系统剖析其架构设计、工程实践与编程哲学。

---

## 第一部分：基础架构

### [第 1 章：全景概览](part1-foundation/ch01-overview.md)
- 1.1 Claude Code 是什么
- 1.2 技术栈选型：为什么是 Bun + React + Ink
- 1.3 代码库全景：1900 个文件的组织哲学
- 1.4 架构分层：从 CLI 到 Agent 的五层模型
- 1.5 核心数据流：一次对话的完整旅程

### [第 2 章：启动流程](part1-foundation/ch02-bootstrap.md)
- 2.1 入口点：main.tsx 的职责
- 2.2 并行预取：MDM + Keychain 的启动优化
- 2.3 Commander.js 命令注册
- 2.4 Feature Flag：编译时死代码消除
- 2.5 延迟加载与懒初始化
- 2.6 启动性能剖析：135ms 的极致追求

### [第 3 章：类型系统设计](part1-foundation/ch03-type-system.md)
- 3.1 TypeScript 严格模式下的类型哲学
- 3.2 循环依赖破解：纯类型文件提取
- 3.3 Zod Schema：运行时类型验证
- 3.4 泛型工具类型：Tool<Input, Output, Progress>
- 3.5 判别联合类型在消息系统中的应用

---

## 第二部分：核心引擎

### [第 4 章：查询引擎](part2-core-engine/ch04-query-engine.md)
- 4.1 QueryEngine 类：会话生命周期管理者
- 4.2 submitMessage：一次查询的完整流程
- 4.3 状态机模型：Continue/Terminal 二元决策
- 4.4 Token 预算与消耗追踪
- 4.5 错误恢复：max_output_tokens 与重试策略
- 4.6 SDK 模式 vs REPL 模式的统一抽象

### [第 5 章：消息系统](part2-core-engine/ch05-message-system.md)
- 5.1 消息类型层次：从 UserMessage 到 TombstoneMessage
- 5.2 消息创建与序列化
- 5.3 工具结果消息的特殊处理
- 5.4 消息持久化：Transcript 录制与恢复
- 5.5 消息归一化：为 API 准备数据

### [第 6 章：流式处理](part2-core-engine/ch06-streaming.md)
- 6.1 AsyncGenerator：贯穿全栈的流式范式
- 6.2 API 流式响应处理
- 6.3 工具执行的进度流
- 6.4 Generator 组合与取消传播
- 6.5 背压控制与内存管理

---

## 第三部分：工具系统

### [第 7 章：工具架构](part3-tool-system/ch07-tool-architecture.md)
- 7.1 Tool 接口契约：30+ 方法的设计考量
- 7.2 buildTool 工厂：失败关闭的默认值设计
- 7.3 ToolUseContext：依赖注入的核心载体
- 7.4 工具注册与发现机制
- 7.5 延迟工具加载：ToolSearchTool 的设计

### [第 8 章：内置工具深度解析](part3-tool-system/ch08-builtin-tools.md)
- 8.1 BashTool：160KB 的安全壁垒
- 8.2 FileReadTool/FileEditTool/FileWriteTool：文件操作三剑客
- 8.3 GlobTool/GrepTool：搜索工具的 Ripgrep 集成
- 8.4 WebFetchTool/WebSearchTool：网络工具
- 8.5 TaskTools：任务管理系统

### [第 9 章：工具执行管线](part3-tool-system/ch09-tool-execution.md)
- 9.1 StreamingToolExecutor：并发调度器
- 9.2 并发安全性判定：isConcurrencySafe 的语义
- 9.3 工具结果的截断与持久化
- 9.4 工具钩子：Pre/Post 拦截器
- 9.5 内容替换预算：ContentReplacementState

---

## 第四部分：Agent 系统

### [第 10 章：Agent 模型](part4-agent/ch10-agent-model.md)
- 10.1 Agent 的定义：从 Markdown 到运行时
- 10.2 内置 Agent：Plan、Explore、Guide、Verification
- 10.3 自定义 Agent：.claude/agents/ 目录
- 10.4 Agent 的工具集解析
- 10.5 Agent 的 Token 预算与模型选择

### [第 11 章：子 Agent 编排](part4-agent/ch11-subagent.md)
- 11.1 Fork 机制：上下文克隆与隔离
- 11.2 Resume 机制：状态恢复与续航
- 11.3 后台任务：LocalAgentTask 与 RemoteAgentTask
- 11.4 Agent 记忆：快照与持久化
- 11.5 Agent 间通信：SendMessageTool

### [第 12 章：Skill 系统](part4-agent/ch12-skill-system.md)
- 12.1 Skill 的本质：Prompt 模板 + Agent 封装
- 12.2 Skill 发现：文件系统、插件、MCP
- 12.3 Skill 执行：Fork 子 Agent 模式
- 12.4 内置 Skill 解析
- 12.5 Skill 与插件的关系

---

## 第五部分：权限与安全

### [第 13 章：权限模型](part5-permission/ch13-permission-model.md)
- 13.1 六层权限模式：从 default 到 bypassPermissions
- 13.2 规则系统：Allow/Deny/Ask 三元决策
- 13.3 权限检查流水线
- 13.4 分类器辅助审批：BASH_CLASSIFIER
- 13.5 拒绝追踪与升级机制
- 13.6 权限持久化与会话隔离

### [第 14 章：Bash 安全分析](part5-permission/ch14-bash-security.md)
- 14.1 命令解析与语义分析
- 14.2 危险命令检测：rm、mv、truncate
- 14.3 路径边界校验
- 14.4 sed 命令验证
- 14.5 只读模式强制执行
- 14.6 沙箱模式切换

---

## 第六部分：MCP 协议

### [第 15 章：MCP 协议实现](part6-mcp/ch15-mcp-protocol.md)
- 15.1 MCP 协议概述：JSON-RPC over Transport
- 15.2 七种传输层：stdio/SSE/HTTP/WebSocket/SDK
- 15.3 MCP 客户端实现：3300 行的协议引擎
- 15.4 工具发现与转换：从 MCP Tool 到内部 Tool
- 15.5 资源系统：Resource 的列举与读取
- 15.6 进度流与 Elicitation

### [第 16 章：MCP 认证体系](part6-mcp/ch16-mcp-auth.md)
- 16.1 OAuth 代码授权流程
- 16.2 Token 缓存与刷新
- 16.3 XAA 跨账户访问
- 16.4 IdP 集成
- 16.5 通道权限控制

---

## 第七部分：状态管理

### [第 17 章：状态管理](part7-state/ch17-state-management.md)
- 17.1 React Store 模式：createStore 工厂
- 17.2 AppState：全局状态的统一视图
- 17.3 useSyncExternalStore：响应式订阅
- 17.4 React Compiler 集成：自动 Memoization
- 17.5 文件状态缓存：LRU 策略

### [第 18 章：会话管理与压缩](part7-state/ch18-conversation.md)
- 18.1 会话持久化：Transcript 机制
- 18.2 自动压缩：Token 触发的历史裁剪
- 18.3 Snip 压缩：基于文件的历史快照
- 18.4 压缩边界标记
- 18.5 会话恢复：--resume 的实现

---

## 第八部分：终端 UI

### [第 19 章：React + Ink 终端 UI](part8-ui/ch19-ink-react.md)
- 19.1 Ink 框架：在终端中运行 React
- 19.2 Yoga 布局引擎：Flexbox in Terminal
- 19.3 组件层次：140+ 组件的设计体系
- 19.4 键盘事件处理
- 19.5 终端 I/O 抽象层

### [第 20 章：REPL 实现](part8-ui/ch20-repl.md)
- 20.1 REPL 组件：6000 行的主界面
- 20.2 输入处理：PromptInput 组件
- 20.3 消息渲染：虚拟列表
- 20.4 权限对话框
- 20.5 全局快捷键系统

---

## 第九部分：工程实践

### [第 21 章：性能优化](part9-engineering/ch21-performance.md)
- 21.1 启动时间优化：并行预取 + 懒加载
- 21.2 运行时优化：Memoization + LRU Cache
- 21.3 Feature Flag 死代码消除
- 21.4 Prompt Cache 共享
- 21.5 Token 计数与预算控制

### [第 22 章：测试策略](part9-engineering/ch22-testing.md)
- 22.1 单元测试：工具级测试
- 22.2 集成测试：QueryEngine 级测试
- 22.3 E2E 测试：CLI 端到端
- 22.4 权限测试：TestingPermissionTool
- 22.5 Harness Engineering：AI 系统的质量保证

### [第 23 章：构建系统](part9-engineering/ch23-build-system.md)
- 23.1 Bun Runtime：选型与优势
- 23.2 Bundle 策略：Feature Gate 编译
- 23.3 依赖管理：零依赖设计理念
- 23.4 发布流程：NPM 包构建

---

## 第十部分：编程思想

### [第 24 章：设计模式提炼](part10-philosophy/ch24-design-patterns.md)
- 24.1 依赖注入：ToolUseContext 的 40+ 字段
- 24.2 失败关闭：安全默认值设计
- 24.3 Generator 流水线：AsyncGenerator 的组合艺术
- 24.4 观察者模式：Hook 系统的设计
- 24.5 策略模式：权限分类器的可插拔架构
- 24.6 工厂模式：buildTool 与 createStore

### [第 25 章：工程哲学](part10-philosophy/ch25-philosophy.md)
- 25.1 安全优先：权限系统的设计哲学
- 25.2 可扩展性：MCP 协议的开放设计
- 25.3 可观测性：Hook + Telemetry 的全链路追踪
- 25.4 渐进式复杂性：从简单到完整的功能渐进
- 25.5 生产级 Agent 系统的工程法则

---

## 附录

### [附录 A：术语表](appendix/appendix-a-glossary.md)
### [附录 B：源码导航](appendix/appendix-b-source-map.md)
