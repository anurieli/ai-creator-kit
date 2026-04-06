# /linkedin-setup

Derive a 10-dimension LinkedIn-specific voice profile from the central brand identity. Covers the 7 base writing dimensions plus 3 LinkedIn-specific dimensions (hook patterns, formatting DNA, engagement patterns).

## Trigger

Activate when `kits/linkedin/identity/style-profile.md` is missing or empty and the user wants to write a LinkedIn post.

## Prerequisites

`brand/identity/brand-document.md` and `brand/identity/voice-guide.md` must exist. If missing, route to `/brand setup` first.

## Process

### Step 1 — Read the Brand

Read central brand documents. Summarize:
> "I know your brand — [summary]. Now I need to tune your voice for LinkedIn specifically. This takes about 10 minutes."

### Step 2 — Gather Writing Samples

LinkedIn posts are the ideal input. Check `brand/identity/writing-samples/` and `kits/linkedin/inspirations/saved-posts/`.

Ask specifically: "Do you have past LinkedIn posts? They're the best input. Paste them in, or drop them into the inspirations folder. Screenshots work too — drop those in `kits/linkedin/inspirations/screenshots/`."

Also accept: blog posts, emails, social posts — any writing in their voice.

- **5+ LinkedIn posts:** Full 10-dimension analysis.
- **Other writing, no LinkedIn posts:** Analyze 7 base dimensions from writing, interview for 3 LinkedIn dimensions.
- **Nothing:** Interview mode, flag low confidence.

### Step 3 — Build 10-Dimension Style Profile

**7 Base Dimensions:**
1. **Sentence Architecture** — length, complexity, fragments
2. **Vocabulary & Language** — formality, jargon, signature phrases
3. **Tone & Register** — warmth, authority, conversational level
4. **Rhetorical Patterns** — storytelling, lists, questions, direct claims
5. **Perspective & POV** — first/second/third person, hedging
6. **Rhythm & Pacing** — cadence, paragraph length, repetition
7. **Personality Markers** — humor, references, emoji, exclamations

**3 LinkedIn-Specific Dimensions:**
8. **Hook Patterns** — how they open posts (bold claim, story, question, number, pattern interrupt). Preferred hook length. "See more" optimization.
9. **Formatting DNA** — line breaks, white space, post length, emoji usage, bullet points, one-liners vs paragraphs. Mobile readability patterns.
10. **Engagement Patterns** — how they close (CTA, question, reflection). Comment strategy. Whether they use "agree/disagree?" or more nuanced prompts.

### Step 4 — Content Pillars

> "What are the 3-5 themes you want to be known for on LinkedIn?"

Save to `kits/linkedin/content-strategy/pillars.yaml` with allocation percentages.

### Step 5 — Posting Cadence

> "How often do you want to post? 3-5 times a week works well for most people. Do you prefer writing one at a time or batching a whole week?"

### Step 6 — Inspiration Creators

> "Any LinkedIn creators you admire? People whose posts make you think 'I want to write like that'?"

Ask if they want to drop screenshots or copy-paste specific posts into `kits/linkedin/inspirations/`. Add creators to `sources.yaml` under `linkedin_creators`. Offer `/study-creator`.

### Step 7 — Save and Confirm

Save to `kits/linkedin/identity/style-profile.md` with all 10 dimensions. Mention: "I also have a LinkedIn algorithm guide built in that optimizes every post for reach."

Present for approval. Then: "Your LinkedIn voice is set up. What's your first post about?"

## Output
- `kits/linkedin/identity/style-profile.md`
