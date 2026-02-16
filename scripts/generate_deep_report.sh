#!/bin/bash
set -e

DATE=$(date +%Y-%m-%d)
REPO_DIR="/home/ubuntu/.openclaw/workspace/maxen-news"
DOCS_DIR="$REPO_DIR/docs/$DATE"

mkdir -p "$DOCS_DIR"
cd "$DOCS_DIR"

echo "🔍 開始深度分析新聞..."

# 第一步：平行抓取基礎資料
echo "📥 Step 1: 抓取基礎資料..."
~/.agents/skills/search/scripts/search.sh '{"query": "GitHub trending repositories today", "max_results": 10}' > github.json &
~/.agents/skills/search/scripts/search.sh '{"query": "Product Hunt trending AI products today", "max_results": 10}' > producthunt.json &
wait

echo "✅ 基礎資料抓取完成"

# 第二步：深度讀取每個項目（這部分需要 OpenClaw 的 agent 來執行）
echo "📖 Step 2: 準備深度分析任務..."

# 創建深度分析任務描述
cat > analysis_task.txt << 'EOF'
請執行以下深度分析任務：

## GitHub Trending 深度分析
閱讀 github.json 中的前 10 個倉庫，對每個倉庫：
1. 訪問倉庫頁面，閱讀 README
2. 分析技術棧和架構
3. 總結主要功能和創新點
4. 評估實用性和影響力
5. 提取關鍵程式碼片段（如果有亮點）

## Product Hunt 深度分析
閱讀 producthunt.json 中的前 10 個產品，對每個產品：
1. 訪問產品頁面
2. 分析產品定位和目標用戶
3. 總結核心功能和特色
4. 評估市場價值和競爭力
5. 記錄價格和商業模式

## Hacker News 深度分析
訪問 https://news.ycombinator.com/，對前 10 篇文章：
1. 閱讀文章全文
2. 總結核心觀點
3. 分析討論熱度和社群反應
4. 提取有價值的評論觀點

## Hugging Face 深度分析
訪問 https://huggingface.co/posts?sort=trending，對前 10 篇：
1. 閱讀完整文章內容
2. 分析技術細節和創新
3. 總結實驗結果和發現
4. 評估對 AI 領域的影響

將所有分析結果整理成結構化的 JSON 格式。
EOF

echo "📝 分析任務已準備，等待 agent 執行..."
