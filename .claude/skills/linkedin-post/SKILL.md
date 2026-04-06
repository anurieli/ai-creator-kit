# LinkedIn Post Skill

Write a complete LinkedIn post draft that sounds like the client wrote it themselves.

## Trigger

Activate when the user says `/linkedin-post` or asks to write, draft, create, or start a LinkedIn post.

## Important — Communication Style

The client is not technical. All communication must be warm, clear, and in plain language. Never show YAML contents, file paths, config details, or internal process mechanics unless explicitly asked. Speak to them like a trusted creative collaborator.

## Entry Points

The user can kick things off in any of these ways:

1. **Topic-driven** — "Write a LinkedIn post about delegation"
2. **Story-driven** — "I had this experience today [story]. Turn it into a post."
3. **Reaction-driven** — "I just saw [link/take]. I want to react to this on LinkedIn."
4. **Template-driven** — "Write a contrarian take about hiring"
5. **Pillar-driven** — "I need a personal story post" (references pillars.yaml)
6. **Auto-suggest** — No input given. Check sources, post history, pillar balance, then suggest 3 topics with templates. Wait for the client to pick one.
7. **Conversational** — Natural language. Extract the core topic and confirm before proceeding.

---

## Phase 1: Context & Strategy Loading

### 1a. Load project context

Read these files to ground yourself in the client's world:

- `identity/brand-profile.md` — brand positioning, audience, messaging pillars, LinkedIn positioning
- `identity/style-profile.md` — writing voice across all 10 dimensions
- `content-strategy/pillars.yaml` — content pillars with allocation targets
- `content-strategy/post-history.yaml` — what has been posted recently
- `content-strategy/algorithm-guide.md` — current LinkedIn algorithm signals and best practices
- `sources.yaml` — curated thought leaders, business figures, LinkedIn creators

**If `brand-profile.md` or `style-profile.md` do not exist**, stop and tell the client:

> "Before we write, I need your brand and voice on file. Let's run a quick setup first."

Do not proceed without both identity files.

### 1b. Strategy check

- Determine which content pillar this post serves
- Check post history: what has been posted recently? What pillar is underserved? What template has not been used?
- Consider format: should this be a text post or a carousel? Carousels get 7% engagement vs 4.5% for text. Use carousel for frameworks, step-by-step processes, and listicles with 5+ items.
- If no template specified, recommend one based on topic + variety needs
- If auto-suggest mode, generate 3 topic options with recommended templates

### 1c. Confirm

Present a brief summary:

> "Here's what I'm thinking: [topic], using the [template] format. This hits your [pillar] pillar, which hasn't gotten much love recently. Sound good?"

Wait for confirmation before proceeding.

---

## Phase 2: Hook Generation (THE critical phase)

The hook is the single most important element of a LinkedIn post. It determines whether anyone reads the rest.

Generate **5 hook options**, each a different strategy:

1. **Bold/contrarian statement** — a strong claim that challenges conventional wisdom
2. **Personal story opener** — drops the reader into a specific moment
3. **Question that provokes** — makes the reader pause and think
4. **Number/data-driven** — specificity that signals substance
5. **Pattern interrupt** — unexpected framing that breaks the scroll

**For each hook, show the character count.** Flag any hook that exceeds 140 characters (mobile "see more" fold). The ideal hook is under 45 characters (one line) — hooks longer than one line perform 20% worse.

Present all 5 to the client:

> "Here are 5 ways to open this post. Pick one, or tell me what direction to go."

**Wait for selection before proceeding.** Never auto-pick. The hook is everything on LinkedIn — it must be the client's choice.

---

## Phase 2b: Rehook Generation

After the hook is selected, write the **rehook** — the 2-3 lines immediately after the "see more" fold.

The hook gets them to click "see more." The rehook slams the door shut and keeps them reading.

The rehook must:
- Make a specific promise about what the post delivers
- Eliminate the reader's reason to leave
- Create an open loop the body will close

Present the rehook with the hook for client approval before drafting.

---

## Phase 3: Draft

### Write the full post

- Use the selected hook + rehook + chosen template structure from `.claude/skills/linkedin-post/templates/`
- Apply all 10 style dimensions from the style profile
- **Target 1,300-1,900 characters** — the engagement sweet spot (optimizes dwell time + completion rate)
- Apply Formatting DNA (line breaks, spacing, emoji, emphasis) from Dimension 9
- **Max 3 lines per paragraph.** Single-sentence paragraphs preferred. Whitespace between every thought.
- **Target grade 3-5 reading level.** Short sentences under 12 words perform 20% better.
- Weave in references naturally — LinkedIn-native style ("A friend told me..." not "According to Dr. Smith...")
- **Never include links in the post body** — links carry a -40-50% reach penalty. If a link is needed, note it for the comments.
- End with a **call-to-conversation (CTC)** from the style profile's Dimension 10 — a genuine question that invites substantive replies (not "Agree?" or "Thoughts?"). Comments >15 words carry 2.5x more algorithmic weight.

