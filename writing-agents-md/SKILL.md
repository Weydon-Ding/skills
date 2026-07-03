---
name: writing-agents-md
description: "Use when the user asks to generate, write, create, consolidate, or update AGENTS.md instructions for AI coding agents."
argument-hint: "[--lang zh|en|...] [--force] [project directory]"
level: 3
---

# AGENTS.md 生成 Skill

<Purpose>
为目标仓库生成或更新高质量的 `AGENTS.md`。本 skill 基于可验证的项目事实、已有 AI instruction 文件，以及一次只问一个问题的访谈，产出简洁、可执行、适合 AI coding agents 使用的项目规则。
</Purpose>

<Use_When>
- 用户要求生成、编写、创建、整合或更新 `AGENTS.md`。
- 用户希望将项目规则整理成面向 AI coding agents 的 `AGENTS.md`。
- 用户希望记录面向 AI coding agents 的项目规则。
- 用户希望把 `CLAUDE.md`、`GEMINI.md`、`.cursor/rules/`、`.cursorrules`、`.windsurfrules` 等工具专用规则整理为面向 `AGENTS.md` 的协作说明。
</Use_When>

<Do_Not_Use_When>
- 用户只想编辑现有 `AGENTS.md` 中某一句或某一小段。
- 用户只是询问 `AGENTS.md` 的含义。
- 用户明确要求一个简单模板，不需要项目分析。
- 用户明确说不要使用此 skill。
</Do_Not_Use_When>

<执行策略>
- 除非从 checkpoint 恢复，否则必须严格按 Phase 0 到 Phase 5 的顺序执行。
- 每个带 checkpoint 的阶段结束后，写入 `.agents-checkpoint-{N}.md`。
- 在用户批准草稿和写入策略之前，绝不写入或覆盖最终 `AGENTS.md`。
- 访谈问题一次只问一个；不要把多个访谈问题批量抛给用户。
- 代码事实优先于假设。若用户说法与项目文件冲突，先说明冲突，再询问最终规则应如何表述。
- 现有工具专用 instruction 文件默认只是信息来源。除非用户明确要求，不删除、不覆盖、不重写它们。
- 最终 `AGENTS.md` 应保持简洁：普通项目建议 60-120 行，复杂项目最多不超过 300 行。
- 不要把当前对话中的一次性任务要求写成长期项目规则。
</执行策略>

<Arguments>
- `--lang zh|en|...`：生成的 `AGENTS.md` 首选语言。若未提供，在访谈中询问；若用户无偏好，则根据当前对话和已有项目文档推断。
- `--force`：可跳过非关键确认，但不得跳过写入或覆盖最终 `AGENTS.md` 前的用户批准。
- `[project directory]`：目标仓库。若省略，使用当前工作目录。
</Arguments>

<Secrets_Exclusion>
在任何读取文件内容之前，先建立敏感文件排除规则。默认不读取以下文件或路径的内容，即使用户说“可以”，也不要读取真实密钥、token、证书或凭据值。只记录这些文件的存在、路径、类别，以及需要写入 `AGENTS.md` 的安全提醒：

- `.env`、`.env.*`、`.env.local`、`.env.development`、`.env.production`
- `credentials.*`、`credentials.json`、`service-account*.json`
- `*.pem`、`*.key`、`*.p12`、`*.pfx`
- `secrets.*`、`secrets.yaml`、`secrets.yml`
- `id_rsa*`、`id_ecdsa*`、`id_ed25519*`
- `*.token`、`private.*`、`*.private`
- 路径中包含 `secret`、`credential`、`private_key` 或 `token`，且看起来可能保存秘密值的文件

如需理解安全规则，只能从安全的模板、文档、示例文件（例如不含真实 secret 的 `.env.example`）或用户提供的抽象说明中提取；不得要求用户粘贴真实 secret。
</Secrets_Exclusion>

