#!/bin/bash

# 🧙‍♂️ Docker 기반 AI 인프라 스택 설치 마법사
# 단계별로 안내하며 설치를 도와드립니다

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 아이콘
ROCKET="🚀"
CHECK="✅"
WARN="⚠️"
INFO="ℹ️"
DOCKER="🐳"
KEY="🔑"

echo -e "${PURPLE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║  ${ROCKET} Docker 기반 AI 인프라 스택 설치 마법사           ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 1. 사전 확인
echo -e "${CYAN}[1/5] ${DOCKER} 사전 환경 확인...${NC}"
echo ""

if ! command -v docker &> /dev/null; then
    echo -e "${RED}${WARN} Docker가 설치되지 않았습니다!${NC}"
    echo "Docker Desktop을 먼저 설치해주세요: https://www.docker.com/products/docker-desktop"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}${WARN} Docker가 실행되지 않았습니다!${NC}"
    echo "Docker Desktop을 실행해주세요."
    exit 1
fi

DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
echo -e "${GREEN}${CHECK} Docker: v${DOCKER_VERSION}${NC}"

COMPOSE_VERSION=$(docker-compose --version | awk '{print $4}' | sed 's/,//')
echo -e "${GREEN}${CHECK} Docker Compose: ${COMPOSE_VERSION}${NC}"
echo ""

# 2. 환경 변수 설정
echo -e "${CYAN}[2/5] ${KEY} 환경 변수 설정...${NC}"
echo ""

if [ ! -f .env ]; then
    echo -e "${YELLOW}${INFO} .env 파일을 생성합니다...${NC}"
    cp .env.example .env
    echo -e "${GREEN}${CHECK} .env 파일 생성 완료${NC}"
else
    echo -e "${GREEN}${CHECK} .env 파일이 이미 존재합니다${NC}"
fi

echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}${WARN} 중요: API 키 설정이 필요합니다!${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "다음 서비스의 API 키를 .env 파일에 설정해야 합니다:"
echo ""
echo "  1. OpenAI API Key (필수)"
echo "     → https://platform.openai.com/api-keys"
echo ""
echo "  2. Anthropic API Key (선택)"
echo "     → https://console.anthropic.com/settings/keys"
echo ""
echo "  3. Google AI API Key (선택)"
echo "     → https://makersuite.google.com/app/apikey"
echo ""
echo "  4. Langfuse Keys (선택 - 관측성)"
echo "     → https://cloud.langfuse.com"
echo ""
echo -e "${BLUE}${INFO} .env 파일 위치: $(pwd)/.env${NC}"
echo ""

read -p "지금 .env 파일을 편집하시겠습니까? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 기본 에디터로 .env 파일 열기
    if [ -n "$VISUAL" ]; then
        $VISUAL .env
    elif [ -n "$EDITOR" ]; then
        $EDITOR .env
    elif command -v nano &> /dev/null; then
        nano .env
    elif command -v vim &> /dev/null; then
        vim .env
    else
        echo -e "${YELLOW}${WARN} 기본 에디터를 찾을 수 없습니다. 수동으로 .env 파일을 편집해주세요.${NC}"
        echo -e "${BLUE}명령어: open .env${NC}"
    fi
fi

echo ""
read -p "API 키 설정을 완료하셨습니까? 계속 진행하려면 Enter를 누르세요..." -r
echo ""

# 3. 실행 모드 선택
echo -e "${CYAN}[3/5] ⚙️  실행 모드 선택${NC}"
echo ""
echo "어떤 모드로 실행하시겠습니까?"
echo ""
echo "  1. 전체 스택 (권장) - 모든 서비스 포함"
echo "     Qdrant, PostgreSQL, Redis, LiteLLM, Langfuse, n8n, Neo4j"
echo ""
echo "  2. 최소 스택 (테스트용) - 핵심 서비스만"
echo "     Qdrant, PostgreSQL, Redis, LiteLLM"
echo ""
echo "  3. 취소"
echo ""

read -p "선택하세요 (1/2/3): " -n 1 -r
echo
echo ""

COMPOSE_FILE="docker-compose.avengers.yml"

case $REPLY in
    1)
        echo -e "${GREEN}${CHECK} 전체 스택 모드로 실행합니다${NC}"
        COMPOSE_FILE="docker-compose.avengers.yml"
        ;;
    2)
        echo -e "${GREEN}${CHECK} 최소 스택 모드로 실행합니다${NC}"
        COMPOSE_FILE="docker-compose.minimal.yml"
        
        # 최소 구성 파일이 없으면 생성
        if [ ! -f "$COMPOSE_FILE" ]; then
            echo -e "${YELLOW}${INFO} 최소 구성 파일을 생성합니다...${NC}"
            cat > $COMPOSE_FILE << 'EOF'
version: '3.8'

