---
description: "功能开发的实施计划模板"
scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

# 实施计划：[功能]

**分支**: `[###-功能名称]` | **日期**: [日期] | **规范**: [链接]
**输入**: 来自 `/specs/[###-功能名称]/spec.md` 的功能规范

## 执行流程（/plan 命令范围）
```
1. 从输入路径加载功能规范
   → 如果未找到：错误 "在 {路径} 处未找到功能规范"
2. 填写技术上下文（扫描 NEEDS CLARIFICATION）
   → 从文件系统结构或上下文检测项目类型（web=前端+后端，mobile=应用+API）
   → 基于项目类型设置结构决策
3. 基于宪法文档内容填写宪法检查部分。
4. 评估下面的宪法检查部分
   → 如果存在违规：在复杂性跟踪中记录
   → 如果无法证明合理性：错误 "首先简化方法"
   → 更新进度跟踪：初始宪法检查
5. 执行阶段0 → research.md
   → 如果仍有 NEEDS CLARIFICATION：错误 "解决未知问题"
6. 执行阶段1 → 合约、data-model.md、quickstart.md、代理特定模板文件（例如，Claude Code的`CLAUDE.md`，GitHub Copilot的`.github/copilot-instructions.md`，Gemini CLI的`GEMINI.md`，Qwen Code的`QWEN.md`或opencode的`AGENTS.md`）。
7. 重新评估宪法检查部分
   → 如果有新违规：重构设计，返回阶段1
   → 更新进度跟踪：设计后宪法检查
8. 计划阶段2 → 描述任务生成方法（不要创建tasks.md）
9. 停止 - 准备执行 /tasks 命令
```

**重要**: /plan 命令在步骤7停止。阶段2-4由其他命令执行：
- 阶段2：/tasks 命令创建 tasks.md
- 阶段3-4：实施执行（手动或通过工具）

## 摘要
[从功能规范中提取：主要需求 + 来自研究的技术方法]

## 技术上下文
**语言/版本**: [例如，Python 3.11、Swift 5.9、Rust 1.75 或 NEEDS CLARIFICATION]  
**主要依赖**: [例如，FastAPI、UIKit、LLVM 或 NEEDS CLARIFICATION]  
**存储**: [如果适用，例如，PostgreSQL、CoreData、文件 或 N/A]  
**测试**: [例如，pytest、XCTest、cargo test 或 NEEDS CLARIFICATION]  
**目标平台**: [例如，Linux服务器、iOS 15+、WASM 或 NEEDS CLARIFICATION]
**项目类型**: [单一/web/移动 - 决定源结构]  
**性能目标**: [特定领域，例如，1000 req/s、10k lines/sec、60 fps 或 NEEDS CLARIFICATION]  
**约束**: [特定领域，例如，<200ms p95、<100MB内存、离线能力 或 NEEDS CLARIFICATION]  
**规模/范围**: [特定领域，例如，10k用户、1M LOC、50个屏幕 或 NEEDS CLARIFICATION]

## 宪法检查
*门控：必须在阶段0研究前通过。在阶段1设计后重新检查。*

[基于宪法文件确定的门控]

## 项目结构

### 文档（此功能）
```
specs/[###-功能]/
├── plan.md              # 此文件（/plan 命令输出）
├── research.md          # 阶段0输出（/plan 命令）
├── data-model.md        # 阶段1输出（/plan 命令）
├── quickstart.md        # 阶段1输出（/plan 命令）
├── contracts/           # 阶段1输出（/plan 命令）
└── tasks.md             # 阶段2输出（/tasks 命令 - 不由 /plan 创建）
```

### 源代码（仓库根目录）
<!--
  需要操作：用此功能的具体布局替换下面的占位符树。删除未使用的选项并
  用真实路径扩展所选结构（例如，apps/admin、packages/something）。交付的计划
  不得包含选项标签。
-->
```
# [如果未使用则删除] 选项1：单一项目（默认）
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [如果未使用则删除] 选项2：Web应用程序（检测到"前端"+"后端"时）
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [如果未使用则删除] 选项3：移动 + API（检测到"iOS/Android"时）
api/
└── [与上面的后端相同]

ios/ 或 android/
└── [平台特定结构：功能模块、UI流程、平台测试]
```

**结构决策**: [记录所选结构并引用上面捕获的真实目录]

## 阶段0：大纲和研究
1. **从上面的技术上下文中提取未知项**：
   - 对于每个 NEEDS CLARIFICATION → 研究任务
   - 对于每个依赖 → 最佳实践任务
   - 对于每个集成 → 模式任务

2. **生成并派发研究代理**：
   ```
   对于技术上下文中的每个未知项：
     任务："为 {功能上下文} 研究 {未知项}"
   对于每个技术选择：
     任务："在 {领域} 中找到 {技术} 的最佳实践"
   ```

3. **在 `research.md` 中整合发现**，使用格式：
   - 决策：[选择了什么]
   - 理由：[为什么选择]
   - 考虑的替代方案：[还评估了什么]

