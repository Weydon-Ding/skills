# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 仓库定位 / Project Overview

这是个人 Claude Code skills 仓库，用于存放和维护日常使用的 skills。这里不是应用项目，也没有固定的构建、测试、lint、format 或发布流程。

仓库内容主要是 Markdown 指令、参考资料，以及少量辅助脚本：

- `creating-knowledge-notes/`：知识笔记生成与整理 skill。
- `mermaid/`：Mermaid 图表创建、验证和排查 skill。
- `writing-agents-md/`：生成或更新 `AGENTS.md` 的 skill。

## Commands / Workflow

- 没有项目级 package manager 配置；不要运行或新增 `npm install`、`pip install` 等安装流程，除非用户明确要求。
- 没有固定 `develop`、`build`、`test`、`lint`、`format` 命令；不要编造不存在的命令。
- 推荐接入方式由用户本地的 `cc-switch` 或 Claude Code skills 配置决定；不要在文档中写入未验证的本地命令参数。

## 维护原则 / Skill Maintenance

- 新增或修改 skill 前，先阅读对应目录下的 `SKILL.md`。
- 每个 skill 以独立目录组织，核心入口是 `SKILL.md`。
- `SKILL.md` 必须保留 YAML frontmatter，至少包含 `name` 和 `description`。
- 修改 skill 时优先保持简单、清晰、可日常使用，不要为了“像项目”而增加复杂结构。
- 新增 skill 后，同步更新根目录 `README.md` 的 Skills 参考列表。
- 不要擅自新增 `package.json`、测试框架、构建流程、格式化器或 CI，除非用户明确要求。

## Mermaid skill

- 修改 Mermaid 示例、规则或图表语法时，先参考 `mermaid/reference.md`。
- 涉及 Mermaid 图表时，用 `mermaid/scripts/validate_mermaid.ps1` 或 `mermaid/scripts/validate_mermaid.sh` 验证。
- Mermaid 验证脚本依赖 Node.js 和 `npx`（用于 `@mermaid-js/mermaid-cli`）；如果环境缺失，应如实说明，而不是跳过验证后声称已通过。

## Safety and Tool-specific Notes

- 不要读取、记录或提交真实 secrets、tokens、credentials、certificates 或 private keys。
- 如果发现 `.env*`、`credentials.*`、`*.pem`、`*.key`、`*.token` 等敏感文件，只记录其存在和类别，不读取真实值。
- `.claude/` 下的配置或 skills 副本属于 Claude Code 工具专用内容；除非用户明确要求，不要擅自重写或删除。
- 删除、重命名 skill 目录，或改变仓库接入/加载方式前，先询问用户。
