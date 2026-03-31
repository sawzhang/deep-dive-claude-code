# 附录 A：术语表

本术语表收录了《深入理解 Claude Code 源码》中出现的关键技术术语，按英文字母顺序排列。每个术语包含英文名、中文译名、一句话定义，以及在本书中首次出现的章节。

---

## A

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **AbortController** | 中止控制器 | Web API 标准的信号控制器，Claude Code 用于取消正在进行的 API 请求和工具执行，通过 `createAbortController` 封装支持用户中断和超时传播 | Ch4 查询引擎 |
| **Agent** | 智能体 | Claude Code 中可自主执行任务的子系统，通过 Markdown frontmatter 定义，拥有独立的工具集、模型选择和权限模式，经 `AgentTool` 派生并运行 | Ch10 Agent 模型 |
| **AgentDefinition** | Agent 定义 | 描述一个 Agent 的联合类型，分为 `BuiltInAgentDefinition`、`CustomAgentDefinition`、`PluginAgentDefinition` 三种形态，由 `loadAgentsDir.ts` 从 `.claude/agents/` 目录解析 | Ch10 Agent 模型 |
| **AppState** | 应用状态 | 全局状态树对象，包含对话消息列表（`messages`）、权限上下文、设置、工具执行状态等所有运行时数据，通过 Zustand-like Store 管理 | Ch17 状态管理 |
| **AssistantMessage** | 助手消息 | `Message` 联合类型的一个分支，表示 Claude 模型的回复内容，可包含文本块、思考过程（thinking）和工具调用块（`tool_use`） | Ch5 消息系统 |
| **AsyncGenerator** | 异步生成器 | TypeScript 的 `async function*` 语法，Claude Code 全栈使用的流式处理范式，支持背压控制、取消传播和 `yield*` 组合 | Ch6 流式处理 |
| **AttributionState** | 归因状态 | 记录文件修改归属信息的状态对象，由 `commitAttribution.ts` 管理，用于追踪哪些文件变更是 Claude 做出的 | Ch17 状态管理 |
| **AutoCompact** | 自动压缩 | 监控 token 用量并在接近上限时自动触发 Compaction 的机制，由 `autoCompact.ts` 实现阈值判断（`calculateTokenWarningState`）和触发逻辑 | Ch18 对话管理 |

## B

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **BashTool** | Bash 工具 | 最复杂的内置工具（18 个源文件），赋予 AI 执行 shell 命令的能力，配备命令安全分类、路径验证、只读模式强制和破坏性操作检测等多层安全机制 | Ch8 内置工具 |
| **Branded Type** | 品牌类型 | TypeScript 中通过交叉类型 `string & { __brand: 'X' }` 创建的名义类型（如 `SessionId`、`AgentId`），在编译期防止不同 ID 类型的意外混用 | Ch3 类型系统 |
| **BridgeAPI** | 桥接 API | 连接 Claude Code CLI 与外部 IDE（VS Code 等）的通信层，通过 `bridge/` 目录下的模块实现 HTTP/WebSocket 双向消息传递 | Ch20 REPL |
| **buildTool** | 工具工厂 | `src/Tool.ts` 中的工厂函数，将 `ToolDef` 注入失败关闭的安全默认值（如 `isConcurrencySafe: false`）并补全为完整的 `Tool` 对象 | Ch7 工具架构 |
| **Bundle** | 打包产物 | 通过 Bun 打包器将 TypeScript 源码编译为单个可分发 JavaScript 文件的最终产物，包含 tree-shaking、DCE 和 `feature()` 宏展开等优化 | Ch23 构建系统 |

