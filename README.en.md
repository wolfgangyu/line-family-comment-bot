# LINE Family Comment Bot

A self-hostable n8n chatbot template for Taiwanese family LINE groups.

When family members share text, photos, daily life updates, health questions, or the greeting cards and blessing pictures that older relatives love to forward, this bot replies with a warm, respectful, and genuinely thoughtful tone — never generic, never dismissive.

You do not need to be an engineer. We recommend pasting this GitHub repo URL into Codex, Claude Code, Gemini CLI, or any other coding agent, and letting it guide you step by step following [AGENTS.md](AGENTS.md).

> 🇹🇼 [繁體中文版 README](README.md)

## Why this project matters

In many Taiwanese family LINE groups, older relatives frequently share image-heavy greeting cards, blessing pictures, and "good morning" messages. This bot explores how AI can help generate polite, warm, and culturally appropriate Traditional Chinese replies while keeping the workflow self-hostable and developer-friendly.

## What to look at first

| Path | Description |
|------|-------------|
| `workflows/LINE_FAMILY_COMMENT_BOT.public.json` | The n8n workflow you import directly. |
| `docs/setup-line.md` | LINE Developers channel setup guide. |
| `docs/setup-n8n.md` | n8n import and configuration guide. |
| `docs/setup-ngrok.md` | Exposing local n8n to the internet with Ngrok. |
| `docs/setup-llm.md` | LLM options: LM Studio, local models, Google Gemini API. |
| `docs/privacy-and-safety.md` | Privacy and security reminders. |
| `docs/troubleshooting.md` | Common errors and how to fix them. |
| `docs/advanced-agent-deployment.md` | Tips for advanced users deploying via n8n API / MCP. |

## Quick start

If you have never used n8n or created a LINE Bot before, start with [docs/beginner-roadmap.md](docs/beginner-roadmap.md) and follow the steps in order.

1. Install or open n8n.
2. Import `workflows/LINE_FAMILY_COMMENT_BOT.public.json`.
3. Create a Messaging API channel on LINE Developers.
4. Paste your LINE channel access token, channel secret, and channel ID into the n8n `LINE Config` node.
5. Configure an LLM. Beginners should pick one:
   - **Privacy first**: LM Studio running a local model.
   - **Simplest setup**: Google Gemini API.
   - **Already have an API key**: Any OpenAI-compatible service.
6. If running n8n locally, set up an Ngrok public URL first — see [docs/setup-ngrok.md](docs/setup-ngrok.md).
7. Paste the n8n webhook URL back into LINE Developers.
8. Enable the workflow and send a test message.

## Things to know before using

This bot is intentionally quiet. If it replies to every single message in a family group, people will get annoyed fast.

The workflow is deliberately conservative: it usually only responds when a specific elder posts, when medical keywords appear, when an image is shared, or when someone explicitly calls the bot by name. We recommend adding the bot as a LINE friend first, testing both text and image messages, and only then adding it to your family group.

If you run n8n locally, LINE needs a publicly reachable URL. Beginners usually start with Ngrok. Note: free Ngrok URLs change on restart, so you will also need to update the Webhook URL in LINE Developers each time. To avoid this, use an Ngrok static domain or switch to n8n Cloud.

The bot has simple memory built in. By default it remembers the last ~5 messages in a conversation. You can adjust this in the n8n `Simple Memory` node via `contextWindowLength`:

| Use case | Recommended value |
|----------|-------------------|
| Beginners | 5 – 10 |
| Save tokens | 3 – 5 |
| Weaker local machine | < 3 |
| Single-turn replies only | 0 or remove the memory connection |

Longer memory means better context awareness, but also more tokens, higher API costs, and more load on local models. For family groups, we generally recommend staying under 10.

## Security reminders

Never share the following publicly or with untrusted people or agents:

- LINE channel access token, channel secret
- LINE user IDs, group IDs, room IDs
- API keys for OpenAI, Google, OpenRouter, Groq, etc.
- Real family members' names, phone numbers, emails, addresses
- n8n's `database.sqlite`, config files, or logs

This repo ships as a public template and contains no private tokens or family data from the original author.

## For advanced users

Most users do not need to set up an n8n API key or n8n MCP. Just import the workflow and fill in the settings manually.

If you are comfortable with agents and understand the API key permission risks, see [docs/advanced-agent-deployment.md](docs/advanced-agent-deployment.md) for letting an agent help with deployment and checks via the n8n API or MCP.

## Who this is for

- Anyone who wants a gentle, companion chatbot for their family LINE group.
- Non-programmers willing to follow step-by-step instructions.
- Anyone who wants to use an AI agent to help deploy an n8n workflow.

## Who this is NOT for

- Anyone who wants a bot to replace a doctor, pharmacist, or professional diagnosis.
- Anyone who wants to bulk-upload family chat history to the cloud without telling family members.
- Anyone unwilling to properly safeguard API keys or tokens.

Medical-related replies are for general information and caring reminders only — they are not diagnosis or treatment advice.

## Stuck?

Do not panic and do not give up. Paste your error screen, error message, or the step you are stuck on into Codex, Claude Code, Gemini CLI, or any other agent, and ask:

```text
I am installing LINE Family Comment Bot from this repo and I am stuck at this step.
Please explain in clear, simple language what to do next.
```

These agents are great at walking you through error messages, checking your settings, and guiding you to the next step. Most of the time you are not stuck because you lack ability — you just need someone to tell you what comes next.

May your family group stay harmonious and your parents stay healthy and happy.
