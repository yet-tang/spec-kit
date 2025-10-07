<div align="center">
    <img src="./media/logo_small.webp"/>
    <h1>🌱 Spec Kit</h1>
    <h3><em>更快地构建高质量软件。</em></h3>
</div>

<p align="center">
    <strong>通过规格驱动开发的帮助，让组织能够专注于产品场景，而非编写无差异化代码。</strong>
</p>

[![Release](https://github.com/github/spec-kit/actions/workflows/release.yml/badge.svg)](https://github.com/github/spec-kit/actions/workflows/release.yml)

---

## 目录

- [🤔 什么是规格驱动开发？](#-什么是规格驱动开发)
- [⚡ 快速开始](#-快速开始)
- [📽️ 视频概览](#️-视频概览)
- [🤖 支持的AI代理](#-支持的ai代理)
- [🔧 Specify CLI 参考](#-specify-cli-参考)
- [📚 核心理念](#-核心理念)
- [🌟 开发阶段](#-开发阶段)
- [🎯 实验目标](#-实验目标)
- [🔧 系统要求](#-系统要求)
- [📖 了解更多](#-了解更多)
- [📋 详细流程](#-详细流程)
- [🔍 故障排除](#-故障排除)
- [👥 维护者](#-维护者)
- [💬 支持](#-支持)
- [🙏 致谢](#-致谢)
- [📄 许可证](#-许可证)

## 🤔 什么是规格驱动开发？

规格驱动开发**颠覆了**传统软件开发的脚本。几十年来，代码一直是王者——规格说明只是我们构建的脚手架，一旦开始"真正的"编码工作就会被丢弃。规格驱动开发改变了这一点：**规格说明变得可执行**，直接生成可工作的实现，而不仅仅是指导实现。

## ⚡ 快速开始

### 1. 安装 Specify

选择您偏好的安装方法：

#### 选项1：持久安装（推荐）

一次安装，随处使用：

```bash
uv tool install specify-cli --from git+https://github.com/yet-tang/spec-kit.git
```

然后直接使用工具：

```bash
specify init <项目名称>
specify check
```

#### 选项2：一次性使用

直接运行而无需安装：

```bash
uvx --from git+https://github.com/yet-tang/spec-kit.git specify init <项目名称>
```

**持久安装的优势：**

- 工具保持安装状态并在PATH中可用
- 无需创建shell别名
- 通过 `uv tool list`、`uv tool upgrade`、`uv tool uninstall` 更好地管理工具
- 更清洁的shell配置

### 2. 建立项目原则

使用 **`/constitution`** 命令创建项目的治理原则和开发指导方针，这些将指导所有后续开发。

```bash
/constitution 创建专注于代码质量、测试标准、用户体验一致性和性能要求的原则
```

### 3. 创建规格说明

使用 **`/specify`** 命令描述您想要构建的内容。专注于**什么**和**为什么**，而不是技术栈。

```bash
/specify 构建一个可以帮助我将照片组织到单独相册中的应用程序。相册按日期分组，可以在主页面上通过拖拽重新组织。相册永远不会嵌套在其他相册中。在每个相册内，照片以瓦片式界面预览。
```

### 4. 创建技术实施计划

使用 **`/plan`** 命令提供您的技术栈和架构选择。

```bash
/plan 应用程序使用Vite，库的数量最少。尽可能多地使用原生HTML、CSS和JavaScript。图片不会上传到任何地方，元数据存储在本地SQLite数据库中。
```

### 5. 分解为任务

使用 **`/tasks`** 从您的实施计划创建可执行的任务列表。

```bash
/tasks
```

### 6. 执行实施

使用 **`/implement`** 执行所有任务并根据计划构建您的功能。

```bash
/implement
```

有关详细的分步说明，请参阅我们的[综合指南](./spec-driven.md)。

## 📽️ 视频概览

想看看Spec Kit的实际操作吗？观看我们的[视频概览](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)！

[![Spec Kit视频标题](/media/spec-kit-video-header.jpg)](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)

## 🤖 支持的AI代理

| 代理                                                     | 支持 | 备注                                             |
|-----------------------------------------------------------|---------|---------------------------------------------------|
| [Claude Code](https://www.anthropic.com/claude-code)      | ✅ |                                                   |
| [GitHub Copilot](https://code.visualstudio.com/)          | ✅ |                                                   |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | ✅ |                                                   |
| [Cursor](https://cursor.sh/)                              | ✅ |                                                   |
| [Qwen Code](https://github.com/QwenLM/qwen-code)          | ✅ |                                                   |
| [opencode](https://opencode.ai/)                          | ✅ |                                                   |
| [Windsurf](https://windsurf.com/)                         | ✅ |                                                   |
| [Trae AI](https://trae.ai/)                               | ✅ |                                                   |
| [Kilo Code](https://github.com/Kilo-Org/kilocode)         | ✅ |                                                   |
| [Auggie CLI](https://docs.augmentcode.com/cli/overview)   | ✅ |                                                   |
| [Roo Code](https://roocode.com/)                          | ✅ |                                                   |
| [Codex CLI](https://github.com/openai/codex)              | ⚠️ | Codex [不支持](https://github.com/openai/codex/issues/2890) 斜杠命令的自定义参数。  |

## 🔧 Specify CLI 参考

`specify` 命令支持以下选项：

### 命令

| 命令     | 描述                                                    |
|-------------|----------------------------------------------------------------|
| `init`      | 从最新模板初始化新的Specify项目      |
| `check`     | 检查已安装的工具（`git`、`claude`、`gemini`、`code`/`code-insiders`、`cursor-agent`、`windsurf`、`qwen`、`opencode`、`codex`） |

### `specify init` 参数和选项

| 参数/选项        | 类型     | 描述                                                                  |
|------------------------|----------|------------------------------------------------------------------------------|
| `<项目名称>`       | 参数 | 新项目目录的名称（如果使用 `--here` 则可选，或使用 `.` 表示当前目录） |
| `--ai`                 | 选项   | 要使用的AI助手：`claude`、`gemini`、`copilot`、`cursor`、`qwen`、`opencode`、`codex`、`windsurf`、`trae`、`kilocode`、`auggie` 或 `roo` |
| `--script`             | 选项   | 要使用的脚本变体：`sh`（bash/zsh）或 `ps`（PowerShell）                 |
| `--ignore-agent-tools` | 标志     | 跳过AI代理工具（如Claude Code）的检查                             |
| `--no-git`             | 标志     | 跳过git仓库初始化                                          |
| `--here`               | 标志     | 在当前目录中初始化项目，而不是创建新目录   |
| `--force`              | 标志     | 在当前目录中初始化时强制合并/覆盖（跳过确认） |
| `--skip-tls`           | 标志     | 跳过SSL/TLS验证（不推荐）                                 |
| `--debug`              | 标志     | 启用详细调试输出以进行故障排除                            |
| `--github-token`       | 选项   | 用于API请求的GitHub令牌（或设置GH_TOKEN/GITHUB_TOKEN环境变量）  |

### 示例

```bash
# 基本项目初始化
specify init my-project

# 使用特定AI助手初始化
specify init my-project --ai claude

# 使用Cursor支持初始化
specify init my-project --ai cursor

# 使用Windsurf支持初始化
specify init my-project --ai windsurf

# 使用PowerShell脚本初始化（Windows/跨平台）
specify init my-project --ai copilot --script ps

# 在当前目录中初始化
specify init . --ai copilot
# 或使用--here标志
specify init --here --ai copilot

# 强制合并到当前（非空）目录而不确认
specify init . --force --ai copilot
# 或 
specify init --here --force --ai copilot

# 跳过git初始化
specify init my-project --ai gemini --no-git

# 启用调试输出进行故障排除
specify init my-project --ai claude --debug

# 使用GitHub令牌进行API请求（对企业环境有帮助）
specify init my-project --ai claude --github-token ghp_your_token_here

# 检查系统要求
specify check
```

### 可用的斜杠命令

运行 `specify init` 后，您的AI编码代理将可以访问这些用于结构化开发的斜杠命令：

| 命令         | 描述                                                           |
|-----------------|-----------------------------------------------------------------------|
| `/constitution` | 创建或更新项目治理原则和开发指导方针 |
| `/specify`      | 定义您想要构建的内容（需求和用户故事）        |
| `/clarify`      | 澄清未充分指定的区域（必须在 `/plan` 之前运行，除非明确跳过；以前称为 `/quizme`） |
| `/clarify-ux`   | 专门针对用户体验设计进行深度澄清，确保 UX 设计需求的完整性 |
| `/plan`         | 使用您选择的技术栈创建技术实施计划     |
| `/tasks`        | 生成实施的可执行任务列表                     |
| `/validate`     | 验证规格的完整性和准确性，识别潜在的需求遗漏 |
| `/validate-ux`  | 验证用户体验设计的完整性和质量，识别 UX 设计缺陷和改进机会 |
| `/analyze`      | 跨工件一致性和覆盖率分析（在/tasks之后、/implement之前运行） |
| `/implement`    | 执行所有任务以根据计划构建功能         |

### 环境变量

| 变量         | 描述                                                                                    |
|------------------|------------------------------------------------------------------------------------------------|
| `SPECIFY_FEATURE` | 为非Git仓库覆盖功能检测。设置为功能目录名称（例如，`001-photo-albums`）以在不使用Git分支时处理特定功能。<br/>**必须在使用 `/plan` 或后续命令之前在您正在使用的代理上下文中设置。 |

## 🚀 新功能和增强命令

### UX 驱动开发支持

Spec Kit 现在完全支持用户体验（UX）驱动的规范驱动开发，确保每个功能都从用户角度得到充分考虑。

#### 新增 UX 专用命令

| 命令 | 描述 | 使用场景 |
|------|------|----------|
| `/clarify-ux` | 深度澄清 UX 设计需求，确保 UX 设计需求的完整性 | 功能涉及复杂用户交互、需要理解用户群体和使用场景时 |
| `/validate-ux` | 验证 UX 设计的完整性和质量，识别 UX 设计缺陷和改进机会 | UX 设计完成后、需要评估设计质量时 |

**使用示例**：
```bash
# 全面 UX 澄清
/clarify-ux

# 重点关注交互设计
/clarify-ux interaction

# 重点关注可访问性
/clarify-ux accessibility

# 全面 UX 验证
/validate-ux

# 验证用户研究质量
/validate-ux research
```

#### 增强的验证命令

| 命令 | 描述 | 功能特性 |
|------|------|----------|
| `/validate` | 验证规格的完整性和准确性，识别潜在的需求遗漏 | 支持多维度验证（business、technical、ux、security） |

**使用示例**：
```bash
# 全面验证
/validate

# 验证业务需求
/validate business

# 验证技术需求
/validate technical

# 验证 UX 设计
/validate ux

# 验证安全需求
/validate security
```

### UX 驱动开发流程

推荐使用以下完整流程来确保 UX 质量：

```bash
# 1. 建立包含 UX 原则的项目原则
/constitution 创建包含 UX 设计原则的项目治理原则

# 2. 创建包含 UX 要求的功能规格
/specify 构建用户管理功能，需要支持多角色权限管理

# 3. 深度澄清 UX 设计需求
/clarify-ux

# 4. 验证 UX 设计完整性
/validate-ux

# 5. 生成包含 UX 设计阶段的实施计划
/plan 使用React和Node.js，注重用户体验设计

# 6. 生成包含 UX 开发任务的详细任务列表
/tasks

# 7. 检查跨工件一致性
/analyze

# 8. 执行包含 UX 开发的完整实施
/implement
```

### 增强的模板系统

#### 规格模板增强
- **新增完整的 UX 设计章节**：包含用户研究、信息架构、交互设计、视觉设计等7个核心领域
- **需求完整性检查清单**：40+个检查项确保 UX 需求的完整性
- **可访问性要求**：符合 WCAG 2.1 标准的无障碍设计要求

#### 独立的 UX 设计模板
- **`ux-design-template.md`**：完整的 UX 设计文档框架
- **包含用户旅程地图**、**交互流程图**、**视觉设计系统**
- **可用性测试计划**和**设计交付标准**

#### 实施计划模板增强
- **新增 UX 设计阶段**：与技术开发并行的 UX 设计流程
- **5个 UX 设计交付物**：用户研究、信息架构、交互设计、视觉设计、原型设计
- **UX 任务生成策略**：自动生成 UX 开发相关任务

#### 任务模板增强
- **UX 设计实施阶段**：9个具体的 UX 开发任务
- **UX 测试任务**：UI组件测试、端到端测试、可访问性测试
- **并行执行支持**：UX 设计与技术开发可并行进行

### 需求追溯和质量保证

#### 需求追溯矩阵
- **`traceability-template.md`**：从业务需求到测试用例的完整追溯链
- **质量指标跟踪**：需求稳定性、明确性、可测试性指标
- **变更历史记录**：完整的变更追踪和影响分析

#### 质量门禁机制
- **三级质量门禁**：规格准备就绪、计划准备就绪、实施准备就绪
- **4阶段评审流程**：业务评审、UX评审、技术评审、安全评审
- **量化验收标准**：任务完成率、错误率、用户满意度指标

### 跨平台脚本支持

所有新功能都包含跨平台脚本支持：

- **Bash 脚本**：`scripts/bash/`
- **PowerShell 脚本**：`scripts/powershell/`
- **统一接口**：相同的命令行参数和输出格式

**脚本示例**：
```bash
# Bash/Shell
./scripts/bash/validate-specification.sh -s ux specs/001-user-authentication/spec.md
./scripts/bash/clarify-ux-requirements.sh -f interaction

# PowerShell
./scripts/powershell/validate-specification.ps1 -Scope ux -Arguments "specs/001-user-authentication/spec.md"
./scripts/powershell/clarify-ux-requirements.ps1 -Focus interaction
```

## 📚 核心理念

规格驱动开发是一个结构化过程，强调：

- **意图驱动开发**，其中规格说明在"_如何_"之前定义"_什么_"
- **丰富的规格说明创建**，使用护栏和组织原则
- **多步骤改进**，而不是从提示一次性生成代码
- **严重依赖**高级AI模型能力进行规格说明解释

## 🌟 开发阶段

| 阶段 | 重点 | 关键活动 |
|-------|-------|----------------|
| **0到1开发**（"绿地项目"） | 从零开始生成 | <ul><li>从高层需求开始</li><li>生成规格说明</li><li>规划实施步骤</li><li>构建生产就绪的应用程序</li></ul> |
| **创意探索** | 并行实现 | <ul><li>探索多样化解决方案</li><li>支持多种技术栈和架构</li><li>实验用户体验模式</li><li>并行设计多种用户界面方案</li></ul> |
| **迭代增强**（"棕地项目"） | 棕地现代化 | <ul><li>迭代添加功能</li><li>现代化遗留系统</li><li>适应流程</li></ul> |

## 🎯 实验目标

我们的研究和实验重点包括：

### 技术独立性

- 使用多样化技术栈创建应用程序
- 验证规格驱动开发是一个不依赖于特定技术、编程语言或框架的过程

### 企业约束

- 演示关键任务应用程序开发
- 整合组织约束（云提供商、技术栈、工程实践）
- 支持企业设计系统和合规要求

### 以用户为中心的开发

- 为不同用户群体和偏好构建应用程序
- 支持各种开发方法（从氛围编码到AI原生开发）
- 集成完整的用户体验设计流程
- 支持可访问性设计和多平台适配
- 提供用户研究和可用性测试框架

### 创意和迭代过程

- 验证并行实现探索的概念
- 提供强大的迭代功能开发工作流
- 扩展流程以处理升级和现代化任务

## 🔧 系统要求

- **Linux/macOS**（或Windows上的WSL2）
- AI编码代理：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/)、[Gemini CLI](https://github.com/google-gemini/gemini-cli)、[Cursor](https://cursor.sh/)、[Qwen CLI](https://github.com/QwenLM/qwen-code)、[opencode](https://opencode.ai/)、[Codex CLI](https://github.com/openai/codex) 或 [Windsurf](https://windsurf.com/)
- [uv](https://docs.astral.sh/uv/) 用于包管理
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

如果您在使用代理时遇到问题，请提交issue，以便我们改进集成。

## 📖 了解更多

- **[完整的规格驱动开发方法论](./spec-driven.md)** - 深入了解完整过程
- **[详细演练](#-详细流程)** - 分步实施指南

---

## 📋 详细流程

<details>
<summary>点击展开详细的分步演练</summary>

您可以使用Specify CLI来引导您的项目，这将在您的环境中引入所需的工件。运行：

```bash
specify init <项目名称>
```

或在当前目录中初始化：

```bash
specify init .
# 或使用--here标志
```

这将设置一个包含以下结构的项目：

```
your-project/
├── .specify/
│   ├── agent.md           # AI代理配置和上下文
│   └── constitution.md    # 项目治理原则
├── specs/                 # 功能规格说明目录
├── scripts/               # 自动化脚本
└── README.md             # 项目文档
```

### 第1步：建立项目原则

使用 `/constitution` 命令创建项目的治理原则：

```bash
/constitution 创建专注于代码质量、测试标准、用户体验一致性和性能要求的原则
```

这将创建或更新 `.specify/constitution.md` 文件，其中包含指导所有开发决策的原则。

### 第2步：创建功能规格说明

使用 `/specify` 命令开始新功能：

```bash
/specify 构建一个用户仪表板，显示关键指标和最近活动
```

这将：
- 自动创建新的功能分支
- 生成功能规格说明文档
- 设置适当的目录结构

### 第3步：澄清需求

使用 `/clarify` 命令确保规格说明完整：

```bash
/clarify
```

AI将分析您的规格说明并询问澄清问题，以确保所有需求都得到充分定义。

### 第4步：创建实施计划

使用 `/plan` 命令创建技术计划：

```bash
/plan 使用React和TypeScript，后端使用Node.js和PostgreSQL
```

这将生成详细的技术实施计划，包括架构决策和技术选择。

### 第5步：生成任务

使用 `/tasks` 命令创建可执行的任务列表：

```bash
/tasks
```

这将分析您的计划并生成具体的实施任务。

### 第6步：分析一致性

使用 `/analyze` 命令验证所有工件的一致性：

```bash
/analyze
```

这将检查规格说明、计划和任务之间的一致性和完整性。

### 第7步：实施功能

使用 `/implement` 命令执行所有任务：

```bash
/implement
```

AI将根据您的规格说明和计划系统地实施功能。

</details>

## 🔍 故障排除

### 常见问题

**Q: 我收到"未找到AI代理"错误**
A: 确保您已安装并正确配置了支持的AI代理之一。运行 `specify check` 来验证您的设置。

**Q: 初始化失败并出现权限错误**
A: 确保您对目标目录有写权限，或使用 `sudo` 运行命令（如果适当）。

**Q: 斜杠命令不工作**
A: 确保您在正确初始化的Specify项目中，并且您的AI代理支持自定义命令。

**Q: 生成的代码质量不佳**
A: 检查您的 `constitution.md` 文件是否包含清晰的质量标准，并确保您的规格说明足够详细。

### 获取帮助

如果您遇到问题：

1. 检查我们的[文档](./docs/)
2. 搜索现有的[GitHub issues](https://github.com/github/spec-kit/issues)
3. 创建新的issue并提供详细信息

## 👥 维护者

该项目由GitHub团队维护。有关贡献指南，请参阅[CONTRIBUTING.md](./CONTRIBUTING.md)。

## 💬 支持

- 📖 [文档](./docs/)
- 🐛 [报告问题](https://github.com/github/spec-kit/issues)
- 💬 [讨论](https://github.com/github/spec-kit/discussions)

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和研究人员。特别感谢AI社区在推进规格驱动开发方法论方面的持续工作。

## 📄 许可证

该项目根据MIT许可证授权。有关详细信息，请参阅[LICENSE](./LICENSE)文件。

---

<div align="center">
    <p><strong>使用Spec Kit开始您的规格驱动开发之旅！</strong></p>
    <p><em>更快地构建更好的软件。</em></p>
</div>