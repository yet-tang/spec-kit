#!/usr/bin/env pwsh

# UX 需求澄清脚本 (PowerShell版本)
# 帮助识别和澄清用户体验设计中的模糊需求和缺失信息

param(
    [string]$Focus = "all",
    [switch]$Verbose = $false,
    [switch]$Help = $false,
    [string]$Arguments = ""
)

# 显示帮助信息
function Show-Help {
    Write-Host @"
UX 需求澄清脚本 - 识别 UX 设计中的模糊需求和缺失信息

用法: ./clarify-ux-requirements.ps1 [选项] [规格文件路径]
选项:
  -Verbose               显示详细输出
  -Focus FOCUS          重点关注区域 (research|interaction|visual|accessibility|all)
  -Help                 显示此帮助信息
  -Arguments ARGUMENTS  规格文件路径

示例:
  ./clarify-ux-requirements.ps1 specs/001-user-authentication/spec.md
  ./clarify-ux-requirements.ps1 -Focus interaction specs/001-user-authentication/spec.md
  ./clarify-ux-requirements.ps1 -Verbose -Focus visual specs/001-user-authentication/spec.md
"@
}

# 解析参数
if ($Help) {
    Show-Help
    exit 0
}

# 从Arguments参数中解析规格文件路径
$SpecFile = ""
if ($Arguments) {
    $SpecFile = $Arguments
}

# 如果没有指定规格文件，尝试自动发现
if (-not $SpecFile) {
    # 获取当前分支
    try {
        $CurrentBranch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -ne 0) {
            $CurrentBranch = "unknown"
        }
    } catch {
        $CurrentBranch = "unknown"
    }

    # 尝试找到规格文件
    $PossibleFiles = @(
        "specs/$CurrentBranch/spec.md",
        "specs/spec.md",
        "spec.md"
    )

    foreach ($file in $PossibleFiles) {
        if (Test-Path $file) {
            $SpecFile = $file
            break
        }
    }

    if (-not $SpecFile) {
        Write-Error "错误: 无法找到规格文件，请指定文件路径"
        exit 1
    }
}

# 验证规格文件存在
if (-not (Test-Path $SpecFile)) {
    Write-Error "错误: 规格文件不存在: $SpecFile"
    exit 1
}

function Write-Log {
    param([string]$Message)
    if ($Verbose) {
        Write-Host "[INFO] $Message"
    }
}

Write-Log "开始 UX 需求澄清分析: $SpecFile"
Write-Log "重点关注区域: $Focus"

# 初始化检查结果
$script:MissingUxInfo = @()
$script:ClarificationNeeded = @()
$script:UxRisks = @()
$script:Recommendations = @()

# 检查 UX 设计章节的函数
function Test-UxSection {
    param(
        [string]$Section,
        [string]$Description,
        [string]$Importance = "high"
    )

    $content = Get-Content $SpecFile -Raw
    if ($content -match "## $Section") {
        Write-Log "✓ 找到 UX 章节: $Section"

        # 检查章节内容是否充分
        $sectionContent = ($content -split "## $Section")[1] -split "## " | Select-Object -First 1
        if (-not $sectionContent -or $sectionContent -match "\[需要澄清\]") {
            $script:ClarificationNeeded += "$Section: $Description (内容不充分)"
        }
    } else {
        if ($Importance -eq "high") {
            $script:MissingUxInfo += "$Section: $Description (重要缺失)"
        } else {
            $script:ClarificationNeeded += "$Section: $Description (建议补充)"
        }
        Write-Log "✗ 缺失 UX 章节: $Section"
    }
}

# 检查用户研究内容
function Test-UserResearch {
    Write-Log "检查用户研究内容..."

    $content = Get-Content $SpecFile -Raw
    if ($content -match "目标用户群体") {
        # 检查是否有具体的用户描述
        if ($content -notmatch "主要用户群体|次要用户群体") {
            $script:ClarificationNeeded += "用户研究: 需要详细定义主要和次要用户群体"
        }
    } else {
        $script:MissingUxInfo += "用户研究: 缺少目标用户群体定义"
    }

    if ($content -notmatch "用户使用场景|用户目标和动机") {
        $script:ClarificationNeeded += "用户研究: 需要详细描述用户使用场景和目标"
    }
}

# 检查交互设计内容
function Test-InteractionDesign {
    Write-Log "检查交互设计内容..."

    $content = Get-Content $SpecFile -Raw
    if ($content -notmatch "交互模式|反馈机制|错误预防和恢复") {
        $script:ClarificationNeeded += "交互设计: 需要定义交互模式、反馈机制和错误处理"
    }
}

# 检查视觉设计内容
function Test-VisualDesign {
    Write-Log "检查视觉设计内容..."

    $content = Get-Content $SpecFile -Raw
    if ($content -notmatch "视觉层次|布局和排版|色彩和对比") {
        $script:ClarificationNeeded += "视觉设计: 需要定义视觉层次、布局和色彩系统"
    }
}