## C

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **CanUseToolFn** | 工具可用性判断函数 | 类型签名为 `(tool, input, toolUseContext, assistantMessage, toolUseID) => Promise<PermissionDecision>` 的回调，决定某个工具调用是否被允许 | Ch13 权限模型 |
| **CircularBuffer** | 循环缓冲区 | 固定容量的环形数据结构（`utils/CircularBuffer.ts`），写满后覆盖最早数据，用于日志记录和终端输出等需要限制内存用量的场景 | Ch21 性能优化 |
| **Claude Code** | Claude Code | Anthropic 官方推出的 CLI 编码助手，基于 Claude 模型构建，集成工具调用、Agent 系统、MCP 协议等能力的终端原生 AI 开发工具，约 49 万行 TypeScript 源码 | Ch1 项目概览 |
| **Compaction** | 上下文压缩 | 当对话 token 超过阈值时，自动裁剪历史消息并生成摘要以释放 token 空间的机制，包括 `compact`、`microCompact`、`snipCompaction` 等策略层级 | Ch18 对话管理 |
| **ContentBlockParam** | 内容块参数 | Anthropic SDK 中表示消息内容块的类型，包括 `text`、`tool_use`、`tool_result`、`image` 等变体，构成 API 请求/响应的基本内容单元 | Ch5 消息系统 |
| **Coordinator Mode** | 协调者模式 | 多 Agent 协作的运行模式，一个主 Agent 充当协调者分配任务给多个子 Agent 并行执行，由 `coordinator/coordinatorMode.ts` 实现 | Ch11 子智能体 |
| **CostTracker** | 成本追踪器 | 追踪 API 调用的 token 用量和费用的模块（`cost-tracker.ts`，约 320 行），提供 `getModelUsage`、`getTotalCost` 等聚合函数 | Ch4 查询引擎 |
| **createStore** | 创建存储 | Zustand-like 的响应式状态存储工厂函数（`state/store.ts`），支持 `useSyncExternalStore` 订阅和 `onChangeAppState` 回调 | Ch17 状态管理 |

## D

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **DCE (Dead Code Elimination)** | 死代码消除 | 构建时通过 `feature()` 宏和 `process.env` 条件判断，在 Bun 打包阶段移除不会执行到的代码分支，减小产物体积并隔离内部/外部功能 | Ch23 构建系统 |
| **DeepImmutable\<T\>** | 深度不可变 | 递归地将对象所有属性标记为 `readonly` 的工具类型，用于权限上下文等安全关键数据结构，防止意外修改 | Ch3 类型系统 |
| **DenialTracking** | 拒绝追踪 | 记录工具调用被用户拒绝次数的机制（`DenialTrackingState`），连续拒绝超过阈值时自动升级为人工确认，避免反复打扰 | Ch13 权限模型 |
| **Discriminated Union** | 可辨识联合 | TypeScript 中通过共享的字面量字段（如 `type: 'user' | 'assistant'`）区分联合类型各分支的设计模式，`Message` 类型体系的核心架构 | Ch3 类型系统 |

## E

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **Elicitation** | 信息征询 | MCP 协议中 Server 向 Client 主动请求额外输入信息的机制（如请求 OAuth 凭据或用户确认），由 `services/mcp/elicitationHandler.ts`（约 310 行）处理 | Ch15 MCP 协议 |
| **ExploreAgent** | 探索智能体 | 内置 Agent 之一，专用于代码库探索和信息收集的只读任务，使用低成本模型并跳过 CLAUDE.md 加载以最大化效率 | Ch10 Agent 模型 |

## F

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **Feature Flag** | 特性开关 | 通过 GrowthBook 远程配置或 `feature()` 编译时宏控制的功能开关，用于渐进式发布新功能、A/B 测试和内外部功能隔离 | Ch23 构建系统 |
| **feature()** | 特性宏 | `bun:bundle` 提供的编译时宏函数，返回布尔常量，在打包阶段决定条件分支的去留，实现零运行时开销的特性开关 | Ch2 启动流程 |
| **FileHistoryState** | 文件历史状态 | 记录工具执行过程中文件修改前后快照的状态对象（`utils/fileHistory.ts`），支持用户回滚（undo）单个文件或整轮变更 | Ch17 状态管理 |
| **FileStateCache** | 文件状态缓存 | LRU 缓存结构（`utils/fileStateCache.ts`），存储已读取文件的内容和元数据，避免同一轮工具执行中重复磁盘 I/O，通过 `cloneFileStateCache` 在 Agent fork 时克隆 | Ch9 工具执行 |
| **Fork (subagent)** | 派生（子智能体） | 从主 Agent 创建独立子 Agent 的操作（`forkSubagent.ts`，约 210 行），子 Agent 继承部分上下文但拥有独立消息历史和工具集，通过共享 prompt cache 前缀最大化缓存命中 | Ch11 子智能体 |

## G

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **Generator Pipeline** | 生成器管道 | `query()` -> `queryLoop()` -> tool execution 构成的三层 `AsyncGenerator` 嵌套管道，通过 `yield` 逐层冒泡进度事件，再由外层收集器聚合为最终结果 | Ch6 流式处理 |
| **GrowthBook** | GrowthBook | 开源的特性开关和 A/B 测试平台，Claude Code 通过 `services/analytics/growthbook.ts`（约 1150 行）集成，控制远程功能发布和实验分组 | Ch2 启动流程 |