services:
  qdrant:
    image: qdrant/qdrant:latest
    container_name: avengers-qdrant
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant_data:/qdrant/storage
    environment:
      - QDRANT__SERVICE__GRPC_PORT=6334
    restart: unless-stopped

  postgres:
    image: postgres:16-alpine
    container_name: avengers-postgres
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: avengers
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-avengers_secret_2025}
      POSTGRES_DB: avengers_db
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U avengers"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    container_name: avengers-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes
    restart: unless-stopped

  litellm:
    image: ghcr.io/berriai/litellm:main-latest
    container_name: avengers-litellm
    ports:
      - "4000:4000"
    environment:
      LITELLM_MASTER_KEY: ${LITELLM_MASTER_KEY:-sk-avengers-master-key}
      DATABASE_URL: postgresql://avengers:${POSTGRES_PASSWORD:-avengers_secret_2025}@postgres:5432/avengers_db
      OPENAI_API_KEY: ${OPENAI_API_KEY}
      ANTHROPIC_API_KEY: ${ANTHROPIC_API_KEY}
      GOOGLE_API_KEY: ${GOOGLE_API_KEY}
    volumes:
      - ./config/litellm_config.yaml:/app/config.yaml
    command: --config /app/config.yaml --detailed_debug
    depends_on:
      - postgres
    restart: unless-stopped

volumes:
  qdrant_data:
  postgres_data:
  redis_data:

networks:
  default:
    name: avengers-network
EOF
            echo -e "${GREEN}${CHECK} 최소 구성 파일 생성 완료${NC}"
        fi
        ;;
    3)
        echo -e "${YELLOW}설치를 취소합니다.${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}잘못된 선택입니다. 설치를 취소합니다.${NC}"
        exit 1
        ;;
esac

echo ""

# 4. Docker 이미지 다운로드
echo -e "${CYAN}[4/5] ${DOCKER} Docker 이미지 다운로드...${NC}"
echo ""
echo "이 작업은 수 분이 걸릴 수 있습니다..."
echo ""

docker-compose -f $COMPOSE_FILE pull

echo ""
echo -e "${GREEN}${CHECK} 이미지 다운로드 완료${NC}"
echo ""

# 5. Docker 스택 시작
echo -e "${CYAN}[5/5] ${ROCKET} Docker 스택 시작...${NC}"
echo ""

docker-compose -f $COMPOSE_FILE up -d

echo ""
echo -e "${GREEN}${CHECK} Docker 스택이 시작되었습니다!${NC}"
echo ""

# 서비스 준비 대기
echo -e "${BLUE}${INFO} 서비스가 준비될 때까지 대기 중... (최대 30초)${NC}"
echo ""

for i in {1..30}; do
    if docker-compose -f $COMPOSE_FILE ps | grep -q "Up"; then
        sleep 2
        break
    fi
    echo -n "."
    sleep 1
done

echo ""
echo ""

# 6. 상태 확인
echo -e "${PURPLE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║  ${CHECK} 설치 완료! 서비스 상태 확인                       ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

docker-compose -f $COMPOSE_FILE ps

echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🌐 서비스 접속 URL${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$COMPOSE_FILE" = "docker-compose.avengers.yml" ]; then
    echo -e "  📊 Langfuse:    ${CYAN}http://localhost:3000${NC}  (관측성 대시보드)"
    echo -e "  🤖 LiteLLM:     ${CYAN}http://localhost:4000${NC}  (LLM Gateway)"
    echo -e "  ⚡ n8n:         ${CYAN}http://localhost:5678${NC}  (워크플로우)"
    echo -e "  🔍 Qdrant:      ${CYAN}http://localhost:6333/dashboard${NC}  (벡터 DB)"
    echo -e "  🕸️  Neo4j:       ${CYAN}http://localhost:7474${NC}  (그래프 DB)"
else
    echo -e "  🤖 LiteLLM:     ${CYAN}http://localhost:4000${NC}  (LLM Gateway)"
    echo -e "  🔍 Qdrant:      ${CYAN}http://localhost:6333/dashboard${NC}  (벡터 DB)"
fi

echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🔧 유용한 명령어${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  상태 확인:        ${BLUE}docker-compose -f $COMPOSE_FILE ps${NC}"
echo -e "  로그 확인:        ${BLUE}docker-compose -f $COMPOSE_FILE logs -f${NC}"
echo -e "  스택 중지:        ${BLUE}docker-compose -f $COMPOSE_FILE stop${NC}"
echo -e "  스택 재시작:      ${BLUE}docker-compose -f $COMPOSE_FILE restart${NC}"
echo -e "  스택 삭제:        ${BLUE}docker-compose -f $COMPOSE_FILE down${NC}"
echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📚 다음 단계${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  1. Python 환경 설정:"
echo -e "     ${BLUE}python3 -m venv .venv${NC}"
echo -e "     ${BLUE}source .venv/bin/activate${NC}"
echo -e "     ${BLUE}pip install -r requirements.txt${NC}"
echo ""
echo "  2. 초기화 스크립트 실행:"
echo -e "     ${BLUE}python init_avengers_stack.py${NC}"
echo ""
echo "  3. 자세한 가이드:"
echo -e "     ${BLUE}cat DOCKER_SETUP_GUIDE.md${NC}"
echo ""
echo -e "${GREEN}${ROCKET} 설치가 완료되었습니다! 즐거운 개발 되세요! ${ROCKET}${NC}"
echo ""
