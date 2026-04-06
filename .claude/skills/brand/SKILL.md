# Skill: /brand

## Description
Build, view, or evolve your brand identity. This is the single skill that manages everything about who you are as a creator — your brand document, voice guide, and visual identity.

## Usage
- `/brand` — Show a summary of your current brand (audit mode)
- `/brand setup` — Build your brand from scratch
- `/brand evolve` — Change or refine something about your brand

## Modes

### Audit Mode (`/brand` with no arguments)

**Trigger:** Client says `/brand`, "show me my brand", "who am I?", or similar.

**Behavior:**
1. Read all three identity files:
   - `identity/brand-document.md`
   - `identity/voice-guide.md`
   - `identity/visual-identity.md`
2. Present a warm, concise summary:

> **Your brand at a glance:**
>
> **Who you are:** [1-2 sentence summary from brand doc]
>
> **Who you serve:** [audience in plain language]
>
> **Your themes:** [list the 3-5 pillars]
>
> **How you sound:** [voice summary — the Quick Reference from voice guide]
>
> **How you look:** [aesthetic summary + key colors]
>
> **Last updated:** [date from frontmatter]

3. Ask if they want to change anything: "Want to evolve any of this, or just checking in?"

If any of the three documents don't exist, note which ones are missing and offer to build them.

---

### Setup Mode (`/brand setup`)

**Trigger:** Client says `/brand setup`, "set up my brand", "I'm new", or the CLAUDE.md onboarding flow routes here.

**Behavior:** Follow the full onboarding flow defined in CLAUDE.md. The short version:

1. **Welcome brief** — Explain what's about to happen
2. **Gather materials** — Ask what they already have (docs, writing, visuals)
3. **Brand identity interview** — Build `identity/brand-document.md` through 8-section conversation
4. **Voice guide** — Build `identity/voice-guide.md` from writing analysis or interview
5. **Visual identity** — Build `identity/visual-identity.md` from references or guided conversation
6. **Handoff** — Summarize what was created, point to content kits

**Rules for setup:**
- Ask ONE question at a time. Wait for an answer before moving on.
- If an answer is vague, ask a gentle follow-up to get specifics.
- Be encouraging — most people haven't done this before.
- Present each completed document for approval before moving to the next.
- All documents get `version: 1` in their frontmatter.

**Writing sample requirements:**
- You need at least 2-3 writing samples to build a reliable voice guide.
- If the client only provides 1, explicitly ask for more.
- If they have zero and insist on continuing, use interview mode but note that confidence is low and recommend coming back with samples later.

---

### Evolve Mode (`/brand evolve`)

**Trigger:** Client says `/brand evolve`, "I want to change X", "make me sound more Y", "update my brand", or similar.

**Behavior:**

1. **Read current state.** Load all three identity documents.

2. **Understand the change.** Ask:
   - "What's prompting this? What feels off right now?"
   - "Can you show me an example of what you want to move toward?"
   - "Is this a small tweak or a bigger directional shift?"

3. **Identify which document(s) are affected:**
   - Messaging, positioning, audience, themes → `brand-document.md`
   - Tone, writing style, vocabulary, personality → `voice-guide.md`
   - Colors, fonts, layout, aesthetic → `visual-identity.md`
   - Could be multiple — handle each one.

4. **If they bring new references (a creator, a brand, writing they like):**
   - Delegate analysis to a sub-agent: study the reference, extract the specific qualities
   - Name what you found: "What I see in their style is X, Y, Z."
   - Ask which qualities to adopt: "Do you want all of these or just some?"
   - Save the reference to `identity/inspirations/` if it's a file

5. **Show before & after.** For every proposed change:

   > **Current:** [exact text from current document]
   >
   > **Proposed:** [new text]
   >
   > "Does this feel right?"

6. **Apply on approval.** When the client says yes:
   - Make the specific change in the relevant document
   - Increment the `version` number in frontmatter
   - Update `last_updated` to today's date
   - Do NOT regenerate the entire document — surgical updates only

7. **Confirm and remind about propagation:**

   > "Done — [specific change]. Version bumped to [N]. Next time you open any content kit, it'll pick this up automatically."

**Rules for evolve:**
- NEVER change a document without showing the proposed change first
- NEVER regenerate a whole document when only part of it is changing
- Always increment version on any change
- One change at a time — if the client wants to change multiple things, handle each sequentially
- If the change seems to contradict their core brand, flag it gently: "This would shift your positioning from X to Y — is that intentional?"

---

## Output Files

| File | What it captures |
|------|-----------------|
| `identity/brand-document.md` | Who you are, who you serve, values, themes, differentiation, platforms |
| `identity/voice-guide.md` | Sentence style, vocabulary, tone, rhetorical patterns, personality, Do/Don't rules |
| `identity/visual-identity.md` | Colors (hex codes), typography, layout preferences, aesthetic, visual Do/Don't |

All files use YAML frontmatter with `version`, `created`, and `last_updated` fields.

---

## Sub-Agent Delegation

Delegate heavy processing to sub-agents to keep the main conversation focused:

- **Writing sample analysis** — send samples to a sub-agent to extract voice patterns
- **Reference analysis** — send creator/brand references to a sub-agent to identify style patterns
- **Document generation** — have a sub-agent draft the document, then present it in the main conversation for approval
- **Visual reference analysis** — send screenshots/design refs to a sub-agent for color extraction and pattern identification

Always present the sub-agent's output to the client for review. Never auto-save without approval.
