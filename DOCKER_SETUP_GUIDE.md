# 🐳 Docker 기반 AI 인프라 스택 설정 가이드

## 📋 목차
1. [사전 준비](#사전-준비)
2. [환경 변수 설정](#환경-변수-설정)
3. [Docker 스택 실행](#docker-스택-실행)
4. [서비스 확인](#서비스-확인)
5. [Python 환경 설정](#python-환경-설정)
6. [초기화 및 테스트](#초기화-및-테스트)
7. [접속 URL 및 사용법](#접속-url-및-사용법)
8. [문제 해결](#문제-해결)

---

## 🔧 사전 준비

### ✅ 이미 설치됨
- Docker Desktop: v28.5.1 ✓
- Docker Compose: v2.40.3 ✓

---

## 🔐 환경 변수 설정

### 1단계: .env 파일 생성

```bash
# 프로젝트 루트에서
cp .env.example .env
```

### 2단계: .env 파일 편집

**필수 항목 (실제 API 키로 교체 필요):**

```bash
# LLM API Keys - 실제 키로 교체하세요!
OPENAI_API_KEY=sk-proj-your-actual-openai-key-here
ANTHROPIC_API_KEY=sk-ant-your-actual-anthropic-key-here
GOOGLE_API_KEY=your-actual-google-api-key-here

# Langfuse (클라우드 사용시)
LANGFUSE_PUBLIC_KEY=pk-lf-your-actual-key-here
LANGFUSE_SECRET_KEY=sk-lf-your-actual-key-here
LANGFUSE_BASE_URL=https://us.cloud.langfuse.com
```

**선택 항목 (기본값 사용 가능):**

```bash
# Database Passwords (기본값 사용 가능)
POSTGRES_PASSWORD=avengers_secret_2025
NEO4J_PASSWORD=avengers_neo4j_2025

# LiteLLM Master Key (기본값 사용 가능)
LITELLM_MASTER_KEY=sk-avengers-master-key

# Langfuse Self-hosted (선택)
NEXTAUTH_SECRET=your-nextauth-secret-min-32-chars-here-change-this
SALT=your-salt-min-32-chars-here-for-security-change-this
ENCRYPTION_KEY=0000000000000000000000000000000000000000000000000000000000000000

# n8n (선택)
N8N_ENCRYPTION_KEY=your-n8n-encryption-key-here
```

### 🔑 API 키 발급 방법

#### OpenAI
1. https://platform.openai.com/api-keys
2. "Create new secret key" 클릭
3. 키 복사 후 `OPENAI_API_KEY`에 입력

#### Anthropic (Claude)
1. https://console.anthropic.com/settings/keys
2. "Create Key" 클릭
3. 키 복사 후 `ANTHROPIC_API_KEY`에 입력

#### Google AI
1. https://makersuite.google.com/app/apikey
2. "Get API key" 클릭
3. 키 복사 후 `GOOGLE_API_KEY`에 입력

#### Langfuse (선택 - 무료)
1. https://cloud.langfuse.com 가입
2. Settings → API Keys에서 키 생성
3. Public/Secret 키 복사

---

## 🚀 Docker 스택 실행

### 1단계: Docker 서비스 시작

```bash
# 프로젝트 루트에서
docker-compose -f docker-compose.avengers.yml up -d
```

**설명:**
- `-f docker-compose.avengers.yml`: 설정 파일 지정
- `up`: 컨테이너 시작
- `-d`: 백그라운드 실행 (detached mode)

### 2단계: 실행 확인

```bash
# 모든 컨테이너 상태 확인
docker-compose -f docker-compose.avengers.yml ps

# 실시간 로그 확인
docker-compose -f docker-compose.avengers.yml logs -f

# 특정 서비스 로그만 확인
docker-compose -f docker-compose.avengers.yml logs -f langfuse
docker-compose -f docker-compose.avengers.yml logs -f litellm
```

---

## ✅ 서비스 확인

### 헬스체크 명령어

```bash
# Qdrant (Vector DB)
curl http://localhost:6333/health

# LiteLLM (LLM Gateway)
curl http://localhost:4000/health

# PostgreSQL
docker exec avengers-postgres pg_isready -U avengers

# Redis
docker exec avengers-redis redis-cli ping
```

### 예상 출력
```
# Qdrant
{"title":"healthz","version":"1.11.3"}

# LiteLLM
{"status":"healthy"}

# PostgreSQL
/var/run/postgresql:5432 - accepting connections

# Redis
PONG
```

---

## 🐍 Python 환경 설정

### 1단계: 가상환경 생성

```bash
# 프로젝트 루트에서
python3 -m venv .venv

# 가상환경 활성화
source .venv/bin/activate  # macOS/Linux
# 또는
.venv\Scripts\activate  # Windows
```

### 2단계: 패키지 설치

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

**설치 시간:** 약 2-5분 소요

---

## 🧪 초기화 및 테스트

### 1단계: 초기화 스크립트 실행

```bash
python init_avengers_stack.py
```

### 예상 출력
```
🦸 Initializing Avengers AI Stack...

==================================================
✅ Qdrant: Connected (0 collections)
✅ LangGraph Agent: Created
✅ CrewAI Team: Created (3 agents)
==================================================

✅ Avengers Stack Ready!
```

### 2단계: 개별 서비스 테스트

#### Qdrant 테스트
```python
from qdrant_client import QdrantClient

client = QdrantClient(host="localhost", port=6333)
print(client.get_collections())
```

#### LiteLLM 테스트
```python
from litellm import completion

response = completion(
    model="gpt-4o-mini",
    messages=[{"role": "user", "content": "Hello!"}],
    api_base="http://localhost:4000",
    api_key="sk-avengers-master-key"
)
print(response.choices[0].message.content)
```

---

## 🌐 접속 URL 및 사용법

### 서비스 대시보드

| 서비스 | URL | 기본 인증 | 설명 |
|--------|-----|----------|------|
| **Langfuse** | http://localhost:3000 | 최초 가입 필요 | LLM 관측성 대시보드 |
| **LiteLLM** | http://localhost:4000 | API Key 필요 | LLM Gateway API |
| **n8n** | http://localhost:5678 | 최초 가입 필요 | 워크플로우 빌더 |
| **Qdrant** | http://localhost:6333/dashboard | 없음 | Vector DB 대시보드 |
| **Neo4j** | http://localhost:7474 | neo4j / avengers_neo4j_2025 | Graph DB 브라우저 |

### 서비스 엔드포인트

| 서비스 | 엔드포인트 | 용도 |
|--------|-----------|------|
| **PostgreSQL** | localhost:5432 | DB 연결 |
| **Redis** | localhost:6379 | 캐시/큐 |
| **Qdrant gRPC** | localhost:6334 | 고성능 벡터 검색 |

---

## 📖 사용 예제

### MCP 서버에서 Docker 서비스 사용

```typescript
// mcp-server-v1/src/index.ts
import { QdrantClient } from "@qdrant/js-client-rest";
import OpenAI from "openai";

export default function createServer({ config }) {
  const server = new McpServer({
    name: "AI Tools",
    version: "1.0.0",
  });

  // Qdrant 연결
  const qdrant = new QdrantClient({
    url: "http://localhost:6333",
  });

  // LiteLLM 연결 (OpenAI 호환)
  const openai = new OpenAI({
    baseURL: "http://localhost:4000",
    apiKey: "sk-avengers-master-key",
  });

  // 벡터 검색 도구
  server.registerTool(
    "search-knowledge",
    {
      title: "Knowledge Search",
      description: "Search knowledge base",
      inputSchema: { query: z.string() },
    },
    async ({ query }) => {
      // Qdrant에서 검색
      const results = await qdrant.search("knowledge", {
        vector: await getEmbedding(query),
        limit: 5,
      });
      return { content: [{ type: "text", text: JSON.stringify(results) }] };
    }
  );

  // LLM 호출 도구
  server.registerTool(
    "ask-ai",
    {
      title: "Ask AI",
      description: "Ask AI a question",
      inputSchema: { question: z.string() },
    },
    async ({ question }) => {
      const response = await openai.chat.completions.create({
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: question }],
      });
      return {
        content: [{ 
          type: "text", 
          text: response.choices[0].message.content 
        }],
      };
    }
  );

  return server.server;
}
```

---

## 🛠️ 관리 명령어

### 스택 관리

```bash
# 스택 시작
docker-compose -f docker-compose.avengers.yml up -d

# 스택 중지 (데이터 유지)
docker-compose -f docker-compose.avengers.yml stop

# 스택 중지 및 컨테이너 제거 (데이터 유지)
docker-compose -f docker-compose.avengers.yml down

# 스택 완전 삭제 (데이터도 삭제 - 주의!)
docker-compose -f docker-compose.avengers.yml down -v

# 특정 서비스만 재시작
docker-compose -f docker-compose.avengers.yml restart litellm

# 스택 업데이트 (이미지 최신화)
docker-compose -f docker-compose.avengers.yml pull
docker-compose -f docker-compose.avengers.yml up -d
```

### 로그 확인

```bash
# 모든 서비스 로그
docker-compose -f docker-compose.avengers.yml logs -f

# 최근 100줄만
docker-compose -f docker-compose.avengers.yml logs --tail=100

# 특정 서비스
docker-compose -f docker-compose.avengers.yml logs -f langfuse
```

### 리소스 확인

```bash
# 컨테이너 상태 확인
docker-compose -f docker-compose.avengers.yml ps

# 리소스 사용량 (CPU, 메모리)
docker stats

# 디스크 사용량
docker system df
```

---

## 🐛 문제 해결

### 문제 1: 포트 충돌

**증상:**
```
Error: bind: address already in use
```

**해결:**
```bash
# 포트 사용 프로세스 확인
lsof -i :3000  # Langfuse
lsof -i :4000  # LiteLLM
lsof -i :5432  # PostgreSQL

# 프로세스 종료 (PID는 위 명령어 결과에서 확인)
kill -9 <PID>

# 또는 Docker Compose 설정에서 포트 변경
# docker-compose.avengers.yml 파일 수정
```

### 문제 2: 메모리 부족

**증상:**
```
Container killed due to OOM
```

**해결:**
```bash
# Docker Desktop 설정 → Resources → Memory 증가 (최소 8GB 권장)

# 또는 불필요한 서비스 비활성화
# docker-compose.avengers.yml에서 주석 처리:
# neo4j, n8n 등
```

### 문제 3: Langfuse 연결 실패

**증상:**
```
Database connection error
```

**해결:**
```bash
# PostgreSQL이 준비될 때까지 대기
docker-compose -f docker-compose.avengers.yml logs postgres

# Langfuse 재시작
docker-compose -f docker-compose.avengers.yml restart langfuse

# 환경 변수 확인
docker-compose -f docker-compose.avengers.yml exec langfuse env | grep DATABASE_URL
```

### 문제 4: LiteLLM API 키 오류

**증상:**
```
AuthenticationError: Invalid API key
```

**해결:**
```bash
# .env 파일에서 API 키 확인
cat .env | grep OPENAI_API_KEY

# 컨테이너 재시작 (.env 변경 후)
docker-compose -f docker-compose.avengers.yml restart litellm

# 환경 변수가 제대로 주입되었는지 확인
docker-compose -f docker-compose.avengers.yml exec litellm env | grep OPENAI
```

### 문제 5: 컨테이너가 계속 재시작됨

**해결:**
```bash
# 로그에서 원인 확인
docker-compose -f docker-compose.avengers.yml logs --tail=50 <service_name>

# 의존성 서비스 먼저 시작
docker-compose -f docker-compose.avengers.yml up -d postgres redis
sleep 10
docker-compose -f docker-compose.avengers.yml up -d
```

---

## 📊 성능 최적화

### 최소 구성 (개발용)

리소스가 제한적이면 핵심 서비스만 실행:

```bash
# docker-compose.minimal.yml 생성
version: '3.8'

services:
  qdrant:
    # Qdrant 설정 (필수)
  
  postgres:
    # PostgreSQL 설정 (필수)
  
  redis:
    # Redis 설정 (필수)
  
  litellm:
    # LiteLLM 설정 (필수)

# 실행
docker-compose -f docker-compose.minimal.yml up -d
```

---

## 🎯 다음 단계

1. **Langfuse 대시보드 접속**
   - http://localhost:3000
   - 최초 계정 생성
   - API 키 발급

2. **LiteLLM 테스트**
   ```bash
   curl http://localhost:4000/v1/chat/completions \
     -H "Authorization: Bearer sk-avengers-master-key" \
     -H "Content-Type: application/json" \
     -d '{
       "model": "gpt-4o-mini",
       "messages": [{"role": "user", "content": "Hello!"}]
     }'
   ```

3. **MCP 서버에서 연동**
   - `mcp-server-v1/src/index.ts` 수정
   - Docker 서비스 호출 코드 추가
   - MCP 서버 재빌드

4. **Qdrant에 데이터 추가**
   ```python
   python scripts/load_initial_data.py
   ```

---

## 📚 참고 자료

- [Docker Compose 문서](https://docs.docker.com/compose/)
- [LiteLLM 문서](https://docs.litellm.ai)
- [Qdrant 문서](https://qdrant.tech/documentation/)
- [Langfuse 문서](https://langfuse.com/docs)
- [n8n 문서](https://docs.n8n.io)

---

## ✅ 체크리스트

- [ ] Docker Desktop 실행 확인
- [ ] .env 파일 생성 및 API 키 설정
- [ ] `docker-compose up -d` 실행
- [ ] 모든 서비스 상태 확인 (docker ps)
- [ ] Python 가상환경 생성 및 패키지 설치
- [ ] `init_avengers_stack.py` 실행 성공
- [ ] Langfuse 대시보드 접속 및 가입
- [ ] LiteLLM API 테스트 성공
- [ ] Qdrant 대시보드 접속 확인

축하합니다! 🎉 AI 인프라 스택이 준비되었습니다.
