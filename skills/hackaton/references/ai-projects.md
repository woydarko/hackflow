# AI projects

Read when the idea or repo has an LLM, agent, RAG, vision, voice or ML feature (signals: deps like `@anthropic-ai/sdk`, `anthropic`, `openai`, `ai`, `langchain`, `llamaindex`, `transformers`, `torch`; or a brief that says chatbot, agent, assistant, generation, embeddings). Layers on top of every phase; superpowers still drives the workflow.

For anything that calls the Claude API or Anthropic SDK, load the `claude-api` skill first and use current model IDs from it, not from memory.

## Phase 1 (intake)
- Ask about the rules: are AI tools, specific model providers, or pre-trained models restricted? Is disclosure of AI usage required? Are credits provided (note the quota)?
- Idea filter reminder: the model is a component, not the product. Name what is more than a prompt (data, workflow, integration, UX).

## Phase 2 (design docs)
- ARCHITECTURE: which calls are made server-side (keys never in the client), what context is sent, what is cached, latency expectation, failure behavior.
- SECURITY: treat all retrieved or user-supplied text as untrusted input to the model (prompt injection); no tool with side effects reachable from untrusted text without confirmation; no real personal data in prompts or logs; redact secrets from logs.
- TESTING: an eval set (see below).

## Phase 4 (build)
- **Server-side proxy** for model calls; keys only in env vars; per-request token and timeout limits; retries with backoff; clear error states in the UI.
- **Cost control**: set provider spend caps/alerts, cap max output tokens, cache identical requests, avoid sending large context needlessly, use the cheapest model that passes the eval for each step.
- **Determinism for the demo path**: fix temperature/seed where supported, cache or record the responses used in the demo, keep a replay mode so the demo works when the API is slow, rate-limited or down. Label replay honestly in the README ("real vs mocked").
- **Latency UX**: stream output, show progress and loading states, never block the UI on a single long call.
- Agent loops: set a maximum number of steps and a visible stop; log each tool call during development.

## Phase 5 (verify)
- **Eval set**: 10-20 representative inputs including edge cases and adversarial ones, each with a pass/fail rule (exact check, schema check, or a rubric). Run it, record pass rate, latency and cost per run in TESTING.md. Re-run after every prompt or model change.
- Check refusals, empty outputs, truncated outputs, invalid JSON, and the fallback path.
- Prompt-injection test: feed text that tries to override instructions or leak the system prompt; confirm nothing sensitive leaks and no unintended tool call happens.
- Never claim accuracy numbers that were not measured; say "measured on N examples".

## Phase 6 (submission)
- README states: which models/providers and versions, what runs live vs replayed, known failure modes, and the AI-usage disclosure if the rules require it (including AI coding assistants used to build the project).
- Demo: pick inputs that show the strength, also show one handled failure; keep the replay mode ready.
- Do not publish keys, system prompts that embed secrets, or private datasets; check data licenses for anything used in training or retrieval.
