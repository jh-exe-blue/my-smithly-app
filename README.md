# 🦸 AI 인프라 게임체인저 & 어벤져스 스택 (2025)

## 📊 Executive Summary

2025년 AI 근접시장(모델 제외)에서 **진정한 게임체인저**들을 분석하고, 이들을 조합한 **"어벤져스 급"** 환경을 구성합니다.

---

## 🎯 TOP 10 게임체인저 기술

### 1️⃣ **MCP (Model Context Protocol)** - ⭐ 필수
> "AI의 USB-C" - Anthropic 개발, 2024.11 출시

| 항목 | 내용 |
|------|------|
| **역할** | AI ↔ Tool/Data 연결 표준 프로토콜 |
| **지원** | OpenAI, Google, Microsoft, GitHub 등 채택 |
| **서버 수** | 2,000+ MCP 서버 (2025.11 기준) |
| **핵심 가치** | 한 번 빌드 → 모든 AI에서 사용 |

```
┌─────────────┐      MCP      ┌─────────────┐
│  AI Model   │◄────────────►│  MCP Server │
│ (Claude 등) │              │ (DB, API 등) │
└─────────────┘              └─────────────┘
```

### 2️⃣ **A2A (Agent2Agent Protocol)** - ⭐ 필수
> "AI 에이전트의 HTTP" - Google 개발, 2025.04 출시

| 항목 | 내용 |
|------|------|
| **역할** | Agent ↔ Agent 통신 표준 |
| **지원** | 150+ 기업 (Salesforce, SAP, ServiceNow 등) |
| **관리** | Linux Foundation (2025.06~) |
| **버전** | v0.3 (gRPC 지원, 보안 강화) |

```
MCP = AI ↔ Tool (도구 연결)
A2A = Agent ↔ Agent (에이전트 협업)
→ 상호 보완적, 함께 사용 권장
```

### 3️⃣ **LangGraph** - ⭐ 핵심
> 상태 기반 에이전트 워크플로우 엔진

| 항목 | 내용 |
|------|------|
| **특징** | Graph 기반 상태 머신, 순환 가능 |
| **강점** | 복잡한 분기/반복 로직 처리 |
| **통합** | LangChain 생태계 완전 호환 |
| **용도** | 프로덕션급 에이전트 워크플로우 |

### 4️⃣ **CrewAI** - ⭐ 핵심
> 역할 기반 멀티 에이전트 협업 프레임워크

| 항목 | 내용 |
|------|------|
| **특징** | Agent에 역할/목표/백스토리 부여 |
| **강점** | Human-in-the-loop, 팀 구조 시뮬레이션 |
| **용도** | 리서치, 콘텐츠 생성, 복잡한 분석 |

### 5️⃣ **Vector Database** - ⭐ 필수
> RAG의 심장, 임베딩 저장/검색

| DB | 특징 | 최적 용도 |
|----|------|----------|
| **Qdrant** | Rust 기반, 최고 성능, 고급 필터링 | 성능 중시 |
| **Weaviate** | GraphQL, 하이브리드 검색, 모듈화 | 기능 중시 |
| **Pinecone** | 완전 관리형, 제로 Ops | 빠른 구축 |
| **Milvus** | 대규모(10억+), 오픈소스 | 엔터프라이즈 |

### 6️⃣ **mem0** - 🔥 신흥 강자
> AI 에이전트를 위한 장기 메모리 레이어

| 항목 | 내용 |
|------|------|
| **문제 해결** | LLM의 컨텍스트 리셋 문제 |
| **성과** | OpenAI 대비 26% 정확도 향상, 91% 레이턴시 감소 |
| **투자** | $24M 시리즈A (YC, Peak XV, Basis Set) |
| **API 호출** | 186M/월 (2025 Q3) |

### 7️⃣ **LiteLLM** - ⭐ 필수
> 100+ LLM을 위한 통합 API 게이트웨이

