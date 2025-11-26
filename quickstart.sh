#!/bin/bash
# 🦸 어벤져스 AI 스택 빠른 시작 스크립트

set -e

echo "════════════════════════════════════════════════════════════"
echo "🦸 Avengers AI Stack - Quick Start Setup"
echo "════════════════════════════════════════════════════════════"
echo ""

# 1. 환경 변수 파일 확인
if [ ! -f ".env" ]; then
    echo "📝 Creating .env from .env.example..."
    cp .env.example .env
    echo "✅ .env file created. Please edit it with your API keys:"
    echo "   - OPENAI_API_KEY"
    echo "   - ANTHROPIC_API_KEY"
    echo "   - GOOGLE_API_KEY"
    echo "   - LANGFUSE_PUBLIC_KEY"
    echo "   - LANGFUSE_SECRET_KEY"
    echo ""
    echo "⚠️  Edit .env file and then re-run this script"
    exit 1
else
    echo "✅ .env file found"
fi

# 2. Docker 설치 확인
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first:"
    echo "   https://docs.docker.com/get-docker/"
    exit 1
fi
echo "✅ Docker found: $(docker --version)"

# 3. Docker Compose 설치 확인
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first:"
    echo "   https://docs.docker.com/compose/install/"
    exit 1
fi
echo "✅ Docker Compose found: $(docker-compose --version)"

# 4. 디렉토리 구조 확인
echo ""
echo "📁 Checking directory structure..."

if [ ! -d "config" ]; then
    mkdir -p config
    echo "✅ Created config/ directory"
else
    echo "✅ config/ directory exists"
fi

if [ ! -f "config/litellm_config.yaml" ]; then
    echo "✅ litellm_config.yaml exists"
else
    echo "ℹ️  litellm_config.yaml already exists"
fi

# 5. Python 환경 설정
echo ""
echo "🐍 Setting up Python environment..."

if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# 6. Python 종속성 설치
echo ""
echo "📦 Installing Python dependencies..."
source .venv/bin/activate
pip install -q --upgrade pip
pip install -q -r requirements.txt
echo "✅ Python dependencies installed"

# 7. Docker 스택 실행
echo ""
echo "🐳 Starting Docker services..."
echo "   Services: Qdrant, PostgreSQL, Redis, n8n, Neo4j, LiteLLM"
echo ""

docker-compose -f docker-compose.avengers.yml up -d

# 8. 서비스 상태 확인
echo ""
echo "⏳ Waiting for services to start (30 seconds)..."
sleep 30

echo ""
echo "📊 Checking service status..."
docker-compose -f docker-compose.avengers.yml ps

# 9. 초기화 테스트
echo ""
echo "🧪 Running initialization tests..."
python init_avengers_stack.py

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ Avengers AI Stack is Ready!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📊 Access URLs:"
echo "   • LiteLLM:    http://localhost:4000"
echo "   • n8n:        http://localhost:5678"
echo "   • Qdrant:     http://localhost:6333"
echo "   • Neo4j:      http://localhost:7474"
echo "   • PostgreSQL: localhost:5432"
echo "   • Redis:      localhost:6379"
echo ""
echo "🌐 Langfuse Dashboard (Cloud):"
echo "   https://us.cloud.langfuse.com"
echo ""
echo "📖 Next Steps:"
echo "   1. Create a Python script using LiteLLM:"
echo "      from litellm import completion"
echo ""
echo "   2. Access n8n to create AI workflows:"
echo "      http://localhost:5678"
echo ""
echo "   3. Monitor LLM calls in Langfuse:"
echo "      https://us.cloud.langfuse.com"
echo ""
echo "💡 Useful Commands:"
echo "   • View logs:    docker-compose -f docker-compose.avengers.yml logs -f"
echo "   • Stop stack:   docker-compose -f docker-compose.avengers.yml down"
echo "   • Restart:      docker-compose -f docker-compose.avengers.yml restart"
echo ""
