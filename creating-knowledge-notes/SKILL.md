---
name: creating-knowledge-notes
description: Use when creating, rewriting, distilling, or standardizing Markdown knowledge notes from articles, social posts, transcripts, videos, audio, or mixed source material for a personal knowledge base or RAG use.
---

# Creating Knowledge Notes

## Overview

Create notes using the user's **知识沉淀模板** standard: paper-like outer structure, summary as the minimum useful version, free topic tags, semantic body headings, lightweight references, and appendix for heavy details.

## When to Use

Use this when the user asks to create or organize a note from raw material, especially social-platform content, medium notes, long transcripts, video/audio summaries, technical articles, or source material intended for future RAG retrieval.

Do not use for casual chat answers, one-off summaries that will not become notes, or strict academic papers with external citation rules.

## Required Output Shape

Use these visible top-level sections in Chinese for finished notes. `# 附录` is conditional, not part of the mandatory skeleton:

```md
---
title:
created:
updated:
tags: []
source:
---

# 摘要
# 关键词
# 目录
[TOC]
# 引言
# 正文
# 结论
# 参考文献
```

Add `# 附录` only when the source material includes heavy knowledge-supporting details such as long code, formulas, tables, raw excerpts, configs, data, or extra cases. If there is no appendix material, omit the entire appendix section; never write an empty appendix heading or placeholder text like `无额外附录。`, `无。`, or `无内容。`.

Rules:

- Single-source note: `source` must be a scalar URL only, with no quotes, e.g. `source: https://example.com/post` or `source: www.baidu.com`.
- Do not use nested source metadata (`platform`, `author`, `url`, `content_type`) in frontmatter; it breaks the user's metadata parser.
- Multi-source note: remove `source`; list sources under `# 参考文献`.
- `frontmatter.tags` and `# 关键词` must contain the exact same keywords in the same order.
- Do not add RAG metadata like `answerable_questions`, `key_claims`, or `limitations`.
- Do not add location metadata like `latitude`, `longitude`, or `altitude`.

## Keyword Rendering

For finished notes, render tags as a YAML list and visible keywords as semicolon-separated text:

```md
---
tags:
  - RAG
  - 检索增强生成
  - 智能体幻觉
---

# 关键词

RAG；检索增强生成；智能体幻觉
```

Do not render `# 关键词` as a JSON/YAML array like `[RAG, 检索增强生成]`. The terms and order must match `frontmatter.tags`; only the syntax differs.

## Section Standards

| Section | Standard |
|---|---|
| `# 摘要` | The minimum useful version: problem, scenario, core method/view, limits, result/judgment. Avoid empty “本文介绍了…” phrasing. |
| `# 关键词` | Free high-relevance topic tags. Include concepts, tools, problems, scenarios, aliases, and risks. Avoid generic tags like “知识/学习/方法/经验/总结”. |
| `# 引言` | Explain demand context, background, current pain, why the note matters, and what solution/view it introduces. Do not repeat the 摘要 or introduce the source itself. |
| `# 正文` | Use semantic, content-rich headings. Cover 5W1H, limits, and results when source supports them. Do not fabricate missing dimensions. |
| `# 结论` | Natural paragraphs that include final judgment, future use advice, and limits/follow-up. Do not create mechanical subheadings named “最终判断/使用建议/局限与后续”. |
| `# 参考文献` | Use stable source identifiers: with URL, `[作者."原文标题".发布平台.发布日期](原文链接)`; without URL, `作者."原文标题".发布平台.发布日期`. No per-claim audit required. |
| `# 附录` | Conditional section for heavy knowledge-supporting details only: long code, formulas, tables, raw excerpts, configs, data, extra cases. Exclude local filesystem paths and processing provenance unless explicitly requested. If none exist, omit this section entirely. |

## Semantic Heading Rule

Body headings should carry topic meaning for RAG chunks.

Good:

```md
## 切分粒度会直接影响召回质量
## 检索不到正确资料时仍然可能幻觉
```

Avoid generic repeated headings:

```md
## 原理
## 方法
## 使用场景
## 限制
## 语义化小标题
```

Use the ideas behind 5W1H as a hidden completeness checklist, not as mandatory headings: What, Why, How, When, Where, Who, limits, results.

## Source Handling