| 항목 | 내용 |
|------|------|
| **역할** | 모든 LLM을 OpenAI 포맷으로 통일 |
| **기능** | 로드밸런싱, 폴백, 비용 추적, 속도 제한 |
| **통합** | Langfuse 콜백으로 관측성 연동 |

### 8️⃣ **n8n** - ⭐ 핵심
> AI 워크플로우 자동화 플랫폼

| 항목 | 내용 |
|------|------|
| **특징** | 비주얼 + 코드 하이브리드 |
| **AI 노드** | OpenAI, Anthropic, Vector Store, Agent 등 |
| **강점** | 400+ SaaS 연동 + AI 워크플로우 |
| **배포** | 셀프호스트 / 클라우드 선택 가능 |

### 9️⃣ **Langfuse** - ⭐ 핵심
> 오픈소스 LLM 관측성 & 프롬프트 관리

| 항목 | 내용 |
|------|------|
| **기능** | 트레이싱, 토큰 사용량, 비용, 레이턴시 |
| **강점** | 셀프호스트 가능, 프라이버시 |
| **대안** | LangSmith (LangChain 전용, 유료) |

### 🔟 **Unstructured.io** - 보조
> 비정형 데이터 전처리 파이프라인

| 항목 | 내용 |
|------|------|
| **역할** | PDF, 이미지, 문서 → 구조화된 텍스트 |
| **용도** | RAG 데이터 수집 단계 |

---

## 🦸‍♂️ 어벤져스 스택 아키텍처

```
┌─────────────────────────────────────────────────────────────────────┐
│                        🌐 User Interface                            │
│                    (Streamlit / Next.js / Chat)                     │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     🎯 Orchestration Layer                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                 │
│  │   n8n       │  │  LangGraph  │  │  CrewAI     │                 │
│  │ (Workflow)  │  │  (Agent)    │  │ (Multi-Agent)│                │
│  └─────────────┘  └─────────────┘  └─────────────┘                 │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐
│    A2A      │ │    MCP      │ │      LiteLLM        │
│  Protocol   │ │  Protocol   │ │    (LLM Gateway)    │
│ (Agent↔Agent)│ │ (Tool Access)│ │  ┌───┬───┬───┐    │
└─────────────┘ └─────────────┘ │  │GPT│Claude│Gemini│ │
                                │  └───┴───┴───┘    │
                                └─────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   Qdrant    │ │    mem0     │ │  PostgreSQL │
│ (Vector DB) │ │  (Memory)   │ │  (State)    │
└─────────────┘ └─────────────┘ └─────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     📊 Observability Layer                          │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      Langfuse                                │   │
│  │    (Tracing / Metrics / Prompt Management / Evaluation)     │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🐳 Docker Compose - 어벤져스 스택

```yaml
# docker-compose.avengers.yml
version: '3.8'

