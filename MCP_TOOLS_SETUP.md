# 🚀 Avengers AI Tools - MCP 서버 설정 가이드

## 개요

업데이트된 MCP 서버(`mcp-server-v1`)에는 4가지 강력한 AI 도구가 통합되었습니다:

1. **BrowserBase** - 웹 브라우저 자동화
2. **Context7** - 컨텍스트 검색 및 문서 분석
3. **mem0** - AI 메모리 레이어
4. **Brave Search** - 프라이버시 기반 웹 검색

---

## 🔑 API 키 설정

### 1단계: 각 서비스에서 API 키 획득

#### BrowserBase
```bash
1. https://www.browserbase.com 접속
2. 로그인 또는 회원가입
3. Dashboard → API Keys → Create New Key
4. API Key 복사
```

#### Context7
```bash
1. https://context7.io 접속
2. 로그인 또는 회원가입
3. Settings → API Keys
4. API Key 생성 및 복사
```

#### mem0
```bash
1. https://mem0.ai 접속
2. 로그인 또는 회원가입
3. Dashboard → Settings → API Keys
4. API Key 생성 및 복사
```

#### Brave Search
```bash
1. https://api.search.brave.com/ 접속
2. Sign Up for API
3. Dashboard → API Keys
4. API Key 복사
```

---

### 2단계: 환경 변수 설정

#### 방법 1: GitHub Secrets (프로덕션)

`.github/SECRETS_GUIDE.md`를 참고하여 다음 secrets를 GitHub에 추가합니다:

```bash
gh secret set BROWSERBASE_API_KEY --body "your-key"
gh secret set CONTEXT7_API_KEY --body "your-key"
gh secret set MEM0_API_KEY --body "your-key"
gh secret set BRAVE_SEARCH_API_KEY --body "your-key"
```

#### 방법 2: 로컬 .env 파일 (개발)

```bash
# .env 파일 생성
cp .env.example .env

# 에디터로 .env 파일 열기
nano .env
# 또는
code .env
```

파일에 다음 내용 추가:

```bash
# MCP Tools API Keys
BROWSERBASE_API_KEY=your-browserbase-api-key
CONTEXT7_API_KEY=your-context7-api-key
MEM0_API_KEY=your-mem0-api-key
BRAVE_SEARCH_API_KEY=your-brave-search-api-key
```

---

## 🚀 MCP 서버 실행

### 개발 모드 (port 8081 플레이그라운드 포함)

```bash
cd mcp-server-v1
npm run dev
```

**출력 예시:**
```
✅ Smithery playground: http://localhost:8081
🚀 Avengers AI Tools MCP Server started
📍 Available Tools:
   - browserbase_navigate
   - context7_search
   - mem0_add_memory
   - mem0_recall
   - brave_search
```

### 프로덕션 빌드

```bash
cd mcp-server-v1
npm run build
```

번들된 파일: `.smithery/` 디렉토리에 생성됨

---

## 📋 각 도구 사용법

### 1. BrowserBase - 웹 브라우저 자동화

**목적**: URL 접속 후 콘텐츠 추출

**입력 파라미터:**
- `url` (필수): 네비게이션할 URL
- `waitFor` (선택): CSS 선택자 (요소 로딩 대기)
- `timeout` (선택): 타임아웃 (밀리초)

**사용 예시:**
```json
{
  "url": "https://example.com",
  "waitFor": ".content",
  "timeout": 30000
}
```

**반환값:**
- ✅ 성공: 페이지 콘텐츠 및 메타데이터
- ❌ 실패: 에러 메시지

---

### 2. Context7 - 컨텍스트 검색

**목적**: 문서/정보 검색 및 분석

**입력 파라미터:**
- `query` (필수): 검색 쿼리
- `limit` (선택): 결과 개수 (기본값: 10)
- `includeMetadata` (선택): 메타데이터 포함 여부

**사용 예시:**
```json
{
  "query": "AI 모델 최신 기술 동향",
  "limit": 20,
  "includeMetadata": true
}
```

**반환값:**
- ✅ 성공: 검색 결과 + 메타데이터
- ❌ 실패: 에러 메시지

---

### 3. mem0 - AI 메모리

#### 3.1 메모리 저장 (mem0_add_memory)

**목적**: 중요한 정보 저장

**입력 파라미터:**
- `memory` (필수): 저장할 정보
- `category` (선택): 카테고리 (예: "user_context", "conversation")
- `importance` (선택): 중요도 ("low", "medium", "high")