## H

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **Harness Engineering** | 骨架工程 | 一种 AI 应用开发方法论，将应用分为确定性的"骨架"（Harness）和非确定性的"模型"（Model）两部分；骨架负责工具注册、权限、UI 等基础设施，模型负责推理和决策 | Ch1 项目概览 |
| **Hook System** | 钩子系统 | 允许用户在工具执行前后注入自定义脚本的扩展机制，通过 `settings.json` 配置 `hooks` 字段，支持 `PreToolUse`、`PostToolUse`、`Notification`、`Stop` 等事件类型 | Ch9 工具执行 |

## I

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **Ink** | Ink 框架 | 基于 React 的终端 UI 框架，Claude Code 使用其深度定制的内部 fork 版本（`src/ink/`，50+ 模块），支持 Flexbox 布局、焦点管理、搜索高亮和虚拟滚动 | Ch19 Ink/React |
| **InputSchema** | 输入模式 | 每个工具使用 Zod（v4）定义的参数验证 schema，在工具注册时声明，运行时自动验证 Claude 返回的 JSON 参数是否合法，同时驱动 TypeScript 类型推断 | Ch7 工具架构 |
| **isConcurrencySafe** | 并发安全 | Tool 接口的布尔方法，返回 `true` 时允许该工具与其他标记为并发安全的工具并行执行；默认为 `false`（失败关闭原则） | Ch7 工具架构 |

## J

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **JSON-RPC** | JSON 远程过程调用 | 基于 JSON 的轻量远程过程调用协议（2.0 规范），MCP 协议的底层传输格式，通过 `jsonrpc: "2.0"` 标记，支持请求/响应和单向通知两种消息模式 | Ch15 MCP 协议 |
| **JSX** | JSX | JavaScript XML 语法扩展，Claude Code 使用 JSX 编写终端 UI 组件（`.tsx` 文件），通过 Ink 框架将 React 组件树渲染到终端而非浏览器 DOM | Ch19 Ink/React |

## L

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **lazySchema** | 惰性模式 | 延迟构造 Zod schema 的包装器（`utils/lazySchema.ts`），用于打破模块加载时的循环依赖，避免启动时同步解析所有工具 schema | Ch7 工具架构 |
| **LRU Cache** | 最近最少使用缓存 | 一种缓存淘汰策略，当容量满时移除最久未被访问的条目；Claude Code 中用于 `FileStateCache`、MCP 连接缓存等多个场景 | Ch21 性能优化 |

## M

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **MCP (Model Context Protocol)** | 模型上下文协议 | Anthropic 提出的开放协议标准，定义 AI 应用（Client）与外部工具/数据源（Server）之间的标准化 JSON-RPC 通信接口，支持 stdio 和 SSE 两种传输方式 | Ch15 MCP 协议 |
| **MCPServerConnection** | MCP 服务器连接 | 表示一个已建立 MCP Server 连接的对象（定义于 `services/mcp/types.ts`），包含连接状态、可用工具列表、资源目录和提示模板等运行时信息 | Ch15 MCP 协议 |
| **Memoization** | 记忆化 | 缓存函数调用结果的优化技术，Claude Code 有三层体系：`memoize`（永久缓存）、`memoizeWithTTL`（定时过期）和 React Compiler 自动 memoization | Ch21 性能优化 |
| **Message (类型体系)** | 消息（类型体系） | 以 Discriminated Union 模式定义的消息类型族，包含 `UserMessage`、`AssistantMessage`、`SystemMessage`、`ProgressMessage`、`TombstoneMessage`、`AttachmentMessage` 等 7+ 种变体 | Ch5 消息系统 |
| **MicroCompact** | 微压缩 | Compaction 的最轻量级策略（`services/compact/microCompact.ts`，约 530 行），使用快速模型对单条过长工具结果进行局部摘要，不触碰整体对话结构 | Ch18 对话管理 |

## N

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **normalizeMessagesForAPI** | API 消息标准化 | 将内部 `Message[]` 转换为 Anthropic API 可接受的 user/assistant 交替格式的多阶段转换函数，处理消息合并、进度消息过滤、附件转换等，定义在 `utils/messages.ts`（约 5500 行） | Ch5 消息系统 |

