# 附录 B：源码导航

本附录提供 Claude Code 源码库的功能分类索引，帮助读者快速定位关键源码文件。所有路径相对于 `src/` 目录。源码总量约 1800 个 TypeScript/TSX 文件，合计约 49 万行代码。

---

## 1. 入口点与启动

| 文件 | 大小估计 | 职责 | 相关章节 |
|------|----------|------|----------|
| `entrypoints/cli.tsx` | ~300 行 | CLI 入口点，处理 `--version` 快速路径，委托启动流程给 `main.tsx` | Ch2 启动流程 |
| `main.tsx` | ~4700 行 | 主启动编排，Commander.js 命令注册，init 流程，迁移系统调度，是整个应用最大的单文件之一 | Ch2 启动流程, Ch23 构建系统 |
| `entrypoints/init.ts` | ~340 行 | 初始化逻辑：身份认证、设置加载、性能 profiling 初始化 | Ch2 启动流程 |
| `entrypoints/sdk/` | 目录 | SDK 入口和对外暴露的类型定义，供 Agent SDK 集成方使用 | Ch4 查询引擎 |
| `entrypoints/mcp.ts` | ~200 行 | MCP 服务器模式入口，将 Claude Code 自身作为 MCP Server 暴露 | Ch15 MCP 协议 |
| `entrypoints/agentSdkTypes.ts` | ~200 行 | Agent SDK 的公共类型定义，包括 `SDKMessage`、`SDKStatus` 等外部投影类型 | Ch1 项目概览 |
| `setup.ts` | ~480 行 | 环境检测与初始设置，包括终端能力检测、默认配置写入 | Ch2 启动流程 |
| `bootstrap/state.ts` | ~1760 行 | 全局 bootstrap 状态管理，包含会话 ID 生成、全局计数器、成本追踪初始化 | Ch2 启动流程, Ch21 性能优化 |
| `migrations/` | 11 个文件 | 配置迁移脚本集合，处理模型重命名链（如 `sonnet45 -> sonnet46`）、设置格式升级等向后兼容逻辑 | Ch23 构建系统 |

## 2. 核心引擎

| 文件 | 大小估计 | 职责 | 相关章节 |
|------|----------|------|----------|
| `QueryEngine.ts` | ~1300 行 | 查询引擎类，一个对话对应一个实例，封装 `submitMessage` 入口、消息流管理、上下文压缩调度和 Agent SDK 适配 | Ch4 查询引擎 |
| `query.ts` | ~1730 行 | 查询循环核心状态机（`queryLoop`），驱动 API 请求 -> 流式响应 -> 工具执行 -> 终止判断的迭代过程 | Ch4 查询引擎 |
| `query/tokenBudget.ts` | ~90 行 | Token 预算追踪器（`BudgetTracker`），监控输入/输出 token 用量并判断是否触发压缩 | Ch4 查询引擎 |
| `query/stopHooks.ts` | ~50 行 | Turn 终止逻辑，判断当前轮次是否应该结束（`Terminal`）还是继续（`Continue`） | Ch4 查询引擎 |
| `query/deps.ts` | ~50 行 | 查询依赖注入接口定义 | Ch4 查询引擎 |
| `query/config.ts` | ~50 行 | 查询循环的配置参数定义 | Ch4 查询引擎 |
| `utils/messages.ts` | ~5500 行 | 消息核心工具库：`createUserMessage` 等工厂函数、`normalizeMessagesForAPI` 多阶段转换、消息合并与过滤逻辑 | Ch5 消息系统 |
| `cost-tracker.ts` | ~320 行 | API 调用成本追踪，提供 `getModelUsage`、`getTotalAPIDuration`、`getTotalCost` 等聚合函数 | Ch4 查询引擎 |
| `services/api/claude.ts` | ~3400 行 | Anthropic API 客户端核心，封装流式请求、重试逻辑、用量累计和错误处理 | Ch4 查询引擎 |
| `services/api/errors.ts` | ~200 行 | API 错误分类与处理，区分可重试和不可重试错误，处理 prompt 过长等特殊情况 | Ch4 查询引擎 |
| `services/api/withRetry.ts` | ~200 行 | 通用重试机制，支持指数退避和 fallback 触发 | Ch4 查询引擎 |
| `utils/conversationRecovery.ts` | ~300 行 | 会话恢复逻辑，支持 `--resume` 从中断处恢复对话 | Ch18 对话管理 |