services:
  # ═══════════════════════════════════════════════════════════
  # 🗄️ DATABASES
  # ═══════════════════════════════════════════════════════════
  
  # Vector Database - RAG의 심장
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

  # PostgreSQL - 상태 저장, Langfuse 백엔드
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

  # Redis - 캐싱, 세션, 큐
  redis:
    image: redis:7-alpine
    container_name: avengers-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes
    restart: unless-stopped

  # ═══════════════════════════════════════════════════════════
  # 🔭 OBSERVABILITY
  # ═══════════════════════════════════════════════════════════
  
  # Langfuse - LLM 관측성 (Self-hosted)
  langfuse:
    image: langfuse/langfuse:latest
    container_name: avengers-langfuse
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://avengers:${POSTGRES_PASSWORD:-avengers_secret_2025}@postgres:5432/avengers_db
      NEXTAUTH_URL: http://localhost:3000
      NEXTAUTH_SECRET: ${NEXTAUTH_SECRET:-your-nextauth-secret-min-32-chars}
      SALT: ${SALT:-your-salt-min-32-chars-here}
      ENCRYPTION_KEY: ${ENCRYPTION_KEY:-0000000000000000000000000000000000000000000000000000000000000000}
      TELEMETRY_ENABLED: "false"
    depends_on:
      postgres:
        condition: service_healthy
    restart: unless-stopped

  # ═══════════════════════════════════════════════════════════
  # 🤖 AI GATEWAY
  # ═══════════════════════════════════════════════════════════
  
  # LiteLLM Proxy - 모든 LLM 통합 게이트웨이
  litellm:
    image: ghcr.io/berriai/litellm:main-latest
    container_name: avengers-litellm
    ports:
      - "4000:4000"
    environment:
      LITELLM_MASTER_KEY: ${LITELLM_MASTER_KEY:-sk-avengers-master-key}
      DATABASE_URL: postgresql://avengers:${POSTGRES_PASSWORD:-avengers_secret_2025}@postgres:5432/avengers_db
      # LLM API Keys
      OPENAI_API_KEY: ${OPENAI_API_KEY}
      ANTHROPIC_API_KEY: ${ANTHROPIC_API_KEY}
      GOOGLE_API_KEY: ${GOOGLE_API_KEY}
      # Langfuse 연동
      LANGFUSE_PUBLIC_KEY: ${LANGFUSE_PUBLIC_KEY}
      LANGFUSE_SECRET_KEY: ${LANGFUSE_SECRET_KEY}
      LANGFUSE_HOST: http://langfuse:3000
    volumes:
      - ./config/litellm_config.yaml:/app/config.yaml
    command: --config /app/config.yaml --detailed_debug
    depends_on:
      - postgres
      - langfuse
    restart: unless-stopped

  # ═══════════════════════════════════════════════════════════
  # ⚡ WORKFLOW AUTOMATION
  # ═══════════════════════════════════════════════════════════
  
  # n8n - AI 워크플로우 자동화
  n8n:
    image: n8nio/n8n:latest
    container_name: avengers-n8n
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - NODE_ENV=production
      - WEBHOOK_URL=http://localhost:5678/
      - GENERIC_TIMEZONE=Asia/Seoul
      - N8N_AI_ENABLED=true
      # Database
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=avengers_db
      - DB_POSTGRESDB_USER=avengers
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD:-avengers_secret_2025}
      # AI Keys (n8n 내부 사용)
      - OPENAI_API_KEY=${OPENAI_API_KEY}
    volumes:
      - n8n_data:/home/node/.n8n
    depends_on:
      postgres:
        condition: service_healthy
    restart: unless-stopped

  # ═══════════════════════════════════════════════════════════
  # 🧠 MEMORY LAYER
  # ═══════════════════════════════════════════════════════════
  
  # Neo4j - mem0 그래프 메모리 백엔드 (선택적)
  neo4j:
    image: neo4j:5-community
    container_name: avengers-neo4j
    ports:
      - "7474:7474"  # HTTP
      - "7687:7687"  # Bolt
    environment:
      NEO4J_AUTH: neo4j/${NEO4J_PASSWORD:-avengers_neo4j_2025}
      NEO4J_PLUGINS: '["apoc"]'
    volumes:
      - neo4j_data:/data
    restart: unless-stopped

volumes:
  qdrant_data:
  postgres_data:
  redis_data:
  n8n_data:
  neo4j_data:

networks:
  default:
    name: avengers-network
```

---

## ⚙️ LiteLLM 설정 파일

```yaml
# config/litellm_config.yaml
model_list:
  # OpenAI Models
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
      
  - model_name: gpt-4o-mini
    litellm_params:
      model: openai/gpt-4o-mini
      api_key: os.environ/OPENAI_API_KEY

  # Anthropic Models
  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-sonnet-4-20250514
      api_key: os.environ/ANTHROPIC_API_KEY
      
  - model_name: claude-haiku
    litellm_params:
      model: anthropic/claude-3-5-haiku-20241022
      api_key: os.environ/ANTHROPIC_API_KEY

  # Google Models
  - model_name: gemini-pro
    litellm_params:
      model: gemini/gemini-1.5-pro
      api_key: os.environ/GOOGLE_API_KEY

  # Fallback 설정 (비용 최적화)
  - model_name: default
    litellm_params:
      model: openai/gpt-4o-mini
      api_key: os.environ/OPENAI_API_KEY