<Project_Scan>
Phase 0/1 优先使用本 skill 自带的项目扫描脚本，避免对常见 manifest 逐个空搜：

- Windows / PowerShell：`writing-agents-md/scripts/scan_project.ps1 <project directory>`

脚本只输出文件存在性、相对路径和敏感候选类别；不得读取或打印 secret 值。运行脚本后：

1. 将扫描摘要写入对应 checkpoint 的 `Extracted Facts`。
2. 只读取扫描结果中确实存在、且不匹配 `Secrets_Exclusion` 的安全文件。
3. 如果脚本不存在、执行失败或目标环境无法运行 PowerShell，才退回手动 `Glob/Search`。
4. 退回手动搜索时，优先使用少量宽模式聚合查询；不要无意义地逐个查询大量明显不存在的 manifest。
</Project_Scan>

<Existing_Instruction_Sources>
起草前查找这些 AI instruction 来源：

- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`
- `.cursor/rules/`
- `.cursorrules`
- `.windsurfrules`
- 其他明显命名为 agent 或 AI coding instruction 的文件

将提取到的规则分类为：

- **Project facts**：技术栈、命令、路径、build/test/lint 工作流。
- **Behavior rules**：代码风格、review 规则、commit 规则、测试要求。
- **Safety boundaries**：不要读取或修改的文件、secret 处理、破坏性操作限制。
- **Tool-specific rules**：Claude Code skills/hooks、Cursor rule globs、Gemini 专用规则或其他 vendor-specific 行为。
- **Conflicts or stale claims**：与当前项目文件不一致的规则。
</Existing_Instruction_Sources>

<Checkpoint_Format>
checkpoint 文件使用 Markdown。模板必须包含草稿字段；Phase 0-2 可将该字段写为 `pending`，Phase 3 必须填写完整草稿或草稿摘要。

```markdown
# AGENTS Checkpoint {N}: {Phase Name}
> Project: {project_path}
> Language: {language_or_pending}

## Extracted Facts
{phase-specific facts}

## Existing Instruction Sources
{files found and how they were classified}

## User Decisions
{answers collected so far}

## Draft or Draft Summary
{pending for Phase 0-2; required draft content or draft summary for Phase 3}