## 3. 工具系统

| 文件 | 大小估计 | 职责 | 相关章节 |
|------|----------|------|----------|
| `Tool.ts` | ~790 行 | Tool 接口定义（30+ 方法）、`ToolUseContext` 类型、`buildTool` 工厂函数、`TOOL_DEFAULTS` 默认值 | Ch7 工具架构 |
| `tools.ts` | ~390 行 | 工具注册表，`getAllBaseTools` 收集所有内置工具、条件加载 ant-only 工具和 feature-gated 工具 | Ch7 工具架构 |
| `tools/BashTool/` | 18 个文件 | Bash 工具完整实现：命令执行（`BashTool.tsx`，~1140 行）、安全分类（`bashSecurity.ts`）、权限检查（`bashPermissions.ts`）、路径验证、sed 验证、只读模式强制、破坏性命令警告等 | Ch8 内置工具, Ch14 Bash 安全 |
| `tools/FileReadTool/` | ~1180 行 | 文件读取工具，支持文本文件、图片、PDF、Jupyter Notebook 等多种格式 | Ch8 内置工具 |
| `tools/FileEditTool/` | ~630 行 | 文件编辑工具，基于唯一性字符串匹配的精确替换机制，支持并发编辑检测 | Ch8 内置工具 |
| `tools/FileWriteTool/` | ~500 行 | 文件写入工具，整文件覆盖写入 | Ch8 内置工具 |
| `tools/GlobTool/` | ~400 行 | 文件名模式搜索工具，底层集成 Ripgrep | Ch8 内置工具 |
| `tools/GrepTool/` | ~580 行 | 文件内容搜索工具，底层集成 Ripgrep，支持正则、上下文行、多行匹配 | Ch8 内置工具 |
| `tools/WebFetchTool/` | ~320 行 | URL 内容抓取工具，HTML 转 Markdown 处理 | Ch8 内置工具 |
| `tools/WebSearchTool/` | ~440 行 | 网络搜索工具 | Ch8 内置工具 |
| `tools/NotebookEditTool/` | ~300 行 | Jupyter Notebook 单元格编辑工具 | Ch8 内置工具 |
| `tools/ToolSearchTool/` | ~470 行 | 延迟工具加载的核心，按需搜索和加载工具 schema 以减少初始 prompt 大小 | Ch7 工具架构 |
| `tools/MCPTool/` | ~80 行 | MCP 工具代理，将 MCP Server 暴露的工具包装为本地 Tool 接口 | Ch15 MCP 协议 |
| `tools/AskUserQuestionTool/` | ~200 行 | 交互式用户提问工具，允许 Claude 主动向用户征求输入 | Ch8 内置工具 |
| `tools/TaskCreateTool/` | ~300 行 | 后台任务创建工具 | Ch8 内置工具 |
| `tools/REPLTool/` | ~500 行 | 交互式代码执行工具（ant-only），支持 JavaScript/Python 等语言的 REPL | Ch8 内置工具 |
| `services/tools/StreamingToolExecutor.ts` | ~530 行 | 流式并发调度器，管理工具的四态生命周期（queued -> executing -> completed -> yielded） | Ch9 工具执行 |
| `services/tools/toolExecution.ts` | ~1750 行 | 工具执行管线核心，`runToolUse` 入口、schema 验证、结果处理、`buildSchemaNotSentHint` 延迟加载提示 | Ch9 工具执行 |
| `services/tools/toolHooks.ts` | ~650 行 | Pre/Post 工具钩子执行引擎，处理 `PreToolUse` 和 `PostToolUse` 事件的钩子注册与调度 | Ch9 工具执行 |
| `services/tools/toolOrchestration.ts` | ~190 行 | 工具编排层，协调多工具并发执行和结果聚合 | Ch9 工具执行 |
| `tools/shared/spawnMultiAgent.ts` | ~1090 行 | 多 Agent 并行派生的共享实现，被 AgentTool 和 TaskTool 复用 | Ch11 子智能体 |