- One source with URL: use unquoted scalar `source: <url>` in frontmatter and cite it again under `# 参考文献`.
- One source without URL: use blank `source:` or omit `source`; record platform/author/content type under `# 参考文献` instead of frontmatter.
- Multiple sources: delete `source`; put every source under `# 参考文献`.
- Never write frontmatter like `source: { platform, author, url, content_type }` or a nested `source:` block.
- In `# 参考文献`, write sources with public URLs as Markdown links: `- [作者."原文标题".发布平台.发布日期](原文链接)`.
- If no public URL is available, write plain text only: `- 作者."原文标题".发布平台.发布日期`. Do not create a fake link target such as `(无公开原文链接)`.
- Do not append parenthetical process notes such as `（无公开原文链接）`, `（时间来自字幕文件名）`, or `（时间来自文件名）`.
- The publication date in references must use `YYYY-MM-DD HH:mm:ssZ` exactly, e.g. `2026-01-07 23:52:15Z`.
- Use ASCII double quotes around the original title inside the reference text, as shown above; do not use `《》` for the required reference entry.
- Do not wrap the frontmatter `source` URL in quotes; quoted URLs can break URL jumping.
- If platform is unknown and cannot be verified from provided source metadata, use `本地字幕材料` for local subtitle material rather than `unknown`, `not provided`, or an invented platform.
- If only partial source information exists, record the stable available fields under `# 参考文献` without inventing author, title, date, platform, or URL.
- Finished notes must not include absolute local source paths such as `D:\workspace\...`, downloader directories, or machine-specific provenance headings like `## 原始素材位置`, unless the user explicitly asks for traceability/debug output.
- In finished notes, keep source framing out of `# 摘要`, `# 引言`, `# 正文`, and `# 结论`. Write from the knowledge point of view, not the source-introduction point of view.
- Avoid repeated phrases like “视频给出”, “原视频”, “这条短视频”, “视频指出”, “该视频认为”. Prefer direct knowledge phrasing: “可尝试的做法是…”, “这个技巧的关键是…”, “适用边界是…”.
- Mention the source in prose only when discussing provenance, evidence limits, or references; otherwise leave it in frontmatter and `# 参考文献`.

## Template Guidance vs Finished Notes

When writing a reusable template, put guidance in HTML comments so rendered notes and RAG indexes stay clean.

When creating a finished note, do **not** leave visible placeholders, example footnotes, or instructional text. Only use HTML comments if the user explicitly wants a template rather than a finished note.

## Quick Checklist

Before finalizing a note:

- [ ] Top-level Chinese sections are present.
- [ ] `[TOC]` is present under `# 目录`.
- [ ] `tags` exactly match `# 关键词`.
- [ ] Single-source metadata with URL uses unquoted scalar `source: <url>` only; no nested `source` object and no quotes around the URL.
- [ ] Single-source metadata without URL uses blank/omitted `source` and a plain no-link reference, not a fake link.
- [ ] Multi-source metadata removes frontmatter `source` and lists sources in `# 参考文献`.
- [ ] No absolute local paths, downloader directories, or `## 原始素材位置` appear in finished notes unless explicitly requested.
- [ ] Source/video framing is absent from 摘要、引言、正文、结论 unless needed for provenance or limits.
- [ ] 正文 headings are semantic, not generic fixed labels.
- [ ] 结论 uses natural paragraphs, not mechanical subheadings.
- [ ] Heavy code/formulas/raw material are in `# 附录` when present.
- [ ] If no appendix material exists, the note has no `# 附录` heading and no empty appendix placeholder text.
- [ ] Missing source details are not invented.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Using English headings like `Summary` or `References` | Use `摘要` and `参考文献`. |
| Adding `summary`, `source_type`, or RAG fields to frontmatter | Keep frontmatter minimal. |
| Writing nested `source.platform/source.url/source.content_type` frontmatter | Use unquoted scalar `source: <url>`; move platform/author/content type to `# 参考文献`. |
| Quoting the frontmatter URL as `source: "https://..."` | Remove quotes: `source: https://...`. |
| Writing linked references as loose plain text or `《标题》` | With URL, use `- [作者."原文标题".发布平台.YYYY-MM-DD HH:mm:ssZ](原文链接)`. |
| Writing no-link references as `[...](无公开原文链接)` or adding `无公开原文链接/时间来自文件名` | Without URL, use plain `- 作者."原文标题".发布平台.YYYY-MM-DD HH:mm:ssZ` only. |
| Using `unknown/not provided` as the platform for local subtitle material | Use `本地字幕材料` unless the real platform is provided or verified. |
| Adding absolute paths or `## 原始素材位置` to 附录 | Remove machine-local provenance; keep only reusable knowledge details. |
| Letting `tags` drift from visible keywords | Make both lists identical and in the same order. |
| Rendering `# 关键词` as `[tag1, tag2]` | Use semicolon-separated text: `tag1；tag2`. |
| Writing `## 原理/方法/限制` everywhere | Replace with content-rich headings. |
| Putting one `source.url` on a multi-source note | Remove `source`; list all sources in `参考文献`. |
| Dumping long scripts in 正文 | Explain principle in正文; move scripts to附录. |
| Writing `# 附录` with `无额外附录。`, `无。`, or other empty placeholders | Delete the entire appendix section when there is no appendix material. |
| Keeping template examples in finished notes | Remove placeholders and examples unless they are real content. |
| Writing “视频给出/原视频/该视频认为” throughout a finished note | Keep source details in metadata/references; rewrite as direct knowledge points except when discussing provenance or limits. |
