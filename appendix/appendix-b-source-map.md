# 附录 B：源码导航

本附录提供 Claude Code 源码库的功能分类索引，帮助读者快速定位关键文件。所有路径相对于 `src/` 目录。

---

## 1. 入口点与启动

| 文件 | 职责 | 相关章节 |
|------|------|---------|
| `entrypoints/cli.tsx` | CLI 入口，`--version` 快速路径，委托 main.tsx | Ch2 |
| `main.tsx` | 主启动编排（~800KB），Commander.js 注册，init 流程，迁移系统 | Ch2, Ch23 |
| `entrypoints/init.ts` | 初始化逻辑：auth、settings、profiling | Ch2 |
| `entrypoints/sdk/` | SDK 入口和类型定义 | Ch4 |
| `entrypoints/mcp.ts` | MCP 服务器模式入口 | Ch15 |
| `utils/startupProfiler.ts` | 启动性能打点系统（`profileCheckpoint`） | Ch2, Ch21 |
| `bootstrap/state.ts` | 全局 bootstrap 状态（全局计数器、成本追踪） | Ch21 |

## 2. 核心引擎

| 文件 | 职责 | 相关章节 |
|------|------|---------|
| `QueryEngine.ts` | 查询引擎类，一个对话一个实例，submitMessage 入口 | Ch4 |
| `query.ts` | 查询循环状态机（queryLoop），API 调用 + 工具执行 | Ch4 |
| `query/tokenBudget.ts` | Token 预算追踪（BudgetTracker） | Ch4 |
| `query/stopHooks.ts` | Turn 终止逻辑 | Ch4 |
| `query/deps.ts` | 查询依赖注入 | Ch4 |
| `types/message.ts` | 消息类型定义（UserMessage、AssistantMessage 等 7+ 种） | Ch5 |
| `utils/messages.ts` | 消息工厂函数（createUserMessage 等）、归一化 | Ch5 |
| `utils/conversationRecovery.ts` | 会话恢复（`--resume`） | Ch18 |

## 3. 工具系统

| 文件 | 职责 | 相关章节 |
|------|------|---------|
| `Tool.ts` | Tool 接口定义、ToolUseContext、buildTool 工厂、TOOL_DEFAULTS | Ch7 |
| `tools.ts` | 工具注册表（getAllBaseTools、assembleToolPool） | Ch7 |
| `tools/BashTool/` | Bash 工具（18 文件，160KB+），命令执行与安全 | Ch8, Ch14 |
| `tools/FileReadTool/` | 文件读取工具 | Ch8 |
| `tools/FileEditTool/` | 文件编辑工具（唯一性校验、并发检测） | Ch8 |
| `tools/FileWriteTool/` | 文件写入工具 | Ch8 |
| `tools/GlobTool/` | 文件搜索（Ripgrep 集成） | Ch8 |
| `tools/GrepTool/` | 内容搜索（Ripgrep 集成） | Ch8 |
| `tools/WebFetchTool/` | URL 抓取 | Ch8 |
| `tools/WebSearchTool/` | 网络搜索 | Ch8 |
| `tools/ToolSearchTool/` | 延迟工具加载（isDeferredTool） | Ch7 |
| `tools/TaskCreateTool/` | 任务创建 | Ch8 |
| `tools/AskUserQuestionTool/` | 交互式提问 | Ch8 |
| `services/tools/StreamingToolExecutor.ts` | 并发调度器（四态状态机） | Ch9 |
| `services/tools/toolExecution.ts` | 工具执行管线（runToolUse、buildSchemaNotSentHint） | Ch9 |
| `services/tools/toolHooks.ts` | Pre/Post 工具钩子 | Ch9 |
| `utils/toolResultStorage.ts` | 工具结果截断与磁盘持久化 | Ch9 |

## 4. Agent 系统

| 文件 | 职责 | 相关章节 |
|------|------|---------|
| `tools/AgentTool/loadAgentsDir.ts` | Agent 定义加载、Markdown 解析、类型定义 | Ch10 |
| `tools/AgentTool/builtInAgents.ts` | 内置 Agent 注册（getBuiltInAgents） | Ch10 |
| `tools/AgentTool/agentToolUtils.ts` | resolveAgentTools、filterToolsForAgent | Ch10 |
| `tools/AgentTool/built-in/exploreAgent.ts` | Explore Agent 定义 | Ch10 |
| `tools/AgentTool/built-in/planAgent.ts` | Plan Agent 定义 | Ch10 |
| `tools/AgentTool/built-in/generalPurposeAgent.ts` | GeneralPurpose Agent 定义 | Ch10 |
| `tools/AgentTool/built-in/claudeCodeGuideAgent.ts` | Guide Agent（动态系统提示词） | Ch10 |
| `tools/AgentTool/built-in/verificationAgent.ts` | Verification Agent（对抗性验证） | Ch10 |
| `tools/AgentTool/forkSubagent.ts` | Fork 机制（buildForkedMessages） | Ch11 |
| `tools/AgentTool/resumeAgent.ts` | Resume 机制（sidechain 恢复） | Ch11 |
| `tools/AgentTool/runAgent.ts` | Agent 运行时（runAgent、initializeAgentMcpServers） | Ch11 |
| `tools/AgentTool/agentMemory.ts` | Agent 记忆系统（三级范围） | Ch11 |
| `tools/SkillTool/SkillTool.ts` | Skill 执行（executeForkedSkill） | Ch12 |
| `skills/bundledSkills.ts` | 内置 Skill 注册 | Ch12 |
| `skills/loadSkillsDir.ts` | 文件系统 Skill 发现 | Ch12 |