## 4. Agent 系统

| 文件 | 大小估计 | 职责 | 相关章节 |
|------|----------|------|----------|
| `tools/AgentTool/AgentTool.tsx` | ~1400 行 | Agent 工具主入口，处理 Agent 定义解析、工具过滤、消息构建和 UI 渲染 | Ch10 Agent 模型 |
| `tools/AgentTool/loadAgentsDir.ts` | ~760 行 | Agent 定义加载器，从 `.claude/agents/` 目录解析 Markdown frontmatter 并转换为 `AgentDefinition` 类型 | Ch10 Agent 模型 |
| `tools/AgentTool/builtInAgents.ts` | ~200 行 | 内置 Agent 注册中心（`getBuiltInAgents`），汇总 Explore、Plan、Verification 等预定义 Agent | Ch10 Agent 模型 |
| `tools/AgentTool/built-in/` | 目录 | 内置 Agent 定义目录：`exploreAgent.ts`（只读探索）、`planAgent.ts`（规划）、`verificationAgent.ts`（对抗验证）、`generalPurposeAgent.ts`（通用）、`claudeCodeGuideAgent.ts`（动态指南） | Ch10 Agent 模型 |
| `tools/AgentTool/agentToolUtils.ts` | ~300 行 | Agent 工具辅助函数：`resolveAgentTools`（工具解析）、`filterToolsForAgent`（工具过滤） | Ch10 Agent 模型 |
| `tools/AgentTool/forkSubagent.ts` | ~210 行 | Fork 机制实现，`buildForkedMessages` 构建子 Agent 的初始消息，克隆父 Agent 上下文并共享 prompt cache | Ch11 子智能体 |
| `tools/AgentTool/runAgent.ts` | ~970 行 | Agent 运行时核心，`runAgent` 函数启动查询循环、`initializeAgentMcpServers` 初始化 Agent 专属的 MCP 连接 | Ch11 子智能体 |
| `tools/AgentTool/resumeAgent.ts` | ~270 行 | Agent 恢复机制，从 sidechain transcript 重建中断的 Agent 执行状态 | Ch11 子智能体 |
| `tools/AgentTool/agentMemory.ts` | ~200 行 | Agent 记忆系统，三级范围（session/project/global）的记忆读写 | Ch11 子智能体 |
| `tools/AgentTool/prompt.ts` | ~300 行 | Agent 系统提示词构建，根据 Agent 类型和配置动态组装 system prompt | Ch10 Agent 模型 |
| `coordinator/coordinatorMode.ts` | ~370 行 | 协调者模式实现，支持一个主 Agent 分配任务给多个子 Agent 并行执行 | Ch11 子智能体 |
| `tools/SkillTool/SkillTool.ts` | ~1110 行 | Skill 执行引擎，`executeForkedSkill` 将 Skill 定义转化为 Agent 调用 | Ch12 技能系统 |
| `skills/bundledSkills.ts` | ~220 行 | 内置 Skill 注册表，列举所有随 Claude Code 分发的预置技能 | Ch12 技能系统 |
| `skills/loadSkillsDir.ts` | ~1090 行 | 文件系统 Skill 发现器，扫描 `.claude/skills/` 目录并解析 Markdown frontmatter 定义 | Ch12 技能系统 |
| `skills/mcpSkillBuilders.ts` | ~200 行 | 将 MCP 提供的 prompt template 转换为 Skill 定义的适配层 | Ch12 技能系统 |

## 5. 权限与安全

