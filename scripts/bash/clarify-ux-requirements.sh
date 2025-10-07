#!/usr/bin/env bash

set -euo pipefail

# UX 需求澄清脚本
- 帮助识别和澄清用户体验设计中的模糊需求和缺失信息

# 解析参数
VERBOSE=false
SPEC_FILE=""
FOCUS_AREA=""

show_help() {
    cat << EOF
UX 需求澄清脚本 - 识别 UX 设计中的模糊需求和缺失信息

用法: $0 [选项] [规格文件路径]
选项:
  -v, --verbose           显示详细输出
  -f, --focus FOCUS       重点关注区域 (research|interaction|visual|accessibility|all)
  -h, --help              显示此帮助信息

示例:
  $0 specs/001-user-authentication/spec.md
  $0 -f interaction specs/001-user-authentication/spec.md
  $0 -v -f visual specs/001-user-authentication/spec.md
EOF
}

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--focus)
            FOCUS_AREA="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "错误: 未知选项 $1" >&2
            show_help
            exit 1
            ;;
        *)
            SPEC_FILE="$1"
            shift
            ;;
    esac
done

# 设置默认值
if [[ -z "$FOCUS_AREA" ]]; then
    FOCUS_AREA="all"
fi

# 如果没有指定规格文件，尝试自动发现
if [[ -z "$SPEC_FILE" ]]; then
    # 获取当前分支
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

    # 尝试找到规格文件
    POSSIBLE_FILES=(
        "specs/$CURRENT_BRANCH/spec.md"
        "specs/spec.md"
        "spec.md"
    )

    for file in "${POSSIBLE_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            SPEC_FILE="$file"
            break
        fi
    done

    if [[ -z "$SPEC_FILE" ]]; then
        echo "错误: 无法找到规格文件，请指定文件路径" >&2
        exit 1
    fi
fi

# 验证规格文件存在
if [[ ! -f "$SPEC_FILE" ]]; then
    echo "错误: 规格文件不存在: $SPEC_FILE" >&2
    exit 1
fi

log() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo "[INFO] $1"
    fi
}

log "开始 UX 需求澄清分析: $SPEC_FILE"
log "重点关注区域: $FOCUS_AREA"

# 初始化检查结果
MISSING_UX_INFO=()
CLARIFICATION_NEEDED=()
UX_RISKS=()
RECOMMENDATIONS=()

# 检查 UX 设计章节的函数
check_ux_section() {
    local section="$1"
    local description="$2"
    local importance="${3:-high}"

    if grep -q "^## $section" "$SPEC_FILE"; then
        log "✓ 找到 UX 章节: $section"

        # 检查章节内容是否充分
        content=$(sed -n "/^## $section/,/^## /p" "$SPEC_FILE" | sed '$d')
        if [[ -z "$content" ]] || [[ "$content" =~ \[需要澄清\] ]]; then
            CLARIFICATION_NEEDED+=("$section: $description (内容不充分)")
        fi
    else
        if [[ "$importance" == "high" ]]; then
            MISSING_UX_INFO+=("$section: $description (重要缺失)")
        else
            CLARIFICATION_NEEDED+=("$section: $description (建议补充)")
        fi
        log "✗ 缺失 UX 章节: $section"
    fi
}

# 检查用户研究内容
check_user_research() {
    log "检查用户研究内容..."

    if grep -q "目标用户群体" "$SPEC_FILE"; then
        # 检查是否有具体的用户描述
        if ! grep -q "主要用户群体\|次要用户群体" "$SPEC_FILE"; then
            CLARIFICATION_NEEDED+=("用户研究: 需要详细定义主要和次要用户群体")
        fi
    else
        MISSING_UX_INFO+=("用户研究: 缺少目标用户群体定义")
    fi

    if ! grep -q "用户使用场景\|用户目标和动机" "$SPEC_FILE"; then
        CLARIFICATION_NEEDED+=("用户研究: 需要详细描述用户使用场景和目标")
    fi
}

# 检查交互设计内容
check_interaction_design() {
    log "检查交互设计内容..."

    if ! grep -q "交互模式\|反馈机制\|错误预防和恢复" "$SPEC_FILE"; then
        CLARIFICATION_NEEDED+=("交互设计: 需要定义交互模式、反馈机制和错误处理")
    fi
}

# 检查视觉设计内容
check_visual_design() {
    log "检查视觉设计内容..."

    if ! grep -q "视觉层次\|布局和排版\|色彩和对比" "$SPEC_FILE"; then
        CLARIFICATION_NEEDED+=("视觉设计: 需要定义视觉层次、布局和色彩系统")
    fi
}