## Open Issues
{conflicts, missing information, or decisions needed later}
```
</Checkpoint_Format>

<Steps>

## Phase 0: Safety Gate + Existing Instruction Analysis

**目标**：建立安全边界，并理解现有 AI guidance。

1. 解析目标项目目录。
2. 检查是否存在 `.agents-checkpoint-*.md`；如果存在，从最新已完成 checkpoint 的下一阶段恢复。
3. 在读取任何文件内容前，先应用 `Secrets_Exclusion`。
4. 运行 `Project_Scan` 脚本获取 instruction sources、manifest/workflow、skill entrypoints 和敏感候选的存在性摘要；如果脚本不可用，按 `Project_Scan` 的退回规则手动搜索。
5. 基于扫描结果查找 `Existing_Instruction_Sources` 中列出的现有 instruction 来源。
6. 只读取安全的 instruction 文件，并对规则分类。
7. 如果已经存在 `AGENTS.md`，识别其中可复用、过期、冲突或工具专用的部分。
8. 写入 `.agents-checkpoint-0.md`；`Draft or Draft Summary` 可为 `pending`。

## Phase 1: Project Context Analysis

**目标**：提取最终 `AGENTS.md` 可依赖的、可验证项目事实。

1. 复用 Phase 0 的 `Project_Scan` 结果；如果尚未运行或 checkpoint 中没有扫描摘要，先运行扫描脚本。
2. 从扫描结果识别项目 manifest 和 workflow 文件，例如：
   - `package.json`、`pnpm-lock.yaml`、`yarn.lock`、`package-lock.json`
   - `pyproject.toml`、`requirements.txt`、`setup.py`
   - `Cargo.toml`、`go.mod`、`pom.xml`、`build.gradle*`、`Makefile`
   - `.github/workflows/*`、test 配置、lint 配置、formatter 配置
3. 只读取扫描结果中确实存在、且安全的 manifest 和项目文档，例如存在时读取 `README.md`；不要为了确认“不存在”而逐个读取或反复搜索。
4. 提取：
   - 项目类型和核心技术栈
   - package manager
   - install、develop、build、test、lint、format 命令
   - 重要目录职责
   - 测试框架和预期验证命令
   - 需要提醒但不能读取 secret 内容的安全敏感路径
5. 如果命令或路径在不同来源中冲突，优先采用可执行项目配置，其次采用文档，并记录冲突。
6. 写入 `.agents-checkpoint-1.md`；`Draft or Draft Summary` 可为 `pending`。

## Phase 2: One-Question-at-a-Time Interview

**目标**：收集无法从代码中安全推断的项目规则。

一次只问一个问题，覆盖这些主题：

1. 目标 AI tool 范围：
   - vendor-neutral 的通用 `AGENTS.md`
   - 从现有工具专用文件整合
   - Claude Code 优先
   - 自定义范围
2. 如果没有提供 `--lang`，询问输出语言。
3. `✅ Always Do` 规则。
4. `⚠️ Ask First` 规则。
5. `🚫 Never Do` 规则。
6. 旧工具专用 instruction 文件的处理方式：保留并引用、部分迁移或分别维护。
7. 团队工作流约定：commit、PR、test、review、release、deployment。

访谈后，将答案与 Phase 1 的事实比较。如有矛盾，最多进行两轮澄清；如果仍无法解决，保留代码事实，并把用户说法标为需要 review。

写入 `.agents-checkpoint-2.md`；`Draft or Draft Summary` 可为 `pending`。

## Phase 3: Draft Generation + Consistency Check

**目标**：生成简洁草稿，并用项目事实校验。

默认使用以下结构生成草稿，可根据用户语言偏好翻译标题：

```markdown
# AGENTS.md

## Project Overview
- Project type:
- Core stack:
- Purpose:
- Key constraints:

## Commands
- Install:
- Develop:
- Build:
- Test:
- Lint:
- Format:

## Working Rules
### ✅ Always Do
- ...

### ⚠️ Ask First
- ...

### 🚫 Never Do
- ...

## Code Style
- ...

## Testing Guidelines
- ...

## Security and Secrets
- ...

## Tool-specific Notes
- ...

## Maintenance
- Update this file when build, test, deployment, or AI collaboration rules change.
```

写作规则：

- 将具体命令放在靠前位置。
- 优先使用简短、可执行的 bullet，避免长篇泛泛说明。
- 只有在能说明项目专用规则时才加入示例。
- 不列完整目录树。
- 不复制 README 内容，只保留 agent 编辑代码时必须知道的事实。
- 工具专用规则放入 `Tool-specific Notes`，或引用原始文件。
- 如果内容过长，保持 `AGENTS.md` 简短，并建议把详细策略移动到 `agent_docs/...`。

展示草稿前执行一致性检查：

- 命令来自真实 manifest、Makefile、workflow 文件或已验证文档。
- 路径存在，或明确标注为 proposed path。
- 技术栈与项目配置一致。
- 没有暴露 secrets。
- 没有把工具专用规则误写成通用规则。
- 未确认的猜测标为需要用户 review。

写入 `.agents-checkpoint-3.md`，其中 `Draft or Draft Summary` 必须包含完整草稿或草稿摘要，并附一致性检查结果。

## Phase 4: User Review Gate

**目标**：写入文件前取得明确批准。

1. 最终写入前，必须向用户展示完整拟写入内容；如果内容太长，可先展示摘要帮助用户定位，但写入确认必须基于完整内容或明确 patch。
2. 列出使用的来源：代码分析、现有 instruction 文件、访谈答案。
3. 列出未解决冲突、假设或需要用户确认的内容。
4. 如果 `AGENTS.md` 已存在，要求用户选择一种写入策略：
   - 覆盖 `AGENTS.md`
   - 写入 `AGENTS.new.md`
   - 只输出 patch 建议
   - 修改草稿后重新 review
5. 如果用户要求修改，更新草稿并重新执行一致性检查。
6. 在用户基于完整内容或明确 patch 批准之前，不写入最终文件。

## Phase 5: Final Write + Cleanup

**目标**：写入已批准文件，并报告变更。

1. 按 Phase 4 批准的策略写入目标文件。
2. 除非用户明确要求，不修改旧工具专用文件。
3. 最终写入成功后，删除 `.agents-checkpoint-*.md`。
4. 报告：
   - 写入的文件
   - 保留或引用的旧 instruction 来源
   - 已解决或仍需 review 的冲突
   - 哪些规则来自代码分析，哪些来自访谈
   - 建议的维护触发条件

</Steps>

<Integrated_Quality_Check>
<质量检查>
最终总结中包含这份 checklist：

### Structural Completeness
- [ ] `Project Overview` 存在且具体。
- [ ] `Commands` 包含已验证的 install、develop、build、test、lint、format 命令；若缺失，应明确标注。
- [ ] `Working Rules` 使用 `✅ Always Do`、`⚠️ Ask First` 和 `🚫 Never Do`。
- [ ] `Testing Guidelines` 存在；如果没有发现测试，应明确说明。
- [ ] `Security and Secrets` 存在。
- [ ] `Tool-specific Notes` 只包含工具专用规则或引用。

### Code Consistency
- [ ] 命令来自真实 manifest、Makefile、workflow 或已验证文档。
- [ ] 路径存在，或明确标为 proposed。
- [ ] 技术栈与项目文件一致。
- [ ] 未验证的用户假设没有被写成事实。

### Safety
- [ ] 没有暴露 `.env*`、keys、tokens、certificates 或 private keys。
- [ ] 没有建议 agent 自动执行危险操作。
- [ ] 覆盖 `AGENTS.md` 或修改工具专用 instruction 文件前需要用户确认。

### Style
- [ ] 文件简洁，不重复 README。
- [ ] 文件不包含完整目录树 dump。
- [ ] 文件不会把一次性任务永久化。
- [ ] 语言遵循用户选择或 `--lang` 参数。
</质量检查>
</Integrated_Quality_Check>

<Recovery_Procedure>
<恢复机制>
如果执行中断：

1. 下一次运行本 skill 时，先检查 `.agents-checkpoint-*.md`。
2. 读取最新 checkpoint。
3. 从最新已完成 checkpoint 的下一阶段恢复。
4. 优先处理 checkpoint 中的 `Open Issues`。
5. 如果已存在 Phase 3 checkpoint，但没有记录最终用户批准，则从 Phase 4 恢复。
</恢复机制>
</Recovery_Procedure>

<Edge_Cases>
<边界情况>
- **Empty project**：降级为访谈驱动生成，并说明项目结构稳定后应更新 `AGENTS.md`。
- **No manifest files**：不要编造命令；询问用户，或使用已验证 README 命令并注明来源。
- **Existing `AGENTS.md` conflicts with code**：报告冲突，优先采用代码事实，并询问用户最终规则应如何表述。
- **Existing `CLAUDE.md`, Cursor, or Gemini rules**：只读取安全内容，分类后引用或迁移；迁移必须得到用户批准。
- **Monorepo**：询问生成一个根目录 `AGENTS.md`，还是为 package 生成局部 `AGENTS.md`。
- **Long guidance**：保持主文件简洁，并建议把详细策略放到 `agent_docs/...`。
- **Local edit request**：如果用户只想小幅编辑 `AGENTS.md`，跳过完整生成流程，直接修改指定部分。
</边界情况>
</Edge_Cases>