| 文件 | 大小估计 | 职责 | 相关章节 |
|------|----------|------|----------|
| `types/permissions.ts` | ~440 行 | 权限类型定义核心：`PermissionMode`（多种模式枚举）、`PermissionRule`、`PermissionResult` 等基础类型 | Ch13 权限模型 |
| `utils/permissions/permissions.ts` | ~500 行 | 权限检查入口：`hasPermissionsToUseTool`、权限规则匹配引擎 | Ch13 权限模型 |
| `utils/permissions/PermissionMode.ts` | ~200 行 | 权限模式配置（每种模式的符号、颜色、行为定义） | Ch13 权限模型 |
| `utils/permissions/PermissionResult.ts` | ~100 行 | 权限结果类型（allow/deny/ask）的构造和判断辅助函数 | Ch13 权限模型 |
| `utils/permissions/permissionSetup.ts` | ~1530 行 | 权限系统初始化，配置各工具的默认权限规则和 bypass 模式设置 | Ch13 权限模型 |
| `utils/permissions/permissionsLoader.ts` | ~300 行 | 从 settings.json 加载和解析用户自定义权限规则 | Ch13 权限模型 |
| `utils/permissions/permissionRuleParser.ts` | ~200 行 | 权限规则的 glob/正则匹配解析器 | Ch13 权限模型 |
| `utils/permissions/bashClassifier.ts` | ~500 行 | Bash 命令自动分类器，判断命令是读取、修改还是危险操作 | Ch14 Bash 安全 |
| `utils/permissions/yoloClassifier.ts` | ~400 行 | Auto 模式（"YOLO"模式）自动审批分类器，判断哪些操作可以自动批准 | Ch13 权限模型 |
| `utils/permissions/denialTracking.ts` | ~50 行 | 拒绝计数器，追踪连续拒绝次数并触发升级机制 | Ch13 权限模型 |
| `utils/permissions/dangerousPatterns.ts` | ~300 行 | 危险命令模式库，定义需要特别警告的 shell 命令模式 | Ch14 Bash 安全 |
| `tools/BashTool/bashSecurity.ts` | ~500 行 | Bash 命令安全深度分析引擎 | Ch14 Bash 安全 |
| `tools/BashTool/readOnlyValidation.ts` | ~400 行 | 只读模式强制执行器，在 Plan 模式下阻止所有写入操作 | Ch14 Bash 安全 |
| `tools/BashTool/sedValidation.ts` | ~300 行 | sed 命令专项安全验证器 | Ch14 Bash 安全 |
| `tools/BashTool/pathValidation.ts` | ~300 行 | 路径边界校验器，确保命令不超出允许的目录范围 | Ch14 Bash 安全 |
| `hooks/useCanUseTool.tsx` | ~200 行 | 权限检查 React hook，`CanUseToolFn` 的实际实现，串联所有权限检查逻辑 | Ch13 权限模型 |

## 6. MCP 协议

| 文件 | 大小估计 | 职责 | 相关章节 |
|------|----------|------|----------|
| `services/mcp/client.ts` | ~3350 行 | MCP 客户端核心实现，连接管理、工具发现、资源读取、prompt template 获取、采样请求处理 | Ch15 MCP 协议 |
| `services/mcp/config.ts` | ~500 行 | MCP 配置管理，多源合并（全局配置、项目配置、settings.json），支持环境变量展开 | Ch15 MCP 协议 |
| `services/mcp/types.ts` | ~300 行 | MCP 类型定义：`MCPServerConnection`（连接对象）、`ServerResource`（资源）、`MCPToolConfig`（工具配置） | Ch15 MCP 协议 |
| `services/mcp/auth.ts` | ~2470 行 | MCP OAuth 认证核心，`ClaudeAuthProvider` 实现完整的 OAuth 2.0 + PKCE 授权码流程 | Ch16 MCP 认证 |
| `services/mcp/xaa.ts` | ~510 行 | XAA 跨账户访问实现，基于 RFC 8693 Token Exchange + RFC 7523 JWT Bearer 的企业级认证 | Ch16 MCP 认证 |
| `services/mcp/xaaIdpLogin.ts` | ~200 行 | XAA 身份提供商（IdP）登录集成 | Ch16 MCP 认证 |
| `services/mcp/elicitationHandler.ts` | ~310 行 | MCP Elicitation 处理器，处理 Server 向 Client 主动请求额外输入信息的交互流程 | Ch15 MCP 协议 |
| `services/mcp/channelPermissions.ts` | ~200 行 | MCP 通道权限控制，管理不同 MCP Server 的信任级别和工具调用权限 | Ch16 MCP 认证 |
| `services/mcp/normalization.ts` | ~150 行 | MCP 工具名称标准化，处理命名冲突和工具名映射 | Ch15 MCP 协议 |
| `services/mcp/InProcessTransport.ts` | ~100 行 | 进程内 MCP 传输实现，用于将内置功能包装为 MCP Server 接口 | Ch15 MCP 协议 |
| `services/mcp/SdkControlTransport.ts` | ~100 行 | SDK 控制传输层，通过 Agent SDK 暴露的 MCP 消息通道 | Ch15 MCP 协议 |
| `services/mcp/MCPConnectionManager.tsx` | ~70 行 | MCP 连接生命周期管理的 React 组件包装 | Ch15 MCP 协议 |
| `services/mcp/useManageMCPConnections.ts` | ~300 行 | MCP 连接生命周期管理的 React hook，处理连接建立、重连和清理 | Ch15 MCP 协议 |