**输出**: 解决所有 NEEDS CLARIFICATION 的 research.md

## 阶段1：设计和合约
*先决条件：research.md 完成*

### 1.1 UX 设计设计
*基于功能规范中的 UX 要求创建详细设计*

1. **用户研究深化** → `ux-research.md`：
   - 扩展用户画像和使用场景
   - 用户旅程地图详细化
   - 竞品分析和最佳实践

2. **信息架构设计** → `ux-information-architecture.md`：
   - 内容组织结构
   - 导航层级和标签系统
   - 内容优先级定义

3. **交互设计规范** → `ux-interaction-design.md`：
   - 核心交互流程设计
   - 交互模式和手势支持
   - 反馈机制和错误处理

4. **视觉设计系统** → `ux-visual-design.md`：
   - 设计系统和组件规范
   - 色彩、字体、间距系统
   - 图标和视觉元素

5. **原型设计** → `ux-prototype.md`：
   - 低保真原型（线框图）
   - 高保真原型（视觉稿）
   - 交互原型

### 1.2 技术设计
1. **从功能规范中提取实体** → `data-model.md`：
   - 实体名称、字段、关系
   - 来自需求的验证规则
   - 如果适用的状态转换

2. **从功能需求生成API合约**：
   - 对于每个用户操作 → 端点
   - 使用标准REST/GraphQL模式
   - 将OpenAPI/GraphQL模式输出到 `/contracts/`

3. **从合约生成合约测试**：
   - 每个端点一个测试文件
   - 断言请求/响应模式
   - 测试必须失败（尚无实现）

4. **从用户故事中提取测试场景**：
   - 每个故事 → 集成测试场景
   - 快速开始测试 = 故事验证步骤

### 1.3 上下文更新
5. **增量更新代理文件**（O(1)操作）：
   - 运行 `{SCRIPT}`
     **重要**: 完全按照上面指定的执行。不要添加或删除任何参数。
   - 如果存在：仅从当前计划添加新技术
   - 保留标记之间的手动添加
   - 更新最近更改（保留最后3个）
   - 保持在150行以下以提高令牌效率
   - 输出到仓库根目录

**输出**: ux-research.md、ux-information-architecture.md、ux-interaction-design.md、ux-visual-design.md、ux-prototype.md、data-model.md、/contracts/*、失败的测试、quickstart.md、代理特定文件

## 阶段2：任务规划方法
*本节描述 /tasks 命令将执行的操作 - 在 /plan 期间不要执行*

**任务生成策略**：
- 加载 `.specify/templates/tasks-template.md` 作为基础
- 从阶段1设计文档（UX设计、合约、数据模型、快速开始）生成任务

**UX 设计任务**：
- 用户研究和画像任务
- 信息架构设计任务 [P]
- 交互设计任务 [P]
- 视觉设计任务 [P]
- 原型设计和测试任务

**技术实施任务**：
- 每个合约 → 合约测试任务 [P]
- 每个实体 → 模型创建任务 [P]
- 每个用户故事 → 集成测试任务
- 使测试通过的实施任务

**UX 实施任务**：
- UI组件开发任务
- 交互功能实现任务
- 响应式设计实现任务
- 可访问性实现任务

**排序策略**：
- TDD顺序：测试在实施之前 
- 依赖顺序：模型在服务之前在UI之前
- 标记 [P] 用于并行执行（独立文件）

**预估输出**: tasks.md 中25-30个编号、有序的任务

**重要**: 此阶段由 /tasks 命令执行，不是由 /plan 执行

## 阶段3+：未来实施
*这些阶段超出了 /plan 命令的范围*

**阶段3**: 任务执行（/tasks 命令创建 tasks.md）  
**阶段4**: 实施（按照宪法原则执行 tasks.md）  
**阶段5**: 验证（运行测试、执行 quickstart.md、性能验证）

## 复杂性跟踪
*仅在宪法检查有必须证明合理的违规时填写*

| 违规 | 为什么需要 | 拒绝更简单替代方案的原因 |
|------|------------|-------------------------|
| [例如，第4个项目] | [当前需要] | [为什么3个项目不够] |
| [例如，仓库模式] | [具体问题] | [为什么直接DB访问不够] |


## 进度跟踪
*此检查清单在执行流程期间更新*

**阶段状态**：
- [ ] 阶段0：研究完成（/plan 命令）
- [ ] 阶段1：设计完成（/plan 命令）
- [ ] 阶段2：任务规划完成（/plan 命令 - 仅描述方法）
- [ ] 阶段3：任务生成（/tasks 命令）
- [ ] 阶段4：实施完成
- [ ] 阶段5：验证通过

**门控状态**：
- [ ] 初始宪法检查：通过
- [ ] 设计后宪法检查：通过
- [ ] 所有 NEEDS CLARIFICATION 已解决
- [ ] 复杂性偏差已记录

---
*基于宪法 v2.1.1 - 参见 `/memory/constitution.md`*