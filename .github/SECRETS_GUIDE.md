# 🔐 GitHub Secrets 설정 가이드

## 개요

이 프로젝트는 **하이브리드 Secret 관리** 방식을 사용합니다:
- **로컬 개발**: `.env` 파일 (`.gitignore`에 등록)
- **CI/CD 배포**: GitHub Secrets
- **프로덕션**: AWS Secrets Manager (선택사항)

---

## 📋 설정 단계

### 1단계: GitHub Repository 설정

#### 1.1 GitHub Secrets 추가

```bash
Repository → Settings → Secrets and variables → Actions
```

**다음 secrets를 추가하세요:**

| Secret 이름 | 설명 | 값 |
|------------|------|-----|
| `OPENAI_API_KEY` | OpenAI API 키 | `sk-proj-8-4ZThB4SzguT0FYixLd...` |
| `ANTHROPIC_API_KEY` | Anthropic API 키 | `sk-ant-api03-ZEVuKfeYPVSc...` |
| `GOOGLE_API_KEY` | Google API 키 | `AIzaSyBEt-YphhB-U8LWihbd...` |
| `LANGFUSE_PUBLIC_KEY` | Langfuse Public Key | `pk-lf-c153ebfd-5ca6-42dc-...` |
| `LANGFUSE_SECRET_KEY` | Langfuse Secret Key | `sk-lf-e1ef0eec-285e-4575-...` |
| `LANGFUSE_BASE_URL` | Langfuse Cloud URL | `https://us.cloud.langfuse.com` |
| `POSTGRES_PASSWORD` | PostgreSQL 비밀번호 | `avengers_secret_2025` |
| `NEO4J_PASSWORD` | Neo4j 비밀번호 | `avengers_neo4j_2025` |
| `LITELLM_MASTER_KEY` | LiteLLM Master Key | `sk-avengers-master-key` |
| `N8N_ENCRYPTION_KEY` | n8n 암호화 키 | `vwsCfesK30aD6FhzNLZ1mpw...` |

#### 1.2 UI를 통한 추가

```
GitHub Repository → Settings → Secrets and variables → Actions → New repository secret
```

**예시:**
```
Name: OPENAI_API_KEY
Secret: sk-proj-YOUR_ACTUAL_API_KEY_HERE (실제 키로 대체)
```

#### 1.3 GitHub CLI를 통한 일괄 추가

```bash
# 1. GitHub CLI 설치 (mac의 경우)
brew install gh

# 2. 인증
gh auth login

# 3. Secrets 일괄 추가
gh secret set OPENAI_API_KEY --body "sk-proj-..."
gh secret set ANTHROPIC_API_KEY --body "sk-ant-..."
gh secret set GOOGLE_API_KEY --body "AIzaSyB..."
# ... 등등

# 4. 등록된 secrets 확인
gh secret list
```

---

### 2단계: GitHub Actions Workflow 확인

`.github/workflows/deploy.yml`이 다음을 포함하는지 확인:

```yaml
env:
  OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
  ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
  GOOGLE_API_KEY: ${{ secrets.GOOGLE_API_KEY }}
  LANGFUSE_PUBLIC_KEY: ${{ secrets.LANGFUSE_PUBLIC_KEY }}
  LANGFUSE_SECRET_KEY: ${{ secrets.LANGFUSE_SECRET_KEY }}
  LANGFUSE_BASE_URL: ${{ secrets.LANGFUSE_BASE_URL }}
  POSTGRES_PASSWORD: ${{ secrets.POSTGRES_PASSWORD }}
  NEO4J_PASSWORD: ${{ secrets.NEO4J_PASSWORD }}
  LITELLM_MASTER_KEY: ${{ secrets.LITELLM_MASTER_KEY }}
  N8N_ENCRYPTION_KEY: ${{ secrets.N8N_ENCRYPTION_KEY }}
```

---

## 🔒 보안 모범 사례

### ✅ DO (권장)

```bash
# ✅ 로컬 개발은 .env 파일 사용 (git에 커밋하지 않음)
.env                          # .gitignore 등록
├─ OPENAI_API_KEY=sk-proj-...
└─ ANTHROPIC_API_KEY=sk-ant-...

# ✅ GitHub Secrets로 CI/CD 배포
GitHub Settings → Secrets
├─ OPENAI_API_KEY
└─ ANTHROPIC_API_KEY

# ✅ 주기적으로 API 키 로테이션
# 매 월/분기마다 새 키 생성 및 업데이트

# ✅ 환경별 다른 키 사용
Development: dev-sk-proj-...
Staging:    staging-sk-proj-...
Production: prod-sk-proj-...
```

### ❌ DON'T (금지)

```bash
# ❌ API 키를 .env 파일에 저장하고 git에 커밋
git add .env              # 절대 금지!
git commit -m "Add API keys"

# ❌ README나 코드 주석에 API 키 노출
API_KEY = "sk-proj-..."   # 금지!
# OPENAI_API_KEY="sk-ant-..." (주석도 금지)

# ❌ 평문 텍스트로 CI/CD 파일에 저장
env:
  OPENAI_API_KEY: sk-proj-...  # 금지! (hardcoded)

# ❌ Slack, Discord, 이메일로 전송
"Your API key is: sk-proj-..."  # 금지!
```

---

## 🚨 비상 대응 (Key Compromised)

API 키가 유출된 경우:

### 1단계: 즉시 조치 (5분 내)
```bash
# 1. 해당 API 서비스 대시보드 접속
# 예: https://platform.openai.com/api-keys

# 2. 노출된 키 삭제
# - OpenAI: Delete API Key
# - Anthropic: Revoke API Key
# - Google: Delete API Key

# 3. 새 키 생성
# 각 서비스에서 새로운 키 생성

# 4. GitHub Secrets 업데이트
gh secret set OPENAI_API_KEY --body "new-sk-proj-..."
```

### 2단계: 감사 로그 확인 (1시간 내)
```bash
# 로그 확인
# OpenAI: https://platform.openai.com/account/billing/usage
# Anthropic: https://console.anthropic.com/usage
# Google: https://console.cloud.google.com/logs

# 비정상 활동 확인
# - 예상치 못한 API 호출
# - 이상한 청구
# - 지역 불일치
```

### 3단계: 팀 공지 (즉시)
```bash
# 팀 채널에 알림
"⚠️ OpenAI API Key가 노출되었습니다.
- 조치: 새 키로 교체 완료
- 영향: 제한적 (비용 한도 설정됨)
- 상태: 복구됨"
```

---

## 🔄 CI/CD 배포 프로세스

### 배포 플로우

```
┌─────────────────────────────────────────────┐
│ 1. Git Push to main                         │
│    git push origin main                     │
└────────────┬────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────┐
│ 2. GitHub Actions 트리거                   │
│    .github/workflows/deploy.yml 실행        │
└────────────┬────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────┐
│ 3. Secrets 로드                             │
│    env:                                     │
│      OPENAI_API_KEY: ${{secrets.OPENAI...}}│
└────────────┬────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────┐
│ 4. .env 파일 동적 생성                      │
│    cat > .env << EOF                        │
│    OPENAI_API_KEY=${{...}}                  │
│    ...                                      │
│    EOF                                      │
└────────────┬────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────┐
│ 5. Docker Compose 배포                      │
│    docker-compose up -d                     │
└────────────┬────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────┐
│ 6. 서비스 검증                              │
│    docker-compose ps                        │
│    확인: 모든 서비스 Running                 │
└─────────────────────────────────────────────┘
```

### 배포 상태 확인

```bash
# GitHub Actions 로그 보기
Repository → Actions → Latest workflow run → deploy job

# 로그에서 다음 확인:
✅ Checkout code        [OK]
✅ Set up Docker        [OK]
✅ Deploy with Docker   [OK]
✅ Verify deployment    [OK]
```

---

## 🎯 환경별 설정

### 로컬 개발

```bash
# 1. 로컬 .env 파일 생성
cp .env.example .env

# 2. 실제 API 키 입력
nano .env
# 또는 IDE에서 편집

# 3. Docker 실행
docker-compose -f docker-compose.avengers.yml up -d

# 4. Python 실행
python init_avengers_stack.py
```

### 스테이징/프로덕션

```bash
# 1. GitHub Secrets에 키 저장
# (이미 위에서 설정함)

# 2. Git Push
git push origin main

# 3. GitHub Actions 자동 배포
# .github/workflows/deploy.yml 자동 실행

# 4. 배포 상태 확인
Repository → Actions
```

---

## 📊 Secret 순환 정책 (Rotation)

### 월간 순환

```bash
# 월 첫째 주에 실행
1. 새 API 키 생성 (각 서비스별)
2. GitHub Secrets 업데이트
3. 로컬 .env 파일 업데이트
4. 팀에 공지
5. 7일 후 이전 키 삭제
```

### 긴급 순환

```bash
# 유출 발생 시 즉시
1. 해당 키 삭제
2. 새 키 생성
3. GitHub Secrets, .env 업데이트
4. 배포 재실행
5. 모니터링 강화
```

---

## 🔍 감시 및 모니터링

### API 사용량 모니터링

```bash
# OpenAI
# https://platform.openai.com/account/billing/usage

# Anthropic
# https://console.anthropic.com/usage

# Google
# https://console.cloud.google.com/billing
```

### GitHub Actions 실패 모니터링

```bash
# 실패 알림 설정
Repository → Settings → Notifications
→ Email on: Workflow run failure
```

### 비정상 활동 탐지

```bash
# 다음을 주시하세요:
- 예상치 못한 높은 청구
- 다른 지역에서의 API 호출
- 급격한 API 사용량 증가
```

---

## 📚 참고 자료

- [GitHub Secrets Docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [GitHub Actions Security](https://docs.github.com/en/actions/security-guides)
- [OWASP Secret Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
- [OpenAI API Security](https://platform.openai.com/docs/guides/production-best-practices/api-keys)

---

## ✅ 체크리스트

- [ ] GitHub Secrets 10개 모두 추가됨
- [ ] `.github/workflows/deploy.yml` 확인됨
- [ ] 로컬 `.env` 파일이 `.gitignore`에 등록됨
- [ ] 첫 배포 테스트 완료
- [ ] 팀에 Secret 관리 정책 공유됨
- [ ] 월간 순환 일정 설정됨
- [ ] 비상 대응 절차 숙지됨

---

## 💬 질문이 있으신가요?

Secret 관리에 대해 더 알고 싶으시면:
- `.github/workflows/deploy.yml` 파일 확인
- 로컬 `.env.example` 템플릿 참고
- GitHub Actions 로그에서 배포 상태 확인