## O

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **OAuth** | 开放授权 | 标准授权框架（2.0 + PKCE），Claude Code 通过 `services/oauth/` 实现完整的授权码流程，用于 claude.ai 登录认证和 MCP Server 授权 | Ch16 MCP 认证 |
| **omitClaudeMd** | 省略 CLAUDE.md | Agent 配置选项，指示在子 Agent 或 SDK 模式下跳过加载 `CLAUDE.md` 项目配置文件以节省 token；Explore Agent 利用此选项每周节省大量 token 消耗 | Ch10 Agent 模型 |

## P

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **PermissionMode** | 权限模式 | 控制工具执行审批策略的枚举，包含 `default`（逐一确认）、`auto`（自动批准安全操作）、`bypassPermissions`（跳过所有确认）、`plan`（只读规划）等多种模式 | Ch13 权限模型 |
| **PermissionResult** | 权限结果 | 工具权限检查的返回值类型（定义在 `utils/permissions/PermissionResult.ts`），行为分为 `allow`（允许）、`deny`（拒绝）、`ask`（需要用户确认）三种 | Ch13 权限模型 |
| **ProgressMessage** | 进度消息 | `Message` 类型的一个分支，表示工具执行过程中的实时进度更新，泛型参数 `<T>` 允许工具自定义进度数据结构，最终结果产出后被替换 | Ch6 流式处理 |
| **Prompt Cache** | 提示缓存 | Anthropic API 的缓存机制，对已发送的 system prompt 和历史消息前缀进行缓存，后续请求可复用已处理的 token；Fork Agent 通过 `model: 'inherit'` 最大化缓存命中率 | Ch11 子智能体 |

## Q

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **QueryEngine** | 查询引擎 | Claude Code 的核心引擎类（`QueryEngine.ts`，约 1300 行），一个对话对应一个实例，封装 `submitMessage` 入口、消息流管理和上下文压缩调度，SDK 和 REPL 共享同一抽象 | Ch4 查询引擎 |
| **queryLoop** | 查询循环 | `query.ts` 中实现的核心状态机（约 1700 行），每次迭代执行"发送 API 请求 -> 接收流式响应 -> 执行工具 -> 判断终止/继续"循环，直至任务完成 | Ch4 查询引擎 |

## R

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **React Compiler** | React 编译器 | Meta 开发的编译器插件，Claude Code 集成该编译器（可在 `AppState.tsx` 的 `_c()` 调用中观察到）自动为 React 组件添加 memoization，无需手动 `useMemo`/`useCallback` | Ch19 Ink/React |
| **Reconciler** | 协调器 | React 渲染管道中负责比较虚拟树差异并更新实际输出的模块，Claude Code 的 `ink/reconciler.ts`（约 510 行）为终端字符矩阵渲染定制了专用协调器 | Ch19 Ink/React |
| **REPL** | 交互式执行环境 | Read-Eval-Print Loop 的缩写，既指 Claude Code 的主交互界面（`screens/REPL.tsx`），也指通过 `REPLTool` 提供的交互式代码执行工具 | Ch20 REPL |
| **Resume (Agent)** | Agent 恢复 | 从持久化的会话 Transcript 中恢复 Agent 执行状态的机制，通过 `resumeAgent.ts`（约 265 行）实现 sidechain 重建，支持 `--resume` 断点续跑 | Ch11 子智能体 |

## S

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **SDKMessage** | SDK 消息 | 通过 Agent SDK 接口传递的消息类型（定义于 `entrypoints/agentSdkTypes.ts`），是内部 `Message` 类型的外部投影，适配 SDK 调用方的集成需求 | Ch1 项目概览 |
| **SessionMemory** | 会话记忆 | 跨会话持久化的关键信息摘要，Compaction 时自动由 `services/compact/sessionMemoryCompact.ts` 提取并存储，支持下次会话恢复上下文 | Ch18 对话管理 |
| **Skill** | 技能 | 由 Markdown frontmatter 定义触发条件、系统提示词和工具白名单的可复用能力模块，对应用户的 `/slash-command`，通过 `SkillTool` 注入会话，支持 bundled 内置和用户自定义两种来源 | Ch12 技能系统 |
| **SnipCompaction** | 片段压缩 | Compaction 策略之一，将过长的工具结果（如大文件内容）截断为摘要并标注被省略的行数，比完整 Compaction 更精细更轻量 | Ch18 对话管理 |
| **StreamingToolExecutor** | 流式工具执行器 | `services/tools/StreamingToolExecutor.ts`（约 530 行）中定义的并发调度引擎，管理工具的四态生命周期（queued -> executing -> completed -> yielded） | Ch9 工具执行 |
| **SystemMessage** | 系统消息 | `Message` 类型的一个分支，由系统自动生成的内部控制消息，包含 15+ 种子类型（`compact_boundary`、`local_command`、`api_error` 等），不直接暴露给用户 | Ch5 消息系统 |

