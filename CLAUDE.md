# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

Spec Kit 是一个规范驱动开发（SDD）工具包，包含 Specify CLI，用于初始化和管理规范驱动的软件开发项目。该项目支持多种 AI 编码助手，提供结构化的开发工作流程。

## 常用命令

### 开发和构建
```bash
# 安装开发依赖
pip install -e .

# 运行 CLI 工具
python -m specify_cli --help
specify --help

# 检查系统工具
specify check

# 初始化新项目
specify init my-project --ai claude
specify init . --ai claude --here  # 在当前目录初始化
```

### 发布流程
```bash
# 创建发布包（需要版本号，如 v0.1.0）
.github/workflows/scripts/create-release-packages.sh v0.1.0

# 检查发布是否已存在
.github/workflows/scripts/check-release-exists.sh v0.1.0

# 生成发布说明
.github/workflows/scripts/generate-release-notes.sh v0.1.0 v0.0.17

# 创建 GitHub 发布
.github/workflows/scripts/create-github-release.sh v0.1.0
```

### 本地开发
```bash
# 测试脚本
./scripts/bash/check-prerequisites.sh
./scripts/bash/create-new-feature.sh "测试新功能"

# 更新代理上下文
./scripts/bash/update-agent-context.sh
```

## 项目架构

### 核心组件

1. **Specify CLI** (`src/specify_cli/__init__.py`)
   - 主要的命令行接口，支持项目初始化和工具检查
   - 支持多种 AI 代理：Claude、Gemini、Copilot、Cursor、Qwen、opencode、Windsurf 等
   - 从 GitHub 下载并提取特定于 AI 代理的模板

2. **模板系统** (`templates/`)
   - `commands/`: 各种斜杠命令模板（specify、plan、tasks、implement 等）
   - `spec-template.md`: 功能规格模板
   - `plan-template.md`: 实施计划模板
   - `tasks-template.md`: 任务列表模板

3. **脚本系统** (`scripts/`)
   - `bash/` 和 `powershell/`: 跨平台脚本支持
   - `create-new-feature.sh`: 创建新功能分支和规格文件
   - `setup-plan.sh`: 设置技术实施计划
   - `validate-specification.sh`: 需求验证脚本（bash 版本）
   - `clarify-ux-requirements.sh`: UX 需求澄清脚本（bash 版本）
   - `common.sh`: 通用函数和变量

4. **工作流程** (`.github/workflows/`)
   - `release.yml`: 自动发布流程，检测文件变更并创建新版本
   - `docs.yml`: 文档部署流程

### 目录结构

```
spec-kit/
├── src/specify_cli/          # CLI 核心代码
├── templates/                # 各种 AI 代理的模板
│   ├── commands/            # 斜杠命令模板（包含 UX 专用命令）
│   ├── spec-template.md     # 功能规格模板（包含完整 UX 设计章节）
│   ├── plan-template.md     # 实施计划模板（包含 UX 设计阶段）
│   ├── tasks-template.md    # 任务列表模板（包含 UX 开发任务）
│   ├── ux-design-template.md # UX 设计文档模板
│   └── traceability-template.md # 需求追溯矩阵模板
├── scripts/                 # 跨平台脚本
│   ├── bash/               # Bash/Shell 脚本
│   └── powershell/         # PowerShell 脚本
├── memory/                 # 项目治理原则
├── .github/workflows/      # CI/CD 工作流程
└── docs/                   # 文档
```

## 规范驱动开发工作流程

### 基础工作流程
1. **初始化项目**: `specify init <project-name> --ai <agent>`
2. **建立原则**: `/constitution` - 创建项目治理原则
3. **创建规格**: `/specify <功能描述>` - 从功能描述创建规格
4. **澄清需求**: `/clarify` - 澄清未充分指定的区域（可选）
5. **制定计划**: `/plan <技术栈选择>` - 创建技术实施计划
6. **生成任务**: `/tasks` - 分析计划并生成可执行任务列表
7. **分析一致性**: `/analyze` - 检查跨工件一致性和覆盖率（可选）
8. **执行实施**: `/implement` - 执行所有任务并构建功能