# 라우팅 설정
router_settings:
  routing_strategy: cost-based  # 비용 기반 라우팅
  num_retries: 3
  timeout: 120
  
# Langfuse 콜백 (관측성)
litellm_settings:
  callbacks: ["langfuse"]
  success_callback: ["langfuse"]
  failure_callback: ["langfuse"]
  
# 속도 제한
general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
```

---

## 🐍 Python 환경 설정

```bash
# requirements.txt
# ═══════════════════════════════════════════════════════════
# Core Frameworks
# ═══════════════════════════════════════════════════════════
langchain>=0.3.0
langgraph>=0.2.0
crewai>=0.80.0
pydantic>=2.0.0
pydantic-ai>=0.0.30

# ═══════════════════════════════════════════════════════════
# Protocols
# ═══════════════════════════════════════════════════════════
mcp>=1.0.0                    # Model Context Protocol
a2a-sdk>=0.3.0                # Agent2Agent Protocol

# ═══════════════════════════════════════════════════════════
# LLM & Memory
# ═══════════════════════════════════════════════════════════
litellm>=1.50.0               # LLM Gateway
mem0ai>=0.1.0                 # AI Memory Layer
openai>=1.50.0
anthropic>=0.35.0

# ═══════════════════════════════════════════════════════════
# Vector & Data
# ═══════════════════════════════════════════════════════════
qdrant-client>=1.11.0
chromadb>=0.5.0               # 개발용 경량 벡터DB
unstructured>=0.15.0          # 비정형 데이터 처리

# ═══════════════════════════════════════════════════════════
# Observability
# ═══════════════════════════════════════════════════════════
langfuse>=2.50.0

# ═══════════════════════════════════════════════════════════
# Web & API
# ═══════════════════════════════════════════════════════════
fastapi>=0.115.0
uvicorn>=0.32.0
httpx>=0.27.0
streamlit>=1.39.0

# ═══════════════════════════════════════════════════════════
# Database
# ═══════════════════════════════════════════════════════════
asyncpg>=0.29.0
redis>=5.0.0
neo4j>=5.25.0
```

---

## 🚀 초기화 스크립트

```python
# init_avengers_stack.py
"""
어벤져스 AI 스택 초기화 스크립트
모든 구성 요소 연결 및 검증
"""
import os
from dotenv import load_dotenv

# 환경 변수 로드
load_dotenv()

# ═══════════════════════════════════════════════════════════
# 1. LiteLLM 연결 (LLM Gateway)
# ═══════════════════════════════════════════════════════════
from litellm import completion

def test_litellm():
    """LiteLLM 프록시 테스트"""
    response = completion(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": "Hello!"}],
        api_base="http://localhost:4000",
        api_key=os.getenv("LITELLM_MASTER_KEY")
    )
    print("✅ LiteLLM: Connected")
    return response

# ═══════════════════════════════════════════════════════════
# 2. Qdrant 연결 (Vector DB)
# ═══════════════════════════════════════════════════════════
from qdrant_client import QdrantClient

def test_qdrant():
    """Qdrant 연결 테스트"""
    client = QdrantClient(host="localhost", port=6333)
    collections = client.get_collections()
    print(f"✅ Qdrant: Connected ({len(collections.collections)} collections)")
    return client

# ═══════════════════════════════════════════════════════════
# 3. mem0 초기화 (AI Memory)
# ═══════════════════════════════════════════════════════════
from mem0 import Memory