## T

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **Tool** | 工具 | Claude Code 的核心接口（`Tool.ts`，约 790 行），定义了 30+ 方法覆盖输入验证、权限检查、执行函数、UI 渲染和并发控制的完整生命周期 | Ch7 工具架构 |
| **ToolDef** | 工具定义 | `Tool` 接口的部分实现类型，开发者只需定义关键方法（`inputSchema`、`call`、`userFacingName` 等），通过 `buildTool` 工厂函数补全默认值后成为完整 Tool | Ch7 工具架构 |
| **ToolResult** | 工具结果 | 工具执行完成后的返回值类型，包含 `data`（内容块数组）、`newMessages`（注入消息）和 `contextModifier`（上下文修改器）等字段 | Ch7 工具架构 |
| **ToolSearchTool** | 工具搜索工具 | 延迟加载机制的核心工具（`tools/ToolSearchTool/`，约 470 行），当可用工具过多时，Claude 先通过搜索发现相关工具再按需加载 schema，避免一次性注册所有工具占满 prompt | Ch7 工具架构 |
| **ToolUseContext** | 工具使用上下文 | 依赖注入的核心载体，传递给每个工具执行函数的大型结构体（40+ 字段），包含 `AppState`、`AbortController`、`FileStateCache`、配置、跟踪器等运行时信息 | Ch7 工具架构 |
| **TombstoneMessage** | 墓碑消息 | `Message` 类型的一个分支，标记已被 Compaction 移除的消息占位符，保留消息 ID 但清空内容，确保消息索引序列不断裂 | Ch18 对话管理 |
| **Transcript** | 对话记录 | 完整的会话消息历史，以 JSONL 格式通过 `utils/sessionStorage.ts` 持久化到磁盘（`~/.claude/sessions/`），支持增量录制和 `--resume` 恢复 | Ch5 消息系统 |

## U

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **UserMessage** | 用户消息 | `Message` 类型的一个分支，表示用户输入的消息，包含文本内容和可选附件（图片、文件等），是查询循环的触发点，由 `createUserMessage` 工厂函数构建 | Ch5 消息系统 |

## V

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **Verification Agent** | 验证智能体 | 内置 Agent 之一，专用于对抗性验证代码变更的正确性，红色标识表示审查角色，通过运行测试、lint 和自我反省确认修改符合预期 | Ch10 Agent 模型 |

## X

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **XAA (Cross-Account Access)** | 跨账户访问 | 企业级 MCP 认证扩展机制（`services/mcp/xaa.ts`，约 510 行），基于 RFC 8693 Token Exchange + RFC 7523 JWT Bearer 实现跨组织的 MCP Server 授权 | Ch16 MCP 认证 |

## Y

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **yield\*** | 委托生成 | JavaScript 生成器语法，将一个 Generator 的所有产出值委托给另一个 Generator，Claude Code 的 Generator Pipeline 中大量使用此语法链接子管道实现组合 | Ch6 流式处理 |
| **Yoga Layout** | Yoga 布局引擎 | Meta 开发的跨平台 Flexbox 布局引擎，Ink 框架底层通过 WASM 调用 Yoga 在终端中计算 UI 组件的尺寸和位置，支持 `flexDirection`、`padding`、`margin` 等属性 | Ch19 Ink/React |

## Z

| 术语 | 中文 | 定义 | 首见章节 |
|------|------|------|----------|
| **Zod Schema** | Zod 验证模式 | 使用 Zod 库（v4）定义的运行时类型验证模式，Claude Code 的所有工具输入参数均通过 Zod schema 声明，同时服务于参数验证、TypeScript 类型推断和 JSON Schema 生成供 API 使用 | Ch3 类型系统 |

---

> **注**：本术语表共收录 65 个术语。部分术语在多个章节中反复出现，"首见章节"仅标注其首次被系统性讨论的位置。