### UX 驱动开发工作流程
1. **初始化项目**: `specify init <project-name> --ai <agent>`
2. **建立原则**: `/constitution` - 创建包含 UX 原则的项目原则
3. **创建规格**: `/specify <功能描述>` - 创建包含 UX 要求的功能规格
4. **UX 澄清**: `/clarify-ux` - 深度澄清 UX 设计需求
5. **UX 验证**: `/validate-ux` - 验证 UX 设计完整性
6. **制定计划**: `/plan <技术栈选择>` - 生成包含 UX 设计阶段的实施计划
7. **生成任务**: `/tasks` - 生成包含 UX 开发任务的详细任务列表
8. **分析一致性**: `/analyze` - 检查跨工件一致性和覆盖率
9. **执行实施**: `/implement` - 执行包含 UX 开发的完整实施

### 可用命令
- **基础命令**: `/constitution`, `/specify`, `/clarify`, `/plan`, `/tasks`, `/implement`
- **增强命令**: `/validate`, `/analyze`
- **UX 专用命令**: `/clarify-ux`, `/validate-ux`

## 支持的 AI 代理

项目为多种 AI 编码助手生成特定配置：

- **Claude Code**: `.claude/commands/` (Markdown 格式)
- **Gemini CLI**: `.gemini/commands/` (TOML 格式)
- **GitHub Copilot**: `.github/prompts/` (Markdown 格式)
- **Cursor**: `.cursor/commands/` (Markdown 格式)
- **Qwen Code**: `.qwen/commands/` (TOML 格式)
- **opencode**: `.opencode/command/` (Markdown 格式)
- **Windsurf**: `.windsurf/workflows/` (Markdown 格式)
- **Amazon Q Developer CLI**: `.amazonq/prompts/` (Markdown 格式)

## 添加新 AI 代理支持

当添加新的 AI 代理时，需要更新以下文件：

1. `src/specify_cli/__init__.py`: 更新 `AI_CHOICES` 和 `agent_folder_map`
2. `README.md`: 更新支持的 AI 代理表格
3. `.github/workflows/scripts/create-release-packages.sh`: 添加新代理的包创建逻辑
4. `scripts/bash/update-agent-context.sh` 和 `scripts/powershell/update-agent-context.ps1`: 添加上下文更新支持
5. 创建相应的模板文件和目录结构

详细步骤请参考 `AGENTS.md` 文件。

## 版本管理

- 版本号在 `pyproject.toml` 中定义
- 使用语义版本控制（semver）
- 发布时会自动生成 GitHub Release 和更新 CHANGELOG.md
- 每次发布需要更新 `CHANGELOG.md` 中的版本记录

## 环境变量

- `SPECIFY_FEATURE`: 覆盖功能检测，设置为功能目录名称（如 `001-photo-albums`）以在不使用 Git 分支时处理特定功能
- `GH_TOKEN` 或 `GITHUB_TOKEN`: GitHub 令牌，用于 API 请求

## 测试

项目使用脚本进行功能测试，主要测试场景包括：

- 项目初始化流程
- 不同 AI 代理的模板生成
- 脚本跨平台兼容性
- 发布包创建流程

## 贡献指南

1. 任何对 `__init__.py` 的更改都需要在 `pyproject.toml` 中进行版本修订
2. 需要相应地在 `CHANGELOG.md` 中添加条目
3. 确保所有脚本都有跨平台版本（bash 和 powershell）
4. 更新文档以反映新功能或更改

## 本地开发提示

- 使用 `uv` 进行包管理：`uv tool install specify-cli --from git+https://github.com/yet-tang/spec-kit.git`
- 使用 `--debug` 标志进行详细调试输出：`specify init my-project --debug`
- 使用 `--ignore-agent-tools` 跳过 AI 代理工具检查：`specify init my-project --ignore-agent-tools`
- 在当前目录初始化时使用 `--force` 跳过确认：`specify init . --ai claude --force`