---

## Phase 4: Self-Edit (Highly Opinionated)

Before presenting anything, run through these checks:

### Voice consistency (against style-profile.md)
- All 10 style dimensions honored
- Signature words and phrases present
- Anti-patterns avoided

### Brand alignment (against brand-profile.md)
- Messaging pillars reinforced
- Audience fit confirmed
- LinkedIn positioning reflected
- Values present in framing

### Hook strength
- "Would I stop scrolling for this?"
- Does the hook work within **140 characters** (mobile fold)? Show the character count.
- Does the rehook (lines 2-3 after fold) lock the reader in?
- Does it create an open loop the reader needs to close?

### Formatting check
- Mobile-readable? (57%+ of LinkedIn is mobile)
- Enough whitespace? One idea per line? **Max 3 lines per paragraph.**
- Scannable on a small screen?
- Emoji usage matches style profile? (1-3 max, standard emojis = 2 chars)
- Reading level at grade 3-5? Short sentences under 12 words?
- **No links in the post body.** Links carry a -40-50% reach penalty.

### Length check
- **Total post between 1,300-1,900 characters?** (the engagement sweet spot)
- Within the template's target character range?
- Every sentence earns its place?

### Save-worthiness check
- Would someone bookmark this as a reference? Posts that get saved reach 5x more people than posts that get liked.
- If it's a framework, listicle, or how-to: is it actionable enough to save?

### Engagement driver check
- Ending invites response with a genuine **call-to-conversation (CTC)**?
- CTC natural, not forced? (Comments >15 words carry 2.5x algorithmic weight)
- Matches the style profile's engagement patterns?
- NOT "Agree?", "Thoughts?", "Tag someone", or any engagement bait

### AI detection check — MANDATORY
- Does this post contain **specific personal details** (names, numbers, dates, places) that signal real experience?
- Does it use **domain-specific vocabulary** from the client's actual expertise?
- Does it include at least one imperfection (fragment, tangent, parenthetical, mid-thought aside)?
- Does it avoid these AI-overused phrases: "Here's the thing," "Let that sink in," "Read that again," "Game-changer," "Full stop," "Unpack this," "Navigate," "Lean into," "Double down"?
- Does the structure differ from the last post? (Never use the same format twice in a row)
- **If the post could have been written by any AI about any brand, it will be distributed to no one.** Make it unmistakably this client.

### Cringe check (LinkedIn-specific)
- Anything performative or virtue-signaling? Rewrite it.
- "Agree?" at the end? Remove it.
- Humble-bragging disguised as a lesson? Reframe it.
- Generic motivational poster language? Make it specific.
- "Tag someone who needs to hear this"? Delete it.
- Fabricated or exaggerated story? Flag it.
- Overly polished AI tone? Roughen it up — imperfect-looking posts get 5x more engagement than AI-polished ones.

Revise as needed. The first draft is never the final draft.

---

## Phase 5: Deliver

### Present the post

Share the draft with the hook highlighted separately:

> "Here's your post! The hook is: '[hook text]'. Take a look and let me know what you think."

### Save the draft

Save to `posts/drafts/YYYY-MM-DD-[slug].md` with YAML frontmatter:

```markdown
---
date: "YYYY-MM-DD"
topic: "topic in plain language"
pillar: "which content pillar"
template: "template-name"
hook_type: "bold-claim/story/question/number/pattern-interrupt"
status: "draft"
---

[Post content]
```

### Update post history

Append an entry to `content-strategy/post-history.yaml`.

### Prompt next action

> "Want me to adjust anything? Or should I write the next one?"

---

## Phase 6: Iterate

When the client gives feedback:
1. Acknowledge it warmly
2. Make the edits
3. Re-run Phase 4 self-edit on the changed sections
4. Present the updated version
5. Save the updated draft (overwriting)
6. Repeat until satisfied

---

## File Reference

| File | Purpose | Required? |
|------|---------|-----------|
| `identity/brand-profile.md` | Brand positioning, audience, pillars | Yes — stop without it |
| `identity/style-profile.md` | 10-dimension writing voice | Yes — stop without it |
| `content-strategy/pillars.yaml` | Content pillar targets | No — works without it |
| `content-strategy/post-history.yaml` | Recent post log | No — works without it |
| `sources.yaml` | Curated sources | No — works without it |
| `.claude/skills/linkedin-post/templates/` | Post templates | Yes — needs at least one |

## Guiding Principle

The post should feel like the client sat down on a great writing day and wrote it in 10 minutes. The style profile is the contract. Every line should pass the test: "Would they actually post this?"