# 检查可访问性内容
function Test-Accessibility {
    Write-Log "检查可访问性内容..."

    $content = Get-Content $SpecFile -Raw
    if ($content -notmatch "WCAG|无障碍访问|可访问性标准") {
        $script:ClarificationNeeded += "可访问性: 需要明确无障碍设计标准"
    }
}

# 检查响应式设计
function Test-ResponsiveDesign {
    Write-Log "检查响应式设计内容..."

    $content = Get-Content $SpecFile -Raw
    if ($content -notmatch "响应式设计|设备兼容性|屏幕尺寸") {
        $script:ClarificationNeeded += "响应式设计: 需要定义设备兼容性要求"
    }
}

# 根据关注区域执行检查
switch ($Focus) {
    "research" {
        Test-UserResearch
    }
    "interaction" {
        Test-InteractionDesign
    }
    "visual" {
        Test-VisualDesign
    }
    "accessibility" {
        Test-Accessibility
    }
    "all" {
        Test-UserResearch
        Test-InteractionDesign
        Test-VisualDesign
        Test-Accessibility
        Test-ResponsiveDesign
    }
}

# 检查通用 UX 章节
Test-UxSection "用户体验设计 (UX Design)" "整体 UX 设计章节" "high"

# 输出结果
Write-Host ""
Write-Host "🎨 UX 需求澄清分析结果"
Write-Host "===================="
Write-Host "规格文件: $SpecFile"
Write-Host "关注区域: $Focus"
Write-Host ""

# 分类输出问题
if ($script:MissingUxInfo.Count -gt 0) {
    Write-Host "🚨 缺失的重要 UX 信息:"
    foreach ($item in $script:MissingUxInfo) {
        Write-Host "   - $item"
    }
    Write-Host ""
}

if ($script:ClarificationNeeded.Count -gt 0) {
    Write-Host "❓ 需要澄清的 UX 问题:"
    foreach ($item in $script:ClarificationNeeded) {
        Write-Host "   - $item"
    }
    Write-Host ""
}

# 生成澄清问题
Write-Host "🔍 建议的澄清问题:"
Write-Host "=================="

if ($Focus -eq "all" -or $Focus -eq "research") {
    Write-Host "用户研究相关:"
    Write-Host "1. 主要用户群体的年龄、职业、技术水平等特征是什么？"
    Write-Host "2. 用户在什么场景下会使用此功能？他们的目标是什么？"
    Write-Host "3. 用户当前遇到的主要痛点是什么？"
    Write-Host "4. 是否有特殊用户群体需要考虑（如老年人、残障人士）？"
    Write-Host ""
}

if ($Focus -eq "all" -or $Focus -eq "interaction") {
    Write-Host "交互设计相关:"
    Write-Host "1. 用户主要通过什么设备使用此功能（桌面、移动、平板）？"
    Write-Host "2. 用户期望的主要交互方式是什么（点击、滑动、键盘）？"
    Write-Host "3. 系统应该如何向用户反馈操作结果？"
    Write-Host "4. 当用户操作错误时，系统应该如何提示和帮助？"
    Write-Host ""
}

if ($Focus -eq "all" -or $Focus -eq "visual") {
    Write-Host "视觉设计相关:"
    Write-Host "1. 是否有现有的设计系统或品牌规范需要遵循？"
    Write-Host "2. 信息的重要程度如何？应该如何通过视觉设计体现？"
    Write-Host "3. 界面整体希望传达什么感觉（简洁、专业、友好）？"
    Write-Host "4. 是否有特殊的色彩偏好或禁忌？"
    Write-Host ""
}

if ($Focus -eq "all" -or $Focus -eq "accessibility") {
    Write-Host "可访问性相关:"
    Write-Host "1. 需要符合哪个级别的可访问性标准（WCAG A、AA、AAA）？"
    Write-Host "2. 是否需要支持屏幕阅读器？"
    Write-Host "3. 是否需要完整的键盘导航支持？"
    Write-Host "4. 是否有色彩对比度的具体要求？"
    Write-Host ""
}

# 提供改进建议
Write-Host "💡 UX 设计改进建议:"
Write-Host "=================="
if ($script:MissingUxInfo.Count -gt 0) {
    Write-Host "1. 补充缺失的 UX 设计章节，特别是用户研究和交互设计"
}
if ($script:ClarificationNeeded.Count -gt 0) {
    Write-Host "2. 详细回答上述澄清问题，完善 UX 需求定义"
}
Write-Host "3. 考虑创建用户画像和用户旅程地图"
Write-Host "4. 进行竞品分析，了解行业最佳实践"
Write-Host "5. 计划可用性测试，验证设计假设"

# 设置退出码
if ($script:MissingUxInfo.Count -gt 0) {
    exit 1
} elseif ($script:ClarificationNeeded.Count -gt 0) {
    exit 2
} else {
    Write-Host "✅ UX 需求定义较为完整，建议进行深度验证"
    exit 0
}