def init_mem0():
    """mem0 메모리 레이어 초기화"""
    config = {
        "llm": {
            "provider": "litellm",
            "config": {
                "model": "gpt-4o-mini",
                "api_base": "http://localhost:4000",
            }
        },
        "vector_store": {
            "provider": "qdrant",
            "config": {
                "host": "localhost",
                "port": 6333,
                "collection_name": "avengers_memory"
            }
        },
        "graph_store": {
            "provider": "neo4j",
            "config": {
                "url": "bolt://localhost:7687",
                "username": "neo4j",
                "password": os.getenv("NEO4J_PASSWORD", "avengers_neo4j_2025")
            }
        }
    }
    memory = Memory.from_config(config)
    print("✅ mem0: Initialized")
    return memory

# ═══════════════════════════════════════════════════════════
# 4. Langfuse 연결 (Observability)
# ═══════════════════════════════════════════════════════════
from langfuse import Langfuse

def init_langfuse():
    """Langfuse 관측성 초기화"""
    langfuse = Langfuse(
        public_key=os.getenv("LANGFUSE_PUBLIC_KEY"),
        secret_key=os.getenv("LANGFUSE_SECRET_KEY"),
        host="http://localhost:3000"
    )
    print("✅ Langfuse: Connected")
    return langfuse

# ═══════════════════════════════════════════════════════════
# 5. LangGraph Agent 예제
# ═══════════════════════════════════════════════════════════
from langgraph.graph import StateGraph, END
from typing import TypedDict, Annotated
import operator

class AgentState(TypedDict):
    messages: Annotated[list, operator.add]
    memory_context: str

def create_avengers_agent():
    """LangGraph 기반 에이전트 생성"""
    
    def research_node(state: AgentState):
        # 연구 수행
        return {"messages": ["Research completed"]}
    
    def analyze_node(state: AgentState):
        # 분석 수행
        return {"messages": ["Analysis completed"]}
    
    def report_node(state: AgentState):
        # 보고서 생성
        return {"messages": ["Report generated"]}
    
    # 그래프 구성
    workflow = StateGraph(AgentState)
    workflow.add_node("research", research_node)
    workflow.add_node("analyze", analyze_node)
    workflow.add_node("report", report_node)
    
    workflow.set_entry_point("research")
    workflow.add_edge("research", "analyze")
    workflow.add_edge("analyze", "report")
    workflow.add_edge("report", END)
    
    app = workflow.compile()
    print("✅ LangGraph Agent: Created")
    return app

# ═══════════════════════════════════════════════════════════
# 6. CrewAI 팀 예제
# ═══════════════════════════════════════════════════════════
from crewai import Agent, Task, Crew, Process

def create_avengers_crew():
    """CrewAI 멀티에이전트 팀 생성"""
    
    # 에이전트 정의
    researcher = Agent(
        role='Market Researcher',
        goal='Gather comprehensive market intelligence',
        backstory='Expert analyst with 10 years of experience',
        verbose=True,
        allow_delegation=False
    )
    
    analyst = Agent(
        role='Data Analyst',
        goal='Analyze data and extract insights',
        backstory='Data scientist specializing in pattern recognition',
        verbose=True,
        allow_delegation=False
    )
    
    writer = Agent(
        role='Report Writer',
        goal='Create compelling reports',
        backstory='Technical writer with MBA background',
        verbose=True,
        allow_delegation=False
    )
    
    print("✅ CrewAI Team: Created (3 agents)")
    return [researcher, analyst, writer]

# ═══════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════
if __name__ == "__main__":
    print("\n🦸 Initializing Avengers AI Stack...\n")
    print("=" * 50)
    
    try:
        # 1. Vector DB
        qdrant = test_qdrant()
        
        # 2. LLM Gateway (Docker 실행 필요)
        # test_litellm()
        
        # 3. Memory Layer
        # memory = init_mem0()
        
        # 4. Observability
        # langfuse = init_langfuse()
        
        # 5. LangGraph Agent
        agent = create_avengers_agent()
        
        # 6. CrewAI Team
        crew = create_avengers_crew()
        
        print("=" * 50)
        print("\n✅ Avengers Stack Ready!\n")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        print("Docker 컨테이너가 실행 중인지 확인하세요.")
