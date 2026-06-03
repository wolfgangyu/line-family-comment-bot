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

### Validation and Test Matrix

Once you complete the basic setup, or if you **customize the workflow by swapping the LLM core (e.g., Ollama, Groq) or the memory component (e.g., Redis)**, we highly recommend using the following test matrix to verify that the pipeline's semantic understanding and routing defense are fully functional:

| Test Scenario | Test Input | Expected Behavior / Purpose | Remarks (for Custom LLM Tuning) |
| :--- | :--- | :--- | :--- |
| **Basic Routing** | Send any photo | Verifies that the Webhook, n8n multimedia nodes, and vision model capabilities are working smoothly. | If using a local model, ensure it supports multimodal capabilities (Vision). |
| **Error Prevention** | Send a LINE Sticker | Verifies that the system correctly identifies the `Sticker` type and either gives a canned response or safely ignores it without triggering the LLM. | Prevents stickers from causing workflow errors or interruptions. |
| **Core Intent Recognition** | "我肚子好痛喔" <br>(My stomach hurts so bad) | Verifies that the LLM accurately triggers the "healthcare/caring" intent and generates a warm reply. | This is a strong-intent baseline scenario; most models should handle this correctly. |
| **Edge Case Test** | "早上起來一直流鼻水" <br>(I've been sniffling since I woke up) | Verifies the LLM's sensitivity to casual, non-emergency symptoms. The system should classify this as healthcare care rather than general small talk. | **Common Pitfall**: Smaller local models (e.g., Llama3/Gemma via Ollama) often misclassify this as standard small talk. If it doesn't reply, optimize your intent classification prompt. |
| **Noise Filtering** | "今天天氣真好" <br>(The weather is nice today) | The system should **NOT reply** (or just log it silently). Verifies that daily small talk is not falsely triggered as a caring event. | Tests anti-spam boundaries to ensure the bot doesn't spam the family group. |
| **Memory Continuity** | 1. "我今天感冒請假"<br>2. (5 mins later) "現在好多了" | 1. The system replies with care regarding the cold.<br>2. The system links the context and replies like: "Good to hear, make sure to get some rest!" | Verifies that Memory (e.g., Redis) correctly passes context to the prompt and the model can comprehend chat history. |

> 💡 **Advanced Troubleshooting Tip**: If you switch to a local model (Ollama) and notice that edge cases like "流鼻水" (sniffling) receive no reply, it is usually because the model's output format (such as JSON fields) is broken or misclassified into the small talk branch. Open n8n's `Execution History`, click on the specific event, and inspect the LLM node's raw output to fine-tune your prompt.

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