**사용 예시:**
```json
{
  "memory": "사용자는 암호화폐 거래에 관심있음",
  "category": "user_context",
  "importance": "high"
}
```

**반환값:**
```json
{
  "id": "mem_12345",
  "category": "user_context",
  "importance": "high",
  "content": "사용자는 암호화폐 거래에 관심있음"
}
```

#### 3.2 메모리 회상 (mem0_recall)

**목적**: 저장된 정보 검색

**입력 파라미터:**
- `query` (필수): 검색 쿼리
- `category` (선택): 필터링 카테고리
- `limit` (선택): 반환 개수

**사용 예시:**
```json
{
  "query": "암호화폐",
  "category": "user_context",
  "limit": 5
}
```

**반환값:**
```json
{
  "memories": [
    {
      "id": "mem_12345",
      "content": "사용자는 암호화폐 거래에 관심있음",
      "relevance_score": 0.95
    }
  ]
}
```

---

### 4. Brave Search - 프라이버시 검색

**목적**: 프라이버시를 보호하는 웹 검색

**입력 파라미터:**
- `query` (필수): 검색 쿼리
- `count` (선택): 결과 개수 (1-20, 기본값: 10)
- `safesearch` (선택): "off", "moderate", "strict"

**사용 예시:**
```json
{
  "query": "최신 AI 기술 동향",
  "count": 10,
  "safesearch": "moderate"
}
```

**반환값:**
```json
{
  "results": [
    {
      "title": "...",
      "url": "...",
      "description": "..."
    }
  ]
}
```

---

## 🔗 통합 워크플로우

### 웹 리서치 워크플로우

```
1. Brave Search → 관련 웹 소스 검색
   ↓
2. BrowserBase → 주요 페이지 네비게이션
   ↓
3. Context7 → 정보 분석 및 합성
   ↓
4. mem0 → 발견 사항 저장
```

### 메모리 기반 어시스턴트

```
1. 사용자 쿼리 수신
   ↓
2. mem0_recall → 관련 메모리 회상
   ↓
3. 맥락 인식 응답 생성
   ↓
4. mem0_add_memory → 새로운 정보 저장
```

---

## 📊 모니터링 & 로그

### 로컬 개발 디버그 모드

MCP 서버를 Debug 플래그와 함께 실행:

```bash
cd mcp-server-v1
DEBUG=* npm run dev
```

### 사용 가능한 리소스

MCP Playground에서 `status://api-keys` 리소스 접속:

```
GET status://api-keys
```

응답:
```
🔐 API Keys Status Report

🔑 BrowserBase: ✅ Configured
🔑 Context7: ✅ Configured
🔑 mem0: ✅ Configured
🔑 Brave Search: ✅ Configured
```

---

## ✅ 체크리스트

- [ ] 4개 API 키 모두 획득됨
- [ ] `.env` 파일 또는 GitHub Secrets에 설정됨
- [ ] `npm install` 완료
- [ ] `npm run dev` 실행 가능
- [ ] MCP Playground 접속 가능 (http://localhost:8081)
- [ ] 각 도구 테스트 완료

---

## 🐛 문제 해결

### "API Key not configured" 에러

**해결책:**
1. `.env` 파일 확인
2. 환경 변수 이름 정확성 확인 (대소문자 구분)
3. MCP 서버 재시작: `npm run dev`

### 타임아웃 에러 (BrowserBase)

**해결책:**
1. `timeout` 값 증가 (예: 60000ms)
2. 네트워크 연결 확인
3. BrowserBase 서버 상태 확인: https://status.browserbase.com

### mem0 연결 거부

**해결책:**
1. mem0 서버 실행 중 확인
2. 포트 8000 사용 가능 확인
3. Docker에서 실행 중이면 네트워크 연결 확인

---

## 📚 추가 참고자료

- [BrowserBase API Docs](https://docs.browserbase.com)
- [Context7 API Docs](https://docs.context7.io)
- [mem0 Documentation](https://docs.mem0.ai)
- [Brave Search API Docs](https://api.search.brave.com/res/v1/documentation/web-search)
- [MCP 프로토콜](https://modelcontextprotocol.io)

---

## 💬 지원

문제가 발생하면:
1. `.github/copilot-instructions.md` 확인
2. `.github/SECRETS_GUIDE.md` 확인
3. GitHub Issues에 보고