# 检查可访问性内容
check_accessibility() {
    log "检查可访问性内容..."

    if ! grep -q "WCAG\|无障碍访问\|可访问性标准" "$SPEC_FILE"; then
        CLARIFICATION_NEEDED+=("可访问性: 需要明确无障碍设计标准")
    fi
}

# 检查响应式设计
check_responsive_design() {
    log "检查响应式设计内容..."

    if ! grep -q "响应式设计\|设备兼容性\|屏幕尺寸" "$SPEC_FILE"; then
        CLARIFICATION_NEEDED+=("响应式设计: 需要定义设备兼容性要求")
    fi
}

# 根据关注区域执行检查
case "$FOCUS_AREA" in
    "research")
        check_user_research
        ;;
    "interaction")
        check_interaction_design
        ;;
    "visual")
        check_visual_design
        ;;
    "accessibility")
        check_accessibility
        ;;
    "all")
        check_user_research
        check_interaction_design
        check_visual_design
        check_accessibility
        check_responsive_design
        ;;
esac

# 检查通用 UX 章节
check_ux_section "用户体验设计 (UX Design)" "整体 UX 设计章节" "high"

# 输出结果
echo
echo "🎨 UX 需求澄清分析结果"
echo "===================="
echo "规格文件: $SPEC_FILE"
echo "关注区域: $FOCUS_AREA"
echo

# 分类输出问题
if [[ ${#MISSING_UX_INFO[@]} -gt 0 ]]; then
    echo "🚨 缺失的重要 UX 信息:"
    for item in "${MISSING_UX_INFO[@]}"; do
        echo "   - $item"
    done
    echo
fi

if [[ ${#CLARIFICATION_NEEDED[@]} -gt 0 ]]; then
    echo "❓ 需要澄清的 UX 问题:"
    for item in "${CLARIFICATION_NEEDED[@]}"; do
        echo "   - $item"
    done
    echo
fi

# 生成澄清问题
echo "🔍 建议的澄清问题:"
echo "=================="

if [[ "$FOCUS_AREA" == "all" || "$FOCUS_AREA" == "research" ]]; then
    echo "用户研究相关:"
    echo "1. 主要用户群体的年龄、职业、技术水平等特征是什么？"
    echo "2. 用户在什么场景下会使用此功能？他们的目标是什么？"
    echo "3. 用户当前遇到的主要痛点是什么？"
    echo "4. 是否有特殊用户群体需要考虑（如老年人、残障人士）？"
    echo
fi

if [[ "$FOCUS_AREA" == "all" || "$FOCUS_AREA" == "interaction" ]]; then
    echo "交互设计相关:"
    echo "1. 用户主要通过什么设备使用此功能（桌面、移动、平板）？"
    echo "2. 用户期望的主要交互方式是什么（点击、滑动、键盘）？"
    echo "3. 系统应该如何向用户反馈操作结果？"
    echo "4. 当用户操作错误时，系统应该如何提示和帮助？"
    echo
fi

if [[ "$FOCUS_AREA" == "all" || "$FOCUS_AREA" == "visual" ]]; then
    echo "视觉设计相关:"
    echo "1. 是否有现有的设计系统或品牌规范需要遵循？"
    echo "2. 信息的重要程度如何？应该如何通过视觉设计体现？"
    echo "3. 界面整体希望传达什么感觉（简洁、专业、友好）？"
    echo "4. 是否有特殊的色彩偏好或禁忌？"
    echo
fi

if [[ "$FOCUS_AREA" == "all" || "$FOCUS_AREA" == "accessibility" ]]; then
    echo "可访问性相关:"
    echo "1. 需要符合哪个级别的可访问性标准（WCAG A、AA、AAA）？"
    echo "2. 是否需要支持屏幕阅读器？"
    echo "3. 是否需要完整的键盘导航支持？"
    echo "4. 是否有色彩对比度的具体要求？"
    echo
fi

# 提供改进建议
echo "💡 UX 设计改进建议:"
echo "=================="
if [[ ${#MISSING_UX_INFO[@]} -gt 0 ]]; then
    echo "1. 补充缺失的 UX 设计章节，特别是用户研究和交互设计"
fi
if [[ ${#CLARIFICATION_NEEDED[@]} -gt 0 ]]; then
    echo "2. 详细回答上述澄清问题，完善 UX 需求定义"
fi
echo "3. 考虑创建用户画像和用户旅程地图"
echo "4. 进行竞品分析，了解行业最佳实践"
echo "5. 计划可用性测试，验证设计假设"

# 设置退出码
if [[ ${#MISSING_UX_INFO[@]} -gt 0 ]]; then
    exit 1
elif [[ ${#CLARIFICATION_NEEDED[@]} -gt 0 ]]; then
    exit 2
else
    echo "✅ UX 需求定义较为完整，建议进行深度验证"
    exit 0
fi