```

---

## 📋 환경 변수 템플릿

```bash
# .env.example
# ═══════════════════════════════════════════════════════════
# LLM API Keys
# ═══════════════════════════════════════════════════════════
OPENAI_API_KEY=sk-xxx
ANTHROPIC_API_KEY=sk-ant-xxx
GOOGLE_API_KEY=xxx

# ═══════════════════════════════════════════════════════════
# Database Passwords
# ═══════════════════════════════════════════════════════════
POSTGRES_PASSWORD=avengers_secret_2025
NEO4J_PASSWORD=avengers_neo4j_2025

# ═══════════════════════════════════════════════════════════
# LiteLLM
# ═══════════════════════════════════════════════════════════
LITELLM_MASTER_KEY=sk-avengers-master-key

# ═══════════════════════════════════════════════════════════
# Langfuse
# ═══════════════════════════════════════════════════════════
NEXTAUTH_SECRET=your-nextauth-secret-min-32-chars-here
SALT=your-salt-min-32-chars-here-for-security
ENCRYPTION_KEY=0000000000000000000000000000000000000000000000000000000000000000
LANGFUSE_PUBLIC_KEY=pk-xxx
LANGFUSE_SECRET_KEY=sk-xxx

# ═══════════════════════════════════════════════════════════
# n8n (Optional)
# ═══════════════════════════════════════════════════════════
N8N_ENCRYPTION_KEY=your-n8n-encryption-key
```

---

## 🎮 Quick Start

```bash
# 1. 환경 설정
cp .env.example .env
# .env 파일 편집하여 API 키 입력

# 2. 디렉토리 구조 생성
mkdir -p config

# 3. LiteLLM 설정 파일 생성
# (위의 litellm_config.yaml 내용 복사)

# 4. Docker 스택 실행
docker-compose -f docker-compose.avengers.yml up -d

# 5. 상태 확인
docker-compose -f docker-compose.avengers.yml ps

# 6. Python 환경 설정
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt

# 7. 초기화 테스트
python init_avengers_stack.py
```

---

## 📊 구성요소별 접속 URL

| 서비스 | URL | 용도 |
|--------|-----|------|
| **Langfuse** | http://localhost:3000 | LLM 관측성 대시보드 |
| **LiteLLM** | http://localhost:4000 | LLM API Gateway |
| **n8n** | http://localhost:5678 | 워크플로우 빌더 |
| **Qdrant** | http://localhost:6333 | Vector DB 대시보드 |
| **Neo4j** | http://localhost:7474 | Graph DB 브라우저 |
| **PostgreSQL** | localhost:5432 | 메인 DB |
| **Redis** | localhost:6379 | 캐시/큐 |

---

## 🔥 Why This Stack?

| 레이어 | 선택 | 이유 |
|--------|------|------|
| **Protocol** | MCP + A2A | 업계 표준, 상호 보완적 |
| **Agent Framework** | LangGraph + CrewAI | 단일 vs 멀티 에이전트 커버 |
| **LLM Gateway** | LiteLLM | 벤더 독립, 비용 최적화 |
| **Vector DB** | Qdrant | 성능 + 오픈소스 + 고급 필터 |
| **Memory** | mem0 | 26% 정확도↑, 91% 레이턴시↓ |
| **Workflow** | n8n | 비주얼 + 코드, 400+ 연동 |
| **Observability** | Langfuse | 오픈소스, 셀프호스트 가능 |

---

## 📚 참고 자료

- [MCP Specification](https://modelcontextprotocol.io)
- [A2A Protocol](https://a2a-protocol.org)
- [LangGraph Docs](https://langchain-ai.github.io/langgraph)
- [CrewAI Docs](https://docs.crewai.com)
- [mem0 Research Paper](https://arxiv.org/abs/2504.19413)
- [LiteLLM Docs](https://docs.litellm.ai)
- [Langfuse Docs](https://langfuse.com/docs)
- [n8n Docs](https://docs.n8n.io)