## 7. 状态管理

| 文件 | 大小估计 | 职责 | 相关章节 |
|------|----------|------|----------|
| `state/AppState.tsx` | ~200 行 | React Context Provider，通过 `AppStateProvider` 向组件树注入全局状态，集成 React Compiler | Ch17 状态管理 |
| `state/AppStateStore.ts` | ~570 行 | 状态存储定义核心，`AppState` 类型声明、`getDefaultAppState` 初始值工厂、`SpeculationState` 推测执行状态 | Ch17 状态管理 |
| `state/store.ts` | ~34 行 | Zustand-like 的 `createStore` 工厂函数，支持 `useSyncExternalStore` 订阅模式 | Ch17 状态管理 |
| `state/selectors.ts` | ~100 行 | 状态选择器函数，从 `AppState` 中高效提取派生数据 | Ch17 状态管理 |
| `state/onChangeAppState.ts` | ~100 行 | 状态变更监听器，处理状态变化时的副作用（如 UI 更新通知） | Ch17 状态管理 |
| `services/compact/compact.ts` | ~1710 行 | 会话压缩核心引擎，`buildPostCompactMessages` 构建压缩后的消息列表，支持多种压缩策略 | Ch18 对话管理 |
| `services/compact/autoCompact.ts` | ~350 行 | 自动压缩触发器，`calculateTokenWarningState` 判断 token 用量阈值并触发压缩 | Ch18 对话管理 |
| `services/compact/microCompact.ts` | ~530 行 | 微压缩策略，使用快速模型对单条过长工具结果进行局部摘要 | Ch18 对话管理 |
| `services/compact/sessionMemoryCompact.ts` | ~300 行 | 会话记忆压缩，从 Compaction 中提取跨会话有价值的关键信息 | Ch18 对话管理 |
| `services/compact/prompt.ts` | ~200 行 | Compaction 提示词模板，指导 Claude 如何生成对话摘要 | Ch18 对话管理 |
| `services/compact/grouping.ts` | ~200 行 | 消息分组逻辑，将相关消息组合为可压缩的单元 | Ch18 对话管理 |
| `utils/sessionStorage.ts` | ~500 行 | Transcript 录制器（`recordTranscript`），JSONL 格式增量写入会话消息到磁盘 | Ch5 消息系统, Ch18 对话管理 |
| `history.ts` | ~460 行 | 会话历史管理，列举、加载和搜索历史对话 | Ch18 对话管理 |
| `utils/fileStateCache.ts` | ~140 行 | 文件状态缓存，LRU 策略缓存文件内容，`cloneFileStateCache` 支持 Agent fork 时的缓存克隆 | Ch9 工具执行 |

## 8. UI 组件

