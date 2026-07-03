# skills

<div align="center"><img alt="Tests" src="https://img.shields.io/badge/tests-not_applicable-lightgrey"><img alt="License" src="https://img.shields.io/badge/license-MIT-green"><img alt="Version" src="https://img.shields.io/badge/version-personal_repo-blue"><img alt="Language" src="https://img.shields.io/badge/language-Markdown%20%7C%20PowerShell%20%7C%20Bash-blueviolet"></div>

个人日常维护的 Claude Code skills 仓库，用于沉淀、管理和复用常用工作流。

## 目录

- [概览](#概览)
- [适用场景](#适用场景)
- [接入方式](#接入方式)
- [使用方式](#使用方式)
- [Skills 参考](#skills-参考)
- [目录结构](#目录结构)
- [维护约定](#维护约定)
- [路线图](#路线图)
- [贡献](#贡献)
- [许可证](#许可证)

## 概览

这个仓库用于存放个人 Claude Code skills。每个 skill 都是一个独立目录，通过 `SKILL.md` 描述触发场景、执行规则和输出约定，方便在 Claude Code 中按需调用。

> [!NOTE]
> 这里不是应用项目，也没有固定的构建、测试、lint 或发布流程。仓库内容主要是 Markdown 指令、参考资料和少量辅助脚本。

## 适用场景

- 集中管理个人常用 Claude Code skills。
- 通过 `cc-switch` 指定仓库链接，让它自动解析可用 skill。
- 为新增或修改 skill 保留清晰的目录结构和维护约定。
- 在需要时复用辅助资料，例如 Mermaid 语法参考和验证脚本。

## 接入方式

本仓库没有项目级包管理配置，不需要运行 `npm install`、`pip install` 或类似安装命令。

推荐使用方式是通过 `cc-switch` 管理：

1. 在 `cc-switch` 中指定本仓库链接。
2. 由 `cc-switch` 自动解析仓库中的 skill。
3. 在 Claude Code 中按需调用对应 skill。

> [!IMPORTANT]
> `cc-switch` 的具体命令参数取决于你的本地配置。README 只记录本仓库的接入思路，不编写未在仓库中验证过的命令。

<details>
<summary>手动维护时的参考流程</summary>

如果不通过 `cc-switch`，也可以按普通 skills 仓库方式维护：

```bash
git clone <THIS_REPOSITORY_URL>
```

然后根据你的 Claude Code skills 管理方式，将需要的 skill 目录接入到本地 skills 搜索路径。

</details>

## 使用方式

### 查看已有 skill

每个 skill 都位于独立目录中，核心入口是 `SKILL.md`：

```text
<skill-name>/
└── SKILL.md
```

### 新增 skill

新增 skill 时建议遵循以下步骤：

1. 新建独立目录，例如 `my-skill/`。
2. 在目录中创建 `SKILL.md`。
3. 在 `SKILL.md` 顶部保留 YAML frontmatter，至少包含 `name` 和 `description`。
4. 用简洁、可日常使用的方式描述触发场景、执行步骤和输出要求。
5. 更新根目录 `README.md` 中的 [Skills 参考](#skills-参考)。

```markdown
---
name: my-skill
description: Describe when this skill should be used.
---

# My Skill

## When to Use

...
```

### 修改 skill

修改现有 skill 前，先阅读对应目录下的 `SKILL.md`。如果涉及 Mermaid 示例、规则或图表语法，还应参考 `mermaid/reference.md`，并使用验证脚本检查图表。

## Skills 参考

| Skill | 位置 | 用途 |
|---|---|---|
| `writing-agents-md` | `writing-agents-md/SKILL.md` | 为目标代码仓库生成或更新高质量 `AGENTS.md`，通过项目分析、用户访谈、草稿校验和用户确认，沉淀 AI coding agent 的协作规则。 |
| `creating-knowledge-notes` | `creating-knowledge-notes/SKILL.md` | 将文章、社交媒体内容、转录稿、视频、音频或混合来源材料整理成规范中文 Markdown 知识笔记，适合个人知识库或 RAG 使用。 |
| `mermaid` | `mermaid/SKILL.md` | 创建、验证和排查 Mermaid.js 图表，支持流程图、时序图、类图、ER 图、甘特图、状态图等，并要求输出前验证语法。 |

### Mermaid 辅助脚本

| 脚本 | 平台 | 说明 |
|---|---|---|
| `mermaid/scripts/validate_mermaid.ps1` | Windows / PowerShell | 验证单个 Mermaid 图、`.mmd/.mermaid` 文件，或 Markdown 文件中的 Mermaid 代码块。 |
| `mermaid/scripts/validate_mermaid.sh` | Linux/macOS / Bash | 验证单个 Mermaid 图、`.mmd/.mermaid` 文件，或 Markdown 文件中的 Mermaid 代码块。 |

示例：

```powershell
@'
flowchart TD
    A[Start] --> B[End]
'@ | ./mermaid/scripts/validate_mermaid.ps1
```

```bash
./mermaid/scripts/validate_mermaid.sh diagram.mmd
```

## 目录结构

```text
skills/
├── CLAUDE.md
├── LICENSE
├── README.md
├── creating-knowledge-notes/
│   └── SKILL.md
├── writing-agents-md/
│   └── SKILL.md
└── mermaid/
    ├── SKILL.md
    ├── reference.md
    └── scripts/
        ├── README.md
        ├── validate_mermaid.ps1
        └── validate_mermaid.sh
```

## 维护约定

| 约定 | 说明 |
|---|---|
| 独立目录 | 每个 skill 使用独立目录组织。 |
| 固定入口 | 每个 skill 的核心入口是 `SKILL.md`。 |
| Frontmatter | `SKILL.md` 必须保留 YAML frontmatter，至少包含 `name` 和 `description`。 |
| 简单优先 | 修改 skill 时优先保持简单、清晰、可日常使用。 |
| 不增加项目化流程 | 不擅自新增 `package.json`、测试框架、构建流程、格式化器或 CI。 |
| Mermaid 变更需验证 | 修改 Mermaid 示例、规则或图表语法时，参考 `mermaid/reference.md` 并运行验证脚本。 |

## 路线图

- [x] 维护 `creating-knowledge-notes` skill。
- [x] 维护 `mermaid` skill。
- [x] 为 Mermaid 图表提供 PowerShell 和 Bash 验证脚本。
- [ ] 新增 skill 时同步更新 README 中的 skills 列表。
- [ ] 持续沉淀高频 Claude Code 工作流。

## 贡献

这是个人日常维护仓库，默认以自用为主。若后续需要与他人共享或协作，建议遵循以下原则：

1. 修改前先阅读目标 skill 的 `SKILL.md`。
2. 保持指令清晰、直接，避免为了“像项目”而增加复杂结构。
3. 涉及 Mermaid 图表时，使用 `mermaid/scripts/validate_mermaid.ps1` 或 `mermaid/scripts/validate_mermaid.sh` 验证。
4. 新增 skill 后同步更新 README 的 skills 列表。

## 许可证

MIT License。详见 [LICENSE](./LICENSE)。
