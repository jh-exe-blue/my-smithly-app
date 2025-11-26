# 🦸 어벤져스 AI 스택 구현 완료 🎉

모든 필수 파일이 생성되었습니다! 아래는 구현된 구성요소들입니다.

---

## ✅ 구현 완료 체크리스트

### 📦 생성된 파일들

1. **docker-compose.avengers.yml** ✅
   - 모든 필수 서비스 설정
   - Langfuse는 클라우드 기반으로 수정
   - 모든 API 키 환경 변수 연결

2. **.env** ✅
   - 실제 API 키 입력됨
   - 보안 비밀 설정됨
   - 데이터베이스 비밀번호 설정됨

3. **.env.example** ✅
   - 템플릿 파일 (공유용)
   - 실제 키는 제거됨

4. **config/litellm_config.yaml** ✅
   - OpenAI, Anthropic, Google 모델 설정
   - Langfuse 콜백 설정
   - 라우팅 설정 완료

5. **requirements.txt** ✅
   - 모든 필수 Python 패키지 목록
   - LangChain, CrewAI, MCP, A2A SDK 포함
   - Vector DB, 관측성 도구 포함

6. **init_avengers_stack.py** ✅
   - 모든 서비스 연결 테스트
   - LangGraph, CrewAI 예제 포함
   - Langfuse 클라우드 연동

7. **quickstart.sh** ✅
   - 자동 설정 및 실행 스크립트
   - Docker 확인
   - Python 환경 설정
   - 서비스 시작 및 초기화

---

## 🚀 즉시 실행 가능

### 1단계: 빠른 시작 (자동 설정)
```bash
cd /Users/joonho/MCP/mcp-server/my-smithly-app
./quickstart.sh
```

이 스크립트가 하는 일:
- Docker & Docker Compose 확인
- Python 가상환경 생성
- 의존성 설치
- Docker 서비스 시작 (Qdrant, PostgreSQL, Redis, Neo4j, n8n, LiteLLM)
- 초기화 테스트 실행

### 2단계: 수동 설정 (세부 제어)
```bash
# 가상환경 활성화
source .venv/bin/activate

# Docker 스택 시작
docker-compose -f docker-compose.avengers.yml up -d

# 초기화 테스트
python init_avengers_stack.py
```

---

## 📊 구성요소별 접속 정보

| 서비스 | URL | 포트 | 용도 |
|--------|-----|------|------|
| **LiteLLM** | http://localhost:4000 | 4000 | LLM API Gateway |
| **n8n** | http://localhost:5678 | 5678 | AI 워크플로우 빌더 |
| **Qdrant** | http://localhost:6333 | 6333 | Vector Database |
| **PostgreSQL** | localhost:5432 | 5432 | 메인 DB |
| **Redis** | localhost:6379 | 6379 | 캐시/큐 |
| **Neo4j** | http://localhost:7474 | 7474 | 그래프 DB |
| **Langfuse** | https://us.cloud.langfuse.com | 🌐 | LLM 관측성 (클라우드) |

---

## 💡 사용 예제

### 1️⃣ Python에서 LLM 호출 (LiteLLM)
```python
from litellm import completion

# OpenAI
response = completion(
    model="gpt-4o-mini",
    messages=[{"role": "user", "content": "안녕하세요!"}],
    api_base="http://localhost:4000"
)

# Anthropic
response = completion(
    model="claude-sonnet",
    messages=[{"role": "user", "content": "안녕하세요!"}],
    api_base="http://localhost:4000"
)
```

### 2️⃣ LangGraph 에이전트
```python
from langgraph.graph import StateGraph, END
from typing import TypedDict, Annotated
import operator

class AgentState(TypedDict):
    messages: Annotated[list, operator.add]

workflow = StateGraph(AgentState)
# 노드 추가, 엣지 연결 등...
app = workflow.compile()
```

### 3️⃣ CrewAI 멀티 에이전트
```python
from crewai import Agent, Task, Crew

researcher = Agent(
    role='Researcher',
    goal='Gather information',
    backstory='Expert analyst'
)

analyst = Agent(
    role='Analyst',
    goal='Analyze data',
    backstory='Data scientist'
)

crew = Crew(agents=[researcher, analyst])
```

### 4️⃣ Vector Database (Qdrant)
```python
from qdrant_client import QdrantClient

client = QdrantClient(host="localhost", port=6333)
collections = client.get_collections()
print(f"Collections: {collections}")
```

