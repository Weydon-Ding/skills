# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 仓库定位

这是我的个人 Claude Code skills 仓库，用于存放和维护日常使用的 skills。这里不是应用项目，也没有固定的构建、测试或发布流程。

## 维护原则

- 新增或修改 skill 前，先阅读对应目录下的 `SKILL.md`。
- 每个 skill 以独立目录组织，核心入口是 `SKILL.md`。
- `SKILL.md` 必须保留 YAML frontmatter，至少包含 `name` 和 `description`。
- 修改 skill 时优先保持简单、清晰、可日常使用，不要为了“像项目”而增加复杂结构。
- 不要擅自新增 `package.json`、测试框架、构建流程、格式化器或 CI，除非用户明确要求。

## Mermaid skill

- 修改 Mermaid 示例、规则或图表语法时，参考 `mermaid/reference.md`。
- 涉及 Mermaid 图表时，用 `mermaid/scripts/validate_mermaid.ps1` 或 `mermaid/scripts/validate_mermaid.sh` 验证。
