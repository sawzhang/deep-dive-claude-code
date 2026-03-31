# 深入理解 Claude Code 源码

[![GitHub stars](https://img.shields.io/github/stars/sawzhang/deep-dive-claude-code?style=social)](https://github.com/sawzhang/deep-dive-claude-code)
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

> 系统剖析 Anthropic Claude Code CLI 的架构设计、工程实践与编程哲学

**[在线阅读 Read Online](https://sawzhang.github.io/deep-dive-claude-code/)**

---

## 这本书讲什么

Claude Code 是 Anthropic 推出的命令行 AI 编程助手，也是目前业界最复杂的终端 AI Agent 实现之一。本书从源码层面，参考《Elasticsearch 源码解析与优化实战》《深入理解 Linux 内核》《C++ 编程思想》等经典技术书籍的架构风格，系统剖析 Claude Code 的设计思想与工程实践。

**核心特色**：
- 所有分析基于**真实源码引用**，非泛泛而谈
- **101 个 Mermaid 图表**（架构图、时序图、状态机、流程图）
- **467 个 TypeScript 代码块**，带语法高亮和注释
- 深入到**设计决策和工程权衡**，不止于 API 描述

## 目录概览

| 部分 | 章节 | 主题 |
|------|------|------|
| **一、基础架构** | Ch1-3 | 全景概览、启动流程、类型系统 |
| **二、核心引擎** | Ch4-6 | 查询引擎、消息系统、流式处理 |
| **三、工具系统** | Ch7-9 | Tool 接口、内置工具、并发执行管线 |
| **四、Agent 系统** | Ch10-12 | Agent 模型、Fork/Resume 编排、Skill |
| **五、权限与安全** | Ch13-14 | 六层权限模式、Bash 安全分析 |
| **六、MCP 协议** | Ch15-16 | 七种传输层、OAuth/XAA 认证 |
| **七、状态管理** | Ch17-18 | React Store、会话压缩与恢复 |
| **八、终端 UI** | Ch19-20 | React+Ink、REPL 实现 |
| **九、工程实践** | Ch21-23 | 性能优化、测试策略、构建系统 |
| **十、编程思想** | Ch24-25 | 设计模式、工程哲学 |
| **附录** | A-B | 术语表(55 条)、源码导航(90+ 文件) |

## 数据一览

```
25 章 + 2 附录 | 14,500+ 行 | ~12 万字
101 个 Mermaid 图表 | 467 个代码块 | 55 个术语定义
```

## 适合谁读

- 想了解 **AI Agent 系统工程实践**的开发者
- 正在使用 Claude Code 并想**深入理解其内部机制**的用户
- 对**大型 TypeScript 项目架构**感兴趣的工程师
- 研究 **MCP 协议**和 AI 工具集成的技术人员

## 本地构建

```bash
# 安装 mdBook
brew install mdbook

# 构建
mdbook build

# 本地预览
mdbook serve --open
```

## 技术栈

本书分析的 Claude Code 技术栈：

- **运行时**: Bun (TypeScript)
- **UI 框架**: React + Ink (终端渲染)
- **状态管理**: Zustand-like Store
- **类型验证**: Zod Schema
- **协议**: MCP (Model Context Protocol)
- **构建**: Bun Bundle + Feature Flags (编译时 DCE)

## 贡献

欢迎通过 [Issue](https://github.com/sawzhang/deep-dive-claude-code/issues) 报告勘误或提出建议，也欢迎通过 [Pull Request](https://github.com/sawzhang/deep-dive-claude-code/pulls) 贡献内容改进。

## License

本书采用 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) 协议。
