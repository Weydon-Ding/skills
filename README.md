# skills

个人日常维护的 Claude Code skills 仓库。

## 概览

这个仓库用于存放自定义 Claude Code skills。每个 skill 用来沉淀一个可复用的工作流、写作约定或验证流程，方便在 Claude Code 中按需调用。

## 可用 Skills

- `creating-knowledge-notes` — 将文章、社交媒体内容、转录稿、视频、音频或混合来源材料整理成规范的中文 Markdown 知识笔记。
- `mermaid` — 创建、验证和排查 Mermaid.js 图表，包含本地语法参考和验证脚本。

新增 skill 时，请同步更新这个列表，方便读者快速了解仓库内容。

## 目录结构

每个 skill 使用独立目录，并通过 `SKILL.md` 定义：

```text
<skill-name>/
└── SKILL.md
```

部分 skill 可能会在 `SKILL.md` 旁边放置参考资料、示例或辅助脚本。

## 说明

这个仓库没有项目级构建、测试、lint 或发布流程。Skills 主要是 Markdown 指令；只有在某个 skill 需要时，才会包含辅助脚本。

Mermaid skill 的验证脚本位于 `mermaid/scripts/`。这些脚本依赖 Node.js 和 `npx`，因为它们会通过 `npx` 运行 Mermaid CLI。

## 许可证

MIT