## 5. 权限与安全

| 文件 | 职责 | 相关章节 |
|------|------|---------|
| `types/permissions.ts` | 权限类型定义（PermissionMode、PermissionRule） | Ch13 |
| `utils/permissions/permissions.ts` | hasPermissionsToUseTool、规则匹配 | Ch13 |
| `utils/permissions/PermissionMode.ts` | 权限模式配置（符号、颜色） | Ch13 |
| `utils/permissions/bashSecurity.ts` | Bash 命令安全分析（~102KB） | Ch14 |
| `utils/permissions/bashClassifier.ts` | Bash 命令自动分类器 | Ch14 |
| `utils/permissions/denialTracking.ts` | 拒绝计数与升级机制 | Ch13 |
| `utils/permissions/yoloClassifier.ts` | Auto 模式自动审批分类器 | Ch13 |
| `tools/BashTool/readOnlyValidation.ts` | 只读模式强制执行（~68KB） | Ch14 |
| `tools/BashTool/sedValidation.ts` | sed 命令专项验证（~21KB） | Ch14 |
| `tools/BashTool/pathValidation.ts` | 路径边界校验（~43KB） | Ch14 |
| `hooks/useCanUseTool.tsx` | 权限检查 React hook（~40KB） | Ch13 |

## 6. MCP 协议

| 文件 | 职责 | 相关章节 |
|------|------|---------|
| `services/mcp/client.ts` | MCP 客户端实现（~3300 行），连接管理、工具发现 | Ch15 |
| `services/mcp/config.ts` | MCP 配置管理（~51KB），多源合并 | Ch15 |
| `services/mcp/auth.ts` | OAuth 认证（~88KB），ClaudeAuthProvider | Ch16 |
| `services/mcp/xaa.ts` | XAA 跨账户访问 | Ch16 |
| `services/mcp/xaaIdpLogin.ts` | IdP 登录集成 | Ch16 |
| `services/mcp/channelPermissions.ts` | 通道权限控制 | Ch16 |
| `services/mcp/types.ts` | MCP 类型定义 | Ch15 |
| `services/mcp/useManageMCPConnections.tsx` | MCP 连接生命周期 React hook | Ch15 |

## 7. 状态管理

| 文件 | 职责 | 相关章节 |
|------|------|---------|
| `state/AppState.tsx` | React Context Provider，React Compiler 集成 | Ch17 |
| `state/AppStateStore.ts` | 状态存储实现（getDefaultAppState） | Ch17 |
| `state/store.ts` | Zustand-like createStore 工厂 | Ch17 |
| `services/compact/` | 会话压缩服务 | Ch18 |
| `utils/sessionStorage.ts` | Transcript 录制（recordTranscript） | Ch5, Ch18 |

## 8. UI 组件

| 文件 | 职责 | 相关章节 |
|------|------|---------|
| `screens/REPL.tsx` | 主 REPL 界面（~6000 行） | Ch20 |
| `components/App.tsx` | 根应用组件 | Ch19 |
| `components/PromptInput.tsx` | 用户输入组件 | Ch20 |
| `components/messages/` | 消息渲染组件群 | Ch20 |
| `components/permissions/` | 权限对话框组件 | Ch13, Ch20 |
| `ink/` | Ink 框架内部化（50+ 模块） | Ch19 |
| `ink/components/` | Ink 兼容 React 组件 | Ch19 |
| `ink/termio/` | 终端 I/O 抽象 | Ch19 |
| `native-ts/yoga-layout/` | Yoga WASM 布局引擎 | Ch19 |
| `hooks/useGlobalKeybindings.tsx` | 全局快捷键 | Ch20 |

## 9. 工程基础设施

| 文件 | 职责 | 相关章节 |
|------|------|---------|
| `utils/memoize.ts` | 三层 Memoization（memoize、memoizeWithTTL、throttle） | Ch21 |
| `services/analytics/growthbook.ts` | GrowthBook 特性开关集成 | Ch2 |
| `migrations/` | 11 个配置迁移脚本（模型重命名链、设置迁移） | Ch23 |
| `utils/semver.ts` | 语义化版本比较 | Ch23 |
| `utils/config.ts` | 全局配置管理（migrationVersion 等） | Ch23 |
| `utils/lazySchema.ts` | Zod schema 延迟构造（打破循环依赖） | Ch3 |
| `schemas/` | Zod 验证 schema 集合 | Ch3 |
| `constants/` | 全局常量定义 | - |
| `utils/hooks/` | 异步 Hook 注册与执行 | Ch9 |
| `services/api/claude.ts` | Anthropic API 客户端 | Ch4 |

---

> **提示**：源码文件路径可能随版本更新而变化。本索引基于 Claude Code v2.1.x 版本编写。
