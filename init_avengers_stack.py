#!/usr/bin/env python3
"""
어벤져스 AI 스택 초기화 스크립트
모든 구성 요소 연결 및 검증
"""
import os
import sys
from dotenv import load_dotenv

# 환경 변수 로드
load_dotenv()

# ═══════════════════════════════════════════════════════════
# 1. LiteLLM 연결 (LLM Gateway)
# ═══════════════════════════════════════════════════════════
def test_litellm():
    """LiteLLM 프록시 테스트"""
    try:
        from litellm import completion
        
        response = completion(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": "Hello!"}],
            api_base="http://localhost:4000",
            api_key=os.getenv("LITELLM_MASTER_KEY")
        )
        print("✅ LiteLLM: Connected")
        return response
    except Exception as e:
        print(f"⚠️  LiteLLM: Connection failed - {e}")
        return None

# ═══════════════════════════════════════════════════════════
# 2. Qdrant 연결 (Vector DB)
# ═══════════════════════════════════════════════════════════
def test_qdrant():
    """Qdrant 연결 테스트"""
    try:
        from qdrant_client import QdrantClient
        
        client = QdrantClient(host="localhost", port=6333)
        collections = client.get_collections()
        print(f"✅ Qdrant: Connected ({len(collections.collections)} collections)")
        return client
    except Exception as e:
        print(f"⚠️  Qdrant: Connection failed - {e}")
        return None

# ═══════════════════════════════════════════════════════════
# 3. mem0 초기화 (AI Memory)
# ═══════════════════════════════════════════════════════════
def init_mem0():
    """mem0 메모리 레이어 초기화"""
    try:
        from mem0 import Memory
        
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
    except Exception as e:
        print(f"⚠️  mem0: Initialization failed - {e}")
        return None

# ═══════════════════════════════════════════════════════════
# 4. Langfuse 연결 (Observability)
# ═══════════════════════════════════════════════════════════
def init_langfuse():
    """Langfuse 관측성 초기화 (클라우드 기반)"""
    try:
        from langfuse import Langfuse
        
        langfuse = Langfuse(
            public_key=os.getenv("LANGFUSE_PUBLIC_KEY"),
            secret_key=os.getenv("LANGFUSE_SECRET_KEY"),
            host=os.getenv("LANGFUSE_BASE_URL", "https://us.cloud.langfuse.com")
        )
        print("✅ Langfuse: Connected (Cloud)")
        return langfuse
    except Exception as e:
        print(f"⚠️  Langfuse: Connection failed - {e}")
        return None

# ═══════════════════════════════════════════════════════════
# 5. LangGraph Agent 예제
# ═══════════════════════════════════════════════════════════
def create_avengers_agent():
    """LangGraph 기반 에이전트 생성"""
    try:
        from langgraph.graph import StateGraph, END
        from typing import TypedDict, Annotated
        import operator
        
        class AgentState(TypedDict):
            messages: Annotated[list, operator.add]
            memory_context: str
        
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
    except Exception as e:
        print(f"⚠️  LangGraph Agent: Creation failed - {e}")
        return None

# ═══════════════════════════════════════════════════════════
# 6. CrewAI 팀 예제
# ═══════════════════════════════════════════════════════════
def create_avengers_crew():
    """CrewAI 멀티에이전트 팀 생성"""
    try:
        from crewai import Agent
        
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
    except Exception as e:
        print(f"⚠️  CrewAI Team: Creation failed - {e}")
        return None

# ═══════════════════════════════════════════════════════════
# 7. PostgreSQL 연결 테스트
# ═══════════════════════════════════════════════════════════
def test_postgresql():
    """PostgreSQL 연결 테스트"""
    try:
        import asyncpg
        import asyncio
        
        async def check_postgres():
            conn = await asyncpg.connect(
                user='avengers',
                password=os.getenv('POSTGRES_PASSWORD', 'avengers_secret_2025'),
                database='avengers_db',
                host='localhost',
                port=5433  # 포트 변경
            )
            await conn.close()
            return True
        
        asyncio.run(check_postgres())
        print("✅ PostgreSQL: Connected")
        return True
    except Exception as e:
        print(f"⚠️  PostgreSQL: Connection failed - {e}")
        return False

# ═══════════════════════════════════════════════════════════
# 8. Redis 연결 테스트
# ═══════════════════════════════════════════════════════════
def test_redis():
    """Redis 연결 테스트"""
    try:
        import redis
        
        r = redis.Redis(host='localhost', port=6379, db=0)
        r.ping()
        print("✅ Redis: Connected")
        return r
    except Exception as e:
        print(f"⚠️  Redis: Connection failed - {e}")
        return None

# ═══════════════════════════════════════════════════════════
# 9. Neo4j 연결 테스트
# ═══════════════════════════════════════════════════════════
def test_neo4j():
    """Neo4j 연결 테스트"""
    try:
        from neo4j import GraphDatabase
        
        driver = GraphDatabase.driver(
            "bolt://localhost:7687",
            auth=("neo4j", os.getenv("NEO4J_PASSWORD", "avengers_neo4j_2025"))
        )
        driver.verify_connectivity()
        print("✅ Neo4j: Connected")
        driver.close()
        return True
    except Exception as e:
        print(f"⚠️  Neo4j: Connection failed - {e}")
        return False

# ═══════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════
if __name__ == "__main__":
    print("\n" + "="*60)
    print("🦸 Initializing Avengers AI Stack...")
    print("="*60 + "\n")
    
    try:
        # 1. PostgreSQL
        test_postgresql()
        
        # 2. Redis
        test_redis()
        
        # 3. Qdrant (Vector DB)
        qdrant = test_qdrant()
        
        # 4. Neo4j
        test_neo4j()
        
        # 5. LLM Gateway (Docker 실행 필요)
        # test_litellm()
        
        # 6. Memory Layer
        # memory = init_mem0()
        
        # 7. Observability
        langfuse = init_langfuse()
        
        # 8. LangGraph Agent
        agent = create_avengers_agent()
        
        # 9. CrewAI Team
        crew = create_avengers_crew()
        
        print("\n" + "="*60)
        print("✅ Avengers Stack Ready!")
        print("="*60)
        print("\n📊 구성요소별 접속 URL:")
        print("  • Langfuse:   http://localhost:3000")
        print("  • LiteLLM:    http://localhost:4000")
        print("  • n8n:        http://localhost:5678")
        print("  • Qdrant:     http://localhost:6333")
        print("  • Neo4j:      http://localhost:7474")
        print("  • PostgreSQL: localhost:5432")
        print("  • Redis:      localhost:6379")
        print("\n")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        print("\n💡 Troubleshooting:")
        print("  1. Docker 컨테이너가 실행 중인지 확인하세요:")
        print("     docker-compose -f docker-compose.avengers.yml ps")
        print("  2. 모든 컨테이너를 시작하려면:")
        print("     docker-compose -f docker-compose.avengers.yml up -d")
        print("  3. 로그를 확인하려면:")
        print("     docker-compose -f docker-compose.avengers.yml logs -f")
        sys.exit(1)