### 5️⃣ Langfuse 모니터링
```python
from langfuse import Langfuse

langfuse = Langfuse(
    public_key="pk-lf-c153ebfd-5ca6-42dc-9c88-bf669a85a17a",
    secret_key="sk-lf-e1ef0eec-285e-4575-b1a2-f4b5d5052e10",
    host="https://us.cloud.langfuse.com"
)

# LLM 호출이 자동으로 Langfuse에 기록됨
```

---

## 🔧 유용한 명령어

```bash
# Docker 서비스 상태 확인
docker-compose -f docker-compose.avengers.yml ps

# 특정 서비스 로그 보기
docker-compose -f docker-compose.avengers.yml logs -f litellm
docker-compose -f docker-compose.avengers.yml logs -f n8n
docker-compose -f docker-compose.avengers.yml logs -f qdrant

# 전체 스택 중지
docker-compose -f docker-compose.avengers.yml down

# 전체 스택 재시작
docker-compose -f docker-compose.avengers.yml restart

# 특정 서비스만 재시작
docker-compose -f docker-compose.avengers.yml restart litellm

# 컨테이너 내부에서 명령 실행
docker-compose -f docker-compose.avengers.yml exec postgres psql -U avengers -d avengers_db

# 가상환경 활성화
source .venv/bin/activate

# 패키지 설치/업데이트
pip install -r requirements.txt
pip install <패키지명>

# Python 초기화 스크립트 실행
python init_avengers_stack.py
```

---

## 🔐 보안 참고사항

1. **`.env` 파일은 절대 공개하지 마세요** ⚠️
   - API 키가 포함되어 있습니다
   - `.gitignore`에 추가되었습니다

2. **프로덕션 배포 시:**
   - 데이터베이스 비밀번호 변경
   - 강력한 POSTGRES_PASSWORD 사용
   - 더 강력한 보안 비밀 생성
   - API 키 회전

3. **API 키 관리:**
   - 민감한 키는 환경 변수로만 사용
   - 키가 손상되면 즉시 재생성

---

## 🐛 문제 해결

### Docker 시작 오류
```bash
# Docker 데몬 확인
docker ps

# Docker 재시작
sudo systemctl restart docker  # Linux
# macOS의 경우 Docker Desktop 재시작
```

### 포트 충돌
```bash
# 특정 포트 사용 중인 프로세스 확인
lsof -i :4000  # LiteLLM
lsof -i :5678  # n8n
lsof -i :6333  # Qdrant

# 프로세스 종료
kill -9 <PID>
```

### Python 패키지 오류
```bash
# 가상환경 삭제 후 재생성
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### API 연결 오류
1. API 키 확인 (.env 파일)
2. LiteLLM 서비스 확인 (`docker-compose logs litellm`)
3. Langfuse 대시보드 확인 (https://us.cloud.langfuse.com)

---

## 📈 다음 단계

1. **AI 에이전트 구축**
   - LangGraph로 상태 기반 워크플로우 생성
   - CrewAI로 멀티에이전트 협업 구성

2. **MCP 서버 개발**
   - 도구 및 데이터 소스 연결
   - 표준 프로토콜로 AI 접근

3. **A2A 에이전트 통신**
   - 에이전트 간 자동 협업
   - 분산 처리 구성

4. **RAG 파이프라인 구축**
   - Unstructured로 데이터 전처리
   - Qdrant에 임베딩 저장
   - mem0로 장기 메모리 추가

5. **모니터링 & 최적화**
   - Langfuse에서 성능 분석
   - 토큰 사용량 추적
   - 비용 최적화

---

## 📚 참고 자료

- [MCP Specification](https://modelcontextprotocol.io)
- [LangGraph Docs](https://langchain-ai.github.io/langgraph)
- [CrewAI Docs](https://docs.crewai.com)
- [LiteLLM Docs](https://docs.litellm.ai)
- [Langfuse Docs](https://langfuse.com/docs)
- [n8n Docs](https://docs.n8n.io)
- [Qdrant Docs](https://qdrant.tech/documentation/)
- [mem0 Docs](https://mem0.ai/docs)

---

## 🎯 요약

✅ **완전히 구성된 AI 인프라**
- 모든 필수 서비스 Docker 컨테이너화
- 실제 API 키 연동
- 자동 초기화 스크립트
- 즉시 사용 가능한 상태

🚀 **다음 명령 실행:**
```bash
./quickstart.sh
```

또는 수동으로:
```bash
docker-compose -f docker-compose.avengers.yml up -d
python init_avengers_stack.py
```

🎉 **성공! 이제 어벤져스 AI 스택을 사용할 준비가 되었습니다!**
