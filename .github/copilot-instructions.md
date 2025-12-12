# Copilot 지침: 어벤져스 AI 스택

이 코드베이스는 MCP 서버, LangGraph 에이전트, Docker 기반 어벤져스 스택을 결합한 **다중 언어 AI 인프라**를 구현합니다.

## 아키텍처 개요

### 세 가지 계층
1. **MCP 서버** (TypeScript/Node): AI-도구 연결을 위한 프로토콜 계층
   - 위치: `mcp-server-v1/` 
   - 런타임: `smithery.yaml` 설정을 포함한 Smithery SDK
   - 전송: HTTP (원격) 또는 stdio (로컬)
   
2. **Python AI 에이전트**: 에이전트 워크플로우를 위한 오케스트레이션 계층
   - LangGraph: 복잡한 제어 흐름이 있는 상태 기반 워크플로우
   - CrewAI: 역할 기반 멀티 에이전트 팀
   - 사용: 통합 LLM 접근을 위한 LiteLLM 게이트웨이
   
3. **Docker Compose 스택**: 지원 서비스를 위한 인프라 계층
   - 파일: `docker-compose.avengers.yml`
   - 주요 서비스: Qdrant (벡터), PostgreSQL (상태), Redis (캐시), n8n (시각적 워크플로우), Langfuse (관측성)

**핵심 통찰**: 이것은 **위임된 에이전트 아키텍처**로, 각 계층은 특정 관심사를 담당합니다 (프로토콜 → 오케스트레이션 → 인프라). 계층 간 통신은 표준화된 API (HTTP/REST)를 통해 흐르며, 강한 결합이 없습니다.

---

## 프로젝트 특화 패턴

### MCP 서버 개발 (`mcp-server-v1/`)
- **표준 구조**: `src/index.ts` → `smithery.yaml` → `npm run dev|build`을 통한 빌드/배포
- **세 가지 컴포넌트 타입** (상호 교체 불가능):
  - **Tools**: 부작용이 있는 실행 가능한 함수 (조치가 필요할 때 사용) → `server.registerTool()`
  - **Resources**: 읽기 전용 데이터 제공자 (문서/참조용 사용) → `server.registerResource()`  
  - **Prompts**: 재사용 가능한 메시지 템플릿 (워크플로우 패턴용 사용) → `server.registerPrompt()`
- **설정 패턴**: 서버 설정을 위해 Zod 스키마를 사용하고 `configSchema`를 내보내 사용자 수준 설정 활성화
- **예제 참고**: `src/index.ts`는 한 파일에서 세 가지 컴포넌트 타입을 모두 보여줍니다

### Python 에이전트 패턴 (`init_avengers_stack.py`)
- **LangGraph**: 상태 스키마를 위해 `TypedDict`와 함께 `StateGraph` 사용; 노드는 상태를 업데이트하기 위해 `{"field": value}` 반환
  - 상태 필드는 메시지 누적을 위해 `Annotated[list, operator.add]` 사용
  - 흐름: `set_entry_point()` → `add_edge()` → 실행 가능한 그래프로 `compile()`
- **CrewAI**: `Agent` 인스턴스를 역할/목표/배경스토리로 정의; `Crew`에 `tasks` 목록과 함께 그룹화
  - `allow_delegation=True`일 때 에이전트는 자율적으로 위임; 결정적 체인의 경우 `False`로 설정
- **LiteLLM 패턴**: 모든 LLM 호출은 `http://localhost:4000`의 게이트웨이를 통해 `litellm.completion()`으로 이동
  - 장점: 단일 코드 경로가 설정 변경을 통해 OpenAI, Anthropic, Google에 작동

### Docker Compose 패턴
- **서비스 카테고리**: 데이터베이스 (Qdrant, PostgreSQL, Redis, Neo4j) → 관측성 (Langfuse 클라우드) → AI 게이트웨이 (LiteLLM) → 워크플로우 (n8n)
- **포트 규칙**: 6333=Qdrant, 5432=PostgreSQL, 6379=Redis, 7474=Neo4j, 4000=LiteLLM, 5678=n8n
- **환경 설정**: `.env` 파일이 시크릿 보유; `.env.example`는 템플릿 표시 (예제만 커밋)
- **시작 순서**: 데이터베이스 헬스체크로 AI 게이트웨이 시작 전에 의존성 사용 가능 보장

---

## 핵심 개발자 워크플로우

### 스택 실행
```bash
# 전체 스택 (초기화에 30-60초 소요)
docker-compose -f docker-compose.avengers.yml up -d

# 인프라 연결 테스트
source .venv/bin/activate  # Python 3.10+
python init_avengers_stack.py

# 로그 보기 (예: LiteLLM 시작 문제)
docker-compose -f docker-compose.avengers.yml logs -f litellm
```

### MCP 서버 개발
```bash
cd mcp-server-v1
npm run dev           # 포트 8081에서 플레이그라운드 시작
npm run build         # 배포용 .smithery/에 번들
```

