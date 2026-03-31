# 深入理解 Claude Code 源码

> 系统剖析 Anthropic Claude Code CLI 的架构设计、工程实践与编程哲学

本书参考《Elasticsearch 源码解析与优化实战》《深入理解 Linux 内核》《C++ 编程思想》等经典技术书籍的架构风格，从源码层面系统剖析 Claude Code 的设计思想与工程实践。

## 目录结构

```
claude-code-book/
├── README.md                          # 本文件
├── SUMMARY.md                         # 全书目录
├── part1-foundation/                  # 第一部分：基础架构
│   ├── ch01-overview.md               # 第1章：全景概览
│   ├── ch02-bootstrap.md              # 第2章：启动流程
│   └── ch03-type-system.md            # 第3章：类型系统设计
├── part2-core-engine/                 # 第二部分：核心引擎
│   ├── ch04-query-engine.md           # 第4章：查询引擎
│   ├── ch05-message-system.md         # 第5章：消息系统
│   └── ch06-streaming.md             # 第6章：流式处理
├── part3-tool-system/                 # 第三部分：工具系统
│   ├── ch07-tool-architecture.md      # 第7章：工具架构
│   ├── ch08-builtin-tools.md          # 第8章：内置工具
│   └── ch09-tool-execution.md         # 第9章：工具执行管线
├── part4-agent/                       # 第四部分：Agent 系统
│   ├── ch10-agent-model.md            # 第10章：Agent 模型
│   ├── ch11-subagent.md               # 第11章：子Agent编排
│   └── ch12-skill-system.md           # 第12章：Skill 系统
├── part5-permission/                  # 第五部分：权限与安全
│   ├── ch13-permission-model.md       # 第13章：权限模型
│   └── ch14-bash-security.md          # 第14章：Bash 安全分析
├── part6-mcp/                         # 第六部分：MCP 协议
│   ├── ch15-mcp-protocol.md           # 第15章：MCP 协议实现
│   └── ch16-mcp-auth.md              # 第16章：MCP 认证体系
├── part7-state/                       # 第七部分：状态管理
│   ├── ch17-state-management.md       # 第17章：状态管理
│   └── ch18-conversation.md           # 第18章：会话管理与压缩
├── part8-ui/                          # 第八部分：终端 UI
│   ├── ch19-ink-react.md              # 第19章：React + Ink 终端 UI
│   └── ch20-repl.md                   # 第20章：REPL 实现
├── part9-engineering/                 # 第九部分：工程实践
│   ├── ch21-performance.md            # 第21章：性能优化
│   ├── ch22-testing.md                # 第22章：测试策略
│   └── ch23-build-system.md           # 第23章：构建系统
├── part10-philosophy/                 # 第十部分：编程思想
│   ├── ch24-design-patterns.md        # 第24章：设计模式提炼
│   └── ch25-philosophy.md             # 第25章：工程哲学
└── appendix/                          # 附录
    ├── appendix-a-glossary.md         # 附录A：术语表
    └── appendix-b-source-map.md       # 附录B：源码导航
```

## 技术栈

- **运行时**: Bun (TypeScript)
- **UI 框架**: React + Ink (终端渲染)
- **状态管理**: Zustand-like Store
- **类型系统**: Zod Schema
- **协议**: MCP (Model Context Protocol)
- **构建**: Bun Bundle + Feature Flags

## 作者

由 Claude Code Agent Team 协作撰写

## License

MIT