| 文件 | 大小估计 | 职责 | 相关章节 |
|------|----------|------|----------|
| `components/App.tsx` | ~55 行 | 根应用组件，组装 Provider 树并渲染主界面 | Ch19 Ink/React |
| `components/Messages.tsx` | ~300 行 | 消息列表组件，渲染对话中的所有消息 | Ch20 REPL |
| `components/Message.tsx` | ~400 行 | 单条消息渲染组件，根据消息类型分发到对应的子组件 | Ch20 REPL |
| `components/MessageRow.tsx` | ~300 行 | 消息行布局组件，处理消息的缩进、图标和时间戳 | Ch20 REPL |
| `components/PromptInput/` | 目录 | 用户输入组件群，处理多行输入、自动补全、附件拖拽等交互 | Ch20 REPL |
| `components/messages/` | 目录 | 消息类型渲染组件群，为不同消息类型（工具结果、错误、Markdown 等）提供专门的渲染逻辑 | Ch20 REPL |
| `components/permissions/` | 目录 | 权限对话框组件群，渲染工具执行确认、权限模式选择等交互界面 | Ch13 权限模型, Ch20 REPL |
| `components/diff/` | 目录 | Diff 显示组件，文件编辑工具的结果可视化 | Ch20 REPL |
| `components/StructuredDiff.tsx` | ~300 行 | 结构化 Diff 渲染，语法高亮的行级差异展示 | Ch20 REPL |
| `components/Markdown.tsx` | ~200 行 | Markdown 渲染组件，将 Markdown 文本渲染为终端格式化输出 | Ch20 REPL |
| `components/StatusLine.tsx` | ~200 行 | 状态栏组件，显示当前模型、token 用量、权限模式等运行时信息 | Ch20 REPL |
| `components/mcp/` | 目录 | MCP 相关 UI 组件，包括 Server 审批对话框、连接状态显示等 | Ch15 MCP 协议 |
| `components/Settings/` | 目录 | 设置界面组件，交互式配置管理 | Ch20 REPL |
| `components/agents/` | 14 个文件 | Agent 管理界面：Agent 列表、编辑器、创建向导、工具/模型选择器等 | Ch10 Agent 模型 |
| `ink/` | 50+ 模块 | Ink 框架深度定制 fork：React 终端渲染器核心，包含 reconciler、renderer、DOM 抽象、焦点管理、搜索高亮、虚拟滚动等 | Ch19 Ink/React |
| `ink/ink.tsx` | ~1720 行 | Ink 框架主入口，React 组件到终端字符矩阵的渲染管线 | Ch19 Ink/React |
| `ink/reconciler.ts` | ~510 行 | 终端专用 React 协调器（reconciler），处理虚拟 DOM 差异比较 | Ch19 Ink/React |
| `ink/renderer.ts` | ~180 行 | 终端渲染器，将协调器输出的变更应用到终端屏幕 | Ch19 Ink/React |
| `ink/dom.ts` | ~300 行 | 终端 DOM 抽象层，模拟浏览器 DOM 接口供 React 使用 | Ch19 Ink/React |
| `ink/focus.ts` | ~200 行 | 终端焦点管理系统 | Ch19 Ink/React |
| `ink/output.ts` | ~200 行 | 终端输出缓冲和优化 | Ch19 Ink/React |
| `native-ts/` | 目录 | 原生 TypeScript 模块，包含 Yoga WASM 布局引擎绑定 | Ch19 Ink/React |
| `hooks/useGlobalKeybindings.tsx` | ~300 行 | 全局快捷键绑定 hook，处理 Ctrl+C、Ctrl+D、搜索等系统级按键 | Ch20 REPL |
| `keybindings/` | 14 个文件 | 快捷键系统：schema 定义、用户自定义绑定加载、冲突检测、chord 组合键支持 | Ch20 REPL |

## 9. 工程基础设施