### 에이전트 엔드-투-엔드 테스트
- Python에 에이전트 코드 작성
- `litellm.completion()` 호출 (로컬 게이트웨이 실행 필수)
- Langfuse 대시보드 사용 (https://us.cloud.langfuse.com)으로 모든 LLM 호출 추적
- 게이트웨이 실패 시: `docker-compose logs litellm`에서 모델 라우팅 오류 확인

### 설정 재정의 포인트
- **LLM 라우팅**: `config/litellm_config.yaml` 편집 (비용 기반 라우팅, 폴백)
- **에이전트 동작**: `create_avengers_agent()`/`create_avengers_crew()` 노드 로직 수정
- **데이터베이스 연결**: `.env` 변수에서 PostgreSQL/Redis/Qdrant 자격 증명 확인

---

## 주요 의존성 & 통합

### 프로토콜 계층
- **MCP 1.0.0+**: AI-도구 통신의 표준; Smithery SDK가 래핑
- **A2A SDK 0.3.0+**: 에이전트 간 통신용 (아직 미구현, Phase 2)

### 에이전트 프레임워크
- **LangGraph 0.2.0+**: 순환 가능한 상태 머신; 복잡한 워크플로우에 적합
- **CrewAI 0.80.0+**: 자율 위임 기반 팀; 역할 기반 시나리오에 적합
- 둘 다 공존 가능; 용도에 따라 선택

### LLM 게이트웨이
- **LiteLLM 1.50.0+**: OpenAI/Anthropic/Google 요청을 단일 인터페이스로 라우팅
- **Langfuse 2.50.0+**: 클라우드 기반 관측성; LiteLLM 호출을 콜백으로 자동 로깅
- 함께 **LLM 관측성 계층** 형성 (비용 추적, 지연 시간 분석)

### 벡터 & 메모리
- **Qdrant 1.11.0+**: RAG용 벡터 데이터베이스; 포트 6333, 임베딩 자동 인덱싱
- **mem0ai 0.1.0**: 장기 메모리 계층 (Phase 2); Qdrant + Neo4j + LiteLLM과 통합

### 검증
- 모든 Python 코드는 스키마 검증을 위해 **Pydantic 2.0.0+** 사용
- MCP 서버는 TypeScript 검증을 위해 **Zod** 사용
- 언어 경계 간 타입 안전성 보장

---

## 흔한 함정 & 해결책

| 이슈 | 원인 | 해결책 |
|------|------|--------|
| LiteLLM이 401 반환 | `.env`에 API 키 미설정 | `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GOOGLE_API_KEY` 확인 |
| `litellm.completion()` 응답 없음 | 게이트웨이 미실행 | `docker-compose up -d litellm` 실행 후 "Application startup complete" 대기 |
| 에이전트 상태가 누적되지 않음 | `Annotated[list, operator.add]` 누락 | 필드 병합이 필요하면 누산기 타입 사용 (교체 아님) |
| MCP 도구가 클라이언트에 표시 안 됨 | 도구가 등록되지 않음 | `server.registerTool()` 호출 확인 (`server.server` 반환 전) |
| Qdrant 연결 거부 | 포트 충돌 또는 컨테이너 충돌 | `docker ps` 확인, `docker logs avengers-qdrant` 로그 확인

---

## 디렉토리 빠른 참조

```
.github/
  ├── copilot-instructions.md (이 파일)
  ├── SECRETS_GUIDE.md         (API 키 안전 관리 방법)
  └── workflows/               (CI/CD 자동화)

mcp-server-v1/                 (MCP 프로토콜 계층 - TypeScript)
  ├── src/index.ts             (tools, resources, prompts)
  ├── smithery.yaml            (MCP 설정: runtime=typescript)
  └── package.json             (MCP SDK + 빌드 도구)

config/
  └── litellm_config.yaml      (LLM 라우팅, 모델, 비용)

docker-compose.avengers.yml    (인프라: 7개 서비스)
init_avengers_stack.py         (에이전트 예제 + 연결성 테스트)
requirements.txt               (Python 의존성)
ROADMAP_AND_STRATEGY.md        (4주 팀 통합 계획)
README.md                       (기술 선택 근거)
```

---

## 단계별 개발 가이드

**Phase 1** (현재): Docker 인프라 + 기본 에이전트 ✅
- 산출물: 모든 7개 서비스 실행, LangGraph/CrewAI 예제 작동

**Phase 2** (다음): mem0 통합 + A2A 에이전트 통신
- 시작: `init_avengers_stack.py`에서 `init_mem0()` 주석 해제
- 통합 지점: Qdrant (벡터) → Neo4j (그래프) → mem0 (영속성) 연결

**Phase 3**: n8n 시각적 워크플로우 + MCP 도구 통합
- 시작: `mcp-server-v1/src/index.ts`에 커스텀 도구 추가
- 통합 지점: n8n 노드가 HTTP 전송을 통해 MCP 도구 호출

---

## 막혔을 때

1. **인프라 문제**: `.github/SECRETS_GUIDE.md`에서 설정 검증 확인
2. **에이전트 로직**: 상태 스냅샷 출력; Langfuse 대시보드에서 LLM 출력 확인
3. **MCP 도구 등록**: `npm run dev` 출력에서 "tools registered: N" 표시 확인
4. **계층 간 통신**: 포트 포워딩 작동 확인 (예: LiteLLM의 `localhost:4000`)

---

*마지막 업데이트: 2025-12-08*
