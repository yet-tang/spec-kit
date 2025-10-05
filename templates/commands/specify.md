---
description: 从自然语言功能描述创建或更新功能规范。
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

用户输入可以直接由代理提供或作为命令参数提供 - 在继续提示之前，您**必须**考虑它（如果不为空）。

用户输入：

$ARGUMENTS

用户在触发消息中在 `/specify` 后输入的文本**就是**功能描述。假设您在此对话中始终可以使用它，即使下面字面上出现 `{ARGS}`。除非用户提供了空命令，否则不要要求用户重复。

给定该功能描述，执行以下操作：

1. 从仓库根目录运行脚本 `{SCRIPT}` 并解析其 JSON 输出以获取 BRANCH_NAME 和 SPEC_FILE。所有文件路径必须是绝对路径。
  **重要** 您只能运行此脚本一次。JSON 在终端中作为输出提供 - 始终参考它来获取您要查找的实际内容。
2. 加载 `templates/spec-template.md` 以了解所需的部分。
3. 使用模板结构将规范写入 SPEC_FILE，用从功能描述（参数）派生的具体细节替换占位符，同时保留部分顺序和标题。
4. 报告完成情况，包括分支名称、规范文件路径以及下一阶段的准备情况。

注意：脚本在写入之前创建并检出新分支并初始化规范文件。