| 文件 | 大小估计 | 职责 | 相关章节 |
|------|----------|------|----------|
| `utils/config.ts` | ~1820 行 | 全局配置管理核心，`getGlobalConfig` 入口、配置文件读写、多层配置合并（全局/项目/环境） | Ch23 构建系统 |
| `utils/claudemd.ts` | ~1480 行 | CLAUDE.md 文件加载与解析，支持层级式加载（全局 -> 项目 -> 子目录）、外部 include、安全检查 | Ch2 启动流程 |
| `services/analytics/growthbook.ts` | ~1160 行 | GrowthBook 特性开关集成，远程配置拉取、实验分组、事件追踪 | Ch2 启动流程 |
| `services/analytics/` | 目录 | 遥测分析服务集合，事件日志、使用统计、实验数据上报 | Ch23 构建系统 |
| `utils/lazySchema.ts` | ~8 行 | Zod schema 延迟构造包装器，一行代码打破模块循环依赖 | Ch3 类型系统 |
| `schemas/hooks.ts` | ~200 行 | Hook 配置的 Zod 验证 schema，定义 settings.json 中 hooks 字段的合法结构 | Ch9 工具执行 |
| `utils/hooks/` | 17 个文件 | 异步 Hook 注册与执行基础设施：`AsyncHookRegistry`（注册中心）、`hookHelpers`（辅助函数）、`hooksConfigManager`（配置管理）、各类 Hook 执行器 | Ch9 工具执行 |
| `utils/hooks/hookHelpers.ts` | ~300 行 | Hook 执行辅助函数，处理 Hook 脚本的调用、超时和错误处理 | Ch9 工具执行 |
| `services/lsp/` | 7 个文件 | LSP（Language Server Protocol）集成：`LSPClient`（客户端）、`LSPServerManager`（服务器管理）、`LSPDiagnosticRegistry`（诊断注册） | Ch8 内置工具 |
| `services/oauth/` | 5 个文件 | OAuth 2.0 认证流程实现：`auth-code-listener`（授权码监听）、`crypto`（PKCE 计算）、`getOauthProfile`（用户信息获取） | Ch16 MCP 认证 |
| `services/plugins/` | 3 个文件 | 插件系统：`PluginInstallationManager`（安装管理）、`pluginOperations`（操作接口）、`pluginCliCommands`（CLI 命令） | Ch12 技能系统 |
| `plugins/builtinPlugins.ts` | ~100 行 | 内置插件注册表 | Ch12 技能系统 |
| `types/ids.ts` | ~44 行 | 品牌类型 ID 定义，`SessionId`、`AgentId` 等强类型标识符 | Ch3 类型系统 |
| `types/permissions.ts` | ~440 行 | 权限相关类型的集中定义，`AdditionalWorkingDirectory`、`PermissionMode` 枚举等 | Ch13 权限模型 |
| `types/hooks.ts` | ~100 行 | Hook 事件类型定义 | Ch9 工具执行 |
| `utils/envUtils.ts` | ~100 行 | 环境变量工具函数，`isBareMode`、`isEnvTruthy` 等判断辅助 | Ch2 启动流程 |
| `utils/cwd.ts` | ~100 行 | 工作目录管理，`getCwd` 获取当前工作目录 | Ch2 启动流程 |
| `utils/abortController.ts` | ~50 行 | 增强版 AbortController 封装，支持超时和级联取消 | Ch4 查询引擎 |
| `utils/systemPrompt.ts` | ~120 行 | 系统提示词构建辅助函数，`asSystemPrompt` 类型标记 | Ch4 查询引擎 |
| `commands.ts` | ~750 行 | 斜杠命令注册中心，定义 `/help`、`/clear`、`/model` 等内置命令 | Ch20 REPL |
| `bridge/` | 15 个文件 | IDE 桥接通信层：`bridgeApi`（HTTP API）、`replBridgeTransport`（传输层）、`sessionRunner`（远程会话运行）、`bridgePermissionCallbacks`（权限回调） | Ch20 REPL |
| `voice/` | 目录 | 语音交互模块（ant-only），语音输入转文字和语音输出 | Ch20 REPL |
| `vim/` | 5 个文件 | Vim 模式支持：`motions`（光标移动）、`operators`（操作符）、`textObjects`（文本对象）、`transitions`（模式转换） | Ch20 REPL |
| `context/` | 9 个文件 | React Context 定义：`mailbox`（消息邮箱）、`notifications`（通知）、`modalContext`（模态框）、`voice`（语音）等全局上下文 | Ch17 状态管理 |

---

> **提示**：源码文件路径和行数可能随版本更新而变化。本索引基于 Claude Code 的当前源码编写，大小估计以源码行数计。实际打包产物的体积会因 DCE 和 minification 而显著缩小。
