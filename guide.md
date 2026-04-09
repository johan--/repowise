# Repowise with Ollama — Model Selection Guide

Quick reference for running repowise with local Ollama models.

## Specifying the model

The model is set via `--model` on the CLI:

```bash
repowise init /path/to/repo --provider ollama --model qwen3:14b -y
```

This gets saved to `<repo>/.repowise/config.yaml`:

```yaml
provider: ollama
model: qwen3:14b
embedder: gemini
```

Subsequent commands (`repowise update`, `repowise watch`) read from that config file, so `--model` only needs to be passed once during `init`.

## Provider resolution order

When no `--provider` flag is given, repowise resolves providers in this order:

1. `--provider` CLI flag (highest priority)
2. `REPOWISE_PROVIDER` env var
3. `.repowise/config.yaml` (written by `init`)
4. Auto-detect from API key env vars (`ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `OLLAMA_BASE_URL`, `GEMINI_API_KEY`)

## Ollama-specific config

| Setting | Default | Override |
|---|---|---|
| Model | `llama3.2` | `--model <name>` |
| Base URL | `http://localhost:11434` | `OLLAMA_BASE_URL` env var |

Any model you've pulled locally works — the catalog list in `provider_config.py` is just for UI suggestions. You're not limited to it.

## Recommended models for code documentation

From `ollama.py` docstring and testing:

| Model | Strengths |
|---|---|
| `llama3.2` | Good general-purpose (default) |
| `codellama` | Code-focused, good for doc generation |
| `deepseek-coder-v2` | Strong code understanding |
| `qwen2.5-coder` | Excellent multilingual code model |
| `qwen3:14b` | Large context, good reasoning — slower on local GPU |

## Key CLI flags for init

```
--provider NAME      LLM provider (anthropic, openai, gemini, ollama, mock)
--model NAME         Model identifier override
--embedder NAME      Embedder for RAG: gemini | openai | mock
--test-run           Limit to top 10 files by PageRank (quick validation)
--dry-run            Show plan without running
--concurrency N      Max concurrent LLM calls (default: 5)
--index-only         Run ingestion (AST, graph, git) without LLM generation
--skip-tests         Skip test files
--skip-infra         Skip infrastructure files
--exclude PATTERN    Gitignore-style exclusion (repeatable)
--commit-limit N     Max commits to analyze (default: 500, max: 5000)
--resume             Resume from last checkpoint
--force              Regenerate all pages, ignoring existing
-y                   Skip cost confirmation prompt
```

## Where things live in the code

- **CLI flags**: `packages/cli/src/repowise/cli/commands/init_cmd.py`
- **Provider resolution**: `packages/cli/src/repowise/cli/helpers.py` — `resolve_provider()`
- **Config persistence**: `packages/cli/src/repowise/cli/helpers.py` — `save_config()` / `load_config()`
- **Ollama provider**: `packages/core/src/repowise/core/providers/llm/ollama.py`
- **Provider catalog (defaults/models list)**: `packages/server/src/repowise/server/provider_config.py`
