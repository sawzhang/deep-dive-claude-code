# 深入理解 Claude Code 源码

> 系统剖析 Anthropic Claude Code CLI 的架构设计、工程实践与编程哲学

本书参考《Elasticsearch 源码解析与优化实战》《深入理解 Linux 内核》《C++ 编程思想》等经典技术书籍的架构风格，从源码层面系统剖析 Claude Code 的设计思想与工程实践。

---

## 这本书讲什么

Claude Code 是 Anthropic 推出的命令行 AI 编程助手，也是目前业界最复杂的终端 AI Agent 实现之一。本书覆盖其**全部核心子系统**：

- **查询引擎** —— 一次对话如何在 QueryEngine 状态机中流转
- **工具系统** —— 40+ 工具的注册、权限检查、并发执行
- **Agent 系统** —— Fork/Resume 编排、Skill 发现与执行
- **权限模型** —— 六层安全模式、Bash 命令语义分析
- **MCP 协议** —— 七种传输层、OAuth/XAA 认证体系
- **状态管理** —— 34 行 Store 如何撑起 450 行 AppState
- **性能优化** —— 并行预取、三层 Memoization、编译时 DCE

## 数据一览

| 指标 | 数值 |
|------|------|
| 章节 | 25 章 + 2 附录 |
| 总行数 | 14,500+ 行 |
| Mermaid 图表 | 101 个 |
| TypeScript 代码块 | 467 个 |
| 术语表 | 55 个条目 |
| 源码索引 | 90+ 关键文件 |

## 如何阅读

**推荐路线**：按顺序阅读 Part 1-2 建立全局认知，然后根据兴趣跳转到具体部分。

**快速入门**：如果时间有限，优先阅读以下章节：
- [第 1 章：全景概览](part1-foundation/ch01-overview.md) —— 建立整体认知
- [第 7 章：工具架构](part3-tool-system/ch07-tool-architecture.md) —— 理解核心接口
- [第 10 章：Agent 模型](part4-agent/ch10-agent-model.md) —— 理解 Agent 系统
- [第 25 章：工程哲学](part10-philosophy/ch25-philosophy.md) —— 提炼设计思想

## 源码版本

本书基于 Claude Code **v2.1.x** 版本的源码分析。源码文件路径可能随版本更新而变化，请参考[附录 B：源码导航](appendix/appendix-b-source-map.md)定位关键文件。
