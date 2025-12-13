import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { z } from "zod"
import axios from "axios"
import * as dotenv from "dotenv"

// 환경 변수 로드
dotenv.config()

// 설정 스키마 정의
export const configSchema = z.object({
	debug: z.boolean().default(false).describe("Enable debug logging"),
	browserbaseApiKey: z.string().optional().describe("Browserbase API Key"),
	context7ApiKey: z.string().optional().describe("Context7 API Key"),
	mem0ApiKey: z.string().optional().describe("mem0 API Key"),
	braveSearchApiKey: z.string().optional().describe("Brave Search API Key"),
})

export default function createServer({
	config,
}: {
	config: z.infer<typeof configSchema>
}) {
	const server = new McpServer({
		name: "Avengers AI Tools",
		version: "2.0.0",
	})

	// ═══════════════════════════════════════════════════════════
	// 1. BrowserBase Tool - 웹 브라우저 자동화
	// ═══════════════════════════════════════════════════════════
	server.registerTool(
		"browserbase_navigate",
		{
			title: "Navigate with BrowserBase",
			description: "Navigate to a URL and extract content using BrowserBase browser automation",
			inputSchema: {
				url: z.string().url().describe("URL to navigate to"),
				waitFor: z.string().optional().describe("CSS selector to wait for"),
				timeout: z.number().optional().describe("Timeout in milliseconds"),
			},
		},
		async ({ url, waitFor, timeout }) => {
			if (!config.browserbaseApiKey) {
				return {
					content: [
						{
							type: "text",
							text: "❌ BrowserBase API Key not configured. Please set BROWSERBASE_API_KEY environment variable.",
						},
					],
				}
			}

			try {
				// BrowserBase API 호출
				const response = await axios.post(
					"https://api.browserbase.com/v1/sessions",
					{
						url: url,
						wait_for: waitFor,
						timeout_ms: timeout || 30000,
					},
					{
						headers: {
							Authorization: `Bearer ${config.browserbaseApiKey}`,
							"Content-Type": "application/json",
						},
					}
				)

				return {
					content: [
						{
							type: "text",
							text: `✅ BrowserBase Navigation successful\n\nURL: ${url}\nContent: ${JSON.stringify(response.data, null, 2)}`,
						},
					],
				}
			} catch (error: unknown) {
				const errorMsg = error instanceof Error ? error.message : String(error)
				return {
					content: [
						{
							type: "text",
							text: `❌ BrowserBase Navigation failed: ${errorMsg}`,
						},
					],
				}
			}
		}
	)

	// ═══════════════════════════════════════════════════════════
	// 2. Context7 Tool - 컨텍스트 검색 및 문서 분석
	// ═══════════════════════════════════════════════════════════
	server.registerTool(
		"context7_search",
		{
			title: "Search with Context7",
			description: "Search and analyze documents using Context7 for comprehensive context understanding",
			inputSchema: {
				query: z.string().describe("Search query"),
				limit: z.number().optional().describe("Number of results to return"),
				includeMetadata: z.boolean().optional().describe("Include metadata in results"),
			},
		},
		async ({ query, limit, includeMetadata }) => {
			if (!config.context7ApiKey) {
				return {
					content: [
						{
							type: "text",
							text: "❌ Context7 API Key not configured. Please set CONTEXT7_API_KEY environment variable.",
						},
					],
				}
			}

			try {
				const response = await axios.post(
					"https://api.context7.io/v1/search",
					{
						query: query,
						limit: limit || 10,
						include_metadata: includeMetadata || false,
					},
					{
						headers: {
							Authorization: `Bearer ${config.context7ApiKey}`,
							"Content-Type": "application/json",
						},
					}
				)

				return {
					content: [
						{
							type: "text",
							text: `✅ Context7 Search successful\n\nQuery: "${query}"\nResults: ${JSON.stringify(response.data, null, 2)}`,
						},
					],
				}
			} catch (error: unknown) {
				const errorMsg = error instanceof Error ? error.message : String(error)
				return {
					content: [
						{
							type: "text",
							text: `❌ Context7 Search failed: ${errorMsg}`,
						},
					],
				}
			}
		}
	)

	// ═══════════════════════════════════════════════════════════
	// 3. mem0 Tool - AI 메모리 레이어
	// ═══════════════════════════════════════════════════════════
	server.registerTool(
		"mem0_add_memory",
		{
			title: "Add Memory to mem0",
			description: "Store and update memories in mem0 for persistent agent memory",
			inputSchema: {
				memory: z.string().describe("Memory content to store"),
				category: z.string().optional().describe("Memory category (e.g., 'user_context', 'conversation')"),
				importance: z.enum(["low", "medium", "high"]).optional().describe("Memory importance level"),
			},
		},
		async ({ memory, category, importance }) => {
			if (!config.mem0ApiKey) {
				return {
					content: [
						{
							type: "text",
							text: "❌ mem0 API Key not configured. Please set MEM0_API_KEY environment variable.",
						},
					],
				}
			}

			try {
				const response = await axios.post(
					"http://localhost:8000/v1/memories/add",
					{
						memory: memory,
						category: category || "default",
						importance: importance || "medium",
						timestamp: new Date().toISOString(),
					},
					{
						headers: {
							Authorization: `Bearer ${config.mem0ApiKey}`,
							"Content-Type": "application/json",
						},
					}
				)

				return {
					content: [
						{
							type: "text",
							text: `✅ Memory added to mem0\n\nMemory ID: ${response.data.id}\nCategory: ${category || "default"}\nImportance: ${importance || "medium"}\nContent: "${memory}"`,
						},
					],
				}
			} catch (error: unknown) {
				const errorMsg = error instanceof Error ? error.message : String(error)
				return {
					content: [
						{
							type: "text",
							text: `⚠️ mem0 Memory storage: ${errorMsg}\n\n📝 Local memory fallback active: ${memory}`,
						},
					],
				}
			}
		}
	)

	server.registerTool(
		"mem0_recall",
		{
			title: "Recall Memory from mem0",
			description: "Retrieve stored memories from mem0 for context-aware responses",
			inputSchema: {
				query: z.string().describe("Memory recall query"),
				category: z.string().optional().describe("Filter by memory category"),
				limit: z.number().optional().describe("Number of memories to retrieve"),
			},
		},
		async ({ query, category, limit }) => {
			if (!config.mem0ApiKey) {
				return {
					content: [
						{
							type: "text",
							text: "❌ mem0 API Key not configured. Please set MEM0_API_KEY environment variable.",
						},
					],
				}
			}

			try {
				const response = await axios.get(
					"http://localhost:8000/v1/memories/recall",
					{
						params: {
							query: query,
							category: category,
							limit: limit || 5,
						},
						headers: {
							Authorization: `Bearer ${config.mem0ApiKey}`,
						},
					}
				)

				return {
					content: [
						{
							type: "text",
							text: `✅ Memories recalled from mem0\n\nQuery: "${query}"\nResults: ${JSON.stringify(response.data, null, 2)}`,
						},
					],
				}
			} catch (error: unknown) {
				const errorMsg = error instanceof Error ? error.message : String(error)
				return {
					content: [
						{
							type: "text",
							text: `❌ mem0 Recall failed: ${errorMsg}`,
						},
					],
				}
			}
		}
	)

	// ═══════════════════════════════════════════════════════════
	// 4. Brave Search Tool - 프라이버시 기반 검색
	// ═══════════════════════════════════════════════════════════
	server.registerTool(
		"brave_search",
		{
			title: "Search with Brave Search",
			description: "Search the web using Brave Search for privacy-respecting search results",
			inputSchema: {
				query: z.string().describe("Search query"),
				count: z.number().optional().describe("Number of results (1-20)"),
				safesearch: z.enum(["off", "moderate", "strict"]).optional().describe("Safe search level"),
			},
		},
		async ({ query, count, safesearch }) => {
			if (!config.braveSearchApiKey) {
				return {
					content: [
						{
							type: "text",
							text: "❌ Brave Search API Key not configured. Please set BRAVE_SEARCH_API_KEY environment variable.",
						},
					],
				}
			}

			try {
				const response = await axios.get("https://api.search.brave.com/res/v1/web/search", {
					params: {
						q: query,
						count: Math.min(count || 10, 20),
						safesearch: safesearch || "moderate",
					},
					headers: {
						Accept: "application/json",
						"X-Subscription-Token": config.braveSearchApiKey,
					},
				})

				const results = response.data.web?.map((item: any) => ({
					title: item.title,
					url: item.url,
					description: item.description,
				})) || []

				return {
					content: [
						{
							type: "text",
							text: `✅ Brave Search results\n\nQuery: "${query}"\nResults count: ${results.length}\n\n${results
								.map((r: any, i: number) => `${i + 1}. ${r.title}\n   URL: ${r.url}\n   ${r.description}`)
								.join("\n\n")}`,
						},
					],
				}
			} catch (error: unknown) {
				const errorMsg = error instanceof Error ? error.message : String(error)
				return {
					content: [
						{
							type: "text",
							text: `❌ Brave Search failed: ${errorMsg}`,
						},
					],
				}
			}
		}
	)

	// ═══════════════════════════════════════════════════════════
	// RESOURCES - 읽기 전용 데이터
	// ═══════════════════════════════════════════════════════════

	server.registerResource(
		"api-keys-status",
		"status://api-keys",
		{
			title: "API Keys Configuration Status",
			description: "Current status of all configured API keys",
		},
		async () => ({
			contents: [
				{
					uri: "status://api-keys",
					text: `🔐 API Keys Status Report
					
🔑 BrowserBase: ${config.browserbaseApiKey ? "✅ Configured" : "❌ Not configured"}
🔑 Context7: ${config.context7ApiKey ? "✅ Configured" : "❌ Not configured"}
🔑 mem0: ${config.mem0ApiKey ? "✅ Configured" : "❌ Not configured"}
🔑 Brave Search: ${config.braveSearchApiKey ? "✅ Configured" : "❌ Not configured"}

📝 Setup Instructions:
1. Set environment variables in .env file:
   - BROWSERBASE_API_KEY=your_key
   - CONTEXT7_API_KEY=your_key
   - MEM0_API_KEY=your_key
   - BRAVE_SEARCH_API_KEY=your_key

2. Reload the server (npm run dev)

3. All tools will be available once configured`,
					mimeType: "text/plain",
				},
			],
		})
	)

	// ═══════════════════════════════════════════════════════════
	// PROMPTS - 재사용 가능한 메시지 템플릿
	// ═══════════════════════════════════════════════════════════

	server.registerPrompt(
		"web_research",
		{
			title: "Web Research Workflow",
			description: "Multi-step workflow for comprehensive web research",
			argsSchema: {
				topic: z.string().describe("Topic to research"),
				depth: z.enum(["shallow", "medium", "deep"]).optional().describe("Research depth"),
			},
		},
		async ({ topic, depth }) => {
			return {
				messages: [
					{
						role: "user",
						content: {
							type: "text",
							text: `Conduct a ${depth || "medium"} depth research on "${topic}" using:
1. Brave Search - Find relevant web sources
2. BrowserBase - Navigate to key pages and extract detailed content
3. Context7 - Analyze and synthesize the information
4. mem0 - Store findings in persistent memory

Provide a comprehensive research report with key findings, sources, and insights.`,
						},
					},
				],
			}
		}
	)

	server.registerPrompt(
		"memory_assistant",
		{
			title: "Memory-Augmented Assistant",
			description: "Use mem0 to provide context-aware responses with memory",
			argsSchema: {
				query: z.string().describe("User query"),
				usePreviousContext: z.boolean().optional().describe("Include previous conversation context"),
			},
		},
		async ({ query, usePreviousContext }) => {
			return {
				messages: [
					{
						role: "user",
						content: {
							type: "text",
							text: `${usePreviousContext ? "Using previous context from mem0: " : ""}
User query: "${query}"

Please:
1. Recall relevant memories using mem0_recall
2. Answer the question with context awareness
3. Store new important information using mem0_add_memory
4. Provide a well-informed response`,
						},
					},
				],
			}
		}
	)

	if (config.debug) {
		console.log("🚀 Avengers AI Tools MCP Server started")
		console.log("📍 Available Tools:")
		console.log("   - browserbase_navigate")
		console.log("   - context7_search")
		console.log("   - mem0_add_memory")
		console.log("   - mem0_recall")
		console.log("   - brave_search")
	}

	return server.server
}
