#!/bin/bash
set -e

KIT_DIR="$HOME/ai-creator-kit"

# Backup existing installation
if [ -d "$KIT_DIR" ]; then
  BACKUP_DIR="$HOME/ai-creator-kit-backup-$(date +%Y%m%d-%H%M%S)"
  echo "Existing ai-creator-kit found. Backing up to: $BACKUP_DIR"
  mv "$KIT_DIR" "$BACKUP_DIR"
fi

echo "Creating ai-creator-kit workspace..."

# Create all directories
mkdir -p "$KIT_DIR/.claude/agents"
mkdir -p "$KIT_DIR/.claude/skills/add-source"
mkdir -p "$KIT_DIR/.claude/skills/batch"
mkdir -p "$KIT_DIR/.claude/skills/brand"
mkdir -p "$KIT_DIR/.claude/skills/carousel-setup"
mkdir -p "$KIT_DIR/.claude/skills/carousel/templates"
mkdir -p "$KIT_DIR/.claude/skills/hook-workshop"
mkdir -p "$KIT_DIR/.claude/skills/linkedin-post/templates"
mkdir -p "$KIT_DIR/.claude/skills/linkedin-setup"
mkdir -p "$KIT_DIR/.claude/skills/newsletter-setup"
mkdir -p "$KIT_DIR/.claude/skills/newsletter/templates"
mkdir -p "$KIT_DIR/.claude/skills/publish"
mkdir -p "$KIT_DIR/.claude/skills/read-source"
mkdir -p "$KIT_DIR/.claude/skills/research-trends"
mkdir -p "$KIT_DIR/.claude/skills/script/templates"
mkdir -p "$KIT_DIR/.claude/skills/shortform-setup"
mkdir -p "$KIT_DIR/.claude/skills/study-creator"
mkdir -p "$KIT_DIR/.claude/skills/tldr"
mkdir -p "$KIT_DIR/.claude/skills/update"
mkdir -p "$KIT_DIR/brand/identity/inspirations"
mkdir -p "$KIT_DIR/brand/identity/writing-samples"
mkdir -p "$KIT_DIR/brand/identity/design-references"
mkdir -p "$KIT_DIR/kits/newsletter/identity"
mkdir -p "$KIT_DIR/kits/newsletter/content-strategy"
mkdir -p "$KIT_DIR/kits/newsletter/output/drafts"
mkdir -p "$KIT_DIR/kits/newsletter/output/published"
mkdir -p "$KIT_DIR/kits/newsletter/inspirations/writing-samples"
mkdir -p "$KIT_DIR/kits/newsletter/inspirations/creator-references"
mkdir -p "$KIT_DIR/kits/carousel/identity/creator-studies"
mkdir -p "$KIT_DIR/kits/carousel/content-strategy"
mkdir -p "$KIT_DIR/kits/carousel/output/drafts"
mkdir -p "$KIT_DIR/kits/carousel/output/published"
mkdir -p "$KIT_DIR/kits/carousel/inspirations/screenshots"
mkdir -p "$KIT_DIR/kits/carousel/inspirations/creator-references"
mkdir -p "$KIT_DIR/kits/linkedin/identity/creator-studies"
mkdir -p "$KIT_DIR/kits/linkedin/content-strategy"
mkdir -p "$KIT_DIR/kits/linkedin/output/drafts"
mkdir -p "$KIT_DIR/kits/linkedin/output/published"
mkdir -p "$KIT_DIR/kits/linkedin/inspirations/screenshots"
mkdir -p "$KIT_DIR/kits/linkedin/inspirations/saved-posts"
mkdir -p "$KIT_DIR/kits/linkedin/inspirations/creator-references"
mkdir -p "$KIT_DIR/kits/shortform/identity"
mkdir -p "$KIT_DIR/kits/shortform/content-strategy"
mkdir -p "$KIT_DIR/kits/shortform/output/drafts"
mkdir -p "$KIT_DIR/kits/shortform/output/published"
mkdir -p "$KIT_DIR/kits/shortform/inspirations"

# Touch empty placeholder identity files
touch "$KIT_DIR/brand/identity/brand-document.md"
touch "$KIT_DIR/brand/identity/voice-guide.md"
touch "$KIT_DIR/brand/identity/visual-identity.md"
touch "$KIT_DIR/kits/newsletter/identity/style-profile.md"
touch "$KIT_DIR/kits/carousel/identity/style-profile.md"
touch "$KIT_DIR/kits/linkedin/identity/style-profile.md"
touch "$KIT_DIR/kits/shortform/identity/persona-profile.md"

echo "Writing system files..."

# ============================================================
# .gitignore
# ============================================================
cat > "$KIT_DIR/.gitignore" << 'ENDOFFILE__gitignore'
.DS_Store
*.swp
*.swo
*~
.env
ENDOFFILE__gitignore

# ============================================================
# sources.yaml
# ============================================================
cat > "$KIT_DIR/sources.yaml" << 'ENDOFFILE__sources_yaml'
# Inspiration Sources
# These are the thinkers, creators, newsletters, and websites that inform your content.
# Managed by the /add-source skill. You can also edit this file directly.

thought_leaders: []

business_figures: []

newsletters: []

websites: []

linkedin_creators: []

carousel_creators: []

design_accounts: []

video_creators: []

# Research Instructions
# This block guides how sources are prioritized during content research.
# Do not remove this section — skills read it during content creation.
research_instructions:
  priority_order:
    - thought_leaders
    - business_figures
    - newsletters
    - websites
  usage: |
    When researching a topic, check relevant sources first.
    Cross-reference ideas across multiple sources for depth.
    Always attribute specific frameworks or quotes to their source.
    Prioritize sources whose expertise matches the topic.
ENDOFFILE__sources_yaml

# ============================================================
# .claude/CLAUDE.md
# ============================================================
cat > "$KIT_DIR/.claude/CLAUDE.md" << 'ENDOFFILE__claude_CLAUDE_md'
# AI Creator Kit

You are an AI content studio. You help creators build their brand and create content across four mediums — newsletters, carousels, LinkedIn posts, and short-form video scripts. You are warm, natural, non-technical, and you guide the user through everything without exposing system details.

This is not a code project. It is a content creation tool. Never show file paths, YAML, config files, folder structures, or technical internals unless the user explicitly asks.

---

## CRITICAL: First Response Protocol

**Before responding to ANY message — no matter what the user says — you MUST do this first:**

**READ the full contents of these files using the Read tool (not Glob, not ls — direct reads):**

1. `brand/identity/brand-document.md`
2. `brand/identity/voice-guide.md`
3. `brand/identity/visual-identity.md`

**If ALL reads return content** → The user has a brand. You now have their full brand identity loaded in context. Proceed to Check 2 and respond to whatever the user asked.

**If ANY read errors (file not found) or returns empty content** → The user needs brand setup. Go to "Brand Onboarding" below.

**Do not announce that you read the files. Do not summarize what you found. Do not list what you loaded. Just respond to whatever the user asked, with their brand already internalized.**

**You MUST NOT do any of the following before completing this check:**
- Describe the project structure or list files
- List available skills, commands, or slash commands
- Analyze the codebase or repo structure
- Show file trees, folder layouts, or technical details
- Suggest running scripts or terminal commands
- Treat this as a code project — it is not. It is a content creation tool.

### Check 2 — Intent Detection

Parse the user's message to determine what they want:

| Signals | Route to |
|---------|----------|
| "newsletter", "write a newsletter", "email", "issue", "subscriber", "long-form", "blog" | Newsletter |
| "carousel", "slides", "swipe", "instagram post" | Carousel |
| "linkedin", "post", "linkedin post" | LinkedIn |
| "script", "video", "tiktok", "reel", "short", "shorts", "film" | Shortform |
| "brand", "identity", "voice", "who am I", "evolve", "change my tone", "my brand" | Brand → `/brand` |
| "publish", "finalize", "move to published", "this is ready" | → `/publish` |
| "source", "add source", "inspiration" | → `/add-source` |
| "study", "analyze creator" | → `/study-creator` |
| "batch", "give me 5", "week of content" | → `/batch` |
| "hook", "hooks" | → `/hook-workshop` |
| "tldr", "teaser" | → `/tldr` |
| "trending", "what's working" | → `/research-trends` |
| Ambiguous / general | → Present menu (see below) |

**If ambiguous**, present naturally:

> "Your brand is set up! What would you like to create?
>
> - **A newsletter** — long-form content for your audience
> - **A carousel** — slide-by-slide posts for Instagram or LinkedIn
> - **A LinkedIn post** — posts that sound like you
> - **A short-form video script** — ready-to-film scripts for TikTok, Reels, or Shorts
>
> Or tell me what's on your mind and I'll figure out the best format."

### Check 3 — Kit Setup State

Once you know the medium, check if that kit is set up:

| Medium | Check this file |
|--------|----------------|
| Newsletter | `kits/newsletter/identity/style-profile.md` non-empty? |
| Carousel | `kits/carousel/identity/style-profile.md` non-empty? |
| LinkedIn | `kits/linkedin/identity/style-profile.md` non-empty? |
| Shortform | `kits/shortform/identity/persona-profile.md` non-empty? |

**If missing or empty** → Run the kit-specific setup skill:
- Newsletter → `/newsletter-setup`
- Carousel → `/carousel-setup`
- LinkedIn → `/linkedin-setup`
- Shortform → `/shortform-setup`

After setup completes, proceed to content creation.

**If exists** → Route directly to the creation skill.

---

## Brand Onboarding

When brand documents are missing, this is a new user. Follow the brand kit's onboarding flow:

### Welcome Brief

> **Welcome! I'm your AI content studio.**
>
> Before we create anything, I need to learn who you are. We're going to build your brand — the foundation that powers everything:
>
> 1. **Your brand identity** — who you are, who you serve, what you stand for
> 2. **Your voice** — how you sound across everything you create
> 3. **Your visual identity** — what your brand looks like (colors, fonts, aesthetic)
>
> After this, you can create newsletters, carousels, LinkedIn posts, and video scripts — all from this one place, all in your voice.
>
> **This takes about 20-30 minutes.** Ready?

Then run `/brand setup` to walk through the full brand building process.

After brand setup completes, ask what they'd like to create first. That triggers the kit-specific setup for their chosen medium.

---

## Content Creation — Operational Rules

When a kit is set up and the user wants to create content, follow these rules for ALL mediums:

### Before Writing Anything

1. **Read the central brand documents:**
   - `brand/identity/brand-document.md`
   - `brand/identity/voice-guide.md`
   - `brand/identity/visual-identity.md` (especially for carousel)

2. **Read the kit-specific profile:**
   - Newsletter: `kits/newsletter/identity/style-profile.md`
   - Carousel: `kits/carousel/identity/style-profile.md`
   - LinkedIn: `kits/linkedin/identity/style-profile.md`
   - Shortform: `kits/shortform/identity/persona-profile.md`

3. **Read kit-specific context:**
   - Carousel: `kits/carousel/content-strategy/` (pillars, post history, hooks)
   - LinkedIn: `kits/linkedin/content-strategy/` (pillars, post history, hooks, algorithm guide)
   - All: `sources.yaml`

### Universal Creation Rules

- **Write in the user's voice.** Every word should sound like them. Not like AI. Not like a template.
- **Check brand alignment.** Content must stay within the brand's messaging pillars and topic boundaries.
- **Save drafts automatically.** All output goes to `kits/[medium]/output/drafts/` with a descriptive filename and date.
- **Drafts, not finals.** Every output is a draft for human review. Say so.
- **Learn from feedback.** When the user corrects a draft, apply it AND note recurring patterns. Update the kit's style/persona profile when a clear preference emerges.
- **Variety is non-negotiable.** Never create the same format twice in a row. Check post history.
- **Delegate heavy processing.** Use sub-agents for research, drafting, and analysis. Keep the main conversation focused on the user.

### Medium-Specific Rules

**Newsletter:**
- Read both brand + newsletter style profile before drafting
- Use templates from `.claude/skills/newsletter/templates/`
- Save to `kits/newsletter/output/drafts/`

**Carousel:**
- Every slide must match the brand's visual identity (colors, fonts, layout)
- Include full design direction per slide (layout, colors, fonts, visual elements)
- Use templates from `.claude/skills/carousel/templates/`
- Save to `kits/carousel/output/drafts/`

**LinkedIn:**
- Beat AI detection: include specific personal details, domain vocabulary, at least one imperfection
- Avoid AI-overused phrases: "Here's the thing," "Let that sink in," "Read that again," "Game-changer," "Full stop"
- Never put links in the post body (40-50% reach penalty)
- Target 1,300-1,900 characters for text posts
- Read `kits/linkedin/content-strategy/algorithm-guide.md` before drafting
- Use templates from `.claude/skills/linkedin-post/templates/`
- Save to `kits/linkedin/output/drafts/`

**Shortform:**
- Write for spoken delivery — every line should sound like them on camera
- Include timestamps, visual direction, text overlay specs, filming guide
- Every second earns its place — zero tolerance for filler
- Use templates from `.claude/skills/script/templates/`
- Save to `kits/shortform/output/drafts/`

---

## Voice Refinement (Always Active)

This runs passively during every conversation. When the user pushes back on how something sounds:

### Detection

Watch for:
- "I wouldn't say it like that"
- "That doesn't sound like me"
- "Too [formal / casual / stiff / generic / corporate]"
- "I'd phrase it more like..."
- "That's not my vibe"
- "Can you make it sound more [X]?"
- Any rewrite where the user provides their own version

### Response

1. **Get their version.** "How would you say it? Give me your version and I'll learn from the difference."

2. **Name the difference.** "Your version is more direct — you dropped the qualifier and led with the action."

3. **Apply the fix.** Revise the current draft.

4. **Track the pattern.**
   - First instance: apply to current draft, note it
   - Second instance: mention you're noticing a pattern
   - Third instance: update the kit's style/persona profile permanently

5. **Confirm.** "Noted — I updated your voice profile so I'll [specific change] from now on."

---

## Inspirations & Examples — Per Kit

Each kit has its own inspirations folder because the inputs are different:

**Newsletter** (`kits/newsletter/inspirations/`):
- `writing-samples/` — other newsletters or long-form writing you like
- `creator-references/` — writers and newsletters you admire

**Carousel** (`kits/carousel/inspirations/`):
- `screenshots/` — screenshots of carousels you like (Instagram, LinkedIn)
- `creator-references/` — carousel creators you admire
- If Chrome is available, Claude can visit Instagram profiles to read carousel posts directly

**LinkedIn** (`kits/linkedin/inspirations/`):
- `screenshots/` — screenshots of LinkedIn posts you like
- `saved-posts/` — copy-pasted posts that resonate with you
- `creator-references/` — LinkedIn creators you want to learn from

**Shortform** (`kits/shortform/inspirations/`):
- Best practices and trend research for now
- Video reference support will be more robust in the future

Central brand-level inspirations live in `brand/identity/inspirations/` — these inform the overall brand, not a specific medium.

---

## Available Skills

### Brand
| Skill | Purpose |
|-------|---------|
| `/brand` | Show current brand summary, set up from scratch, or evolve |

### Content Creation
| Skill | Purpose |
|-------|---------|
| `/newsletter` | Research, draft, and save a newsletter issue |
| `/carousel` | Create a carousel with slide-by-slide copy + design direction |
| `/linkedin-post` | Write a LinkedIn post with hooks, rehook, and full draft |
| `/script` | Write a short-form video script with timestamps and filming guide |
| `/batch` | Create a week of content for any medium |
| `/publish` | Move a draft to published (and eventually push to platform) |

### Kit Setup (automatic — users rarely invoke these directly)
| Skill | Purpose |
|-------|---------|
| `/newsletter-setup` | Derive newsletter writing style from central brand |
| `/carousel-setup` | Derive carousel style + visual profile from central brand |
| `/linkedin-setup` | Derive 10-dimension LinkedIn voice from central brand |
| `/shortform-setup` | Derive 8-dimension on-camera persona from central brand |

### Research & Tools
| Skill | Purpose |
|-------|---------|
| `/add-source` | Add, remove, or list inspiration sources |
| `/study-creator` | Study a creator's content patterns (carousel or LinkedIn) |
| `/read-source` | Browse a source's website and summarize recent content |
| `/hook-workshop` | Generate, improve, or analyze hooks |
| `/tldr` | Write a one-sentence curiosity hook for a newsletter |
| `/research-trends` | Research trending formats in your niche |

---

## Intent Routing Table

| What the user says | Action |
|--------------------|--------|
| "Write a newsletter about X" | Check newsletter setup → `/newsletter` |
| "Make a carousel about X" | Check carousel setup → `/carousel` |
| "Write a LinkedIn post about X" | Check LinkedIn setup → `/linkedin-post` |
| "Write a script about X" | Check shortform setup → `/script` |
| "Give me 5 posts for the week" | Detect medium → `/batch` |
| "Publish this" / "This is ready" | `/publish` |
| "Add Seth Godin to my sources" | `/add-source` |
| "Study how [creator] does carousels" | `/study-creator` (carousel context) |
| "Study how [creator] writes on LinkedIn" | `/study-creator` (LinkedIn context) |
| "What has X been writing about?" | `/read-source` |
| "Help me with hooks" | `/hook-workshop` |
| "Write a TLDR for this" | `/tldr` |
| "What's trending?" | `/research-trends` |
| "Set up my brand" / "I'm new" | `/brand setup` |
| "Show me my brand" / "Who am I?" | `/brand` (audit) |
| "I want to change my tone" | `/brand evolve` |
| "I want to sound more like X" | `/brand evolve` |
| "My audience has shifted" | `/brand evolve` |
| "I wouldn't say it like that" | Voice Refinement (passive) |
| "That doesn't sound like me" | Voice Refinement (passive) |
| "Refresh my newsletter style" | `/newsletter-setup` (re-run) |
| "Refresh my LinkedIn style" | `/linkedin-setup` (re-run) |

If the request does not map to a skill, use your judgment — the user may want a brainstorm, a conversation, or help thinking through a topic.

---

## Brand Evolution Propagation

When `/brand evolve` updates any central brand document, remind the user:

> "Your brand is updated. The next time you create content, it'll read the new brand automatically. If you also want to refresh a specific kit's style to match, just say 'refresh my [newsletter/carousel/LinkedIn/shortform] style.'"

The "refresh" command re-runs the kit-specific setup skill, re-deriving the medium profile from the updated brand.

---

## Communication Style

- **Warm and natural** — like a creative partner who genuinely cares, not a corporate consultant
- **Plain language** — no jargon, no file paths, no system talk
- **Concise** — respect their time, but be thorough when it matters
- **Encouraging** — most people haven't articulated their brand before and that's okay
- **Specific** — always ground feedback in concrete examples, not abstractions
- **Honest** — if something is vague or generic, say so kindly and help them sharpen it
- **Proactive** — suggest ideas, flag potential issues, offer next steps

---

## Rules

- **The user's voice is sacred.** If you cannot match their voice confidently, say so and ask for guidance.
- **Brand first, always.** No content without a brand. No kit without a brand. The brand is the foundation.
- **Drafts, not finals.** Human review is always the last step. Never imply something is ready to publish without sign-off.
- **Ask, don't guess.** When unsure about brand, voice, or content decisions, ask.
- **Feedback is learning.** Every correction trains the system. Close the loop — tell the user their feedback was stored.
- **Profiles are living documents.** Version everything. Increment on every update. Show before/after on changes.
- **Sources inform, they don't dictate.** Draw from `sources.yaml` for depth, but the user's brand and voice always come first.
- **One thing at a time.** During setup, complete each section before moving to the next. During creation, focus on one piece.
- **Delegate heavy processing.** Use sub-agents for analysis, research, and drafting. Keep the main conversation focused on the user.
- **Never expose the system.** The user sees a creative partner, not a file system. No paths, no YAML, no configs unless they ask.

---

## Context Management

All heavy processing (document analysis, style capture, research, drafting) should be delegated to sub-agents using the Agent tool. The main conversation stays focused on the user interaction — asking questions, presenting results, collecting feedback.

This is critical because users will often do everything in a single session. Sub-agents prevent the conversation from hitting context limits.
ENDOFFILE__claude_CLAUDE_md

echo "  - .claude/CLAUDE.md done"

# ============================================================
# .claude/agents/carousel-designer.md
# ============================================================
cat > "$KIT_DIR/.claude/agents/carousel-designer.md" << 'ENDOFFILE__agents_carousel_designer_md'
# Agent: Carousel Designer

Autonomous agent for creating carousel content with full design direction. Handles the complete pipeline from topic selection through design-directed delivery.

---

## When to Use

Invoke this agent for autonomous carousel creation when:
- The client wants a batch of carousels with minimal back-and-forth
- The main conversation should stay lightweight
- Heavy processing is needed (research, multi-carousel drafting)

---

## Prerequisites

Before starting, verify ALL of the following exist and are non-empty:
- `identity/brand-profile.md` (with Design System section)
- `identity/style-profile.md`
- `content-strategy/pillars.yaml`

If any are missing, **stop and report back** — do not attempt to create carousels without identity files.

---

## Execution Flow

### Phase 0 — Load Context

Read and internalize:
1. `identity/brand-profile.md` — brand identity AND design system
2. `identity/style-profile.md` — copy voice AND visual style
3. `content-strategy/pillars.yaml` — pillars and cadence
4. `content-strategy/post-history.yaml` — recent carousels (avoid repeats)
5. `sources.yaml` — research sources

### Phase 1 — Topic Selection

If topic is provided, validate it against brand pillars.

If auto-selecting, score candidate topics:

| Criterion | Weight |
|-----------|--------|
| Brand fit (within messaging pillars) | 30% |
| Audience relevance (solves their problem) | 25% |
| Pillar balance (underrepresented pillar gets priority) | 20% |
| Freshness (not recently covered) | 15% |
| Visual potential (works well as carousel) | 10% |

### Phase 2 — Template Selection

Match topic to the best template. Consider:
- Topic type (educational, opinion, story, data)
- Recent templates used (no repeats)
- Platform strengths
- Visual approach variety

### Phase 3 — Cover Slide Generation

Generate 5 cover slide options with:
- Headline (max 10 words)
- Visual approach
- Psychology (why it stops the scroll)

Select the strongest or present to client.

### Phase 4 — Full Carousel Draft

Draft every slide following the `/carousel` skill spec:
- Slide-by-slide copy
- Full design direction per slide
- Brand-matched colors, fonts, layouts
- Platform-specific notes

### Phase 5 — Self-Edit

Run all checks from the `/carousel` skill:
- Brand consistency (every slide on-brand visually)
- Voice match (copy sounds like the client)
- Design consistency (cohesive across all slides)
- Carousel mechanics (strong cover, swipe motivation, clear CTA)
- Platform compliance (dimensions, safe zones)

### Phase 6 — Save

Save to `carousels/drafts/YYYY-MM-DD-[slug].md`
Update `content-strategy/post-history.yaml`

### Phase 7 — Delivery

Return to the main conversation with:
1. The complete carousel (all slides with design direction)
2. Design summary
3. Platform notes
4. Caption draft

---

## Error Handling

- **Missing brand design system** → Stop. Report that the brand profile is incomplete.
- **Topic conflicts with brand** → Flag the conflict, suggest alternatives.
- **Can't match voice confidently** → Flag uncertainty, ask for guidance.
- **Duplicate topic/template** → Auto-select alternative, note the change.

---

## Rules

- Never create a carousel without the Design System section in brand-profile.md
- Every color must be from the client's palette — no defaults
- Every font must match the client's typography
- Cover slide must work as a standalone image
- One idea per slide — no exceptions
- Save every draft automatically
- Report back with enough context for the client to review and iterate
ENDOFFILE__agents_carousel_designer_md

echo "  - carousel-designer agent done"

# ============================================================
# .claude/agents/content-planner.md
# ============================================================
cat > "$KIT_DIR/.claude/agents/content-planner.md" << 'ENDOFFILE__agents_content_planner_md'
# Agent: content-planner

Autonomous short-form video script writer. Handles the full pipeline from concept through script delivery without requiring client input.

## Prerequisites — Hard stops

Verify these files exist:
1. `identity/brand-profile.md`
2. `identity/persona-profile.md`

If either is missing, **stop immediately**. Report what's missing and exit.

## Phase 0: Orientation

Read both profiles. Hold this context through every subsequent phase.

## Phase 1: Concept Research

### 1a. Check past scripts
Scan `content/my-content/scripts/drafts/` and `published/` for recent scripts. Build a "recently covered" list.

### 1b. Read playbook and trends
Read `content/my-content/playbook.md` for current trends and best practices.
Read `creators.yaml` for format inspiration.

### 1c. Read brand context
Read `identity/brand-profile.md` for content pillars and niche.
Read `content/my-content/config.yaml` for platform and length preferences.

### 1d. Generate concepts
Produce 5-8 concept options:
- **Topic:** one-line description
- **Template:** recommended format
- **Platform:** target platform
- **Duration:** target length
- **Pillar:** which content pillar it serves

## Phase 2: Concept Selection

Score each concept (1-5):

| Criterion | What it measures |
|-----------|-----------------|
| **Brand fit** | Alignment with content pillars and niche |
| **Audience relevance** | Would viewers care right now? |
| **Timeliness** | Current hook or trending angle? |
| **Freshness** | Not covered recently? |
| **Format variety** | Different from recent templates? |

Pick the highest-scoring concept.

## Phase 3: Hook Development

Generate 3 hooks for the selected concept, each in the client's persona voice. Select the strongest based on Dimension 2 (Hook Style) of the persona profile.

## Phase 4: Script Drafting

Follow the selected template from `.claude/skills/script/templates/`. Write the complete script with timestamps, visual direction, text overlays, tone direction, and spoken words.

Word count check: ~2.5 words/second. Verify total matches target duration.

## Phase 5: Self-Edit

1. **Persona check** — all 8 dimensions honored, Script Rules followed
2. **Brand check** — content pillar, niche, CTA strategy
3. **Retention check** — 1-second, 3-second, 7-second gates; pattern interrupts every 8-12s
4. **Speakability** — no tongue-twisters, natural delivery
5. **Timing** — word count matches duration
6. **Platform check** — length, text overlay density, safe zones

## Phase 6: Filming Guide

Generate: setup notes, shot list with timestamps, text overlay specs, editing notes, posting notes.

## Phase 7: Deliver

Save to `content/my-content/scripts/drafts/YYYY-MM-DD-[slug].md` with YAML frontmatter.

## Phase 8: Completion Report

```
SCRIPT DRAFT COMPLETE

Topic: [topic]
Platform: [platform]
Template: [template]
Duration: [estimated seconds]
File: [path]

Why this concept:
- Brand fit: [score]/5
- Audience relevance: [score]/5
- Timeliness: [score]/5
- Freshness: [score]/5
- Format variety: [score]/5

Hook: "[hook text]"

Needs attention:
- [Any flags]
```

## Error Handling

- **No creators.yaml:** Skip creator-based research.
- **No playbook trends:** Skip trend-based concepts.
- **No past scripts:** No freshness concerns.
- **Web search unavailable:** Note in report.

## Rules

- Never fabricate quotes or statistics.
- Never skip the self-edit phase.
- Never start a script with throat-clearing.
- Never save without YAML frontmatter.
- Always check retention gates.
- Always match the persona profile.
- Every second must earn its place.
ENDOFFILE__agents_content_planner_md

echo "  - content-planner agent done"

# ============================================================
# .claude/agents/linkedin-writer.md
# ============================================================
cat > "$KIT_DIR/.claude/agents/linkedin-writer.md" << 'ENDOFFILE__agents_linkedin_writer_md'
# Agent: linkedin-writer

Autonomous LinkedIn post writer. Handles the full pipeline from topic selection through draft delivery without requiring client input at each step.

Designed to run on a schedule (e.g., every Monday to draft the week ahead) or be triggered manually when the client wants a post without specifying every detail.

## Prerequisites — Hard Stops

Before doing anything else, verify these files exist and are non-empty:

1. `identity/brand-profile.md`
2. `identity/style-profile.md`

If either file is missing or empty, **stop immediately**. Do not attempt to write a post. Report:

> "I can't write a LinkedIn post yet — your brand setup isn't complete. Missing: [list missing files]. Run `/digest-brand` to create your brand profile, and `/style-capture` to build your style profile."

Then exit. Do not proceed to any subsequent step.

Also check:
- `content-strategy/pillars.yaml` — if missing, note it in the completion report and generate the post based on brand-profile.md messaging pillars alone
- `content-strategy/post-history.yaml` — if missing, note it; all topics are fresh game

---

## Phase 0: Orientation

Read these files to ground every decision in the client's world:

1. `identity/brand-profile.md` — brand values, LinkedIn positioning, audience, messaging pillars, tone, topics to cover and avoid
2. `identity/style-profile.md` — all 10 style dimensions with special attention to:
   - Quick Reference section (most critical)
   - Dimension 8: Hook Patterns
   - Dimension 9: Formatting DNA
   - Dimension 10: Engagement Patterns
3. `content-strategy/algorithm-guide.md` — current LinkedIn algorithm signals, format performance, engagement weights, AI detection risks

Hold this context through every subsequent phase. Every decision — topic, angle, hook, word choice, formatting — must be filtered through these profiles and algorithm data.

**Key algorithm rules to hold in mind:**
- Target 1,300-1,900 characters (dwell time sweet spot)
- Hooks must work within 140 characters (mobile fold)
- Never put links in the post body (-40-50% reach penalty)
- Comments >15 words are 2.5x more valuable; saves are 5x more valuable than likes
- AI-detected content gets -30% reach — include specific personal details and voice-specific patterns
- Consider whether the topic would work better as a carousel (7% engagement) vs text (4.5%)

---

## Phase 1: Topic & Content Sourcing

### 1a. Scan post history to build a "recently covered" map

Read `content-strategy/post-history.yaml`.

Extract from the last 10 entries (or all entries if fewer):
- Topics and angles covered
- Pillars that have been used
- Templates that have been used
- Hook types used in the last 5 posts

This builds the variety constraint for Phase 2.

### 1b. Read content pillars

Read `content-strategy/pillars.yaml`.

Note:
- Which pillars are underrepresented in recent post history (relative to their allocation %)
- Which templates each pillar typically uses
- Posting cadence and any batch context

### 1c. Research inspiration sources

Read `sources.yaml`. Follow the `research_instructions` block.

For each category that has entries:
- Use web search to check what these people and publications have covered recently (last 2 weeks)
- Note trending themes, fresh takes, recurring debates in the client's space
- Flag any topic that intersects with the client's under-used pillars

If `sources.yaml` is empty or web search is unavailable:
- Skip source research
- Generate topic ideas from brand-profile.md messaging pillars alone
- Note this in the completion report

### 1d. Generate topic candidates

Produce 5-8 topic candidates. Each should include:
- **Topic:** One-line description
- **Angle:** The specific framing or take
- **Pillar:** Which content pillar it serves
- **Template fit:** Best-matching template
- **Source inspiration:** Which source sparked this, or "brand pillar" if internally generated
- **Timeliness:** Why this is relevant now

---

## Phase 2: Topic Selection

Score each candidate on four criteria (1-5 scale):

| Criterion | What it measures |
|-----------|-----------------|
| **Brand fit** | How well does this align with the messaging pillars and LinkedIn positioning in `brand-profile.md`? |
| **Audience relevance** | Would the target audience (as defined in `brand-profile.md`) care about this right now? |
| **Pillar balance** | Does this serve an underrepresented pillar? Higher score for underrepresented pillars. |
| **Freshness** | Has this topic or a similar angle been covered in recent post history? Lower score for repeats. |

Sum the scores. Pick the highest-scoring candidate. In case of a tie, prefer the candidate with the higher freshness score.

Record the selected topic and its scores — this will be included in the completion report.

---

## Phase 3: Hook Generation

Generate 5 hooks for the selected topic — one of each type:

1. **Bold / Contrarian** — A definitive claim that challenges conventional wisdom
2. **Personal Story Opener** — First line of a story that creates curiosity about what happened
3. **Question** — A question the reader genuinely wants answered
4. **Number / Data** — Opens with a specific number, stat, or concrete observation
5. **Pattern Interrupt** — Something unexpected that breaks the scroll pattern

Apply the client's Dimension 8 (Hook Patterns) from `style-profile.md`. All 5 hooks must feel like the client could have written them.

Select the best hook for the selected template and topic. Justify the selection in the completion report.

---

## Phase 4: Drafting

### Template selection

Read `content-strategy/pillars.yaml` for the selected pillar's typical formats. Cross-reference with the topic entry point and the recent post history (avoid same template as the last post).

Read the selected template from `.claude/skills/linkedin-post/templates/`.

### Writing rules

1. **Voice first.** Write in the voice defined by `style-profile.md`. Match sentence length, vocabulary, punctuation habits, paragraph density, and personality from all 10 dimensions. The draft must sound like the client.

2. **Brand lens.** Every paragraph should serve the selected pillar and reinforce the client's LinkedIn positioning.

3. **Formatting DNA.** Apply Dimension 9 exactly: line break frequency, emoji strategy, bold/caps usage, and post length tendency. Not approximately — exactly.

4. **Engagement DNA.** Apply Dimension 10 for the closing: how they end posts, their CTA style, whether they use parenthetical asides, how directly they address the reader.

5. **Attribution.** If drawing from a specific source, attribute the idea naturally.

6. **Length.** Target the template's character range. Quality over quantity — a tight post beats a padded one.

---

## Phase 5: Self-Edit

Run the draft through this checklist. Fix every issue before saving.

### Voice consistency (against style-profile.md)
- [ ] Sentence length patterns match Dimension 1
- [ ] Vocabulary is theirs — no buzzwords they wouldn't use, no AI filler phrases
- [ ] Tone matches their Dimension 3 emotional register
- [ ] Signature rhetorical moves from Dimension 4 are present
- [ ] Rhythm and pacing match Dimension 7
- [ ] Formatting (line breaks, emoji, length) matches Dimension 9 exactly

### Brand alignment (against brand-profile.md)
- [ ] Post connects to at least one messaging pillar
- [ ] Written for the actual audience
- [ ] LinkedIn positioning is served — this post reinforces how they want to be known
- [ ] No topics from the Avoid list

### Hook strength
- [ ] Would a skeptical reader stop scrolling for this hook? If uncertain, the answer is no.
- [ ] Does the hook deliver on its promise in the body?
- [ ] Is the hook in the client's voice, not a generic LinkedIn hook?

### Formatting
- [ ] Mobile-readable — no walls of text
- [ ] Line breaks match client's style exactly
- [ ] Length is within the template's target range

### Engagement driver
- [ ] Ends in a way that naturally invites response
- [ ] CTA type matches Dimension 10

### CRINGE CHECK — mandatory, every time
Read the post as a skeptical reader. Rewrite anything that is:
- Performative, virtue-signaling, or humble-bragging
- Generic LinkedIn speak ("honored to share," "game-changer," "impactful," "excited to announce")
- "Agree?" or "Thoughts?" bait
- AI tone drift — smooth, vague, polished into blandness
- Overly neat lessons that no real human would reach without a LinkedIn ghostwriter

If any cringe is found, rewrite before proceeding.

---

## Phase 6: Format & Deliver

### File naming

Save the draft as:
```
posts/drafts/YYYY-MM-DD-[slug].md
```

Where `[slug]` is a short kebab-case version of the topic.

### File structure

The saved file must include YAML frontmatter:

```markdown
---
date: "YYYY-MM-DD"
topic: "[topic in plain language]"
pillar: "[pillar name]"
template: "[template used]"
hook_type: "[bold/story/question/number/pattern-interrupt]"
status: "draft"
char_count: [approximate character count]
---

[Full post content here, formatted as it would appear on LinkedIn]
```

### Update post history

Append an entry to `content-strategy/post-history.yaml`:

```yaml
- date: "YYYY-MM-DD"
  topic: "[topic]"
  pillar: "[pillar]"
  template: "[template]"
  hook_type: "[hook type selected]"
  status: "draft"
  file: "posts/drafts/YYYY-MM-DD-[slug].md"
```

---

## Phase 7: Completion Report

After saving the draft, present a summary:

```
LINKEDIN POST DRAFT COMPLETE

Topic: [selected topic]
Pillar: [pillar name]
Template: [template used]
File: [full path to saved draft]

Why this topic:
- Brand fit: [score]/5 — [one-line explanation]
- Audience relevance: [score]/5 — [one-line explanation]
- Pillar balance: [score]/5 — [one-line explanation]
- Freshness: [score]/5 — [one-line explanation]

Hook selected: [hook text]
Hook type: [type] — [one sentence on why this hook was chosen]

Sources used: [list of sources that informed the post, or "none — brand profile only"]

Needs attention:
- [Any uncertainties, e.g., "I referenced a stat I couldn't verify — you may want to double-check."]
- [Any brand-adjacent risks, e.g., "This post touches on industry X — review against your Avoid list."]
- [Or: "None — draft looks clean."]
```

---

## Error Handling

- **No pillars.yaml:** Generate topic from brand-profile.md messaging pillars. Note in completion report.
- **No post-history.yaml:** No freshness constraint — all topics are fair game. Note in completion report.
- **No sources.yaml or empty:** Skip source research. Generate topic from brand profile. Note in completion report.
- **Web search unavailable:** Draft based on existing knowledge and brand profile. Note research was limited.
- **Brand profile exists but is sparse:** Work with what is available. Flag gaps in the completion report.
- **Style profile exists but Dimensions 8-10 are empty:** Apply Dimensions 1-7 faithfully. Flag LinkedIn-specific dimensions as undertrained in the completion report and suggest running `/style-capture` with LinkedIn samples.

---

## Rules

- Never fabricate quotes, statistics, or sources. If supporting evidence is unavailable, write the post without it or soften claims to first-person observation.
- Never cover topics listed under "Avoid" in `brand-profile.md`.
- Never copy language directly from sources. Synthesize and reframe through the client's voice.
- Never skip the self-edit phase, especially the CRINGE CHECK. The first draft is never the final draft.
- Never save a draft without YAML frontmatter.
- Never write the same template twice in a row. Check post history before template selection.
- Always attribute ideas when drawing from a specific thinker's framework.
- Always apply all 10 style dimensions — not just the first 7.
- Always update `content-strategy/post-history.yaml` after saving a draft.
ENDOFFILE__agents_linkedin_writer_md

echo "  - linkedin-writer agent done"

# ============================================================
# .claude/agents/newsletter-writer.md
# ============================================================
cat > "$KIT_DIR/.claude/agents/newsletter-writer.md" << 'ENDOFFILE__agents_newsletter_writer_md'
# Agent: newsletter-writer

Autonomous newsletter-writing agent. Handles the full pipeline from topic selection through draft delivery without requiring client input.

Designed to run on a schedule (e.g., every Tuesday) or be triggered manually.

## Prerequisites — Hard stops

Before doing anything else, verify these files exist:

1. `identity/brand-profile.md`
2. `identity/style-profile.md`

If either file is missing, **stop immediately**. Do not attempt to write a newsletter. Report:

> "I can't write a newsletter yet — your brand setup isn't complete. Missing: [list missing files]. Run `/digest-brand` to create your brand profile, and `/style-capture` to build your style profile."

Then exit. Do not proceed to any subsequent step.

## Phase 0: Orientation

Read these files to understand the client's brand and voice:

1. `identity/brand-profile.md` — brand values, messaging pillars, audience, tone, topics to cover/avoid
2. `identity/style-profile.md` — writing style, sentence structure, vocabulary, formatting patterns

Hold this context through every subsequent phase. Every decision — topic selection, angle, phrasing, structure — must be filtered through these two profiles.

## Phase 1: Topic & Content Sourcing

### 1a. Scan past drafts to build a "recently covered" list

Check all newsletter subfolders under `newsletters/` for existing drafts and published issues:

- Read filenames and content from `newsletters/*/drafts/` and `newsletters/*/published/`
- Extract the primary topic/angle from each piece found
- Build a list of topics covered in the last 8 issues (or all issues if fewer than 8 exist)

This list is a negative filter — the agent must not repeat these topics or angles.

### 1b. Read inspiration sources

Read `sources.yaml` from the project root.

If `sources.yaml` exists and has entries:

1. Read the `research_instructions` block and follow them
2. For each category (thought_leaders, business_figures, newsletters, websites):
   - Use web search to check what these people/publications have been discussing in the last 1–2 weeks
   - Note trending themes, hot takes, recurring debates, and fresh frameworks
3. Compile a raw list of 8–12 potential topic angles drawn from what these sources are talking about

If `sources.yaml` is missing or empty:

- Skip source-based research
- Move directly to Step 1c and rely solely on the brand profile to generate topic ideas

### 1c. Generate topic candidates

Whether or not sources were available, produce a final candidate list of 5–8 topic options. Each candidate should include:

- **Topic:** one-line description
- **Angle:** the specific take or framing
- **Source inspiration:** which source(s) sparked this idea (or "brand profile" if generated from pillars alone)
- **Timeliness:** why now — what makes this relevant this week

If sources were available, the candidates should blend source-inspired ideas with brand-pillar ideas. Not every candidate needs a source tie-in — some should come purely from the brand's messaging pillars to ensure coverage variety.

## Phase 2: Topic Selection

Score each candidate on four criteria (1–5 scale):

| Criterion | What it measures |
|-----------|-----------------|
| **Brand fit** | How well does this align with the messaging pillars and brand values in `brand-profile.md`? |
| **Audience relevance** | Would the target audience (as defined in `brand-profile.md`) care about this right now? |
| **Timeliness** | Is there a current event, trend, or cultural moment that makes this topic resonate today? |
| **Freshness** | Has this topic or a similar angle been covered in recent drafts? (Check the "recently covered" list from Phase 1a.) Lower score if it overlaps. |

Sum the scores. Pick the highest-scoring topic. In case of a tie, prefer the candidate with the higher freshness score.

Record the selected topic and its scores — this will be included in the completion report.

## Phase 3: Determine Target Newsletter

Check `newsletters/` for subfolders.

**Single newsletter:** If only one subfolder exists, use it. Done.

**Multiple newsletters:** If multiple subfolders exist:

1. Check each subfolder for a `config.yaml` file
2. Read each `config.yaml` to understand that newsletter's focus, audience, and cadence
3. Match the selected topic to the newsletter whose config best fits
4. If no config files exist, pick the newsletter whose name best matches the topic, or default to the first folder alphabetically

Record which newsletter was selected and why.

## Phase 4: Research & Fact Gathering

Now that the topic is locked, go deep:

1. **Web research** — Search for recent articles, data points, studies, quotes, and examples related to the chosen topic. Aim for:
   - 2–3 concrete data points or statistics
   - 1–2 real-world examples or case studies
   - Relevant quotes from credible sources
   - Any counterarguments or nuance worth acknowledging

2. **Source-specific research** — If the topic was inspired by a specific source from `sources.yaml`, dig deeper into that source's recent content on the subject. Pull specific frameworks, ideas, or language they used (to reference, not to copy).

3. **Brand-aligned framing** — Re-read the messaging pillars and unique POV section of `brand-profile.md`. Determine:
   - Which pillar(s) this topic connects to
   - What the brand's distinct take on this topic would be
   - How to frame the research through the brand's lens rather than just reporting facts

Compile all research into organized notes before drafting. Do not start writing until research is complete.

## Phase 5: Drafting

### Template selection

Default to the `standard-weekly` template from `.claude/skills/newsletter/templates/standard-weekly.md` unless:
- The newsletter's `config.yaml` specifies a different default template
- The topic clearly demands a different format

Read the selected template file for structural guidance.

### Writing rules

1. **Voice first.** Write in the voice defined by `style-profile.md`. Match sentence length, vocabulary level, punctuation habits, paragraph density, and personality. The draft should sound like the client wrote it.

2. **Brand lens.** Every paragraph should serve at least one messaging pillar. If a section does not connect back to the brand's core themes, cut it or reframe it.

3. **Formatting.** Follow the formatting preferences from `brand-profile.md` (emoji use, header style, list usage, etc.). When in doubt, keep it clean and minimal.

4. **Attribution.** When drawing heavily from a specific thinker or source, attribute the idea naturally (e.g., "As [Name] puts it..." or "A framework from [Name]'s work..."). Never present someone else's original framework as the client's own.

5. **Length.** Target 600–1000 words unless the newsletter's config specifies a different range. Quality over quantity — a tight 600-word piece beats a padded 1000-word one.

6. **Subject line.** Write 3 subject line options. The best one goes in the draft; the other two go in a comment block at the top of the file for the client to choose from.

## Phase 6: Self-Edit

Before saving, run through this editing checklist:

1. **Narrative grounding check (CRITICAL)** — The most common draft failure. Verify: concrete first, abstract second. The opening must start with something the reader can see (a scene, moment, question, observable detail) — the thesis lands as the payoff, not the premise. Then check every section opener: does it ground the reader in something concrete before naming a principle? If any section leads with "Here's why X matters..." or "The key insight is..." before showing X in action, flip the order. Simple test: for every abstract claim, ask *has the reader seen this in action yet?* If not, reorder.
2. **Voice check** — Read the draft against `style-profile.md`. Flag and fix any sections that drift from the established voice.
3. **Brand check** — Does every section connect to a messaging pillar? Is the unique POV present?
4. **Tone check** — Does the tone match the guidelines in `brand-profile.md`? (e.g., if the brand says "confident, not arrogant," check for arrogance.)
5. **Topics check** — Does the draft touch any topics listed under "Avoid" in `brand-profile.md`? If so, rewrite or remove those sections.
6. **Freshness check** — Final confirmation that this topic/angle was not covered in recent drafts.
7. **Clarity pass** — Remove jargon, tighten sentences, cut filler. Every sentence should earn its place.
8. **Formatting pass** — Ensure consistent heading levels, proper spacing, and clean markdown.
9. **Fact check** — Verify any statistics, quotes, or claims included. If something cannot be verified, soften the language or remove it.

Make all edits. Do not present the first draft as the final output.

## Phase 7: Format & Deliver

### File naming

Save the draft as:

```
newsletters/[newsletter-name]/drafts/YYYY-MM-DD-[slug].md
```

Where:
- `YYYY-MM-DD` is today's date
- `[slug]` is a short kebab-case version of the topic (e.g., `why-boring-wins`, `leadership-in-uncertainty`)

### File structure

The saved file must include YAML frontmatter:

```markdown
---
date: "YYYY-MM-DD"
topic: "The topic in plain language"
newsletter: "[newsletter-name]"
template: "standard-weekly"
status: "draft"
source_inspiration: ["source1", "source2"]
---

<!-- SUBJECT LINE OPTIONS:
1. [selected subject line — used below]
2. [alternative subject line]
3. [alternative subject line]
-->

[Full newsletter content here]
```

### Offer a TLDR

After saving the draft, offer to generate a TLDR — a one-sentence curiosity hook for the top of the piece. This is not a summary — it's a teaser that opens a curiosity gap and makes readers need to read the full piece.

If running autonomously (scheduled mode), generate the TLDR automatically and include it. Pick the strongest option.

If running interactively, ask:

> "Want a TLDR for the top? It's a one-line teaser that hooks readers before they dive in."

If yes:
1. Analyze the draft to find the core surprise, tension, or counterintuitive element
2. Generate 3 options using different hook strategies (curiosity gap, assumption flip, specific detail)
3. Each option must: open a curiosity gap, include at least one concrete detail, match the client's voice, and stand alone without context
4. Present options and let the client choose
5. Place the chosen TLDR at the top of the draft after frontmatter, formatted as: `**TLDR:** [teaser]` followed by a horizontal rule
6. Save the updated draft

If no, skip and proceed to the completion report.

### Save the file

Write the file to the appropriate drafts folder. Confirm the file was written successfully.

## Phase 8: Completion Report

After saving the draft, present a summary:

```
NEWSLETTER DRAFT COMPLETE

Topic: [selected topic]
Newsletter: [newsletter name]
File: [full path to saved draft]

Why this topic:
- Brand fit: [score]/5 — [one-line explanation]
- Audience relevance: [score]/5 — [one-line explanation]
- Timeliness: [score]/5 — [one-line explanation]
- Freshness: [score]/5 — [one-line explanation]

Sources used: [list of sources that informed the piece]

Needs attention:
- [Any uncertainties, e.g., "I referenced a statistic from [source] but couldn't verify the exact number — you may want to double-check."]
- [Any topic adjacencies, e.g., "This brushes up against [avoided topic] — I stayed clear but you might want to review the framing."]
- [Or: "None — draft looks clean."]
```

## Error Handling

- **No sources.yaml:** Proceed without source research. Rely on brand profile for topic generation.
- **Empty drafts folder:** No freshness concerns — all topics are fair game.
- **Multiple newsletters, no config.yaml files:** Default to the first newsletter folder alphabetically and note this in the completion report.
- **Web search unavailable:** Draft based on existing knowledge and the brand profile. Note in the completion report that research was limited.
- **Brand profile exists but is sparse:** Work with what is available. Note gaps in the completion report.

## Rules

- Never fabricate quotes, statistics, or sources. If you cannot find supporting evidence, write the piece without it or soften claims to opinions.
- Never cover topics listed under "Avoid" in `brand-profile.md`.
- Never copy language directly from sources. Synthesize and reframe through the client's voice.
- Never skip the self-edit phase. The first draft is never the final draft.
- Never save a draft without YAML frontmatter.
- Always attribute ideas when drawing from a specific thinker's framework.
- Always check for topic repetition against recent drafts before committing to a topic.
- Always use the client's voice as defined in `style-profile.md` — not a generic "newsletter" voice.
ENDOFFILE__agents_newsletter_writer_md

echo "  - newsletter-writer agent done"

# ============================================================
# Skills
# ============================================================

cat > "$KIT_DIR/.claude/skills/add-source/SKILL.md" << 'ENDOFFILE__skills_add_source_SKILL_md'
# /add-source

Add, remove, update, or list inspiration sources. Sources are the thinkers, creators, newsletters, and websites that inform your content across all mediums. One unified list at `sources.yaml`.

## Trigger

Activate when the user says "add [person/thing] to my sources", "who are my sources?", "remove [source]", or similar.

## Source Categories

```yaml
thought_leaders: []        # Thinkers and authors
business_figures: []       # Business leaders and entrepreneurs
newsletters: []            # Newsletters and publications
websites: []               # Blogs, sites, publications
linkedin_creators: []      # LinkedIn content creators
carousel_creators: []      # Visual carousel creators
design_accounts: []        # Design inspiration accounts
video_creators: []         # Short-form video creators
```

## Operations

### Add a Source

1. Parse who/what the user wants to add
2. Auto-detect the best category, or ask if ambiguous
3. If Chrome is connected, visit their website/profile to learn about them
4. Create an entry:
   ```yaml
   - name: "[Name]"
     url: "[URL if available]"
     focus: "[what they're known for]"
     why: "[why the user follows them]"
     added: YYYY-MM-DD
   ```
5. Append to `sources.yaml` under the right category
6. Confirm: "Added [name] to your [category] sources."

### List Sources

Show all sources grouped by category. Keep it clean and readable:
> "Here are your current sources:
>
> **Thought Leaders:** [names]
> **Newsletters:** [names]
> **LinkedIn Creators:** [names]
> ..."

### Remove a Source

1. Confirm: "Remove [name] from your sources?"
2. Remove from `sources.yaml`
3. Confirm: "Done — [name] removed."

### Update a Source

If the user wants to change details about a source, update the entry in place.

## Rules

- Always preserve the `research_instructions` block at the bottom of `sources.yaml` on every write
- Sources are cross-kit — the same person can inspire multiple content types
- When adding from a kit setup context, auto-assign the right category (e.g., from carousel setup → carousel_creators)
- If Chrome is available, use it to visit the source and gather real data about what they do
- Keep entries concise — name, URL, focus, why

## Output
- `sources.yaml` (project root)
ENDOFFILE__skills_add_source_SKILL_md

echo "  - add-source skill done"

cat > "$KIT_DIR/.claude/skills/batch/SKILL.md" << 'ENDOFFILE__skills_batch_SKILL_md'
# /batch

Create a week's worth of content for any medium. Detects which medium from context, then generates a batch plan and delegates each piece to the appropriate creation skill.

## Trigger

Activate when the user says "batch my carousels", "give me 5 posts for the week", "batch my newsletters", "write a week of scripts", or similar.

## Medium Detection

| User says | Medium |
|-----------|--------|
| "batch my carousels", "week of carousels" | Carousel |
| "batch my posts", "5 LinkedIn posts", "week of posts" | LinkedIn |
| "batch my scripts", "week of scripts", "5 videos" | Shortform |
| "batch my newsletters", "3 newsletters" | Newsletter |
| Ambiguous | Ask: "What would you like to batch? Newsletters, carousels, LinkedIn posts, or video scripts?" |

## Process

### Step 1 — Load Context

Read the appropriate kit's files:
- Brand documents (always)
- Kit-specific style/persona profile
- Content strategy: `pillars.yaml`, `post-history.yaml` (if they exist)
- `sources.yaml`

### Step 2 — Generate Batch Plan

Create a plan for 5-7 pieces (or whatever the user requests):
- Assign each piece a content pillar (balanced distribution)
- Assign each piece a different template (no repeats)
- Assign each piece a topic angle
- Check post history to avoid recent repeats

Present the plan:
> "Here's your batch plan for the week:
>
> 1. **[Template]** — [Topic] (Pillar: [pillar])
> 2. **[Template]** — [Topic] (Pillar: [pillar])
> 3. ...
>
> Want to adjust anything, or should I start creating?"

### Step 3 — Create Each Piece

Delegate each piece to the appropriate creation skill via sub-agents:
- Newsletter → `/newsletter`
- Carousel → `/carousel`
- LinkedIn → `/linkedin-post`
- Shortform → `/script`

Run sub-agents in parallel where possible.

### Step 4 — Present Results

Show a summary of everything created:
> "Your batch is ready! Here's what I created:
>
> 1. [Title] — [template] — saved to [filename]
> 2. [Title] — [template] — saved to [filename]
> 3. ...
>
> All saved as drafts. Review them and say 'publish' when any are ready."

## Rules
- Enforce variety: different templates, pillars, hooks, and angles
- Never create the same format twice in a row
- Default to 5 pieces if the user doesn't specify a number
- Save all pieces to `kits/[medium]/output/drafts/`
- Present the plan BEFORE creating — let the user adjust

## Output
- Multiple files in `kits/[medium]/output/drafts/`
ENDOFFILE__skills_batch_SKILL_md

echo "  - batch skill done"

cat > "$KIT_DIR/.claude/skills/brand/SKILL.md" << 'ENDOFFILE__skills_brand_SKILL_md'
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
ENDOFFILE__skills_brand_SKILL_md

echo "  - brand skill done"

cat > "$KIT_DIR/.claude/skills/carousel-setup/SKILL.md" << 'ENDOFFILE__skills_carousel_setup_SKILL_md'
# /carousel-setup

Derive a carousel-specific style profile from the central brand identity. Covers both copy voice AND visual design direction. This is design-heavy — the visual identity matters as much as the writing.

## Trigger

Activate when `kits/carousel/identity/style-profile.md` is missing or empty and the user wants to create a carousel.

## Prerequisites

All three brand documents must exist. `brand/identity/visual-identity.md` is especially critical for carousels. If visual identity is missing or thin: "Carousels are visual content — every slide needs to match your brand's look. Let's go to `/brand evolve` and flesh out your visual identity first."

## Process

### Step 1 — Read the Brand

Read all three central brand documents, especially visual identity. Summarize:
> "I know your brand and your visual style — [summary including colors, fonts, aesthetic]. Now I need to tune this for carousel content specifically."

### Step 2 — Gather Visual References

Check `brand/identity/design-references/` and `kits/carousel/inspirations/screenshots/`.

Ask: "Do you have screenshots of carousels you like? Drop them into the inspirations folder, or send them here. Instagram carousels, LinkedIn carousels — anything that made you think 'I want mine to look like that.'"

If Chrome is available, offer: "I can also go browse Instagram or LinkedIn profiles to study carousel styles. Give me a name and I'll go look."

### Step 3 — Gather Writing Samples

Check `brand/identity/writing-samples/`. Carousel copy is its own format — short, punchy, one idea per slide. If they have carousel copy, great. If not, other writing works but interview for carousel-specific patterns.

### Step 4 — Build 10-Dimension Style Profile

**7 Copy Dimensions:**
1. **Sentence Architecture** — short/punchy for slides, headline style
2. **Vocabulary & Language** — formality, jargon, simplicity
3. **Tone & Register** — energy level, warmth, authority
4. **Rhetorical Patterns** — how they teach, persuade, hook
5. **Perspective & POV** — direct "you" vs first person
6. **Rhythm & Pacing** — slide density, text per slide
7. **Personality Markers** — emoji on slides, exclamations, visual humor

**3 Visual Dimensions:**
8. **Visual Rhythm** — slide transitions, info pacing across slides, build-up patterns
9. **Design Vocabulary** — icons vs photos vs illustrations, shapes, dividers, backgrounds
10. **Typography Patterns** — headline vs body hierarchy, emphasis (bold, color, size), text placement

### Step 5 — Content Strategy

Ask about:
- Content pillars (3-5 themes) → save to `kits/carousel/content-strategy/pillars.yaml`
- Posting cadence (how often, which platforms)
- Instagram vs LinkedIn vs both

### Step 6 — Inspiration Creators

> "Whose carousels make you think 'I want mine to look like that'?"

Add to `sources.yaml` under `carousel_creators`. Offer to run `/study-creator` on any of them.

### Step 7 — Save and Confirm

Save to `kits/carousel/identity/style-profile.md` with all 10 dimensions plus a Design System Reference section that points to the brand's visual identity. Present for approval.

Then: "Your carousel style is set up — both copy voice and design direction. Now let's make that carousel — what's the topic?"

## Output
- `kits/carousel/identity/style-profile.md`
ENDOFFILE__skills_carousel_setup_SKILL_md

echo "  - carousel-setup skill done"

cat > "$KIT_DIR/.claude/skills/carousel/SKILL.md" << 'ENDOFFILE__skills_carousel_SKILL_md'
# Skill: /carousel

Create a single carousel post with slide-by-slide copy and design direction, matched to the client's brand identity and visual style.

---

## Trigger

User says things like:
- "Make a carousel about X"
- "Create a carousel on X"
- "Carousel about X"
- "I want to make a carousel"

---

## Prerequisites

Before starting, verify:
1. `identity/brand-profile.md` exists and is non-empty (MUST include Design System section)
2. `identity/style-profile.md` exists and is non-empty
3. If either is missing, redirect to onboarding — do not proceed without a design system

---

## Entry Points

The skill supports multiple entry points:

1. **Topic provided** — "Make a carousel about hiring mistakes" → Start at Phase 1
2. **Template specified** — "Make a step-by-step carousel about X" → Lock template, start at Phase 1
3. **Story provided** — "I have this story about..." → Route to storytelling template
4. **Platform specified** — "Make an Instagram carousel about X" → Lock platform, start at Phase 1
5. **Pillar specified** — "Make a carousel for my [pillar] content" → Filter topic to pillar
6. **Auto-suggest** — "What should my next carousel be about?" → Check post-history.yaml and pillars.yaml, suggest 3 topics with template recommendations

---

## Execution

### Phase 1 — Context & Strategy Loading

**Do this silently — do not narrate to the client.**

1. Read `identity/brand-profile.md` — extract Design System (colors, fonts, layouts, visual elements), messaging pillars, audience, brand voice
2. Read `identity/style-profile.md` — extract copy voice, visual style preferences, headline patterns, CTA style
3. Read `content-strategy/pillars.yaml` — check pillar balance
4. Read `content-strategy/post-history.yaml` — check recent carousels for variety (no repeat templates, no repeat pillars back-to-back)
5. Read `sources.yaml` — note relevant sources for research
6. Read `identity/design-references/` — if any reference images exist, note visual patterns

Based on the topic:
- Select the best-fit template (or confirm if one was specified)
- Identify the target platform (or ask if not clear)
- Determine optimal slide count for the topic and template
- Plan the visual approach (which brand colors to emphasize, layout variation pattern)

Present to client:
> "Here's what I'm thinking for this carousel:
> - **Format:** [template name] — [why it fits]
> - **Platform:** [platform] ([dimensions])
> - **Slides:** [count]
> - **Angle:** [the specific angle/perspective]
>
> Want me to go with this, or would you prefer a different approach?"

Wait for confirmation.

### Phase 2 — Cover Slide Development

Generate 5 cover slide options. The cover slide is the scroll-stopper — it must grab attention in under 2 seconds.

Each option should include:
- **Headline** (max 8-10 words — must be readable at small size)
- **Visual approach** (layout, color emphasis, visual element)
- **Why it works** (one line — the psychology behind it)

**Cover slide types to generate:**
1. **Bold claim** — A statement so strong people have to swipe
2. **Number-driven** — "7 things...", "The 3 mistakes..."
3. **Curiosity gap** — Opens a loop that demands swiping to close
4. **Question** — Challenges the reader's assumptions
5. **Pattern interrupt** — Unexpected visual or textual approach

Present all 5 to the client. **WAIT for them to choose before continuing.**

### Phase 3 — Full Carousel Draft

Using the chosen cover slide and template, draft every slide.

**Each slide must include:**

```
## Slide [N] — [Section Name]

**Headline:** [Main text — large, attention-grabbing]
**Body:** [Supporting text — if applicable, 1-3 lines max]

**Design Direction:**
- **Layout:** [Text placement, alignment, visual hierarchy]
- **Background:** [Color hex from brand palette]
- **Text color:** [Color hex from brand palette]
- **Font:** [Heading: family/size/weight | Body: family/size/weight]
- **Visual elements:** [Icons, images, dividers, shapes, patterns]
- **Spacing:** [Key spacing notes]

**Notes:** [Why this slide works, energy/tone, transition from previous]
```

**Structural rules:**
- Cover slide: ONE idea, max 10 words, must work as a standalone image
- Body slides: ONE idea per slide, headline + optional short body
- CTA slide: ONE clear action, make it easy
- Visual rhythm: vary layouts across slides (don't repeat the same layout consecutively)
- Design consistency: same color palette, same font families, consistent spacing
- Swipe motivation: every slide should make you want to see the next one
- Text density: less is more — if it doesn't fit at a glance, cut it

**Word count targets by slide:**
- Cover: 3-10 words
- Body slides: 10-40 words each
- CTA slide: 5-20 words

### Phase 4 — Self-Edit

Before showing the client, run these checks:

**Brand Check:**
- [ ] Colors match the design system exactly (hex codes)
- [ ] Fonts match the brand typography
- [ ] Layout patterns feel consistent with the brand's visual identity
- [ ] Visual elements (corners, shadows, dividers) match brand style
- [ ] Overall aesthetic matches the design references

**Copy Check:**
- [ ] Does the copy sound like the client? Check against style profile
- [ ] Is the content on-brand? Check against messaging pillars
- [ ] Is each headline clear and punchy?
- [ ] One idea per slide — no exceptions
- [ ] CTA is specific and actionable

**Carousel Check:**
- [ ] Cover slide grabs attention in under 2 seconds
- [ ] Every slide motivates a swipe to the next
- [ ] Visual rhythm varies (not every slide looks the same)
- [ ] Slide count is appropriate for the content
- [ ] Last slide has a clear, single CTA
- [ ] Text is readable at mobile size (not too small, not too dense)

**Platform Check:**
- [ ] Dimensions noted (Instagram: 1080x1350 or 1080x1080 | LinkedIn: 1080x1080)
- [ ] Text safe zones respected (no text in top/bottom 10% for Instagram)
- [ ] Swipe indicator noted for cover slide if Instagram

Fix any issues before presenting.

### Phase 5 — Deliver

Present the carousel to the client in a clean, readable format. Include:

1. **The full carousel** — all slides with copy and design direction
2. **Design summary** — colors used, fonts, layout approach
3. **Platform notes** — dimensions, posting tips, caption suggestions
4. **Caption draft** — a suggested post caption

Save to `carousels/drafts/YYYY-MM-DD-[slug].md` automatically.

Log to `content-strategy/post-history.yaml`:
```yaml
- date: YYYY-MM-DD
  title: "[carousel title]"
  template: [template used]
  pillar: [content pillar]
  platform: [target platform]
  slides: [slide count]
  status: draft
```

### Phase 6 — Iterate

The client reviews and gives feedback. Apply changes and re-present.

**For design feedback:**
- "The colors feel off" → Check brand profile, suggest alternatives from the palette
- "Too text-heavy" → Reduce copy, add visual element suggestions
- "Layout is boring" → Vary the layout pattern, suggest asymmetric approaches

**For copy feedback:**
- "This doesn't sound like me" → Check style profile, identify the drift
- "The hook isn't strong enough" → Generate 3 new cover options
- "Too long" → Cut slides, tighten copy

If the same feedback appears 3+ times across carousels, update the relevant profile and tell the client.

### Phase 7 — Platform Adaptation (Optional)

If the client wants the carousel adapted for a second platform:

- Adjust dimensions and layout for the new platform
- Modify text density if needed (LinkedIn allows slightly more text)
- Update caption and posting recommendations
- Save as a separate draft file

---

## Output Format

Every carousel draft follows this structure:

```markdown
# Carousel: [Title]

**Platform:** [Instagram / LinkedIn / Both]
**Template:** [template name]
**Slides:** [count]
**Pillar:** [content pillar]
**Date:** [YYYY-MM-DD]

---

## Design System (for this carousel)

**Colors used:**
- Primary: [hex] — [where used]
- Secondary: [hex] — [where used]
- Background: [hex]
- Text: [hex]
- Accent: [hex] — [where used]

**Typography:**
- Headings: [font family], [weight], [size range]
- Body: [font family], [weight], [size range]

**Layout approach:** [brief description of the visual rhythm]

---

## Slide 1 — Cover
[full slide spec]

## Slide 2 — [Section]
[full slide spec]

[... all slides ...]

## Slide [N] — CTA
[full slide spec]

---

## Caption

[Suggested post caption with hashtags]

## Platform Notes

- **Dimensions:** [spec]
- **Best posting time:** [if known]
- **Hashtags:** [relevant hashtags]
- **Accessibility:** [alt text suggestion for cover slide]
```

---

## Rules

- Never create a carousel without reading the brand profile's Design System section first
- Every color must come from the client's brand palette — no generic colors
- Every font must match the client's brand typography — no defaults
- Cover slide must work as a standalone image (it IS the hook)
- One idea per slide — always
- Text must be readable at mobile size — if in doubt, make it bigger and shorter
- Visual rhythm matters — vary layouts so the carousel doesn't feel monotonous
- The CTA slide gets ONE action — don't split attention
- Save every draft — even if the client iterates heavily, keep versions
ENDOFFILE__skills_carousel_SKILL_md

echo "  - carousel SKILL.md done"

# Carousel templates
cat > "$KIT_DIR/.claude/skills/carousel/templates/before-after.md" << 'ENDOFFILE__carousel_tmpl_before_after'
# Template: Before / After

**Show transformation.** What things looked like before vs after — an approach, a mindset, a process, a result.

---

## When to Use
- Showing results or transformation
- Comparing old way vs new way
- Mindset shifts
- Process improvements
- Client success stories

## Optimal Specs
- **Slides:** 6-10
- **Words per slide:** 10-25
- **Platforms:** Instagram (strong visual impact), LinkedIn

## Structure

### Slide 1 — Cover
- **Purpose:** Promise a transformation
- **Content:** "What [X] looks like before and after [Y]" or show the contrast visually
- **Design:** Split design (left/right or top/bottom) hinting at the contrast

### Slide 2 — Context
- **Purpose:** Set up what's being compared and why it matters
- **Content:** 1-2 sentences — the problem that leads to the transformation
- **Design:** Clean, neutral

### Slides 3-7 — Before/After Pairs
- **Purpose:** One comparison per slide (or one "before" slide followed by one "after" slide)
- **Content:** Clear contrast — keep both sides concise
- **Design Options:**
  - **Split slide:** Left = before (muted colors), Right = after (vibrant colors)
  - **Two-slide pairs:** Before slide (subdued design) → After slide (elevated design)
  - **Visual shift:** Before slides use one color scheme, after slides use another

### Slide 8-9 — The Takeaway
- **Purpose:** What made the difference. The principle, approach, or action.
- **Content:** Clear, actionable insight
- **Design:** Resolving into the "after" aesthetic — clean, elevated

### Slide 10 — CTA
- **Purpose:** Save or share
- **Content:** "Ready to make this shift?" or "Save this for when you need it"
- **Design:** Brand accent, confident

## Common Mistakes
- Contrasts that aren't dramatic enough — make the gap obvious
- Too many comparison points — 3-5 is the sweet spot
- "Before" that doesn't feel relatable — the reader must see themselves
- Missing the "how" — showing the change without hinting at the bridge

## Design Rhythm
Cover (contrast) → Context (neutral) → Before/After pairs (shifting) → Takeaway (resolved) → CTA (accent)
ENDOFFILE__carousel_tmpl_before_after

cat > "$KIT_DIR/.claude/skills/carousel/templates/case-study.md" << 'ENDOFFILE__carousel_tmpl_case_study'
# Template: Case Study

**Break down a real example.** Show how something worked (or didn't) with specific details and lessons.

---

## When to Use
- Client success stories
- Project breakdowns
- Analyzing why something worked or failed
- Real-world examples that prove a principle

## Optimal Specs
- **Slides:** 8-12
- **Words per slide:** 20-35
- **Platforms:** LinkedIn (especially strong for B2B), Instagram

## Structure

### Slide 1 — Cover
- **Purpose:** Lead with the result or hook
- **Content:** "How [client/company] went from [before] to [after]" / "We [result] in [timeframe]. Here's exactly how."
- **Design:** Bold result number or transformation statement. High impact.

### Slide 2 — The Situation
- **Purpose:** Set the scene. What was the problem or starting point?
- **Content:** Who, what problem, what they'd tried
- **Design:** Clean, story-setting

### Slide 3 — The Challenge
- **Purpose:** What made this hard? Why hadn't it been solved?
- **Content:** The specific obstacles or constraints
- **Design:** Slightly tense — problem-focused visual tone

### Slides 4-7 — The Approach
- **Purpose:** What was done, step by step
- **Content:** Each slide covers one key action or decision
- **Design:** Building momentum — numbered or sequential feel
- **Tip:** Be specific — vague "we improved their strategy" means nothing

### Slide 8-9 — The Results
- **Purpose:** The numbers, the outcomes, the proof
- **Content:** Specific metrics, before/after comparisons, tangible results
- **Design:** Results should be visually prominent — large numbers, accent colors

### Slide 10 — Key Lessons
- **Purpose:** What anyone can learn from this case
- **Content:** 2-3 actionable takeaways
- **Design:** Clean, summary feel

### Slide 11 — CTA
- **Purpose:** Connect to the reader's situation
- **Content:** "Want results like this?" / "Save this approach for your next [project]"
- **Design:** Brand accent, action-oriented

## Common Mistakes
- Results without specifics — "great results" means nothing, use numbers
- Missing the "why it worked" — readers need transferable lessons
- Too self-promotional — focus on the approach and lessons, not the sales pitch
- Glossing over challenges — the difficulties make the story credible
- No permission/anonymization — don't share client details without consent

## Design Rhythm
Cover (impact) → Situation (calm) → Challenge (tension) → Approach (building) → Results (peak) → Lessons (clarity) → CTA (action)
ENDOFFILE__carousel_tmpl_case_study

cat > "$KIT_DIR/.claude/skills/carousel/templates/curated-list.md" << 'ENDOFFILE__carousel_tmpl_curated_list'
# Template: Curated List

**Recommend resources, tools, or ideas in a curated format.** Your audience trusts your curation.

---

## When to Use
- Tool recommendations ("10 tools every [role] needs")
- Resource roundups ("Best books on [topic]")
- Tip compilations ("My top [N] tips for [X]")
- Any curated collection with your commentary

## Optimal Specs
- **Slides:** 7-12
- **Words per slide:** 15-25
- **Platforms:** Instagram (high save rate), LinkedIn

## Structure

### Slide 1 — Cover
- **Purpose:** Promise a useful, curated collection
- **Content:** "[N] [things] every [audience] needs" / "My favorite [tools/resources] for [outcome]"
- **Design:** Clean, organized feel — visually communicate "collection" or "list"

### Slide 2 — Criteria or Context
- **Purpose:** Why you curated this list and what made the cut
- **Content:** "I've tested [X] of these. Here are the ones that actually work." / "These are what I use daily."
- **Design:** Personal, credible

### Slides 3-10 — List Items
- **Purpose:** One item per slide
- **Content:**
  - Item name (headline)
  - What it is (1 line)
  - Why it's on the list / your personal take (1-2 lines)
  - Optional: price, link hint, key feature
- **Design:** Consistent layout — item name prominent, details supporting. Number each item for progress.
- **Tip:** Put the most interesting items first (positions 1-3) and last (final item before CTA) — these get the most attention

### Slide 11 — Bonus or Summary
- **Purpose:** A bonus item, a summary, or the one you'd pick if you could only choose one
- **Content:** "If I had to pick one: [item]" or "Bonus: [extra item]"
- **Design:** Slightly different from list slides to signal completion

### Slide 12 — CTA
- **Purpose:** Save this list
- **Content:** "Save this for later" / "Bookmark this before you forget"
- **Design:** Brand accent, save-oriented

## Common Mistakes
- Items without your take — curation means adding perspective, not just listing
- Too many items per slide — one per slide, always
- No hierarchy — not all items are equal, show which ones you love most
- Generic items everyone knows — include at least 2-3 unexpected picks
- No personal experience — "I use this daily" is more powerful than "this is popular"

## Design Rhythm
Cover (organized) → Context (personal) → Items (consistent, numbered) → Bonus (shift) → CTA (save)
ENDOFFILE__carousel_tmpl_curated_list

cat > "$KIT_DIR/.claude/skills/carousel/templates/data-driven.md" << 'ENDOFFILE__carousel_tmpl_data_driven'
# Template: Data-Driven

**Let numbers tell the story.** Stats, data points, research findings — presented visually so they land with impact.

---

## When to Use
- Sharing research findings or statistics
- Making a data-backed argument
- Industry reports or trend analysis
- Any time numbers support your point better than words

## Optimal Specs
- **Slides:** 6-9
- **Words per slide:** 10-20 (let the numbers breathe)
- **Platforms:** LinkedIn (especially strong), Instagram

## Structure

### Slide 1 — Cover
- **Purpose:** Lead with the most surprising stat
- **Content:** One shocking number + minimal context. "73% of [X] fail because of [Y]"
- **Design:** The number should be HUGE. Minimal other text. High contrast.

### Slide 2 — Context
- **Purpose:** Why this data matters, where it comes from
- **Content:** Source attribution + framing — "We analyzed [X] and found..."
- **Design:** Clean, credible — slightly more text, authoritative feel

### Slides 3-7 — Data Points
- **Purpose:** One stat or finding per slide
- **Content:** The number (large), the finding (1 line), brief implication (1 line)
- **Design:** Numbers should be the largest visual element. Use brand colors to highlight key figures. Consider simple visual representations (bars, percentages, icons) even in text form.
- **Tip:** Order from most surprising to most actionable

### Slide 8 — So What?
- **Purpose:** The conclusion. What all this data means for the reader.
- **Content:** The actionable insight that emerges from all the data
- **Design:** Shift from data-heavy to statement-driven

### Slide 9 — CTA
- **Purpose:** Save for reference, share with team
- **Content:** "Save this for your next strategy session" / "Share this with your team"
- **Design:** Brand accent, clean

## Common Mistakes
- Too many numbers per slide — one stat per slide
- Stats without context — every number needs "so what?"
- No source attribution — data without sources feels untrustworthy
- Numbers that are too small to read — the stat should be the biggest element on the slide
- Data that doesn't build to a conclusion — random stats aren't a carousel

## Design Rhythm
Cover (impact) → Context (credibility) → Data points (rhythm) → Conclusion (synthesis) → CTA (action)
ENDOFFILE__carousel_tmpl_data_driven

cat > "$KIT_DIR/.claude/skills/carousel/templates/educational.md" << 'ENDOFFILE__carousel_tmpl_educational'
# Template: Educational

**The go-to format for teaching something.** Break a concept into digestible pieces, one slide at a time.

---

## When to Use
- Teaching a concept, framework, or skill
- Breaking down something complex into simple parts
- Sharing expertise in an accessible way
- "5 things you need to know about X"

## Optimal Specs
- **Slides:** 7-10
- **Words per slide:** 15-30
- **Platforms:** Instagram, LinkedIn (works great on both)

## Structure

### Slide 1 — Cover (THE HOOK)
- **Purpose:** Stop the scroll. Promise value.
- **Content:** Bold headline — number-driven or curiosity-driven
- **Design:** High contrast, minimal text, brand colors prominent
- **Examples:** "7 things I wish I knew about X" / "The X framework nobody talks about" / "Stop doing X (do this instead)"

### Slide 2 — Context (THE WHY)
- **Purpose:** Why this matters. Why now.
- **Content:** 1-2 sentences setting up the problem or opportunity
- **Design:** Clean, text-focused, slightly lower energy than cover

### Slides 3-8 — Teaching Points (THE VALUE)
- **Purpose:** One lesson per slide
- **Content:** Headline (the point) + 1-2 lines of explanation
- **Design:** Consistent layout across teaching slides, but vary alignment or visual elements to avoid monotony
- **Tip:** Number the points for progress cues ("3 of 7")

### Slide 9 — Summary (THE WRAP)
- **Purpose:** Recap the key takeaways
- **Content:** Quick list or single powerful restatement
- **Design:** Can mirror cover slide design for bookend effect

### Slide 10 — CTA
- **Purpose:** One clear action
- **Content:** "Save this for later" / "Follow for more [topic]" / "Share with someone who needs this"
- **Design:** Brand accent color, clear and bold

## Common Mistakes
- Too much text per slide — one idea only
- All slides look identical — vary layouts
- No context slide — jumping straight into points feels abrupt
- Weak cover — if the number isn't interesting, the angle isn't sharp enough
- Teaching without a point of view — opinions make educational content memorable

## Design Rhythm
Cover (bold) → Context (calm) → Point 1-6 (consistent with micro-variations) → Summary (bold) → CTA (accent)
ENDOFFILE__carousel_tmpl_educational

cat > "$KIT_DIR/.claude/skills/carousel/templates/hot-take.md" << 'ENDOFFILE__carousel_tmpl_hot_take'
# Template: Hot Take

**Lead with a bold, potentially controversial opinion.** Then back it up across slides.

---

## When to Use
- Challenging conventional wisdom in your field
- Taking a strong stance on a debated topic
- "Unpopular opinion: [X]"
- Content designed to spark conversation

## Optimal Specs
- **Slides:** 6-8
- **Words per slide:** 15-25
- **Platforms:** LinkedIn (engagement magnet), Instagram

## Structure

### Slide 1 — Cover (THE TAKE)
- **Purpose:** Drop the opinion. No warming up.
- **Content:** The bold statement — direct, confident, slightly provocative
- **Design:** Stark, bold. Consider dark background with bright text. Minimal design — the words ARE the visual.

### Slide 2 — The Setup
- **Purpose:** Acknowledge the conventional view you're challenging
- **Content:** "Most people think [conventional wisdom]. Here's why that's wrong."
- **Design:** Slightly calmer — transitional

### Slides 3-5 — The Argument
- **Purpose:** One supporting point per slide. Build your case.
- **Content:** Each slide presents one reason, example, or piece of evidence
- **Design:** Consistent layout, building conviction. Can use numbered points or independent arguments.

### Slide 6 — The Flip
- **Purpose:** Restate the take with full context — now it should feel undeniable
- **Content:** The refined version of the original take, now with context
- **Design:** Visual callback to cover slide — bookend effect

### Slide 7 — The Nuance (Optional)
- **Purpose:** Acknowledge where the take has limits or exceptions
- **Content:** "The caveat: [exception]" — shows intellectual honesty
- **Design:** Softer than the argument slides

### Slide 8 — CTA
- **Purpose:** Spark conversation
- **Content:** "Agree or disagree? Tell me in the comments" / "Tag someone who needs to hear this"
- **Design:** Brand accent, discussion-oriented

## Common Mistakes
- A "hot take" that everyone actually agrees with — make it genuinely challenging
- No evidence — an opinion without support is just noise
- Being controversial for controversy's sake — the take should be USEFUL
- Missing nuance — all-or-nothing takes feel immature
- Angry or condescending tone — confident ≠ aggressive

## Design Rhythm
Cover (bold, stark) → Setup (transition) → Argument (building) → Flip (bold, callback) → Nuance (soft) → CTA (discussion)
ENDOFFILE__carousel_tmpl_hot_take

cat > "$KIT_DIR/.claude/skills/carousel/templates/myth-bust.md" << 'ENDOFFILE__carousel_tmpl_myth_bust'
# Template: Myth-Bust

**Challenge common beliefs.** Take something everyone assumes is true and dismantle it — then reveal what's actually true.

---

## When to Use
- Debunking misconceptions in your industry
- "Stop believing these myths about X"
- Correcting bad advice that circulates online
- Contrarian content that educates

## Optimal Specs
- **Slides:** 7-10
- **Words per slide:** 15-25
- **Platforms:** Instagram, LinkedIn (high engagement — people love proving myths wrong)

## Structure

### Slide 1 — Cover
- **Purpose:** Call out the myths. Create urgency.
- **Content:** "[N] myths about [X] that are costing you" / "Everything you've been told about [X] is wrong" / "Stop believing these about [X]"
- **Design:** Bold, slightly provocative — red accent or warning visual cue

### Slide 2 — Setup
- **Purpose:** Why these myths matter and why they persist
- **Content:** "These myths keep showing up because..." — brief context
- **Design:** Clean, authoritative

### Slides 3-8 — Myth/Truth Pairs
- **Purpose:** One myth per slide, immediately followed by the truth
- **Content Format:**
  - **Myth:** "[Common belief]" — with a visual "X" or "MYTH" label
  - **Truth:** "[What's actually true]" — with a visual "✓" or "TRUTH" label
- **Design:** Strong visual contrast between myth (crossed out, muted, red) and truth (clear, bright, green/brand color)
- **Tip:** Can do myth + truth on one slide, or split across two slides for more impact

### Slide 9 — The Real Takeaway
- **Purpose:** The overarching truth that ties all myth-busts together
- **Content:** One powerful statement that reframes the whole topic
- **Design:** Clean, bold — this is the "aha" moment

### Slide 10 — CTA
- **Purpose:** Share to help others avoid these myths
- **Content:** "Share this with someone who still believes #3" / "Which myth surprised you most?"
- **Design:** Brand accent, engagement-focused

## Common Mistakes
- Myths that aren't actually commonly believed — pick real ones
- Truth that's just as vague as the myth — be specific
- Missing the "why it matters" — connect each myth to a real consequence
- All text, no visual contrast — the myth/truth distinction should be visually obvious

## Design Rhythm
Cover (provocative) → Setup (authoritative) → Myth/Truth pairs (contrasting) → Takeaway (clarity) → CTA (engagement)
ENDOFFILE__carousel_tmpl_myth_bust

cat > "$KIT_DIR/.claude/skills/carousel/templates/quote-series.md" << 'ENDOFFILE__carousel_tmpl_quote_series'
# Template: Quote Series

**Curate powerful quotes with your commentary.** Combine the authority of known voices with your unique perspective.

---

## When to Use
- Curating wisdom from industry leaders
- Themed quote collections with analysis
- Book summaries or key takeaways
- When you want to borrow authority while adding your voice

## Optimal Specs
- **Slides:** 7-10
- **Words per slide:** 15-30
- **Platforms:** Instagram (high save rate), LinkedIn

## Structure

### Slide 1 — Cover
- **Purpose:** Set up the theme. Why these quotes matter.
- **Content:** "[N] quotes that changed how I think about [X]" / "The best advice I've ever gotten about [X]"
- **Design:** Clean, elevated — set a thoughtful, curated tone

### Slide 2 — Context (Optional)
- **Purpose:** Why you curated these, what connects them
- **Content:** Brief framing — 1-2 sentences
- **Design:** Simple, sets up the pattern

### Slides 3-8 — Quote + Commentary
- **Purpose:** One quote per slide with your take
- **Content:**
  - The quote (in quotation marks, attributed)
  - Your commentary (1-2 lines — what this means, why it matters, how to apply it)
- **Design:** Quote in larger/different font. Attribution below. Commentary in smaller text or on the next line. Visual separator between quote and commentary.
- **Tip:** Your commentary is what makes this YOUR content, not just a quote collection

### Slide 9 — Your Addition
- **Purpose:** Add your own principle or insight alongside the quoted voices
- **Content:** Your own quote or takeaway that ties everything together
- **Design:** Same format as quote slides but marked as yours

### Slide 10 — CTA
- **Purpose:** Save for reference
- **Content:** "Save this for when you need a reminder" / "Which one hit hardest?"
- **Design:** Brand accent, engagement-focused

## Common Mistakes
- Quotes without commentary — that's a Pinterest board, not a carousel
- Generic quotes everyone has seen — find specific, surprising ones
- No unifying theme — random quotes feel disconnected
- All the same source — diversity of voices is more interesting
- Missing attribution — always credit the source

## Design Rhythm
Cover (curated) → Context (simple) → Quote slides (consistent, elegant) → Your addition (personal) → CTA (save-focused)
ENDOFFILE__carousel_tmpl_quote_series

cat > "$KIT_DIR/.claude/skills/carousel/templates/step-by-step.md" << 'ENDOFFILE__carousel_tmpl_step_by_step'
# Template: Step-by-Step

**A how-to guide in carousel form.** Walk the reader through a process they can follow immediately.

---

## When to Use
- Teaching a specific process or workflow
- "How to X in Y steps"
- Tutorials, recipes, setup guides
- Any sequential process

## Optimal Specs
- **Slides:** 6-10
- **Words per slide:** 15-25
- **Platforms:** Instagram (especially strong), LinkedIn

## Structure

### Slide 1 — Cover
- **Purpose:** Promise a clear outcome
- **Content:** "How to [outcome] in [N] steps" or "The exact process I use to [outcome]"
- **Design:** Bold, outcome-focused, can include a before/after hint

### Slide 2 — Overview or Prerequisites
- **Purpose:** What they need before starting, or what this process achieves
- **Content:** Brief context — who this is for, what they'll get
- **Design:** Clean, informational

### Slides 3-8 — Steps
- **Purpose:** One step per slide, in order
- **Content:** Step number + action headline + brief explanation (1-2 lines)
- **Design:** Numbered clearly (Step 1, Step 2...), consistent layout, progress feels built-in
- **Tip:** Make each step actionable — start with a verb

### Slide 9 — Result or Bonus Tip
- **Purpose:** Show the outcome of following all steps, or add one bonus insight
- **Content:** "When you do all of this, here's what happens" or "Bonus: [pro tip]"
- **Design:** Slightly different from step slides to signal completion

### Slide 10 — CTA
- **Purpose:** Save, share, or follow
- **Content:** "Save this for next time you need to [outcome]"
- **Design:** Brand accent color, clear action

## Common Mistakes
- Steps that aren't actionable — every step should start with a verb
- Too many sub-steps crammed into one slide
- No clear outcome promised on the cover
- Missing context on WHY each step matters

## Design Rhythm
Cover (bold) → Overview (clean) → Steps 1-6 (numbered, consistent) → Result (shift) → CTA (accent)
ENDOFFILE__carousel_tmpl_step_by_step

cat > "$KIT_DIR/.claude/skills/carousel/templates/storytelling.md" << 'ENDOFFILE__carousel_tmpl_storytelling'
# Template: Storytelling

**A narrative arc told across slides.** Pulls the reader in with a story and delivers a lesson or insight at the end.

---

## When to Use
- Personal experiences with a lesson
- Client/customer transformation stories
- Behind-the-scenes narratives
- Any time emotion drives the message more than logic

## Optimal Specs
- **Slides:** 8-12
- **Words per slide:** 20-40
- **Platforms:** Instagram, LinkedIn (both love stories)

## Structure

### Slide 1 — Cover (THE HOOK)
- **Purpose:** Drop the reader into the middle of the story
- **Content:** A moment, a line of dialogue, a dramatic statement — NOT "let me tell you a story"
- **Design:** Moody, atmospheric — consider dark background, minimal text, cinematic feel

### Slide 2-3 — Setup
- **Purpose:** Set the scene. Who, where, what was happening
- **Content:** Short, vivid sentences. Paint the picture in minimal words.
- **Design:** Building tension — clean layouts, focused text

### Slides 4-6 — Rising Action
- **Purpose:** The challenge, the mistake, the turning point
- **Content:** One beat per slide. Build tension. Don't resolve too early.
- **Design:** Can intensify visually — bolder colors, larger text for key moments

### Slide 7-8 — Climax / Turning Point
- **Purpose:** The moment everything changed
- **Content:** The insight, the decision, the realization
- **Design:** Visual peak — this slide should feel different from the rest (accent color, different layout)

### Slides 9-10 — Resolution + Lesson
- **Purpose:** What changed because of this. What the reader should take away.
- **Content:** The lesson stated clearly — not vague, not preachy
- **Design:** Settling down visually — return to calmer design

### Slide 11 — Reflection or Question
- **Purpose:** Invite the reader to connect to their own experience
- **Content:** "Have you ever...?" or a thought-provoking question
- **Design:** Simple, text-focused

### Slide 12 — CTA
- **Purpose:** Follow, share, comment
- **Content:** "Share this with someone who needs to hear it" or "Drop a [emoji] if you've been there"
- **Design:** Brand accent, warm

## Common Mistakes
- Starting with "Let me tell you a story" — drop into the action
- Too much setup, not enough payoff
- The lesson feels forced or disconnected from the story
- Every slide reads like a paragraph — keep it punchy even in narrative mode
- No emotional peak — the story flatlines

## Design Rhythm
Cover (dramatic) → Setup (calm, building) → Rising action (intensifying) → Climax (peak) → Resolution (settling) → CTA (warm)
ENDOFFILE__carousel_tmpl_storytelling

echo "  - all carousel templates done"
cat > "$KIT_DIR/.claude/skills/hook-workshop/SKILL.md" << 'ENDOFFILE__hook_workshop_skill'
# Skill: hook-workshop

Dedicated hook generation, improvement, analysis, and extraction. The hook is the single most important element of a LinkedIn post — this skill gives it the attention it deserves.

## Trigger

Activate when the user says `/hook-workshop` or asks for help with hooks specifically:
- "Give me hooks for X"
- "Help me with hooks"
- "Why does this hook work?"
- "Make this hook better"
- "What hooks can I pull from this story?"

## Four Modes

### Mode 1: Generate

**Trigger:** "Give me 10 hooks about [topic]" or similar.

Generate **10 hooks** across these types, labeling each:

1. **Bold Statement** — a strong claim that challenges or surprises
2. **Question** — makes the reader stop and think
3. **Story Opener** — drops into a specific moment or experience
4. **Number-Driven** — specificity that signals substance
5. **Pattern Interrupt** — unexpected framing, single-word opener, or confession
6. **Vulnerability/Confession** — admission that builds trust instantly
7. **Comparison** — "Everyone talks about X. Nobody talks about Y."
8. **List Preview** — "3 things I stopped doing that doubled my [result]:"
9. **Coaching Truth** — ultra-short reframe of common assumption (Dr. Julie Gurner style)
10. **Relatable Enemy** — names something the audience dislikes, then flips to a hero (Justin Welsh style)

For each hook:
- Write the hook (1 line ideal, **under 140 characters** for the mobile fold — under 45 characters is even better)
- **Show the character count** in brackets: [87 chars]
- Label the type
- Add a one-line note on why it works
- **Flag any hook over 140 characters** — it won't work before the mobile fold

Also generate a **rehook** (2-3 lines after the fold) for the top 3 hooks. The rehook slams the door shut and keeps the reader reading.

Present all 10 and ask: "Which ones jump out? I can refine any of these or go in a different direction."

### Mode 2: Improve

**Trigger:** "I have this hook: [hook]. Make it better."

Take the client's hook and produce **3 improved versions**, each with a different improvement angle:
1. **Sharper** — tighter language, more specific
2. **Bolder** — stronger claim, more provocative
3. **Reframed** — different angle on the same idea

For each version, explain what changed and why it's stronger.

### Mode 3: Analyze

**Trigger:** "Why does this hook work?" or "Break down this hook."

Analyze the psychology and mechanics of a hook:
- What type of hook is it (bold claim, question, story, etc.)?
- What open loop does it create?
- What emotion does it trigger?
- Why would someone click "see more"?
- What makes it specific vs. generic?
- How does it work before the fold (~140 chars)?
- What could make it even stronger?

### Mode 4: Extract

**Trigger:** "Here's something that happened to me: [experience]. What hooks could I pull?"

Take a personal experience, observation, or story and extract **5 hook angles**:
1. The bold takeaway hook
2. The "I was wrong" hook
3. The question hook
4. The specific-number hook
5. The pattern-interrupt hook

Each reframes the same experience differently. Present with brief notes on which would work best for different audiences.

## Swipe File Management

When a hook is marked as a winner by the client (they use it, they say they love it, or they ask to save it):

1. Add it to `content-strategy/hooks-swipe-file.md` under the appropriate type category
2. Note the date and topic it was created for
3. Confirm: "Added to your hooks swipe file for future reference."

## Rules

- **Quality over quantity.** 5 excellent hooks beat 10 mediocre ones. But when asked for 10, make all 10 strong.
- **Specificity wins.** "I made $47K in 3 months" beats "I made a lot of money quickly." Numbers, names, and details make hooks compelling.
- **The fold is the filter.** The first line must work in **140 characters** (mobile fold) or ideally **under 45 characters** (one line). Show character count for every hook. Hooks longer than 1 line perform 20% worse.
- **No negative words in hooks.** Hooks with negative words perform 30% worse (Jasmin Alic data).
- **No cringe hooks.** Nothing performative, humble-braggy, or engagement-baity. "Agree?" is banned. "Tag someone" is banned.
- **No AI-sounding hooks.** Avoid: "Here's the thing," "Let that sink in," "Read that again," "Game-changer," "Full stop." 82% of AI posts use 1 of 3 opening patterns — vary your approach.
- **Match the client's voice.** Read `identity/style-profile.md` Dimension 8 (Hook Patterns) before generating. The hooks should sound like the client, not like generic LinkedIn advice.
- **Open loops, not clickbait.** Every hook should honestly represent what the post delivers. Curiosity gaps are good. Misleading promises are bad.
- **The rehook matters as much as the hook.** The hook gets them to click "see more." The rehook (lines 2-3 after the fold) keeps them reading to the end.
ENDOFFILE__hook_workshop_skill

echo "  - hook-workshop SKILL.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/SKILL.md" << 'ENDOFFILE__linkedin_post_skill'
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
ENDOFFILE__linkedin_post_skill

echo "  - linkedin-post SKILL.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/before-after.md" << 'ENDOFFILE__li_tmpl_before_after'
# Template: Before-After

Transformation post showing contrast between past and present state. Works best with specific, measurable changes.

**Target length:** 1000-1500 characters

---

## Structure

### 1. Hook — Contrast Statement (1-2 lines)
- Juxtapose the before and after in one line
- "X years ago I was [painful state]. Today I [better state]."
- The gap between the two states creates tension

### 2. The "Before" (2-3 lines)
- Paint the before state vividly — specific details
- Make it relatable — readers should see themselves
- Be honest about the struggle, not dramatic about it

### 3. The Bridge / Turning Point (2-3 lines)
- What specifically changed? A decision, habit, framework, person
- This is the actionable core — the reader wants to know HOW
- Be concrete: "I started doing X every day" not "I changed my mindset"

### 4. The "After" (2-3 lines)
- Current state with specifics (numbers, outcomes, feelings)
- Keep it grounded — impressive but believable
- Acknowledge it's still a work in progress if true

### 5. The Principle (1-2 lines)
- Distill the transformation into a universal truth
- "The thing that changed everything was..."

### 6. Close (1 line)
- Question or invitation: "What's a transformation you're proud of?"

---

## Example Hooks
- "3 years ago I dreaded Mondays. Now I forget what day it is."
- "2022: 0 followers, 0 clients. 2025: 50K followers, waitlisted practice."
- "Before: working 70-hour weeks, barely breaking even. After: 30 hours, 3x the revenue."

## Common Mistakes
- Making the "before" too dramatic (reads as performance)
- Skipping the bridge (readers came for the HOW)
- Making the "after" sound too perfect (breaks trust)
- No actionable takeaway

## When to Use
- When you have a genuine transformation with specific numbers
- When you want to establish credibility through results
- When the Expertise or Personal Stories pillar needs a post
ENDOFFILE__li_tmpl_before_after

echo "  - before-after.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/carousel-script.md" << 'ENDOFFILE__li_tmpl_carousel_script'
# Template: Carousel Script

Write the slide-by-slide content for a LinkedIn carousel (document post). Carousels are one of the highest-reach formats on LinkedIn — they earn impressions because every swipe is counted as engagement. But they require more structure and design intent than a text post.

**Target length:** 6–9 slides, 30–60 words per slide (7 slides is optimal — 18% higher engagement than other lengths)
**Total word count:** ~250–500 words across all slides

---

## Structure

### Slide 1: Cover (The Hook Slide)
- Must earn the first swipe
- Large, readable headline — 5-10 words maximum
- Optionally a brief subtitle (1 line) that adds context
- Should communicate the value proposition immediately: what will the reader get by swiping?
- Examples: "7 mistakes I made in year 1," "The framework that changed how I hire," "What your team actually needs from you"
- No body text — this is a visual slide

### Slide 2: Context / Setup (optional but often valuable)
- 1-3 sentences that establish why this matters
- Frame the problem or the stakes before diving into the content
- Skip if Slide 1's headline is self-explanatory

### Slides 3–[N-1]: Core Content Slides
- Each slide = one point, idea, or step
- Slide headline: 5-8 words (the key point in plain language)
- Body: 1-3 sentences of explanation, example, or supporting detail
- One idea per slide — no cramming
- Write them so they make sense in order AND so any individual slide is shareable or screenshot-able
- If it's a numbered list: use consistent numbering across all core slides (1 of 7, 2 of 7, etc.)
- If it's a framework: each slide = one component of the framework, with brief explanation
- **Swipe rate matters:** If click-through drops below 35% between slides, LinkedIn penalizes visibility. Each slide must earn the next swipe.

### Second-to-last slide: The Synthesis / So What
- Pull the whole carousel together in 2-3 sentences
- The key insight or the action the reader should take
- Should feel like the earned payoff after the content slides

### Last Slide: CTA / Follow
- Ask the reader to save, share, or comment
- Keep it to 1-2 sentences — no begging, no lengthy asks
- Optional: "Follow [name] for more on [topic]" — keep it brief and non-sycophantic
- Match to client's Dimension 10 engagement style

---

## Tone Notes
- Carousels reward clarity over cleverness — each slide has a few seconds to land
- Write each slide as if someone might screenshot it and share it separately
- The slide headlines are the backbone — they should tell the full story if read alone in sequence
- Body copy expands on headlines; it doesn't repeat them or contradict them

---

## Formatting Guidance
- Output format for the script: each slide on its own clearly labeled section
- Use this format in the draft:
  ```
  --- SLIDE 1 ---
  HEADLINE: [text]
  BODY: [text if any]
  
  --- SLIDE 2 ---
  HEADLINE: [text]
  BODY: [text]
  ```
- Write for the reader's eye, not for a wall of text — each slide is a visual unit
- Client or designer handles visuals; your job is the words

---

## Example Cover Slide Headlines
- "5 things I wish I knew before building a team"
- "How to write a job post that attracts the right people"
- "The 3-part framework I use for every difficult conversation"
- "What most people get wrong about [topic]"
- "My hiring process, slide by slide"

---

## Common Mistakes
- **Too many slides:** 2026 data shows 6-9 slides is optimal. The old 12-13 slide carousels now underperform. 7 slides is the peak performer.
- **Too many words per slide:** More than 60 words per slide and people stop reading. Cut.
- **Weak cover slide:** If Slide 1 doesn't earn the swipe, nothing else matters.
- **Slides that only work in sequence:** Each slide should have some standalone value. If it's completely meaningless without context, reconsider.
- **No synthesis:** The second-to-last slide is where carousels build to — don't let the content just... end.
- **Lazy CTC:** "Like and share!" is the carousel equivalent of "Agree?" — match the client's actual engagement style.
- **Ignoring swipe rate:** If readers stop swiping partway through, LinkedIn penalizes the carousel's visibility. Every slide must earn the next swipe.

---

## When to Use vs. Others
- Use this when the content is visual, sequential, or framework-based and would benefit from the swipeable format
- Use `listicle.md` when you want to deliver similar content as a text post
- Use `framework.md` when the mental model is better expressed in prose than in slides
- Carousels require more production work (design) — confirm the client has capacity to execute the visual before writing the script
ENDOFFILE__li_tmpl_carousel_script

echo "  - carousel-script.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/coaching-truth.md" << 'ENDOFFILE__li_tmpl_coaching_truth'
# Template: Coaching Truth

An ultra-short, authority-first post that delivers one powerful reframe in 2-5 sentences. Inspired by Dr. Julie Gurner's LinkedIn style — zero formatting tricks, zero filler, just a distilled insight from deep expertise. The radical opposite of long-form narrative posts.

**Target length:** 300-700 characters

---

## Structure

### 1. The Truth — Bold Statement (1-2 sentences)
- A direct, declarative reframe of something the reader assumes
- No hedging, no "in my experience" — state it with conviction
- Should feel like something a coach would say to a client in a private session
- The insight must come from real expertise, not generic wisdom

### 2. The Reframe (1-2 sentences)
- Briefly expand on WHY this is true or what it means in practice
- One specific detail or example — just enough to anchor the claim
- Do not over-explain. The brevity is the point. Trust the reader.

### 3. The Close (0-1 sentence)
- Optional. Sometimes the truth + reframe is enough.
- If included: a short prescriptive statement ("Do this instead") or a question that makes the reader sit with the insight
- No "Agree?" or "Thoughts?" — either let it land or ask something specific

---

## Formatting Guidance
- **No line-break formatting tricks.** No staircase format, no single-word lines, no emoji bullets.
- Write it as a short paragraph or 2-3 short paragraphs. Let the words do the work.
- This format intentionally breaks LinkedIn formatting conventions — that's what makes it stand out.
- The entire post should fit above the fold on mobile (under 140 characters for the first line, under 300 characters total if possible).

## Example Posts

**Example 1:**
"The people who say 'I work best under pressure' are usually the ones creating the pressure for everyone else."

**Example 2:**
"Obsession gets a bad reputation. The most successful people I coach aren't disciplined — they're obsessed. Discipline is forcing yourself to do things. Obsession is not being able to stop."

**Example 3:**
"If you have to 'hold people accountable,' you've already lost. Accountability isn't something you do TO someone. It's a culture you build so people do it to themselves."

## Why This Format Works
- **Extremely low AI detection risk.** This format requires genuine domain expertise that AI cannot fake. The brevity leaves no room for generic filler.
- **High save rate.** Short, quotable truths are the most saved content type on LinkedIn.
- **High share rate.** These posts are screenshot-friendly and reshare-friendly.
- **Pattern interrupt.** In a feed full of long posts with heavy formatting, a 3-sentence post with zero tricks stands out.
- **Authority signal.** Saying less, with more conviction, signals expertise.

## Common Mistakes
- Padding it with explanation. If you need 5 paragraphs to explain it, use a Framework post instead.
- Generic truths. "Hard work beats talent" is not a coaching truth. It's a poster.
- Lacking the credentials to back it up. This format only works when the reader believes you have the experience to make this claim.
- Adding formatting. The whole point is zero formatting. No bold, no lists, no emojis.

## When to Use
- When you have a single insight that's powerful enough to stand alone
- When the Culture & Values or Expertise pillar needs a shorter post
- When the last few posts have been long and narrative — this provides energy contrast
- When you want high save and share rates
- Use sparingly — 1-2 per month maximum. Overuse dilutes the authority signal.
- NOT when the insight requires context or a story to land — use Story-Lesson instead
ENDOFFILE__li_tmpl_coaching_truth

echo "  - coaching-truth.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/contrarian-take.md" << 'ENDOFFILE__li_tmpl_contrarian'
# Template: Contrarian Take

A bold, opinion-first post that challenges conventional wisdom. Drives high comment engagement because people want to agree or argue.

**Target length:** 1000-1500 characters

---

## Structure

### 1. Hook — Bold Contrarian Statement (1 line)
- A single strong claim that goes against common belief
- Must be specific and defensible, not just provocative for its own sake
- Works best when it names the thing being challenged

### 2. The Conventional Wisdom (2-3 lines)
- Acknowledge what most people believe and why
- Show you understand the other side — this builds credibility
- "Most people think..." or "The advice you've always heard is..."

### 3. Why It's Wrong (3-5 lines)
- Your evidence, experience, or reasoning
- Be specific — use numbers, timelines, examples
- This is where your unique perspective shines
- Each point gets its own line

### 4. The Reframe (2-3 lines)
- What you believe instead
- The alternative approach or mindset
- Should feel like a relief or an "aha" for the reader

### 5. Challenge / Close (1-2 lines)
- Invite the reader to reconsider
- Or ask: "What's a piece of advice you've stopped following?"
- Or restate your claim with confidence

---

## Formatting Guidance
- Short, punchy lines. This format thrives on rhythm.
- Whitespace between every thought
- Bold or caps sparingly for emphasis on the key claim
- Keep it tight — contrarian posts lose power when they ramble

## Example Hooks
- "Hustle culture is a scam."
- "Your morning routine is not why you're successful."
- "Stop networking. Start being useful."
- "Nobody cares about your company's mission statement."

## Common Mistakes
- Being contrarian just for clicks without a real argument behind it
- Attacking people instead of ideas
- Making it too long — contrarian posts should be sharp and fast
- Backing down in the conclusion ("but that's just my opinion!")

## When to Use
- When you genuinely disagree with common advice in your field
- When you want to drive comments and debate
- When the Industry Commentary pillar needs attention
- NOT when the take is lukewarm or obvious — go bold or use a different format
ENDOFFILE__li_tmpl_contrarian

echo "  - contrarian-take.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/framework.md" << 'ENDOFFILE__li_tmpl_framework'
# Template: Framework

Share a mental model, system, or structured way of thinking about a problem. The framework format works because it gives people a new tool — a reusable lens they can apply after reading. Done well, it generates saves, shares, and "I'm going to use this" comments.

**Target length:** 1500–2200 characters
**Character range:** 1500–2200

---

## Structure

### 1. Hook (1 line)
- Name the problem the framework solves, or name the framework itself if it's catchy
- The hook should communicate: "there is a better way to think about this"
- Best hooks make the reader feel the pain of not having the framework
- Examples that pair well: bold statement, consequence opener, contrarian reframe, number-driven (e.g., "3 questions I ask")

### 2. The Problem Setup (2-4 lines)
- Define the problem clearly — what breaks down for most people when they don't have this framework?
- Give a specific, recognizable scenario or context
- Make the reader feel "yes, that is exactly what I struggle with" before you offer the solution
- Don't skip this — frameworks without problem context feel like solutions to no problem

### 3. The Framework (core section, 4-10 lines depending on complexity)
- Present the model clearly and structured
- Name it if it has a name; if not, give it a simple label so it's memorable
- Walk through the components:
  - If it's a matrix or quadrant: explain each quadrant
  - If it's a process/steps: walk through each step
  - If it's a set of questions: present each question with context
  - If it's a mental model: explain the model, then show it applied
- Use numbered or labeled components for scannability
- Each component should be 1-3 lines: the label + a brief explanation + optionally a concrete example

### 4. The Framework Applied (2-4 lines)
- Show it in action — give a real or realistic example of using the framework
- This bridges from "interesting concept" to "I can actually use this"
- Be specific: a real situation, a real decision, a real outcome

### 5. Why This Works / The Underlying Principle (1-3 lines)
- Optional but powerful — explain the deeper logic
- Why does this framework work better than the default approach?
- What does it help you see that you couldn't see without it?

### 6. Engagement Driver (1-2 lines)
- Invite the reader to share how they'd apply it or ask for their version
- "Save this for the next time you're in [situation]" is a legitimate CTA here — frameworks earn saves
- Match to client's Dimension 10 style

---

## Tone Notes
- Confident and practical — you're sharing a tool that works, not a theory
- Avoid academic framing: "research suggests" / "it has been observed that"
- The best frameworks feel like something the author built from their own experience, not something they read in a book
- If you did take it from a book or thinker, attribute it — frameworks borrowed without attribution are a trust problem

---

## Formatting Guidance
- Numbered or labeled components help scannability — this is one format where structure aids the content
- Bold component labels if the style profile allows (e.g., "**1. Define the constraint**")
- Line breaks between components for breathing room
- This format benefits from slightly longer post length — complexity requires space
- Emoji: follow client's Dimension 9; functional emoji (e.g., as bullets or section markers) can work here

---

## Example Hooks That Pair Well
- "Most people solve the wrong problem. Here's how to tell which one you're facing."
- "I use 3 questions before making any hiring decision. They've saved me from 4 bad hires."
- "The framework I use for every difficult client conversation."
- "There are 4 types of feedback. Most people only give one."
- "If a decision keeps you up at night, run it through this."

---

## Common Mistakes
- **Framework without a problem:** A model with no context for when or why to use it is just a structure for its own sake.
- **Too many components:** A 9-part framework is not memorable. 3-5 parts work best; 6-7 if the topic genuinely requires it.
- **No example application:** Showing the framework in action is what separates theoretical and useful.
- **Vague component labels:** "Step 1: Clarity" with no explanation of what that means in practice. Define every component.
- **Reinventing something famous:** If you're teaching the Eisenhower matrix and calling it "my priority system," credit the source.

---

## When to Use vs. Others
- Use this when you have a structured way of thinking about something that the reader can actually use
- Use `listicle.md` when the ideas don't form a system — just a collection of observations
- Use `contrarian-take.md` when you're arguing against a view rather than offering a replacement model
- Use `carousel-script.md` to present the same framework visually — carousels are often the better format for multi-component frameworks
ENDOFFILE__li_tmpl_framework

echo "  - framework.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/how-i-process.md" << 'ENDOFFILE__li_tmpl_how_i_process'
# Template: How I [Process/System]

An autobiographical breakdown of a specific process, system, or routine you use. Different from Framework (which presents a reusable mental model) because this is personal — "here is exactly how I do this thing, step by step." Justin Welsh's most viral format.

**Target length:** 1300-1900 characters

---

## Structure

### 1. Hook — The Result + Process Tease (1-2 lines)
- Lead with the outcome, then signal the process is coming
- "How I [built/grew/managed/created] [specific result] in [timeframe]."
- The hook should make the reader think: "I want to know how they did that."
- Specificity is everything — numbers, timeframes, concrete outcomes

### 2. Why This Matters / Context (2-3 lines)
- Brief context on why you developed this process
- What problem were you solving?
- What were you doing before that wasn't working?
- Keep it short — the reader came for the process, not the backstory

### 3. The Process — Step by Step (bulk of the post, 5-10 lines)
- Number each step clearly (1, 2, 3...)
- Each step: **what you do** + **why it works** (1-2 lines per step)
- Be specific enough that someone could actually replicate this
- 3-7 steps is ideal. More than 7 and it becomes a listicle.
- Use your actual tools, actual numbers, actual language — specificity defeats AI detection

### 4. The Result Restated (1-2 lines)
- Circle back to the outcome from the hook
- Add a detail the hook didn't include — make the payoff feel earned
- Optional: acknowledge what it cost (time, effort, trade-offs)

### 5. Call-to-Conversation (1-2 lines)
- Invite the reader to share their version: "What does your process look like?"
- Or ask about a specific step: "Which step would change the most for your situation?"

---

## Formatting Guidance
- Numbered steps are the backbone — they create visual structure and scannability
- Bold the action in each step, explain in plain text after
- One idea per line within the process section
- This format can run longer (up to 1900 chars) because the numbered structure maintains dwell time

## Example Hooks
- "How I write 5 LinkedIn posts a week in under 2 hours."
- "How I built a $2M pipeline with zero cold outreach."
- "How I run 1:1s that my team actually looks forward to."
- "How I review 50 resumes in 30 minutes without missing great candidates."
- "How I prepare for a board meeting in one afternoon."

## Common Mistakes
- Describing a process you don't actually use. Readers can tell.
- Steps that are too vague ("Step 2: Optimize") — every step must be actionable
- Too many steps. If it's more than 7, consider a carousel instead.
- No result. The process must connect to a specific, believable outcome.
- Making it sound too easy. Acknowledge the difficulty — it builds trust.

## When to Use
- When you have a repeatable process with a specific, measurable result
- When the Expertise & Craft pillar needs a post
- When you want high save rates — process posts are the most bookmarked format on LinkedIn
- NOT when the "process" is really just advice — use Listicle or Framework instead
ENDOFFILE__li_tmpl_how_i_process

echo "  - how-i-process.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/i-was-wrong.md" << 'ENDOFFILE__li_tmpl_i_was_wrong'
# Template: I Was Wrong

Vulnerability-first post admitting a past belief or mistake. Extremely high engagement because genuine humility is rare on LinkedIn. Use sparingly — once or twice a month maximum.

**Target length:** 1200-1800 characters

---

## Structure

### 1. Hook — The Admission (1-2 lines)
- "I was wrong about X" or "I gave terrible advice for 3 years"
- Name the specific thing, not a vague generality
- The admission itself is the hook

### 2. What I Used to Believe (2-3 lines)
- The old belief or behavior, stated clearly
- Why it made sense at the time — this shows self-awareness
- Be specific about the timeframe and context

### 3. What Changed (3-4 lines)
- The experience, conversation, data, or moment that shifted your thinking
- Tell the story of the change — don't just state it
- This is where specificity matters most

### 4. What I Believe Now (2-3 lines)
- The updated belief or approach
- How it differs from what you used to think
- What the practical impact has been

### 5. What It Means for You (1-2 lines)
- Turn the personal lesson into reader-relevant advice
- "If you're where I was 3 years ago..."
- End with a question or invitation to share

---

## Formatting Guidance
- Conversational, almost confessional tone
- Shorter paragraphs — vulnerability reads better in small doses
- No defensive language or qualifiers
- Let the honesty speak for itself

## Example Hooks
- "I gave terrible advice for 3 years. Here's what I got wrong."
- "I used to think work-life balance was for people who weren't ambitious enough."
- "My biggest business mistake cost me $200K."

## Common Mistakes
- Making the "mistake" actually a humble brag ("I was wrong to only charge $500/hr")
- Being vague about what changed and why
- Not offering a takeaway — this isn't just confession, it's growth
- Using this format too often (diminishing returns on vulnerability)

## When to Use
- When you have a genuine belief shift with a real story behind it
- When the Personal Stories pillar needs a post
- When you want to build trust and relatability
- NOT for minor opinions or obvious growth ("I used to be bad at email")
ENDOFFILE__li_tmpl_i_was_wrong

echo "  - i-was-wrong.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/listicle.md" << 'ENDOFFILE__li_tmpl_listicle'
# Template: Listicle

Numbered list of lessons, mistakes, rules, or observations. Easy to scan, high dwell time, versatile across all content pillars.

**Target length:** 1500-2500 characters

---

## Structure

### 1. Hook with Number (1-2 lines)
- Lead with the count and the framing: "7 mistakes I made...", "10 lessons from 10 years of..."
- The number should feel earned — "I've [done X] and here's what I know"
- Odd numbers and specific experience-counts perform best

### 2. Brief Context (1-2 lines)
- One sentence on why you're qualified to share this list
- Or why the reader should care: "I wish I'd known these 5 years ago."

### 3. The List (bulk of the post)
- Each item: **number + bold headline + 1-2 line explanation**
- Items should be self-contained — each makes sense on its own
- Vary the rhythm: some items are one line, some are two
- Build to the strongest item at the end (or put it first)

### 4. Close (1-2 lines)
- "Which one resonates most?" or "What would you add to this list?"
- Or: "Save this. You'll need it."

---

## Formatting Guidance
- Numbers are structural — use them consistently (1. 2. 3. or numbered emoji)
- Each item gets its own visual block with whitespace above and below
- Bold the headline of each item
- Total items: 5-10 (fewer than 5 feels thin, more than 10 loses attention)

## Example Hooks
- "I've written 500+ LinkedIn posts. These 7 patterns get 80% of the engagement."
- "10 lessons from 10 years of building companies."
- "5 books that changed how I think about money (not the ones you'd expect)."

## Common Mistakes
- Items that are too similar to each other
- Explanations that are too long (the list should be scannable)
- Not building to a strong finish
- Generic advice that anyone could write ("Be consistent!" "Add value!")

## When to Use
- When you have multiple distinct insights on a theme
- When you want high dwell time (readers count through items)
- When content should be save-worthy (lists get saved)
- Works for Expertise, Personal Stories, or any pillar
ENDOFFILE__li_tmpl_listicle

echo "  - listicle.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/milestone-insight.md" << 'ENDOFFILE__li_tmpl_milestone'
# Template: Milestone + Insight

Share an achievement, anniversary, or milestone — and immediately pivot to the insight or lesson behind it. The milestone earns attention and proves credibility; the insight is why anyone should care beyond a congratulations.

**Target length:** 1000–1800 characters
**Character range:** 1000–1800

---

## Structure

### 1. Hook (1 line)
- State the milestone specifically — a number, a date, a result
- The hook is the milestone itself, but framed as an entry point to a lesson, not a celebration
- Best hooks imply there is something surprising or counterintuitive about how the milestone was reached
- Avoid: "I'm so humbled and grateful to announce..." — that's an announcement, not a hook
- Examples that pair well: number-driven hook, story opener, consequence opener

### 2. What the Milestone Represents (2-4 lines)
- Give the milestone meaning — what does this number, date, or achievement actually mean in context?
- Brief story or context: where did you start, what was the journey, what made this harder or more meaningful than it might appear?
- Be specific: "5 years" means more when you say "5 years after my first client paid me $400 for something I had no idea how to do"
- Let the milestone feel real, not polished

### 3. The Counterintuitive Insight (3-5 lines)
- This is the core of the post — what does this milestone teach that's not obvious?
- The insight should surprise the reader slightly, or at least reframe something they thought they understood
- What did reaching this milestone reveal about the nature of the work, the industry, or the challenge?
- Examples: "I expected to feel accomplished. What I felt was responsible." / "The milestone I thought would change everything didn't. This much smaller thing did."
- Avoid generic lessons: "Consistency is key," "Hard work pays off" — find the specific, non-obvious lesson

### 4. What This Might Mean for the Reader (1-3 lines)
- Bridge from your milestone to their world
- What can someone earlier in the journey do with this insight?
- Keep it humble — you reached a milestone, not enlightenment
- One concrete implication is better than three vague ones

### 5. Engagement Driver (1-2 lines)
- Invite the reader to share their milestone, their version of the insight, or what they're working toward
- Match to client's Dimension 10 style
- This format naturally generates supportive and authentic comments — set it up for that

---

## Tone Notes
- Pride without arrogance — you earned this; own it without performing gratitude or humility
- The insight must outweigh the celebration — if the post feels like a humble-brag, the insight isn't strong enough
- Vulnerable is better than polished: the struggles that led to the milestone make it real
- Avoid the word "journey" — it is the most overused word in milestone posts

---

## Formatting Guidance
- The milestone itself should be prominent in the first line — don't bury it
- Keep paragraphs short; this is an emotional format, not an information-dense one
- Line breaks between the milestone section and the insight section add breathing room
- Emoji: follow client's Dimension 9 — a single emoji can punctuate the milestone without overdoing it
- Bold: use sparingly if the style profile allows, perhaps on the key insight line

---

## Example Hooks That Pair Well
- "5 years ago today, I sent my first invoice. It was for $400."
- "100 posts. Here's what I learned about what actually matters."
- "$1M in revenue. The number I thought would feel different."
- "We hit 50 employees this month. It's nothing like I expected."
- "3 years of not taking a salary. It ended last month. Here's what I'd tell the version of me who started."

---

## Common Mistakes
- **Milestone without insight:** "We hit 1M followers! So grateful for all of you!" — not a post, an announcement. LinkedIn is not Instagram.
- **Humble-brag:** Using the milestone as the main event and dressing it up as a lesson. The insight must be genuinely useful.
- **Generic lessons:** If the takeaway is "believe in yourself" or "never give up," you haven't found the real insight yet.
- **Thanking everyone:** A list of acknowledgements takes up post real estate and reads as filler to everyone not mentioned.
- **Setting up the insight then not delivering it:** "This milestone taught me the most important thing in business. [Vague paragraph.]" — say the thing.

---

## When to Use vs. Others
- Use this when you have a real milestone AND a genuinely interesting insight attached to it
- If you have the story of how you got there but no strong insight: use `story-lesson.md`
- If the milestone revealed you were wrong about something: use `i-was-wrong.md`
- If the insight stands alone without needing the milestone as context: use `contrarian-take.md` or `framework.md`
ENDOFFILE__li_tmpl_milestone

echo "  - milestone-insight.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/observation-post.md" << 'ENDOFFILE__li_tmpl_observation'
# Template: Observation Post

A short, insight-only post that shares something you've noticed without prescribing a framework or lesson. High comment engagement because it invites the reader to add their own interpretation. Think of it as thinking out loud in public.

**Target length:** 600-1000 characters

---

## Structure

### 1. Hook — The Observation (1-2 lines)
- State what you've noticed, clearly and specifically
- "I've been noticing that..." or just state the observation directly
- The observation itself should be interesting enough to stop the scroll
- No lesson promised — just a genuine noticing

### 2. Evidence / Pattern (2-4 lines)
- What have you seen that supports this observation?
- Specific examples: people you've talked to, situations you've witnessed, data you've encountered
- Keep it concrete — "3 of the last 5 founders I talked to said the same thing" not "many people feel this way"

### 3. The Open Question (1-2 lines)
- Do NOT resolve the observation with a tidy lesson
- Instead, leave it open: "I'm not sure what to make of this yet" or "I wonder if..."
- Or turn it to the reader: "Are you seeing this too?"

---

## Formatting Guidance
- Keep it short. This format thrives on brevity — under 1000 characters.
- Conversational tone. This should feel like a text to a smart friend, not a LinkedIn post.
- Whitespace between the observation, the evidence, and the question.
- No bold headers, no lists, no structure signals. This is a thought, not a framework.

## Example Hooks
- "I've noticed something about the best managers I work with."
- "Something weird is happening in hiring right now."
- "The founders who are growing fastest right now all have one thing in common."
- "I keep having the same conversation with different people this month."

## Why This Format Works
- **Authenticity signal:** Not having a neat lesson is rare on LinkedIn and signals genuine thinking, not AI-generated content.
- **Comment magnet:** Open observations invite people to share their own experience — driving the substantive comments the algorithm rewards most (15x more than likes).
- **Low AI detection risk:** This format is nearly impossible for AI to generate convincingly because it requires specific, recent, personal observations.

## Common Mistakes
- Sneaking a lesson in at the end. If you have a lesson, use Story-Lesson or Framework instead.
- Being too vague about the observation. "Things are changing" is not an observation.
- Asking a generic question. "What do you think?" is weak. "Are you seeing this in your hiring too?" is specific.

## When to Use
- When you've noticed a pattern but haven't fully formed an opinion yet
- When you want high comment engagement without a strong claim
- When the Industry Commentary or Culture & Values pillar needs a lighter post
- NOT when you have a clear lesson or framework — use the appropriate template instead
ENDOFFILE__li_tmpl_observation

echo "  - observation-post.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/poll-context.md" << 'ENDOFFILE__li_tmpl_poll'
# Template: Poll + Context

A LinkedIn poll paired with commentary that makes the poll meaningful. The poll earns engagement because people love to share opinions with one click; the context gives the post substance and a reason to read. Used well, this format gets broad reach and generates rich discussion in the comments.

**Target length:** 400–800 characters (post text only, not counting poll options)
**Character range:** 400–800 (brevity is the point)

---

## Structure

### Post Text: Context + Setup (The Written Part)
**Hook (1 line)**
- Pose a tension, debate, or genuine question that the poll will resolve
- Or make a brief observation that sets up why the poll question matters
- The written post should make the reader think "I have a view on this" before they even see the poll options

**Body (2-4 lines)**
- Give just enough context for the poll to be meaningful
- Frame why this question matters right now
- Or share your own initial lean (without revealing your "answer" — that goes in the comments after votes come in)
- Keep it short — the poll itself is the star

**Bridge to poll (1 line)**
- Optional — a natural transition to the poll if the setup doesn't flow into it organically
- Or skip entirely and let the poll follow naturally

### The Poll (4 options maximum, usually 2-4)
- LinkedIn polls allow up to 4 options
- Options should be genuinely distinct — no filler options for the sake of having 4
- Avoid loaded options that obviously steer toward one answer
- Best polls have options where the "right" answer is genuinely debatable
- Label options concisely (max ~25 characters each)

### Post Continues After Poll (optional, 1-3 lines)
- Some post structures put commentary before the poll; some add a line or two after
- After-poll text can add: your own take, a provocative data point, or an invitation to elaborate in comments
- This is the place to add "I'll share my take in the comments once results are in" if that's the strategy

### Engagement Driver (1-2 lines after the poll or as the closing)
- "Drop your reasoning in the comments" works well — polls get votes, but you want discussion
- Match to client's Dimension 10 style

---

## Tone Notes
- The best poll posts feel like a genuine question the author wants answered, not manufactured engagement
- If the poll question is too easy (everyone will say the same thing), it won't generate discussion
- If the poll question is too abstract, people won't vote
- The sweet spot: a real business question with a non-obvious answer where reasonable people disagree

---

## Formatting Guidance
- Post text should be short — let the poll be the visual anchor
- No need for line-by-line breaks in this format; 2-3 line paragraphs work fine
- Emoji: optional — a single relevant emoji can add visual texture without cluttering
- The written content must work if someone reads it without voting on the poll

---

## Example Poll Questions That Work Well
- "What's your default when a client misses a deadline?"
  Options: Charge a late fee / Give them a pass / Depends on the client / I've never tracked it
- "Which kills a pitch faster?"
  Options: Bad product / Bad presenter / Wrong audience / Wrong timing
- "How do you handle employee performance issues?"
  Options: Address immediately / Give it a week / Coach first / Depends on severity
- "What's your honest approach to client feedback?"
  Options: Take everything / Filter it / Mostly ignore / Ask why first

---

## Common Mistakes
- **Polls with obvious "correct" answers:** If 95% of people vote the same way, you've learned nothing and generated low discussion value.
- **Post text that's too short:** "Hot take — poll time:" with no context is lazy. Give the poll meaning.
- **Forgetting to engage with results:** If you say "I'll share my take," actually do it. Following up in comments when results come in is a strong engagement move.
- **4 options when 2 are sufficient:** More options is not better. If the question only has 2 natural answers, use 2.
- **Asking what people think when you don't care:** If you're not going to reply to comments, don't invite discussion you won't engage with.

---

## Audience Size Note

Polls perform best for accounts with 10K+ followers. For smaller accounts, a question-close text post may generate more meaningful engagement. Poll reach has increased 206% YoY but engagement rates are lower than text or carousel formats.

## When to Use vs. Others
- Use this when you have a genuine question you want the audience's input on, or when you want to surface a debate in your field
- Use `contrarian-take.md` when you have a definite position (not a question) and want to argue for it
- Use `framework.md` when you want to provide the answer yourself rather than crowdsource it
- Polls work well for building community and learning what the audience thinks — they are not a substitute for genuine content
ENDOFFILE__li_tmpl_poll

echo "  - poll-context.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/story-lesson.md" << 'ENDOFFILE__li_tmpl_story_lesson'
# Template: Story-Lesson

A personal story that builds to a universal lesson. The most versatile LinkedIn format — works for any pillar, any audience, any day of the week.

**Target length:** 1200-1800 characters

---

## Structure

### 1. Hook (1-2 lines)
- Bold personal statement, surprising moment, or scene-drop
- Must work before the "see more" fold (~140 characters)
- Approaches: "I almost [dramatic verb]...", "Three years ago I was...", "My [person] told me something I'll never forget."

### 2. Scene Setting (2-4 lines)
- Set the specific situation — time, place, what was happening
- Use sensory details sparingly but effectively
- The reader should feel like they are there
- Keep paragraphs to 1-2 lines maximum

### 3. Tension / Conflict (3-5 lines)
- What went wrong, what was at stake, what the dilemma was
- This is where the reader invests emotionally
- Be specific — names, numbers, feelings
- Vulnerability is strength here

### 4. Turning Point (2-3 lines)
- The moment something shifted
- A realization, a conversation, a decision
- This should feel earned, not forced

### 5. Lesson / Takeaway (2-3 lines)
- The universal insight the story illustrates
- Frame it outward — "Here's what I learned" becomes advice for the reader
- Make it applicable beyond your specific situation

### 6. Engagement Close (1-2 lines)
- A question that invites the reader to share their own experience
- Or a challenge: "Try this today..."
- Or a reflection that lingers

---

## Formatting Guidance
- One idea per line. Heavy whitespace between thoughts.
- Short paragraphs (1-2 sentences max)
- No headers within the post — this is a continuous narrative
- Emoji: only if the client uses them; never for decoration

## Example Hooks
- "In 2019, I was $50K in debt with no plan."
- "My boss pulled me into a room and said three words that changed my career."
- "I almost didn't send that email. It was worth $500K."
- "The hardest conversation I've ever had lasted 4 minutes."

## Common Mistakes
- Starting with context instead of tension ("So last week I was at a conference and...")
- Making the lesson too generic ("Always believe in yourself!")
- Over-explaining the lesson instead of letting the story carry it
- Fabricating or exaggerating details — audiences can tell

## When to Use
- When you have a real personal experience with a clear lesson
- When a pillar needs a human, relatable angle
- When you want to build trust and connection with your audience
- NOT when the topic is purely tactical — use Framework or Listicle instead
ENDOFFILE__li_tmpl_story_lesson

echo "  - story-lesson.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-post/templates/thread-series.md" << 'ENDOFFILE__li_tmpl_thread_series'
# Template: Thread Series

A planned series of 3-5 connected posts that go deep on one topic over multiple days. Each post stands alone as a complete, valuable post — but also connects to the others as part of a larger arc. Used for topics too big for a single post and for building sustained engagement with an audience over a week.

**Important caveat:** LinkedIn's algorithm treats each post independently — there is no "series boost." Organic reach is typically 2-8% of followers, so most people will not see all posts. Before committing to a series, ask whether the topic would work better as a single longer post, a carousel (6-9 slides), or a framework post. Only use this format when the topic genuinely cannot be compressed.

**Target length:** 3–5 posts, 600–1000 characters each
**Total series:** 2200–4500 characters across all posts

---

## Structure

### Series Planning (do this before writing any individual post)

Before writing Post 1, define:
- **Series topic:** The big idea or theme the series covers
- **Number of posts:** 3-5 (3 for tight topics, 5 for complex or multi-faceted ones)
- **Arc:** What does the reader's understanding or perspective shift to by Post 5?
- **Post titles / angles:** One-line description of each post's specific angle
- **The standalone value of each post:** Each post must be valuable alone — a reader who only sees Post 3 should still get something real

Present the series plan to the client before writing. Get approval on the arc.

---

### Individual Post Structure (apply to each post in the series)

#### Post 1: The Opening
- Sets up the whole series topic — makes the reader want to follow along
- Hook: The most compelling or provocative angle from the entire series
- Briefly signal there is more coming: "I'll share the rest this week" or "Part 1 of 5"
- End with an engagement driver and an invitation to follow for the rest of the series

#### Posts 2–[N-1]: The Body Posts
- Each covers one distinct aspect, step, or angle of the series topic
- Hook: Stands alone — works as an opening even if the reader hasn't seen Post 1
- Early in the post: brief connection to the series (1 line: "Continuing from Monday's post on [topic]...")
- Core content: 4-7 lines covering this post's specific angle
- End with either: an engagement driver OR a brief tease for the next post

#### Last Post: The Conclusion
- The synthesis, the final insight, or the actionable summary
- Should feel like the earned payoff of the series
- Connect back to Post 1 (callback to the hook or opening) if natural
- Strong engagement driver — this is where you invite the discussion the series has been building toward
- Optional: "Save this series" or summarize all posts in a brief list for easy reference

---

## Tone Notes
- The series arc should feel like a natural deepening — each post adds something, not just repeats the premise
- Avoid cliffhangers that feel manipulative ("you won't believe what I say in Part 4")
- Natural connective tissue between posts ("building on yesterday" or "the flip side of what I shared Monday") is genuine; forced cliff-hangers are not
- Each post must earn its own engagement — don't bank on the series context to carry a weak individual post

---

## Formatting Guidance
- Each post should follow the client's individual post formatting (Dimension 9 from style profile)
- Posts in a series should feel consistent in length and density — readers will notice jarring length differences
- The connection line at the start of posts 2-N should be subtle and brief (1 line) — don't spend 3 lines re-explaining the series
- Delivery: write all posts in one document for the client to review, clearly labeled

---

## Delivery Format

Write all posts in this format for the client's review:

```
---
POST 1 of [N] — [Day, e.g., Monday]
---

[Full post text]

---
POST 2 of [N] — [Day]
---

[Full post text]

[Continue for all posts...]
```

---

## Example Series Arcs

**3-post series: "Why my team stopped having weekly meetings"**
- Post 1: The decision and why (the hook: we stopped all recurring meetings)
- Post 2: What we do instead (async, documented decisions, short syncs)
- Post 3: What surprised us after 6 months (the unexpected effects)

**5-post series: "How to hire your first 5 employees"**
- Post 1: Why your first 5 hires define the next 50 (the big claim)
- Post 2: What to look for in hire #1 (values and generalism)
- Post 3: When to hire a specialist vs. generalist
- Post 4: The interview question I ask everyone
- Post 5: The mistakes I made on my first 5 hires

---

## Common Mistakes
- **Posts that only make sense in order:** Each post must stand alone. Test: "If a reader found only Post 3 in their feed, would it be valuable?"
- **Series that go on too long:** 3-5 is the sweet spot. 7-part series lose readers by post 4.
- **First post that doesn't earn the follow:** Post 1 is the hardest sell — it must make people actively want the rest.
- **Inconsistent posting:** If you plan a 5-post series, post it 5 days in a row. Dead air between posts kills the series arc.
- **Forcing a series when one post would do:** Not every topic deserves a series. Use a series when the topic genuinely cannot be compressed without losing value.

---

## When to Use vs. Others
- Use this when a topic is too complex or multi-faceted for a single post and when you want sustained engagement across multiple days
- Use `framework.md` if the topic can be compressed into a structured mental model
- Use `listicle.md` if the multiple angles can be covered in one longer post
- Use `carousel-script.md` if the multi-part content would work better as a visual swipeable experience
ENDOFFILE__li_tmpl_thread_series

echo "  - thread-series.md done"
cat > "$KIT_DIR/.claude/skills/linkedin-setup/SKILL.md" << 'ENDOFFILE__linkedin_setup_skill'
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
ENDOFFILE__linkedin_setup_skill

echo "  - linkedin-setup SKILL.md done"
cat > "$KIT_DIR/.claude/skills/newsletter-setup/SKILL.md" << 'ENDOFFILE__newsletter_setup_skill'
# /newsletter-setup

Derive a newsletter-specific writing style profile from the central brand identity. The brand already exists — this tunes it for long-form newsletter writing.

## Trigger

Activate when the master CLAUDE.md routes here because `kits/newsletter/identity/style-profile.md` is missing or empty.

## Prerequisites

`brand/identity/brand-document.md` and `brand/identity/voice-guide.md` must exist and be non-empty. If missing, tell the user to run `/brand setup` first.

## Process

### Step 1 — Read the Brand

Read all three central brand documents. Summarize back:
> "I already know your brand — [1-2 sentence summary]. Now I need to tune your voice specifically for newsletter writing. This takes about 5-10 minutes."

### Step 2 — Gather Writing Samples

Check `brand/identity/writing-samples/` and `kits/newsletter/inspirations/writing-samples/`.

- **3+ samples exist:** Analyze them for the 7 dimensions below.
- **Fewer than 3:** "I have [N] sample(s). The profile will be stronger with 5-10 pieces of your writing — newsletters, blog posts, emails, anything long-form. Want to add more, or should I interview you instead?"
- **Zero, they insist:** Interview mode. Note low confidence in the profile.

### Step 3 — Build 7-Dimension Style Profile

Analyze writing across:
1. **Sentence Architecture** — long/short, simple/complex, fragments
2. **Vocabulary & Language** — formal/casual, jargon level, signature phrases
3. **Tone & Register** — serious/playful, warm/cool, conversational level
4. **Rhetorical Patterns** — storytelling, questions, analogies, lists, direct claims
5. **Perspective & POV** — first/second/third person, hedging vs directness
6. **Rhythm & Pacing** — cadence, paragraph length, repetition, flow
7. **Personality Markers** — humor, cultural references, emoji, exclamations, quirks

Delegate analysis to a sub-agent. Present results to user.

### Step 4 — Newsletter Specifics

Ask:
- Newsletter name
- Target audience (may differ from brand audience)
- Publishing frequency
- Typical format (deep dive, curated, weekly roundup, essays)
- Preferred length

### Step 5 — Inspiration Sources

> "Any newsletters or long-form writers you admire?"

Add to `sources.yaml`. Save any named references to `kits/newsletter/inspirations/creator-references/`.

### Step 6 — Save and Confirm

Save to `kits/newsletter/identity/style-profile.md`:

```markdown
---
version: 1
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
medium: newsletter
derived_from_brand_version: [version from brand-document.md]
---

# Newsletter Style Profile

## Voice DNA — Quick Reference
[3-5 bullet summary]

## Sentence Architecture
[analysis]

## Vocabulary & Language
[analysis]

## Tone & Register
[analysis]

## Rhetorical Patterns
[analysis]

## Perspective & Point of View
[analysis]

## Rhythm & Pacing
[analysis]

## Personality Markers
[analysis]

## Do
- [Pattern] — *Example: "[their actual words]"*

## Don't
- [Anti-pattern] — *Instead: "[their version]"*
```

Present to user for approval. Then: "Your newsletter voice is set up. Now let's write that newsletter — what's the topic?"

## Output
- `kits/newsletter/identity/style-profile.md`
ENDOFFILE__newsletter_setup_skill

echo "  - newsletter-setup SKILL.md done"
cat > "$KIT_DIR/.claude/skills/newsletter/SKILL.md" << 'ENDOFFILE__newsletter_skill'
# Newsletter Skill

## Context Management

When executing this skill, use the Agent tool to spawn a sub-agent for the heavy processing work. This keeps the main conversation lightweight and preserves context for the client interaction.

The main conversation should:
- Handle the client interaction (questions, confirmations, presenting results)
- Spawn a sub-agent for document analysis, writing sample processing, research, or drafting
- Receive the sub-agent's output and present it to the client in a friendly way

The sub-agent handles:
- Reading and analyzing documents
- Writing profile files
- Research and fact-gathering
- Drafting newsletter content

Write a complete newsletter draft that sounds like the client wrote it herself.

## Trigger

Activate when the user says `/newsletter` or asks to write, draft, create, or start a newsletter.

## Important — Communication Style

The client is not technical. All communication must be warm, clear, and in plain language. Never show YAML contents, file paths, config details, or internal process mechanics unless she explicitly asks. Speak to her like a trusted creative collaborator, not a system.

## Entry Points

The user can kick things off in any of these ways. Detect which one and proceed accordingly:

1. **Topic-driven** — User gives a topic directly (e.g., `/newsletter "topic: the power of saying no"`)
2. **Inspiration-driven** — User references a thinker or concept (e.g., "riff on Brene Brown's vulnerability concept")
3. **Link/content-driven** — User provides a URL or pastes article text
4. **Auto-suggest** — No input given. Research trending topics from available sources, then propose 3 options with a one-line pitch for each. Wait for the client to pick one before proceeding.
5. **Conversational** — User describes what they want in natural language. Extract the core topic and confirm it back before proceeding.

The user can also specify a template inline: `/newsletter "template: deep dive, topic: ..."`. See Phase 1 for template selection.

---

## Phase 1: Topic & Content Sourcing

### 1a. Load project context

Read these files to ground yourself in the client's world:

- `identity/brand-profile.md` — her brand positioning, audience, messaging pillars, values
- `identity/style-profile.md` — her writing voice, sentence patterns, vocabulary, tone
- `sources.yaml` — curated thought leaders, business figures, newsletter sources, and their key ideas

**If `brand-profile.md` or `style-profile.md` do not exist**, stop and tell the client:

> "Before we write, I need your brand voice on file. Let's run a quick setup to capture that first."

Do not proceed without both identity files. Suggest running the onboarding/setup skill if one exists, or explain what's needed.

**If `sources.yaml` does not exist**, you can still proceed. Let the client know:

> "I don't have your curated sources yet, so I'll research independently. If you'd like to add preferred thought leaders and sources later, we can set that up."

### 1b. Match topic to brand and sources

- Confirm the topic fits within the brand's messaging pillars from `brand-profile.md`. If it's a stretch, flag it gently and suggest how to angle it so it aligns.
- Search `sources.yaml` for thought leaders and frameworks relevant to the topic. Note which thinkers and key ideas connect.
- Identify 2-4 key points or angles to explore in the newsletter.

### 1c. Select the template

Check the `templates/` folder at the project root for available newsletter templates. Standard options:

| Template | Use when |
|---|---|
| `standard-weekly.md` | Default for most newsletters |
| `deep-dive.md` | Longer, single-topic exploration |
| `curated-links.md` | Roundup of links/resources with commentary |
| `announcement.md` | Product launch, event, or news-driven piece |

Selection logic:
- If the user specified a template, use it.
- If not specified, default to `standard-weekly.md`.
- If the topic clearly suits a different template (e.g., a resource roundup), suggest the better fit and confirm.

### 1d. Determine the newsletter folder

Check `newsletters/` for subfolders. If only one exists, use it. If multiple exist, either infer from context or ask the client which newsletter this is for.

### 1e. Output

Before moving on, present a brief summary to the client:

> "Here's what I'm working with: [topic in plain language], drawing on [relevant thinkers/frameworks]. I'll use the [template name] format. Sound good?"

Wait for confirmation (or adjust based on feedback) before proceeding.

Internally, assemble a structured brief: key points, relevant thinker references, source material, chosen template, target newsletter folder.

---

## Phase 2: Research & Fact Gathering

### 2a. Live source research (when Chrome is available)

Before falling back to general web search, try to pull fresh content directly from the client's curated inspiration sources.

1. **Check for Chrome browser tools** — Determine whether the `mcp__claude-in-chrome__*` tools (navigate, get_page_text, etc.) are available in the current session. If they are not available, skip this entire sub-step gracefully and proceed to 2b. Do not surface an error to the client.

2. **Select relevant sources** — Read `sources.yaml` and pick 2-3 sources whose URLs are most relevant to the newsletter topic. Prioritize newsletters and websites (sources that publish regularly) over individual thought leaders who may not have a dedicated site.

3. **Visit each source URL** — For each selected source:
   - Use `navigate` to open the URL.
   - If a cookie banner, paywall modal, or popup appears, attempt to dismiss it (click dismiss/close/accept buttons).
   - Use `get_page_text` to extract the visible page content.
   - Scan for recent posts or articles related to the newsletter topic.
   - If the landing page is an index or homepage, look for links to recent relevant articles and navigate into 1-2 of them for full text.

4. **Extract research material** — From each visited page, pull out:
   - Relevant quotes and key phrases
   - Frameworks, models, or mental models the source uses
   - Recent data points, statistics, or examples
   - Unique angles or contrarian takes on the topic
   - Publication date (to confirm freshness)

5. **Why this matters** — This step produces real, current content from the sources the client actually follows and trusts, not generic web search results. It grounds the newsletter in the same intellectual ecosystem the client inhabits.

### 2b. Web research and source matching

For each key point from the brief, gather supporting material:

- **Current data and examples** — Use web search for recent statistics, case studies, news, or cultural moments that connect to the topic.
- **Thought leader frameworks** — Pull relevant ideas, quotes, and frameworks from the thinkers identified in `sources.yaml`. Note the specific work or concept being referenced.
- **Practical business angles** — Find concrete, actionable angles from business figures in the source list.
- **Trending perspectives** — Check newsletter sources from `sources.yaml` for recent takes on the topic.

### Attribution tracking

For every idea, quote, or framework you pull in, note:
- Who said it or where it comes from
- The specific work, talk, or publication (if applicable)
- Whether it's a direct quote, paraphrase, or inspired-by reference

This attribution feeds into Phase 3 for natural weaving and Phase 4 for accuracy checks.

### Cross-reference

If a statistic or claim seems surprising, verify it with a second source. Flag anything you cannot verify so the client can decide whether to include it.

### Output

Compile a research document organized by newsletter section, with source attribution attached to each item. This stays internal — do not show it to the client unless asked.

---

## Phase 3: Drafting

### Load both identity files

Read `identity/brand-profile.md` and `identity/style-profile.md` fresh before drafting. These are the two most important inputs.

- **Brand profile** governs what you say — topic framing, audience awareness, messaging alignment, values reinforcement
- **Style profile** governs how you say it — sentence structure, rhythm, vocabulary, tone, diction, rhetorical patterns, signature markers

The style profile is the most critical input. The newsletter must sound like the client wrote it, not like AI generated it.

### Follow the template

Read the selected template from `templates/`. Follow its structure: sections, headers, CTAs, structural elements. The template is the skeleton; the voice and content are the flesh.

### Weave in references naturally

Thought leader ideas should be integrated, not forced. Good: "As Brene Brown puts it, vulnerability isn't weakness — it's the birthplace of innovation." Bad: "According to renowned researcher Dr. Brene Brown, PhD, in her landmark 2012 book..."

Reference thinkers the way the client would in conversation — naturally, with attribution but without academic formality (unless the style profile says otherwise).

### Draft the full piece

Write the complete newsletter following the template structure, in the client's voice, incorporating research and references. Include every structural element the template calls for (headers, sections, CTAs, sign-offs, etc.).

### Output

The full newsletter draft, held internally for self-edit before showing to the client.

---

## Phase 4: Self-Edit

Before presenting anything, run the draft through these checks:

### Voice consistency (against style-profile.md)

- **Sentence length** — Do the sentence length patterns match? Short punchy sentences if that's her style, longer flowing ones if not. Check the mix.
- **Vocabulary and diction** — Are you using her words, not generic AI words? Check for corporate buzzwords, filler phrases, or language she would never use.
- **Tone and emotional register** — Does the emotional temperature match? Too formal? Too casual? Too motivational-poster?
- **Rhetorical patterns** — Are her signature moves present? (Questions to the reader, list patterns, callback structures, metaphor style, etc.)
- **Rhythm and pacing** — Read it mentally as if speaking aloud. Does it flow the way her writing flows?

### Brand alignment (against brand-profile.md)

- **Messaging pillars** — Does the piece reinforce at least one core messaging pillar?
- **Audience fit** — Is this written for her actual audience, at their level?
- **Brand values** — Are her values reflected in the framing and conclusions?
- **Guardrails** — No prohibited topics, off-brand language, or messaging that contradicts her positioning?

### Source integrity

- Attribution present where needed?
- No unverified claims stated as fact?
- Quotes accurate?

### Narrative grounding check (CRITICAL)

This is the most common failure mode in drafts. Check that the piece follows the principle: **concrete first, abstract second. Scene before thesis. Let the reader arrive.**

- **Opening** — Does the piece start with something concrete (a scene, moment, question, or observable detail)? The thesis or core insight should land as the payoff, not the premise. If the draft opens with "Here's why X matters..." or "The key to X is..." — it fails. Flip it: show X in action first, then name it.
- **Section openers** — Every section should ground the reader in something concrete before naming an abstract principle. If a section opens with "The important thing to understand is..." before showing the thing in action, flip the order.
- **The test:** For every abstract claim in the draft, ask: *has the reader seen this in action yet?* If not, flip the order. Show first, name second.

### Flow check

Read the draft start to finish as a reader would. Check for:
- Strong opening that hooks (must pass the narrative grounding check above — concrete first, not thesis-first)
- Smooth transitions between sections
- A clear throughline from start to finish
- An ending that lands (not a fizzle)

### Revise

Make all necessary revisions. Track what you changed so you can provide a brief edit summary if asked, but do not volunteer the edit summary to the client — she doesn't need to see the sausage-making.

### Output

The revised, polished draft ready for delivery.

---

## Phase 5: Format & Deliver

### Format the final draft

Format as clean markdown. Add a metadata header at the top of the file:

```
---
date: YYYY-MM-DD
topic: [topic in plain language]
template: [template filename used]
sources: [list of key sources/thinkers referenced]
status: draft
---
```

### Save the draft

Save to: `newsletters/[newsletter-folder]/drafts/[YYYY-MM-DD]-[topic-slug].md`

- `newsletter-folder` is the folder identified in Phase 1d.
- `topic-slug` is a short, lowercase, hyphenated version of the topic (e.g., `the-power-of-saying-no`).
- Always save automatically. Nothing should be lost.

### Offer a TLDR

After saving the draft, offer to generate a TLDR — a one-sentence curiosity hook for the top of the piece:

> "Want a TLDR for the top? It's a one-line teaser that hooks readers before they start — great for email previews and social sharing."

If the client says yes, run the `/tldr` skill on the draft. It will analyze the piece, generate 3 options using different hook strategies, and let the client pick one. The chosen TLDR gets placed at the top of the draft, right after the frontmatter.

If the client says no or wants to skip it, move on. Do not push.

### Present to the client

Share the draft with the client. For shorter pieces (under ~800 words), present the complete draft. For longer pieces, present it section by section with brief pauses, or ask the client how she'd like to see it.

Frame the delivery warmly:

> "Here's your draft! I drew on [brief mention of key sources/angles]. Take a look and let me know what you think — happy to revise anything."

Do not dump the draft without context. Always give her a short orientation before the content.

### Handle feedback and revisions

Be ready for any of these:
- "Make it punchier" — Tighten sentences, cut filler, sharpen the hook and transitions
- "Add a personal anecdote placeholder" — Insert a clearly marked `[PERSONAL ANECDOTE: brief suggestion of what could go here]` placeholder
- "Swap the opening" — Write 2-3 alternative openings and let her pick
- "Too long / too short" — Adjust length while preserving voice and key points
- "Change the tone" — Adjust emotional register while staying within brand guardrails
- Any other revision request — apply it, re-run the Phase 4 checks on the changed sections, and save the updated version

On every revision, save the updated draft to the same file path (overwriting the previous version). Confirm the save to the client.

---

## File Reference

| File | Purpose | Required? |
|---|---|---|
| `identity/brand-profile.md` | Brand positioning, audience, messaging pillars | Yes — stop without it |
| `identity/style-profile.md` | Writing voice, patterns, tone, vocabulary | Yes — stop without it |
| `sources.yaml` | Curated thought leaders and sources | No — works without it |
| `templates/` | Newsletter structure templates | Yes — needs at least one |
| `newsletters/` | Output folder for drafts and published pieces | Yes — must exist |

## Guiding Principle

The newsletter should feel like the client sat down and wrote it on a great writing day. The style profile is the contract. Every sentence should pass the test: "Would she actually say it this way?"
ENDOFFILE__newsletter_skill

echo "  - newsletter SKILL.md done"
cat > "$KIT_DIR/.claude/skills/newsletter/templates/announcement.md" << 'ENDOFFILE__nl_tmpl_announcement'
# Template: Announcement

Short, focused, high-signal. One message with one clear call to action. For launches, events, updates, offers, or important news.

**Target length:** 300–500 words

---

## Structure

### 0. TLDR (optional)
- One sentence, placed at the very top before the hook
- For announcements, this can be more direct — but still create pull, not just state the news
- Generated via the `/tldr` skill after the draft is complete — not written during drafting
- Format: `**TLDR:** [teaser sentence]` followed by a horizontal rule

### 1. Hook
- One bold sentence or question — no preamble
- Hit the reader with energy immediately
- Approaches:
  - A bold declaration: "It's happening."
  - A direct question: "What if you could...?"
  - A surprising statement that demands the next line
- No warm-up, no "I hope this finds you well" — get to it

### 2. The News
- 50–100 words (2–4 sentences)
- What's happening? State it clearly and directly
- Cover the essentials: what it is, when it's happening, who it's for
- Write with excitement but don't oversell — let the thing speak for itself
- One paragraph, no fluff

### 3. Why It Matters
- 50–100 words
- Why should the reader care? What does this mean for them specifically?
- Connect it to:
  - A problem they have that this solves
  - An opportunity they don't want to miss
  - A value or aspiration they share with the brand
- Make it about THEM, not about the client

### 4. The Details
- 50–150 words
- Specifics: dates, times, links, prices, logistics, how to access
- Use a scannable format:
  - Bullet points for multiple details
  - Bold key information (dates, links, prices)
  - Short paragraphs if narrative works better
- Make it impossible to miss the important information

### 5. CTA
- One clear action. NOT three. One.
- Make it unmissable — bold, linked, set apart
- Be specific: "Sign up here" > "Learn more"
- Create gentle urgency if appropriate (limited spots, deadline, early access)
- The reader should know exactly what to do and feel motivated to do it

### 6. P.S. (Optional)
- 1–2 sentences
- A personal note, a bonus detail, or a secondary CTA
- P.S. lines have high readership — use this strategically
- Can be warmer/more personal than the rest of the email
- Good for: "If you have questions, just reply" or a small bonus offer

---

## Tone Notes
- Announcements should feel exciting but not hypey
- Confidence over salesiness — the client believes in what she's sharing
- Respect the reader's time — get in, deliver the message, get out
- Every sentence should earn its place — if it doesn't add information or energy, cut it
- The CTA is the most important element — everything builds toward it
- This is the shortest template — brevity is a feature, not a limitation
ENDOFFILE__nl_tmpl_announcement

echo "  - newsletter announcement template done"
cat > "$KIT_DIR/.claude/skills/newsletter/templates/curated-links.md" << 'ENDOFFILE__nl_tmpl_curated_links'
# Template: Curated Links

Commentary on 5–7 links the client has been reading or thinking about. This format showcases the client's taste, perspective, and ability to connect ideas across sources.

**Target length:** 600–900 words

---

## Structure

### 0. TLDR (optional)
- One sentence, placed at the very top before the intro
- Not a summary — a curiosity hook (e.g., the most surprising link or a connecting thread framed as a question)
- Generated via the `/tldr` skill after the draft is complete — not written during drafting
- Format: `**TLDR:** [teaser sentence]` followed by a horizontal rule

### 1. Intro
- 50–100 words
- Brief personal note setting the mood or theme for this edition
- Can be:
  - What she's been thinking about this week
  - A connecting thread she noticed across what she's been reading
  - A mood or season or moment that frames the picks
  - A direct "here's what caught my eye" opener
- Warm, casual, like opening a conversation

### 2. The Links (5–7 items)
Each item follows this structure:

**[Headline or Title for the Link]**
*Source: [Publication/Author/Platform]*

50–100 words of personal commentary. This is NOT a summary of the article. It's the client's reaction:
- Why it caught her attention
- What she agrees or disagrees with
- How it connects to something she's been thinking about
- What it made her question or reconsider
- A specific line or idea she'd highlight
- How it relates to her audience's world

Guidelines for link selection:
- Mix sources: don't pull all links from the same place
- Mix weight: some items can be quick ("this is just fun") and others deeper
- At least one link should connect to a thought leader from the sources library
- At least one link should be directly relevant to the audience's work/life
- Variety in format is good: articles, podcasts, videos, threads, books

### 3. Connecting Thread (Optional)
- 1–2 sentences
- If there's a theme that emerged across the links, name it
- Don't force it — only include this if a genuine through-line exists
- Can be framed as a question: "What I keep noticing across all of these is..."

### 4. Closing
- 2–3 sentences
- Quick, warm sign-off
- Can include:
  - What she's reading or exploring next
  - An invitation: "Send me what you've been reading"
  - A light teaser for next week's topic
- Keep it brief — this format is naturally lighter

---

## Tone Notes
- This is the most casual template — it should feel like a smart friend texting you links
- The client's personality and taste are the main attraction, not the links themselves
- Commentary should reveal how the client thinks, not just what she reads
- Opinionated is good — she doesn't have to be balanced here
- Quick energy — each item should be a fast, satisfying read before moving to the next
- The value is in the curation and the perspective, not comprehensiveness
ENDOFFILE__nl_tmpl_curated_links

echo "  - newsletter curated-links template done"
cat > "$KIT_DIR/.claude/skills/newsletter/templates/deep-dive.md" << 'ENDOFFILE__nl_tmpl_deep_dive'
# Template: Deep Dive

Long-form, single-topic exploration. For when the client wants to go deep on one subject and build a thorough argument or narrative.

**Target length:** 1500–2500 words

---

## Structure

### 0. TLDR (optional)
- One sentence, placed at the very top before the title
- Not a summary — a curiosity hook that makes readers need to keep reading
- Especially valuable for deep dives where the reader commits to 1500+ words
- Opens a curiosity gap: gives enough to intrigue, withholds the resolution
- Must include at least one specific detail (a number, a timeframe, a named thing)
- Generated via the `/tldr` skill after the draft is complete — not written during drafting
- Format: `**TLDR:** [teaser sentence]` followed by a horizontal rule

### 1. Title / Headline
- Compelling and specific — not clickbait
- Should communicate what the reader will walk away understanding
- Can be a statement, a question, or a framing device
- Keep it under 12 words when possible

### 2. Opening
- 100–200 words
- Scene-setting — draw the reader in before making your point
- Approaches that work well:
  - A vivid story or moment that embodies the topic
  - A paradox or contradiction that demands exploration
  - A personal experience that led to this inquiry
  - A "what if" scenario that reframes something familiar
- Don't reveal the full thesis yet — create pull

### 3. The Problem / The Question
- 100–150 words
- Frame what this piece is really exploring
- Why does this topic matter? Why now? Why to this audience?
- Create stakes — what's at risk if we don't think about this clearly?
- This section bridges the story opening into the analytical body

### 4. Section 1 — Context & Background
- 200–300 words
- Set the stage with what the reader needs to know
- Can include:
  - Historical context or origin of the idea
  - Current landscape — what's happening now
  - Foundational concepts the argument builds on
  - Common misconceptions to clear away
- Keep it tight — this is setup, not the main event
- Use a descriptive subheading (not "Section 1")

### 5. Section 2 — The Core Insight
- 300–400 words
- This is the heart of the piece — the main argument, framework, or revelation
- Where thought leader ideas get woven in deeply:
  - Connect frameworks from sources to the topic
  - Build on existing thinking, don't just cite it
  - Show how different thinkers' ideas intersect or conflict
- Make the insight feel earned — the reader should feel "I never thought about it that way"
- Use concrete examples to anchor abstract ideas
- Use a descriptive subheading

### 6. Section 3 — Practical Application
- 200–300 words
- Bridge from insight to action
- How does this apply to the reader's life, work, or decisions?
- Be concrete:
  - Specific steps or frameworks they can use
  - Real-world examples of the insight in practice
  - Questions they can ask themselves
- Avoid generic advice — make it specific to this audience and this topic
- Use a descriptive subheading

### 7. Section 4 — The Nuance / The Counterpoint
- 100–200 words
- Acknowledge complexity — nothing is absolute
- Address:
  - Limits of the argument — when does this not apply?
  - Reasonable objections — what might a thoughtful person push back on?
  - Edge cases or tradeoffs
- This section builds credibility — it shows intellectual honesty
- Don't undermine the core insight; add dimension to it
- Use a descriptive subheading

### 8. Closing
- 100–150 words
- Synthesize — don't summarize
- Circle back to the opening story or image (callbacks create resonance)
- Leave the reader with something to sit with — a question, an image, a reframing
- The last line should linger

### 9. CTA
- 1–2 sentences
- One clear action: reply, share, reflect, try something, read further
- Keep it simple and aligned with the piece's energy

---

## Tone Notes
- Deep dives should feel like a long conversation with a thoughtful person, not a textbook
- Build slowly — earn the reader's attention through the first third, reward it in the middle, leave them thinking at the end
- Philosophical depth is welcome here, but always anchor it to something concrete
- Transitions matter more in long-form — each section should flow naturally into the next
- This is where the client's intellectual depth and unique perspective shine most
ENDOFFILE__nl_tmpl_deep_dive

echo "  - newsletter deep-dive template done"
cat > "$KIT_DIR/.claude/skills/newsletter/templates/standard-weekly.md" << 'ENDOFFILE__nl_tmpl_standard_weekly'
# Template: Standard Weekly

The default newsletter format. One main story with supporting content. Conversational, focused, and actionable.

**Target length:** 800–1200 words

---

## Structure

### 0. TLDR (optional)
- One sentence, placed at the very top before the opening hook
- Not a summary — a curiosity hook that makes readers need to keep reading
- Opens a curiosity gap: gives enough to intrigue, withholds the resolution
- Must include at least one specific detail (a number, a timeframe, a named thing)
- Generated via the `/tldr` skill after the draft is complete — not written during drafting
- Format: `**TLDR:** [teaser sentence]` followed by a horizontal rule

### 1. Opening Hook
- 2–3 sentences maximum
- Grab attention immediately — use one of these approaches:
  - A personal anecdote that connects to the theme
  - A surprising fact or statistic
  - A provocative question the reader can't ignore
  - A bold, contrarian statement
- Set the emotional tone for the entire piece
- The reader should feel "I need to keep reading" after the first line

### 2. Main Story
- 400–600 words
- One big idea, explored thoroughly
- Follow this narrative arc:
  1. **Setup** — Frame the problem, situation, or question (2–3 paragraphs)
  2. **Tension** — Why this matters, what's at stake, what most people get wrong (2–3 paragraphs)
  3. **Insight** — The core idea, framework, or shift in perspective. This is where thought leader references belong — woven in naturally, not name-dropped (2–3 paragraphs)
  4. **Resolution** — What the reader can do with this insight. Practical, concrete, actionable (1–2 paragraphs)
- Reference at least one thought leader framework or idea from the sources library
- Stay aligned with the brand's messaging pillars
- Write in the client's voice throughout — sentence rhythm, vocabulary, and tone should match the style profile

### 3. Key Takeaway
- 1–2 sentences maximum
- Distill the main insight into something quotable and shareable
- Should work as a standalone statement — if someone only reads this line, they get the core message
- Format it to stand out (bold, blockquote, or set apart with whitespace)

### 4. Quick Takes
- 2–3 shorter items, 50–100 words each
- These are secondary content — lighter, faster, varied
- Each item can be any of:
  - A relevant link with the client's commentary (not a summary — a reaction)
  - A quick practical tip related to the theme
  - A question posed to the reader to spark reflection or replies
  - A brief riff on a related but secondary topic
  - A quote from a thought leader with brief context
- Each item should have a short bold header or label

### 5. Closing
- 2–4 sentences
- Personal, warm sign-off in the client's natural voice
- Include one of:
  - A question to spark reader replies ("Hit reply and tell me...")
  - A CTA (share the newsletter, check out a resource, try something this week)
  - A reflective one-liner that lingers
- Sign off with the client's name or preferred closing

---

## Tone Notes
- This template should feel like a smart friend sharing something they've been thinking about
- Conversational but substantive — not fluffy, not academic
- The main story carries weight; the quick takes keep it light and varied
- Energy should build through the main story and ease off in the closing
ENDOFFILE__nl_tmpl_standard_weekly

echo "  - newsletter standard-weekly template done"
cat > "$KIT_DIR/.claude/skills/publish/SKILL.md" << 'ENDOFFILE__publish_skill'
# /publish

Move a draft from drafts to published and optionally push to the target platform.

## Trigger

Activate when the user says "publish this", "move to published", "this is ready", "finalize this", or similar.

## Process

### Step 1 — Identify the Draft

Determine which draft to publish:
- The user references a specific draft by name
- The user just finished reviewing a draft in this conversation — use that one
- Ambiguous — list recent drafts across all kits and ask which one

### Step 2 — Confirm

Show the draft title and first few lines:
> "Ready to publish this? I'll move it from drafts to published."

### Step 3 — Move the File

Move from the kit's `output/drafts/` to `output/published/`:
- Newsletter: `kits/newsletter/output/drafts/` → `kits/newsletter/output/published/`
- Carousel: `kits/carousel/output/drafts/` → `kits/carousel/output/published/`
- LinkedIn: `kits/linkedin/output/drafts/` → `kits/linkedin/output/published/`
- Shortform: `kits/shortform/output/drafts/` → `kits/shortform/output/published/`

### Step 4 — Log It

If the kit has a post-history tracker (`kits/[kit]/content-strategy/post-history.yaml`), append:
```yaml
- date: YYYY-MM-DD
  title: "[title]"
  template: "[template used]"
  pillar: "[content pillar]"
  file: "output/published/[filename]"
```

### Step 5 — Platform Guidance

> "Draft moved to published! To post it:
> - **Newsletter:** Copy into your email platform (Substack, Beehiiv, ConvertKit, etc.)
> - **LinkedIn:** Copy the text into LinkedIn's post composer
> - **Carousel:** Use the slide-by-slide specs to build in Canva, Figma, or your design tool
> - **Shortform:** Use the script and filming guide to record
>
> Direct platform integrations are coming soon."

### Step 6 — Suggest Next

> "What's next? Want to create another piece, or work on something different?"

## Rules
- Always confirm before moving — never auto-publish
- If the draft was never reviewed/approved by the user, warn them first
- Never auto-publish without explicit user approval
ENDOFFILE__publish_skill

echo "  - publish SKILL.md done"
cat > "$KIT_DIR/.claude/skills/read-source/SKILL.md" << 'ENDOFFILE__read_source_skill'
# Skill: read-source

## Context Management

When executing this skill, use the Agent tool to spawn a sub-agent for the heavy processing work. This keeps the main conversation lightweight and preserves context for the client interaction.

The main conversation should:
- Handle the client interaction (questions, confirmations, presenting results)
- Spawn a sub-agent for browsing, content extraction, and summarization
- Receive the sub-agent's output and present it to the client in a friendly way

The sub-agent handles:
- Chrome browsing and content extraction
- Reading and summarizing articles
- Compiling research summaries

Browse a source's website or newsletter and summarize what they've been writing about recently. This gives the client real, current inspiration from the people and publications they follow.

## Trigger

This skill activates when the user invokes `/read-source` or asks things like:

- "What has [source] been writing about?"
- "Go check [source]'s latest posts"
- "Read [source] for me"
- "What's trending on [newsletter]?"
- "What did [person] publish recently?"
- "I need inspiration — go read my sources"

## Inputs

- **With a specific source:** A name or URL of a source to check (e.g., `/read-source Lenny's Newsletter`)
- **No arguments or "all":** Browse 2-3 of the client's most relevant sources from `sources.yaml` and summarize across all of them
- **With a topic filter:** A source plus a topic to focus on (e.g., "What has Stratechery written about AI lately?")

## Instructions

### 1. Identify the source

Read `sources.yaml` from the project root. Find the source the client is asking about:

- Search across all categories (thought_leaders, business_figures, newsletters, websites) by name (case-insensitive, partial match)
- If a URL is found in the source entry (`url`, `newsletter_url`), use it
- If no URL is stored, use web search to find the source's main publication URL
- If the client gave a URL directly, use that

If no match is found and no URL was provided, tell the client:

> "I don't have that source on file. Want me to add them? Just give me a name or URL and I'll set them up."

If the client asks to read "all" or "my sources" without specifying, pick the 2-3 sources from `sources.yaml` that have URLs (prioritize newsletters and websites categories).

### 2. Check Chrome availability

Check if Chrome browser tools (`mcp__claude-in-chrome__*`) are available.

**If Chrome is NOT available**, tell the client:

> "I can't browse websites right now — Chrome isn't connected. I can still search the web for recent content from [source]. Want me to do that instead?"

If they say yes, use web search to find recent articles and summarize what you find. If they say no, stop.

**If Chrome IS available**, proceed to step 3.

### 3. Browse the source

Use Chrome browser tools to visit and read the source:

1. **Get tab context** — Call `tabs_context_mcp` to see available tabs
2. **Create a new tab** — Use `tabs_create_mcp` for a fresh tab
3. **Navigate** — Go to the source URL
4. **Handle popups** — Dismiss cookie banners, subscribe modals, and email signup popups:
   - Use `read_page` with `filter: "interactive"` and shallow depth to find close/dismiss buttons
   - Click "No thanks", "Close", "X", or similar dismiss buttons
   - If a popup can't be dismissed, proceed anyway — content may still be readable
5. **Extract the page** — Use `get_page_text` to read the page content
6. **Find recent articles** — If you landed on a homepage or archive:
   - Use `read_page` with `filter: "interactive"` to find article links
   - Identify 2-3 recent articles that look substantive (skip ads, navigation links, etc.)
   - Navigate to each article and extract text with `get_page_text`
   - If the client specified a topic, prioritize articles related to that topic
7. **If `get_page_text` fails** (page too heavy), use `read_page` at shallow depth to find article content, or try navigating to a specific article URL from the page

### 4. Compile the summary

From the content you extracted, compile a research summary covering:

- **Recent topics** — What themes and subjects has the source been covering?
- **Key ideas** — The most interesting or notable arguments, frameworks, or perspectives
- **Relevant angles** — Ideas that connect to the client's brand or could inspire newsletter content (reference `identity/brand-profile.md` for brand alignment if it exists)
- **Publishing cadence** — How often they seem to publish (if observable from dates)
- **Notable quotes or lines** — 2-3 short, striking phrases that capture the source's perspective (keep under 15 words each)

If the client specified a topic filter, focus the summary on content related to that topic.

### 5. Present to the client

Share the summary in warm, plain language. Frame it as inspiration and conversation, not as a research report. Example tone:

> "I just read through Lenny's Newsletter — here's what he's been focused on lately:
>
> **AI in product management** seems to be his big theme right now. He's been writing about how PMs should be using AI tools daily, not just theoretically...
>
> **Hiring and team building** keeps coming up too. His latest piece argues that...
>
> A few things jumped out that could work well for your newsletter: [specific angles tied to their brand]."

Do NOT:
- Show URLs, file paths, or technical details
- Dump raw extracted text
- Present it as a bulleted research document
- Use phrases like "I scraped" or "I extracted" — say "I read" or "I checked"

### 6. Optionally save for future reference

If the summary is substantive, save it to `sources-research/[source-slug]-[YYYY-MM-DD].md` for future reference during newsletter research. Create the `sources-research/` directory if it doesn't exist. Use this format:

```markdown
---
source: [Source Name]
url: [URL visited]
date: YYYY-MM-DD
topics: [list of topics covered]
---

[Summary content in markdown]
```

This step is silent — do not tell the client about the saved file unless they ask.

## Rules

- **Never show raw scraped content.** The client sees a curated, conversational summary — never raw text dumps.
- **Respect copyright.** Summarize and synthesize. Never reproduce full paragraphs from articles. Short quotes (under 15 words, in quotation marks) are fine for flavor.
- **If Chrome tools aren't available, fall back gracefully.** Offer web search as an alternative. Never error out.
- **If a site requires login the client doesn't have**, let them know plainly: "That content is behind a paywall I can't access. If you're subscribed, you can log into Chrome and I'll be able to read it."
- **Keep summaries concise.** The client wants inspiration, not a research paper. Aim for 200-400 words per source.
- **Frame everything as inspiration.** The goal is to spark ideas for their newsletter, not to report on what someone else wrote.
- **Never show YAML, file paths, or system details** unless the client specifically asks.
- **Always tie back to the client's world** when possible — "This could be a great angle for your newsletter because..." connects the research to action.
ENDOFFILE__read_source_skill

echo "  - read-source SKILL.md done"
cat > "$KIT_DIR/.claude/skills/research-trends/SKILL.md" << 'ENDOFFILE__research_trends_skill'
# Skill: research-trends

Research currently trending formats, hooks, and patterns in the client's niche and platform. Updates the playbook with fresh intelligence.

## Trigger

Activate when the user says:
- "What's trending?"
- "Research current trends"
- "/research-trends"
- Or when `content/my-content/playbook.md` hasn't been updated in 2+ weeks

## Process

### Step 1 — Load context

Read:
- `identity/brand-profile.md` — for niche and platform
- `creators.yaml` — for creators to research
- `content/my-content/playbook.md` — for existing trend notes

### Step 2 — Research

Use web search to find:
- **Trending formats** on the client's primary platform(s)
- **What tracked creators are posting** — recent content from creators in `creators.yaml`
- **Viral patterns in the client's niche** — what's getting traction right now
- **Trending sounds/audio** — described textually (trending song names, audio meme descriptions)
- **Format structures** that are performing well

### Step 3 — Update playbook

Append to `content/my-content/playbook.md` under dated sections:

```markdown
## Trend Update — YYYY-MM-DD

### Currently Trending Formats
- [format description with example]

### Trending in [User's Niche]
- [niche-specific trends]

### Creator Watch
- [Creator Name]: [what they're doing differently this week]

### Sound/Audio Trends
- [described textually — song name, audio meme, voice effect]

### Format Ideas for You
- [mapped to templates: "This trending format maps well to your myth-bust template"]
```

### Step 4 — Update creators.yaml

Add any new trends to the `format_trends` section.

### Step 5 — Present summary

Conversational summary of what's working right now:

> "Here's what I found trending in your niche this week: [summary]. A few format ideas that could work well for you: [ideas mapped to templates]."

## Rules

- **Trends are inspiration, not mandates.** The client's persona and brand always come first.
- **Describe audio trends textually.** We can't play sounds, but we can describe them.
- **Date everything.** Trends expire fast. Always timestamp.
- **Map to templates.** Don't just report trends — suggest how the client could use them with their existing templates.
ENDOFFILE__research_trends_skill

echo "  - research-trends SKILL.md done"
cat > "$KIT_DIR/.claude/skills/script/SKILL.md" << 'ENDOFFILE__script_skill'
# Script Skill

Write a complete short-form video script that sounds like the client on camera. Includes hooks, timestamps, visual direction, text overlays, and a filming guide.

## Trigger

Activate when the user says `/script` or asks to write, draft, or create a video script.

## Important — Communication Style

The client is not technical. All communication must be warm, clear, and in plain language. Never show YAML, file paths, or system internals unless asked.

## Entry Points

1. **Topic-driven** — "/script 'topic: why most morning routines fail'"
2. **Format-driven** — "/script 'format: myth-bust, topic: passive income'"
3. **Creator-inspired** — "/script 'in the style of how Hormozi does listicles'"
4. **Trend-driven** — "/script 'use the trending [format]'"
5. **Platform-specific** — "/script 'youtube short about...'"
6. **Auto-suggest** — No input → research + propose 3 concepts with format recommendations
7. **Conversational** — Natural language

---

## Phase 1: Concept & Context Loading

### 1a. Load project context

Read these files:
- `identity/brand-profile.md` — brand, audience, content pillars, platform, CTA strategy
- `identity/persona-profile.md` — 8-dimension on-camera persona
- `creators.yaml` — inspiration creators and format trends
- `content/my-content/config.yaml` — platform, niche, frequency, preferred length

**Hard stop** if brand or persona profiles are missing:

> "Before we script, I need your brand and on-camera persona on file. Let's run setup first."

### 1b. Determine platform and template

- Platform from config.yaml or user input
- Template: user-specified or recommended based on topic type
- Check `content/my-content/playbook.md` for current trends and best practices

### 1c. Confirm

> "Here's what I'm thinking: a [template] about [topic], [duration] for [platform]. Sound good?"

Wait for confirmation.

---

## Phase 2: Hook Development (THE critical phase)

The hook IS the video. If the first 1-3 seconds don't stop the scroll, nothing else matters.

Generate **5 hook options**, each under 3 seconds spoken (~10 words max), all in the client's persona voice:

1. **Bold claim** — a strong, specific statement
2. **"You" accusation** — makes it about the viewer
3. **Question** — provokes thought or curiosity
4. **Mid-story start** — drops into action
5. **Pattern interrupt** — unexpected framing

For each hook:
- The spoken words
- Suggested text overlay
- Brief note on why it works

> "Here are 5 ways to open this video. Pick one, or tell me what direction to go."

**Wait for selection.** Never auto-pick.

---

## Phase 3: Full Script Drafting

Write the complete script using the selected hook + template structure. **Every section must include:**

```
[TIMESTAMP: 0:00-0:03]
[VISUAL: Talking head, close-up, eye contact with camera]
[TEXT ON SCREEN: "Stop doing THIS" in bold]
[TONE: High energy, slight frustration]

"Stop wasting your mornings on routines that don't actually work."

---

[TIMESTAMP: 0:03-0:08]
[VISUAL: Medium shot, slight lean forward]
[TEXT ON SCREEN: None]
[TONE: Conversational, pulling viewer in]

"I tried every morning routine out there. The 5am club. Cold plunges. Journaling for an hour. None of it moved the needle."
```

**Requirements:**
- Every section: timestamp, visual direction, text overlay cues, tone/energy direction, spoken words in quotes
- Pattern interrupt markers where needed (camera change, text overlay, energy shift)
- Word count check: ~2.5 words/second (150 words/minute)
- End with: total word count, estimated duration, platform target

---

## Phase 4: Self-Edit (Highly Opinionated)

### Persona check (against persona-profile.md)
- Sounds like them speaking? Energy, vocabulary, humor match?
- Script Rules (Do/Don't) from persona profile honored?

### Brand alignment (against brand-profile.md)
- Content pillar served? Niche appropriate? CTA matches strategy?

### Retention check
- **1-second rule:** First FRAME stops the scroll?
- **3-second gate:** Hook creates reason to stay by second 3?
- **7-second cliff:** Something CHANGES at 7-8 seconds?
- **Pattern interrupts** every 8-12 seconds?
- **Ending** pays off the hook's promise?

### Speakability check
- Any tongue-twisters? Read every line aloud mentally.
- Sentences short enough to deliver in one breath?
- Natural transitions between sections?
- No filler phrases ("so basically," "um," "like I said")

### Timing check
- Word count matches target duration? (~2.5 words/sec)
- No section runs too long without a visual change?

### Platform check
- Length appropriate for the platform?
- Text overlay density right?
- Safe zones respected (avoid bottom 20%, top 15%)?

Revise as needed. First draft is never final.

---

## Phase 5: Filming Guide

Generate a companion guide:

### Setup Notes
- Camera: framing, angle, distance
- Lighting: natural/ring/studio recommendation
- Audio: mic recommendation, room notes
- Background: what should be visible

### Shot List
| Timestamp | Shot | Description |
|-----------|------|-------------|
| 0:00-0:03 | Close-up | Eye contact, high energy |
| 0:03-0:08 | Medium | Lean forward, conversational |
| ... | ... | ... |

### Text Overlay Specs
| Timestamp | Text | Style | Position |
|-----------|------|-------|----------|
| 0:00-0:03 | "Stop doing THIS" | Bold, large | Center |
| ... | ... | ... | ... |

### Editing Notes
- Cut style, pace, music/sound vibe
- Transitions between sections
- Caption style and timing

### Posting Notes
- Best posting time for platform
- Suggested hashtags (3-5)
- Caption text for the post
- CTA from brand profile

---

## Phase 6: Deliver

Save to `content/my-content/scripts/drafts/YYYY-MM-DD-[slug].md` with frontmatter:

```markdown
---
date: "YYYY-MM-DD"
topic: "topic"
platform: "tiktok/reels/shorts"
template: "template-name"
duration: "estimated seconds"
word_count: X
hook_type: "bold-claim/you/question/mid-story/interrupt"
status: "draft"
---
```

Present warmly:

> "Here's your script! [duration] [format] for [platform]. Hook: '[hook text]'. Take a look."

---

## Phase 7: Platform Adaptation

If the client posts on multiple platforms, generate delta notes:

- **TikTok:** More casual tone, trending sound suggestion, heavier text overlays
- **Reels:** Slightly more polished, use Instagram's native music, adjust caption safe zones
- **Shorts:** More educational framing, lighter text, longer shelf life so optimize for evergreen

---

## Guiding Principle

The script should sound like the client grabbed their phone and filmed it on a great content day. The persona profile is the contract. Every line should pass the test: "Would they actually say this on camera?"
ENDOFFILE__script_skill

echo "  - script SKILL.md done"
cat > "$KIT_DIR/.claude/skills/script/templates/day-in-my-life.md" << 'ENDOFFILE__script_tmpl_day'
# Template: Day in My Life

Behind-the-scenes content that gives viewers a window into your daily routine. Builds parasocial connection — viewers feel like they know you personally.

**Optimal platforms:** TikTok, Reels
**Target length:** 45-90 seconds
**Word count target:** 110-225 words
**Key mechanic:** Parasocial connection — viewers bond with you as a person, not just a creator

---

## Structure

### 1. Hook — Set the Day — 0:00-0:03
**Word count:** 5-10 words
**Purpose:** Establish what kind of day this is and why it's worth watching
**Visual:** Morning shot or establishing shot of your environment
**Text overlay:** "Day in my life as a [role]" or "How I [achievement] by [time]"
- Frame the day around a theme or outcome, not just "here's my day"

### 2. Morning Block — 0:03-0:20
**Word count:** 20-40 words
**Purpose:** Show your routine with insights woven in
**Visual:** B-roll of morning activities, voiceover
**Audio:** Chill morning music
**Text overlay:** Time stamps, habit names
- Show 2-3 morning habits/activities
- Each one has a brief insight: WHY you do this, not just WHAT
- "I start with [activity] because [insight]"

### 3. Work Block — 0:20-0:50
**Word count:** 35-70 words
**Purpose:** The professional content — this is where value lives
**Visual:** Screen recordings, workspace shots, meetings (brief), deep work
**Text overlay:** Task labels, productivity tips
- Show 2-4 work activities
- Each with a micro-lesson or behind-the-scenes insight
- This is where you establish expertise through action, not just claims

### 4. Reflection / Close — 0:50-0:80
**Word count:** 20-40 words
**Purpose:** The takeaway — what made today worth sharing
**Visual:** End-of-day setting, relaxed
**Text overlay:** Key insight from the day
- One lesson from the day
- "The thing I keep coming back to is..."
- CTA: "Follow along — I share what I learn every week"

---

## Common Mistakes
- Just showing activities without insights (boring daily vlog)
- Too many activities — pick 5-7 highlights, not every minute
- No through-line or theme — random activities don't connect
- Over-produced (this format works best slightly raw and real)
ENDOFFILE__script_tmpl_day

echo "  - day-in-my-life script template done"
cat > "$KIT_DIR/.claude/skills/script/templates/hook-story-cta.md" << 'ENDOFFILE__script_tmpl_hsc'
# Template: Hook-Story-CTA

The universal short-form format. A hook that stops the scroll, a story that holds attention, and a punchline that pays it off. DEFAULT template when no other format is specified.

**Optimal platforms:** TikTok, Reels, Shorts
**Target length:** 30-60 seconds
**Word count target:** 75-150 words
**Key mechanic:** Narrative tension — the viewer stays to see how the story ends

---

## Structure

### 1. Hook — 0:00-0:03
**Word count:** 5-10 words
**Purpose:** Stop the scroll. This is the entire reason someone watches.
**Visual:** Close-up, eye contact, high energy or intense expression
**Audio:** No music yet, or music starts low. Voice is the focus.
**Text overlay:** Bold, 4-6 words that reinforce the hook
- One strong sentence that creates an open loop
- Must work in the first FRAME (before audio even registers)
- Approaches: bold claim, "you" statement, mid-story drop-in

### 2. Context / Setup — 0:03-0:10
**Word count:** 15-25 words
**Purpose:** Answer "why should I care?" Lock in the viewer past the 7-second cliff.
**Visual:** Medium shot, conversational posture
**Audio:** Background music fades in subtly
**Text overlay:** Optional — key phrase or none
- Brief setup: who, what, why this matters
- Keep it tight — no backstory dumps
- Pattern interrupt at 0:07-0:08 (camera angle change or text overlay)

### 3. Story / Value — 0:10-0:45 (bulk of the video)
**Word count:** 40-90 words
**Purpose:** Deliver on the hook's promise. Hold attention through the middle.
**Visual:** Mix of shots — talking head, B-roll, text overlays every 8-12 seconds
**Audio:** Music supports pacing — builds during tension, eases during reflection
**Text overlay:** Key points, numbers, or emphasis words
- The narrative arc: tension → escalation → payoff
- Pattern interrupts every 8-12 seconds
- Each section delivers a micro-payoff so the viewer keeps going
- Concrete details > abstract concepts

### 4. Punchline / CTA — final 3-5 seconds
**Word count:** 10-20 words
**Purpose:** Land the message and drive action
**Visual:** Back to close-up, direct eye contact
**Audio:** Music resolves or cuts
**Text overlay:** CTA text if applicable
- The payoff that the hook promised
- Follow with soft CTA: "Follow for more [specific thing]" or "Save this"
- Or: loop back to the hook for replay effect

---

## Pattern Interrupts
- 0:07-0:08: Camera angle change or B-roll cut (7-second cliff)
- 0:15-0:18: Text overlay or visual element
- 0:25-0:30: Energy shift, new visual, or sound effect
- 0:40+: Final build to punchline

## Hook Options
- "Stop wasting your mornings on routines that don't work."
- "Nobody told me this when I started [thing]."
- "I lost $20K because I ignored this one thing."
- "The one mistake that almost ended my [career/business/relationship]."

## Common Mistakes
- Starting with "Hey guys" or any throat-clearing
- Story is interesting but has no lesson or payoff
- Hook promises something the story doesn't deliver
- No pattern interrupts in the middle section
- CTA is generic ("follow for more!") instead of specific

## Filming Notes
- Start close for the hook, pull back for context, mix shots for story
- Record the hook 3-5 times — it's the most important take
- Film B-roll before or after the main take for cutaway material
- Leave room for text overlays in your framing (don't fill the entire frame with your face)
ENDOFFILE__script_tmpl_hsc

echo "  - hook-story-cta script template done"
cat > "$KIT_DIR/.claude/skills/script/templates/hot-take.md" << 'ENDOFFILE__script_tmpl_hot_take'
# Template: Hot Take

A deliberately polarizing opinion designed to split your audience into "totally agree" and "completely disagree" camps. Optimized for comments because controversy drives discussion.

**Optimal platforms:** TikTok, Reels, Shorts
**Target length:** 30-60 seconds
**Word count target:** 75-150 words
**Key mechanic:** Polarization → comments — the algorithm loves content that splits opinion

---

## Structure

### 1. The Take — 0:00-0:03
**Word count:** 5-12 words
**Purpose:** Drop the controversial opinion immediately
**Visual:** Close-up, confident, no hesitation
**Text overlay:** The take in bold text
- State it like a fact, not an opinion
- The stronger and more specific, the better
- Must be genuinely held — not just provocative for clicks

### 2. "Here's Why" — 0:03-0:10
**Word count:** 15-25 words
**Purpose:** Establish that this isn't random — you have reasoning
**Visual:** Slight pull back, conversational
- Bridge from the shocking take to the logical argument
- "And before you come at me in the comments, hear me out."

### 3. Supporting Arguments — 0:10-0:45
**Word count:** 30-80 words
**Purpose:** Build your case with evidence and logic
**Visual:** Mixed shots, text overlays for key evidence
**Text overlay:** Evidence points, numbers, examples
- 2-3 strong supporting points
- Use personal experience AND observable evidence
- Acknowledge the counter-argument briefly (shows intellectual honesty)
- Pattern interrupts every 8-12 seconds

### 4. Restatement + CTA — final 5-10 seconds
**Word count:** 10-20 words
**Purpose:** Stand by your take and invite debate
**Visual:** Back to close-up, confident
**Text overlay:** Restated take or "Agree or disagree?"
- Don't back down in the conclusion
- "Agree or disagree — tell me in the comments"
- The CTA is the debate itself

---

## Common Mistakes
- Take isn't actually controversial (everyone agrees)
- No supporting evidence (just yelling an opinion)
- Being offensive rather than thought-provoking
- Backing down at the end ("but that's just my opinion")
- Using this format too often (audience fatigue)
ENDOFFILE__script_tmpl_hot_take

echo "  - hot-take script template done"
cat > "$KIT_DIR/.claude/skills/script/templates/listicle.md" << 'ENDOFFILE__script_tmpl_listicle'
# Template: Listicle

"3 things I learned" / "5 mistakes to avoid" — the numbered list format. Viewers stay because completion expectation kicks in — they need to see all the items.

**Optimal platforms:** TikTok, Reels, Shorts
**Target length:** 30-60 seconds
**Word count target:** 75-150 words
**Key mechanic:** Completion expectation — viewers count along and stay to see all items

---

## Structure

### 1. Hook with Count — 0:00-0:03
**Word count:** 5-12 words
**Purpose:** Establish the list and why the viewer should care
**Visual:** Close-up, confident, text overlay with the number
**Text overlay:** "5 things..." or the number prominently displayed
- Lead with the number: "3 things nobody tells you about [X]"
- The number IS the hook — it tells the viewer how much time to invest

### 2. Brief Context — 0:03-0:06
**Word count:** 8-15 words
**Purpose:** Establish credibility for why you know these things
**Visual:** Same shot or slight angle change
**Text overlay:** None or subtitle only
- One sentence: "After 10 years of [experience], here's what I know."
- Skip this section if the hook already contains the context

### 3. Items — 0:06-0:50 (evenly divided)
**Word count per item:** 10-25 words
**Purpose:** Each item delivers a discrete insight
**Visual:** NEW visual treatment for each item (camera angle, text overlay, or B-roll)
**Text overlay:** Item number + headline for each
- Each item: number → headline → 1-2 sentence explanation
- Each item gets a visual reset (the pattern interrupt IS the new number)
- Build to the best item (save the strongest for last, or put it first)
- 3-5 items for 30s, 5-7 for 60s

### 4. Close — final 3-5 seconds
**Word count:** 8-15 words
**Purpose:** Drive saves and engagement
**Visual:** Back to close-up
**Text overlay:** "Save this" or "Which one hit?"
- "Which one hit hardest?" or "Save this for later"
- Or: "Number 6 is on my profile" (drives profile visits)

---

## Pattern Interrupts
- Each new number IS a pattern interrupt (visual change + text overlay)
- Between items: camera angle change, B-roll, or energy shift
- Before last item: brief pause or "and the biggest one..." build-up

## Common Mistakes
- Items too similar to each other (each must be distinct)
- Spending too long on context/intro before getting to the list
- Items too long — each should be 5-10 seconds max
- Not using visual cues for each number (viewers need to track progress)
- Generic items ("be consistent," "work hard") that add nothing

## Filming Notes
- Film each item as a separate take — easier to edit and rearrange
- Use different angles for different items to create visual variety
- Pre-plan text overlays: number + 2-4 word headline per item
ENDOFFILE__script_tmpl_listicle

echo "  - script listicle template done"
cat > "$KIT_DIR/.claude/skills/script/templates/myth-bust.md" << 'ENDOFFILE__script_tmpl_myth_bust'
# Template: Myth-Bust

"Stop doing X" / "Everything you know about X is wrong." Cognitive dissonance is the engine — challenge what the viewer believes, then replace it with something better.

**Optimal platforms:** TikTok, Reels, Shorts
**Target length:** 30-60 seconds
**Word count target:** 75-150 words
**Key mechanic:** Cognitive dissonance — viewer needs resolution after their belief is challenged

---

## Structure

### 1. Myth Statement — 0:00-0:03
**Word count:** 5-10 words
**Purpose:** State the myth directly and boldly
**Visual:** Close-up, slightly confrontational energy
**Text overlay:** The myth in bold, crossed out or with "WRONG" stamp
- "Stop [common practice]" or "No, [common belief] is NOT true"
- Present it as something the viewer probably believes RIGHT NOW

### 2. Why People Believe It — 0:03-0:08
**Word count:** 12-20 words
**Purpose:** Show you understand the other side (builds credibility before the takedown)
**Visual:** Medium shot, understanding tone
**Text overlay:** None or "What most people think:"
- "I get why everyone says this..." or "It makes sense on the surface..."
- Brief — just enough to show you're not dismissing them

### 3. The "Actually..." Pivot — 0:08-0:10
**Word count:** 5-10 words
**Purpose:** The turn. Energy shift that signals the real insight is coming.
**Visual:** Camera angle change, lean in, or visual cut
**Text overlay:** "But here's the thing..." or "Actually..."
- This is the hinge. Make it feel like a revelation.
- Pattern interrupt: change something visual to mark the shift

### 4. The Truth + Evidence — 0:10-0:45
**Word count:** 30-80 words
**Purpose:** Replace the myth with your better understanding
**Visual:** Alternating between talking head and B-roll/text overlays
**Text overlay:** Key evidence points, numbers, or quotes
- 2-3 supporting points for why the truth is different
- Use specific evidence: numbers, personal experience, examples
- Pattern interrupts every 8-12 seconds

### 5. Reframe / CTA — final 5 seconds
**Word count:** 10-15 words
**Purpose:** Give the viewer the new mental model
**Visual:** Close-up, confident
**Text overlay:** The new truth stated simply
- "So instead of [myth], try [truth]"
- CTA: "Save this before you forget" or challenge question

---

## Hook Options
- "Stop wasting money on [common thing]."
- "No, [popular advice] will NOT make you [desired outcome]."
- "Everything you've heard about [X] is wrong."
- "[Popular practice]? That's actually hurting you."

## Common Mistakes
- Being contrarian without real evidence (just being provocative)
- Not acknowledging WHY the myth exists (feels dismissive)
- The "truth" being just as vague as the myth
- Spending too long on the myth and not enough on the alternative
ENDOFFILE__script_tmpl_myth_bust

echo "  - myth-bust script template done"
cat > "$KIT_DIR/.claude/skills/script/templates/pov.md" << 'ENDOFFILE__script_tmpl_pov'
# Template: POV

"POV: you're a..." — immersive, relatable content where the viewer sees themselves in the scenario. Often the most shareable format because viewers tag friends.

**Optimal platforms:** TikTok, Reels
**Target length:** 20-40 seconds
**Word count target:** 50-100 words (often minimal speech)
**Key mechanic:** Self-identification — viewer instantly projects themselves into the scenario

---

## Structure

### 1. POV Text Setup — 0:00-0:02
**Word count:** 3-8 words (text overlay only)
**Purpose:** Set the scenario instantly
**Visual:** Text overlay dominates. Creator may or may not be visible yet.
**Text overlay:** "POV: you're a [specific person] who [specific situation]"
- Must be specific enough that the RIGHT viewer thinks "that's me"
- The text IS the hook

### 2. Scene / Reaction — 0:02-0:30
**Word count:** 15-60 words (mostly visual/reaction)
**Purpose:** Play out the scenario in a relatable way
**Visual:** Acting out the scenario — facial expressions, gestures, actions
**Audio:** Trending audio or original — music carries the mood
**Text overlay:** Commentary or internal monologue captions
- Show, don't tell — this format is visual-first
- Exaggeration is expected and appreciated
- The humor or truth comes from HOW relatable it is

### 3. Punchline / Twist — final 3-5 seconds
**Word count:** 5-15 words
**Purpose:** The payoff — the unexpected twist or the too-real moment
**Visual:** Reaction shot or unexpected visual
**Text overlay:** The punchline if it's text-based
- Either a funny escalation or a surprisingly sincere moment
- Best POVs end with "...and then [unexpected thing]"

---

## Hook Options (Text Overlays)
- "POV: you're a [profession] on your 47th Zoom call today"
- "POV: you're explaining your job to your parents for the 5th time"
- "POV: you finally tried [thing everyone recommends]"

## Common Mistakes
- POV too broad ("POV: you're stressed") — needs specificity
- Over-scripting what should feel spontaneous
- No payoff at the end — just a recreation without a punchline
- Using POV when a talking-head format would be more effective

## Filming Notes
- Acting ability matters here more than any other format
- Trending audio can carry the video — choose carefully
- Minimal talking, maximum showing
- Phone/front-facing camera feel is authentic for this format
ENDOFFILE__script_tmpl_pov

echo "  - pov script template done"
cat > "$KIT_DIR/.claude/skills/script/templates/stitch-react.md" << 'ENDOFFILE__script_tmpl_stitch'
# Template: Stitch-React

React to someone else's content — add your perspective, challenge their take, or build on their idea. Borrows their audience while establishing your own authority.

**Optimal platforms:** TikTok (strongest — stitch is native), Reels, Shorts
**Target length:** 30-60 seconds
**Word count target:** 75-150 words
**Key mechanic:** Borrowed audience — their followers discover you through the reaction

---

## Structure

### 1. Source Clip / Setup — 0:00-0:05
**Word count:** 0 (it's their content) or 5-10 (if describing rather than stitching)
**Purpose:** Set up what you're reacting to
**Visual:** The original clip (stitch) or you describing it
**Text overlay:** Source credit, context if needed
- Keep the source clip SHORT — just enough to establish the claim
- If not stitching: "Someone said [claim]. Let me respond."

### 2. Your Reaction — 0:05-0:10
**Word count:** 10-15 words
**Purpose:** Your immediate, genuine response
**Visual:** Your face — real reaction, not performed
**Text overlay:** Your one-line take
- This is the hook within the react — your take must be strong
- "They're wrong." / "They're right, but they missed something." / "This changed how I think about [X]."

### 3. Your Perspective — 0:10-0:50
**Word count:** 40-100 words
**Purpose:** Deliver your value — why your take matters
**Visual:** Talking head with B-roll or text overlays for evidence
**Text overlay:** Key points
- 2-3 supporting points
- Add something the original didn't cover
- Use your niche expertise to go deeper
- Pattern interrupts every 8-12 seconds

### 4. Close — final 5 seconds
**Word count:** 10-15 words
**Purpose:** Land your perspective + CTA
**Visual:** Close-up, direct
**Text overlay:** Your conclusion
- Restate your take concisely
- "Follow for more [niche] breakdowns"

---

## Common Mistakes
- Being mean-spirited instead of thoughtful (react ≠ attack)
- Source clip too long (eating into YOUR content time)
- No original value — just agreeing without adding anything
- Not crediting the original creator
ENDOFFILE__script_tmpl_stitch

echo "  - stitch-react script template done"
cat > "$KIT_DIR/.claude/skills/script/templates/storytime.md" << 'ENDOFFILE__script_tmpl_storytime'
# Template: Storytime

Longer narrative format. Pure storytelling with a beginning, middle, and end. Works because humans are biologically wired for story completion — once a story starts, we need to know how it ends.

**Optimal platforms:** TikTok (strongest for longer content), Shorts
**Target length:** 60-180 seconds
**Word count target:** 150-450 words
**Key mechanic:** Story completion drive — once the narrative starts, the viewer NEEDS the ending

---

## Structure

### 1. Hook — In Medias Res — 0:00-0:03
**Word count:** 5-12 words
**Purpose:** Drop into the most dramatic moment of the story
**Visual:** Close-up, intensity that matches the moment
**Text overlay:** "Storytime:" or the most dramatic line
- Start at the peak of tension, not the beginning
- "So I'm standing in the CEO's office and he says..."
- The viewer needs to think "wait, what happened?"

### 2. "Let Me Back Up" — 0:03-0:08
**Word count:** 10-20 words
**Purpose:** Signal that you're going to explain how you got here
**Visual:** Settle into storytelling posture, medium shot
**Text overlay:** None — let the story breathe
- "Let me back up." / "Okay so here's how this started."
- Brief — just a transition to the beginning

### 3. Setup — 0:08-0:30
**Word count:** 30-55 words
**Purpose:** Establish the normal world before things change
**Visual:** Conversational, B-roll illustrating the situation
**Audio:** Subtle background music building slowly
- Who, where, when — just enough context
- Plant the details that will matter later
- Keep it moving — viewers are waiting for the tension

### 4. Rising Tension — 0:30-1:30
**Word count:** 50-150 words
**Purpose:** Build toward the climax with escalating stakes
**Visual:** Mix of talking head, B-roll, text overlays
**Text overlay:** Key moments, dramatic quotes
- Each beat raises the stakes
- Pattern interrupts every 10-12 seconds
- Dialogue (quoted speech) creates intimacy
- "And then she said..." moments are goldmine retention points

### 5. Climax / Reveal — 5-10 seconds before end
**Word count:** 15-30 words
**Purpose:** The payoff everyone stayed for
**Visual:** Back to close-up, emotional delivery
**Audio:** Music peaks or goes silent for impact
- This must satisfy the promise of the hook
- The twist, the answer, the resolution
- Emotional delivery matters — this is the money moment

### 6. Lesson / Close — final 5 seconds
**Word count:** 10-20 words
**Purpose:** The universal takeaway
**Visual:** Direct, genuine
**Text overlay:** The lesson in a few words
- One sentence that turns a personal story into universal wisdom
- CTA: "Follow for more stories" or "Part 2?"

---

## Common Mistakes
- Linear storytelling (starting from the beginning instead of in medias res)
- Too much setup, not enough tension
- No payoff — the story just kind of ends
- Monologue with no visual variety (talking head for 3 minutes straight)
- Story is interesting but has no lesson or relevance to the viewer

## Filming Notes
- The hook moment should be re-performed with intensity — it's the most important shot
- Film B-roll that illustrates key story beats
- Vary your camera distance throughout — close for emotional, wide for scene-setting
- This is the format where your acting ability matters most
ENDOFFILE__script_tmpl_storytime

echo "  - storytime script template done"
cat > "$KIT_DIR/.claude/skills/script/templates/transformation.md" << 'ENDOFFILE__script_tmpl_transformation'
# Template: Transformation

Before/after content. The human brain is wired to detect change — contrast between two states creates an irresistible viewing experience.

**Optimal platforms:** TikTok, Reels, Shorts
**Target length:** 30-60 seconds
**Word count target:** 75-150 words
**Key mechanic:** Contrast/change detection — the gap between before and after creates satisfaction

---

## Structure

### 1. Hook — Contrast Statement — 0:00-0:03
**Word count:** 5-12 words
**Purpose:** Establish the transformation gap
**Visual:** "Before" state or split-screen tease
**Text overlay:** The transformation in numbers or timeframe
- "3 months ago vs. today" or "What [X] looked like before and after [change]"

### 2. "Before" State — 0:03-0:15
**Word count:** 15-30 words
**Purpose:** Make the starting point vivid and relatable
**Visual:** Show the "before" — raw, unpolished, real
**Text overlay:** "Before:" label
- Paint the pain point. Be specific about what was wrong.
- The more relatable the "before," the more powerful the "after"

### 3. The Process — 0:15-0:40
**Word count:** 25-50 words
**Purpose:** Show what changed (the how, briefly)
**Visual:** Montage of the work, effort, or steps taken
**Audio:** Music builds during this section
**Text overlay:** Key milestones or actions
- Don't over-explain — montage the highlights
- Pattern interrupts every 8-12 seconds
- This section should FEEL like effort and progress

### 4. "After" Reveal — 0:40-0:55
**Word count:** 15-25 words
**Purpose:** The payoff — show the transformation
**Visual:** The "after" state — polished, impressive, contrasting
**Audio:** Music peaks or drops for dramatic effect
**Text overlay:** "After:" or specific results
- Make the reveal feel earned by the process section
- Specifics over vague improvement ("0 to 50K followers" not "I grew my audience")

### 5. Close — final 5 seconds
**Word count:** 8-15 words
**Purpose:** Universal takeaway + CTA
**Visual:** Close-up, genuine
**Text overlay:** Key lesson or "save this"
- The principle behind the transformation
- "If I can do it, so can you" (only if genuine)

---

## Common Mistakes
- "Before" isn't bad enough or "after" isn't good enough (weak contrast)
- Skipping the process section (viewers want to see the work)
- Inauthentic transformations that feel staged
- No lesson — just showing off without a takeaway
ENDOFFILE__script_tmpl_transformation

echo "  - transformation script template done"
cat > "$KIT_DIR/.claude/skills/script/templates/trend-adapt.md" << 'ENDOFFILE__script_tmpl_trend_adapt'
# Template: Trend-Adapt

A meta-template for adapting trending formats to your niche. This is not a fixed structure — it's a framework for taking what's currently viral and making it yours.

**Optimal platforms:** TikTok (strongest — algorithm rewards trend participation), Reels
**Target length:** Varies (match the trending format's typical length)
**Word count target:** Varies
**Key mechanic:** Algorithm boost — platforms push content that uses trending formats/sounds

---

## Structure

### 1. Identify the Trend
- What format is trending? (a specific transition, audio, structure, or visual style)
- What makes it work? (the underlying mechanic — humor, surprise, relatability)
- How can your niche adapt it? (same structure, different content)

### 2. Adapt the Structure
- Keep the STRUCTURE of the trend intact (timing, pacing, transitions)
- Replace the CONTENT with your niche expertise
- Keep the trending audio if applicable

### 3. Add Your Persona
- The adaptation should feel natural to your on-camera persona
- Don't force a trend that doesn't fit your energy or niche
- Best adaptations feel like "this trend was made for [your topic]"

### 4. Niche-Specific Twist
- The best trend adaptations add something unexpected
- Your niche knowledge IS the twist
- "Everyone's doing this trend about [general topic], but here's how it applies to [your niche]"

---

## How to Use This Template

1. Check `content/my-content/playbook.md` for current trends from `/research-trends`
2. Check `creators.yaml` format_trends for documented trends
3. Pick a trend that maps naturally to your niche and persona
4. Write the script following the trend's structure but with your content and voice
5. Note in frontmatter: `trend_source: "[description of trend]"`

## Common Mistakes
- Forcing a trend that doesn't fit your niche (viewers can tell)
- Arriving too late to a trend (check trending dates)
- Copying exactly without any adaptation (adds nothing)
- Ignoring the trend's timing/pacing (the structure IS the trend)

## Filming Notes
- Watch 5-10 examples of the trend before filming your version
- Match the original timing as closely as possible
- Use the original audio if it's trending
ENDOFFILE__script_tmpl_trend_adapt

echo "  - trend-adapt script template done"
cat > "$KIT_DIR/.claude/skills/script/templates/tutorial.md" << 'ENDOFFILE__script_tmpl_tutorial'
# Template: Tutorial

How-to / step-by-step instruction. The key: SHOW THE RESULT FIRST. The viewer needs to see the payoff before investing in the process.

**Optimal platforms:** Shorts (strongest), Reels, TikTok
**Target length:** 30-90 seconds
**Word count target:** 75-225 words
**Key mechanic:** Utility promise — viewer stays because they want to learn the skill

---

## Structure

### 1. Result First — 0:00-0:03
**Word count:** 5-10 words
**Purpose:** Show the end result before explaining how
**Visual:** The finished product, outcome, or demonstration
**Text overlay:** "Here's how to [achieve result]"
- "Here's the finished product. Let me show you how."
- The result creates desire → desire creates watch-through

### 2. "Here's How" Transition — 0:03-0:05
**Word count:** 5-8 words
**Purpose:** Transition from result to instruction
**Visual:** Cut to setup / starting point
**Text overlay:** "Step 1:" or "Here's how:"
- Quick, clean transition. No rambling setup.

### 3. Steps — 0:05-0:75 (bulk of video)
**Word count per step:** 15-30 words
**Purpose:** Clear, actionable instruction
**Visual:** Show each step being performed. Screen recording for digital tutorials.
**Text overlay:** Step number + action for each step
- Each step: number → action → brief explanation → show it happening
- 3-5 steps for 30-60s, 5-7 for 60-90s
- Keep explanations tight — show > tell
- Pattern interrupt at each new step (visual change + text overlay)

### 4. Final Result Again — final 3-5 seconds
**Word count:** 8-15 words
**Purpose:** Confirm the payoff and drive saves
**Visual:** The finished result again, same as opening
**Text overlay:** "Save this for later" or "Try it yourself"
- Loop opportunity: ending matches the opening
- CTA: "Save this" (tutorials get massive save rates)

---

## Common Mistakes
- Starting with a long explanation instead of the result
- Steps too complicated or too many for the video length
- Not showing each step visually (just talking about it)
- Forgetting captions (tutorials are often watched sound-off and saved)

## Filming Notes
- Film the result first, then the steps
- Screen recording with cursor highlighting for digital tutorials
- Close-up shots for physical tutorials (hands visible)
- Pre-plan text overlays for each step number
ENDOFFILE__script_tmpl_tutorial

echo "  - tutorial script template done"
cat > "$KIT_DIR/.claude/skills/shortform-setup/SKILL.md" << 'ENDOFFILE__shortform_setup_skill'
# /shortform-setup

Derive an 8-dimension on-camera persona profile from the central brand identity. Video is a spoken, visual medium — this produces a persona profile, not a writing style profile.

## Trigger

Activate when `kits/shortform/identity/persona-profile.md` is missing or empty and the user wants to create a video script.

## Prerequisites

`brand/identity/brand-document.md` and `brand/identity/voice-guide.md` must exist. If missing, route to `/brand setup` first.

## Process

### Step 1 — Read the Brand

Read central brand documents. Summarize:
> "I know your brand — [summary]. Now I need to capture how you come across on camera. This is different from writing — it's about your energy, your delivery, your on-screen personality."

### Step 2 — Three Input Modes

Ask what they have:

**Mode A: Existing Videos (best)**
> "Do you have any existing videos? Links to TikToks, Reels, or Shorts? Or even transcripts? 3-5 videos is ideal."

Analyze all 8 dimensions. Ask about visual elements not captured in transcripts.

**Mode B: Creator Emulation**
> "Is there a creator whose on-camera style you want to be inspired by? I can study their approach and build your persona from that, then we'll adjust it to make it yours."

Process: Research creator → build baseline persona → interview for differences → result is "inspired by," never a clone.

**Mode C: Interview (when they have nothing)**
> "No videos yet? That's fine. I'll ask you some questions about how you'd show up on camera. We can also pick a creator you admire as a starting point.
>
> Fair warning: the persona will be more accurate once you've filmed a few things and I can study the real you. But this gets us started."

Also check `brand/identity/writing-samples/` — written voice gives clues about spoken voice.

### Step 3 — Build 8-Dimension Persona Profile

1. **Energy & Pace** — high/low energy, fast/slow talker, intense vs chill, how they use pauses
2. **Hook Style** — how they open (direct claim, "you" statement, mid-story, question, pattern interrupt). Speed of hook (under 1 second? 3 seconds?)
3. **Speaking Voice & Language** — vocabulary on camera, slang, catchphrases, filler words they use or avoid, sentence complexity when speaking
4. **Humor & Personality** — dry, sarcastic, goofy, none? Do they use irony? Self-deprecation? Pop culture references?
5. **Visual Presentation** — talking head vs B-roll heavy, text overlays, camera angles, background style, props
6. **Structure & Pacing** — how they build a video (linear, loop, reveal), pattern interrupts, retention hooks, pacing changes
7. **Authority & Relatability** — expert teaching down vs peer sharing, vulnerability level, how they establish credibility
8. **CTA & Closing Patterns** — how they end (direct CTA, soft ask, open question, cliffhanger), follow button prompt style

### Step 4 — Platform & Config

Ask:
- Which platforms? (TikTok, Reels, Shorts, all)
- Niche
- Posting frequency
- Preferred video length (15s, 30s, 60s, 90s)

### Step 5 — Inspiration

> "What video creators do you watch and think 'I want to make content like that'?"

Note: Video references are harder to analyze than text. For now, focus on best practices and trend research. Say: "Video inspiration analysis is expanding soon — for now I'll note your references and use your playbook of platform best practices."

Save to `kits/shortform/inspirations/` and `sources.yaml` under `video_creators`.

### Step 6 — Save and Confirm

Save to `kits/shortform/identity/persona-profile.md`:

```markdown
---
version: 1
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
medium: shortform-video
derived_from_brand_version: [version]
input_mode: [videos/emulation/interview]
confidence: [high/medium/low]
---

# On-Camera Persona Profile

## Persona DNA — Quick Reference
[3-5 bullet summary of how they show up on camera]

## Energy & Pace
[analysis]

## Hook Style
[analysis]

## Speaking Voice & Language
[analysis]

## Humor & Personality
[analysis]

## Visual Presentation
[analysis]

## Structure & Pacing
[analysis]

## Authority & Relatability
[analysis]

## CTA & Closing Patterns
[analysis]

## Do
- [On-camera pattern] — *Example: "[how they'd say it]"*

## Don't
- [Anti-pattern] — *Instead: "[their version]"*
```

Present for approval. Then: "Your on-camera persona is set up. What's your first video about?"

## Output
- `kits/shortform/identity/persona-profile.md`
ENDOFFILE__shortform_setup_skill

echo "  - shortform-setup SKILL.md done"
cat > "$KIT_DIR/.claude/skills/study-creator/SKILL.md" << 'ENDOFFILE__study_creator_skill'
# /study-creator

Deep-dive a creator's content patterns. Context-aware — analyzes visual design for carousel creators, writing patterns for LinkedIn creators, or both.

## Trigger

Activate when the user says "study how [creator] does carousels", "analyze [creator]'s LinkedIn", "study [creator]", or similar.

## Context Detection

Determine which analysis to run:
- **Carousel signals:** "carousels", "design", "slides", "visual", "Instagram" → Visual analysis
- **LinkedIn signals:** "LinkedIn", "posts", "writing" → Writing analysis
- **Ambiguous:** Ask — "Should I study their carousel design style, their LinkedIn writing style, or both?"

## Carousel Analysis (Visual Focus)

1. Research the creator's carousel content. If Chrome is available, visit their Instagram/LinkedIn to see actual posts.
2. Analyze:
   - **Cover slide patterns** — headline style, visual hierarchy, hook approach
   - **Slide structure** — info density per slide, build-up patterns, pacing
   - **Design system** — colors, fonts, layout patterns, visual elements
   - **Copy style** — headline writing, body text density, CTA approach
   - **Engagement patterns** — what formats get most engagement
3. Save study to `kits/carousel/identity/creator-studies/[creator-name].md`
4. Offer: "Want me to incorporate any of their techniques into your carousel style?"

## LinkedIn Analysis (Writing Focus)

1. Research the creator's LinkedIn content. If Chrome is available, visit their profile.
2. Analyze across 10 dimensions:
   - 7 base writing dimensions (sentence architecture, vocabulary, tone, rhetorical patterns, perspective, rhythm, personality)
   - 3 LinkedIn-specific (hook patterns, formatting DNA, engagement patterns)
3. Save study to `kits/linkedin/identity/creator-studies/[creator-name].md`
4. Offer: "Want me to incorporate any of their techniques into your LinkedIn style?"

## Integration

If the user wants to adopt specific techniques:
1. Identify exactly which techniques to borrow
2. Show before/after of how the user's profile would change
3. Update the kit's style profile on approval
4. Note: "Inspired by [creator]" in the Do section — never clone, always adapt

## Output
- `kits/carousel/identity/creator-studies/[name].md` or
- `kits/linkedin/identity/creator-studies/[name].md`
ENDOFFILE__study_creator_skill

echo "  - study-creator SKILL.md done"
cat > "$KIT_DIR/.claude/skills/tldr/SKILL.md" << 'ENDOFFILE__tldr_skill'
# TLDR Skill

Generate a single-sentence teaser that makes readers *need* to read the full piece. Not a summary — a curiosity hook.

## Trigger

Activate when the user says `/tldr` or asks for a TLDR, teaser, preview line, or hook sentence for a newsletter or article.

## Important — Communication Style

The client is not technical. All communication must be warm, clear, and in plain language. Never show file paths, config details, or internal process mechanics unless she explicitly asks.

---

## What a TLDR Is (and Isn't)

A TLDR in this system is **not a summary.** It's the opposite — it's a curiosity engine. The reader should finish the TLDR sentence and feel an itch they can only scratch by reading the full piece.

**What it is:**
- One sentence (occasionally two short ones)
- Opens a curiosity gap — gives enough to hook, not enough to satisfy
- Captures the core *tension* or *surprise* of the piece, not the conclusion
- Written in the client's voice

**What it is NOT:**
- A summary of the article's main points
- A thesis statement
- A table of contents ("In this issue, I cover...")
- A generic teaser ("You won't believe what happened next")

### Examples of good vs. bad

**Bad:** "This newsletter is about why most founders struggle with hiring." (Summary — no gap)

**Bad:** "In this issue, I discuss three frameworks for better hiring decisions." (Table of contents — no pull)

**Bad:** "Hiring is one of the most important things a founder does." (Obvious statement — no tension)

**Good:** "Most founders think their hiring problem is finding talent — it's actually something they're doing in the first 5 minutes of every interview."

**Good:** "I spent 3 years hiring for culture fit before I realized culture fit was the thing destroying my culture."

**Good:** "There's a question I ask in every interview now that has nothing to do with the job — and it's the only one that actually predicts success."

The pattern: **specific enough to be intriguing, incomplete enough to demand the full read.**

---

## Process

### Step 1: Load voice

Read `identity/style-profile.md` fresh. The TLDR must sound like the client wrote it — same rhythm, same vocabulary, same tone. A perfectly crafted hook in the wrong voice is useless.

### Step 2: Deep analysis

Read the full piece carefully. Do not skim. Identify:

1. **The core argument** — What is this piece actually saying? Not the topic, the *point*. Strip away all supporting material and find the one sentence that everything else serves.

2. **The surprise** — What's the most counterintuitive, unexpected, or contrarian element? This is often the best hook material. Look for:
   - Conventional wisdom being challenged
   - An unexpected cause-and-effect relationship
   - A paradox or contradiction
   - A specific detail that reframes the whole topic

3. **The tension** — What's the central conflict, question, or unresolved problem? What makes someone care about this *before* they know the answer?

4. **The specificity** — Find the most concrete, vivid detail in the piece. Specificity creates credibility and curiosity simultaneously. A TLDR that says "a surprising thing about hiring" is weaker than one that says "something that happens in the first 5 minutes of every interview."

### Step 3: Craft the TLDR

Using the analysis above, write one sentence that:

- **Opens a curiosity gap** — Gives the reader enough to understand the territory, but withholds the resolution
- **Uses the surprise or tension** as the hook mechanism
- **Includes at least one specific detail** — a number, a timeframe, a named thing, a concrete action
- **Matches the client's voice** — sentence length, vocabulary, tone, and rhythm from the style profile
- **Stands alone** — Makes sense without any context. Someone seeing just this sentence (in an email preview, a social post, an RSS feed) should feel pulled to read more

### Step 4: Generate alternatives

Produce 3 TLDR options using different hook strategies:

1. **The gap** — States something surprising but withholds the key detail ("There's one question I stopped asking in interviews — and it doubled my retention rate.")
2. **The flip** — Inverts an assumption ("The best hire I ever made was the person who failed my interview.")
3. **The specificity** — Leads with a vivid, concrete detail that raises questions ("It took exactly 11 minutes for me to realize I'd been hiring wrong for a decade.")

Not every strategy works for every piece. If one feels forced, replace it with a natural alternative. The goal is variety in approach, not forced adherence to a formula.

### Step 5: Present to the client

Show all 3 options with brief context on why each works differently:

> "Here are three TLDR options for the top of your piece:"
>
> 1. [Option 1]
> 2. [Option 2]
> 3. [Option 3]
>
> "I'd go with #[N] — [one-line reason]. But pick whichever sounds most like you."

Wait for the client to choose. If they want to tweak one, help them refine it.

### Step 6: Place it

Once chosen, add the TLDR to the top of the newsletter draft, immediately after the frontmatter and subject line block, before the content begins:

```markdown
**TLDR:** [chosen teaser line]

---

[Newsletter content starts here]
```

Save the updated draft file.

---

## Standalone Mode

When invoked on its own (`/tldr` or "write a TLDR for my latest draft"):

1. Find the most recent draft in `newsletters/*/drafts/` (by date in filename)
2. If multiple newsletters exist and it's unclear which one, ask the client
3. Run the full process above
4. Save the updated draft with the TLDR added

If the client pastes or references a specific piece of text (not a saved draft), run the analysis on that text and present the options without saving.

---

## Integration with Newsletter Skill

When called as part of the `/newsletter` flow (Phase 5), the process is the same but the interaction is streamlined:

> "Want a TLDR for the top? It's a one-line teaser that hooks readers before they start — great for email previews and social sharing."

If yes, generate and present options. If no, skip and move on. Do not push — some clients prefer to jump straight into the piece.

---

## Self-Edit

Before presenting TLDR options, check each one against:

1. **Curiosity test** — Does this make you want to read the piece? If the TLDR satisfies the reader's curiosity, it failed. It should *create* curiosity, not resolve it.
2. **Specificity test** — Is there at least one concrete detail? Vague teasers feel generic.
3. **Voice test** — Does this sound like the client? Check against `style-profile.md`.
4. **Standalone test** — Does it make sense without any surrounding context?
5. **Honesty test** — Does the TLDR accurately represent what the piece delivers? It should hook without misleading.

If any option fails a test, revise it before presenting.

---

## Rules

- Never summarize the article. The TLDR replaces nothing — it adds pull.
- Never reveal the main conclusion or punchline. The TLDR opens a door; the article walks through it.
- Never use clickbait formulas ("You won't believe...", "This one weird trick..."). The hook should feel like the client's voice, not a content mill.
- Never use the word "TLDR" in the teaser itself. The label is in the formatting; the sentence is pure content.
- Always match the client's voice. A great hook in the wrong voice is worse than no hook at all.
- Always offer options. Different readers respond to different hook types. Give the client choice.
ENDOFFILE__tldr_skill

echo "  - tldr SKILL.md done"
cat > "$KIT_DIR/.claude/skills/update/SKILL.md" << 'ENDOFFILE__update_skill'
# /update

Check for and install updates to your newsletter tool. This updates the skills, templates, and system files while leaving all your personal files (brand profile, style profile, writing samples, sources, and drafts) untouched.

## Trigger

Activate when the user says `/update` or asks to update, upgrade, or check for new features.

## Instructions

### 1. Check if this is a git repo

Run `git status` to confirm the project is a git repository with a remote configured.

If it is NOT a git repo (no `.git` folder), tell the client:

> "It looks like your newsletter folder isn't connected to the update system. This can happen if the folder was copied instead of cloned. I can connect it now — this won't change any of your files. Want me to go ahead?"

If they say yes:
1. Run `git init`
2. Run `git remote add origin https://github.com/anurieli/ai-newsletter-kit.git`
3. Run `git fetch origin`
4. Run `git reset --mixed origin/main` — this aligns the history without touching any local files
5. Continue to Step 2

If they say no, stop.

### 2. Check for updates

Run:
```
git fetch origin
git log HEAD..origin/main --oneline
```

If there are no new commits, tell the client:

> "You're all up to date! No new changes available."

Stop here.

If there ARE new commits, read the commit messages to understand what changed.

### 3. Protect user files

Before pulling, verify that the user's personal files won't be affected. Run:
```
git diff origin/main -- identity/brand-profile.md identity/style-profile.md sources.yaml newsletters/
```

If this diff is empty (it should be — these files should be gitignored), proceed safely.

If for any reason user files WOULD be affected, stop and warn the client:

> "I found an update that would change some of your personal files. I'm going to skip this update to keep your stuff safe. Let me know if you want to look into this together."

Do NOT proceed with the pull.

### 4. Pull the updates

Run:
```
git pull origin main
```

If there are merge conflicts, do NOT attempt to resolve them automatically. Tell the client:

> "There's a conflict between your local changes and the update. This is unusual — let me know and we can sort it out together."

### 5. Summarize what changed

Read the new commit messages and summarize the changes in plain, friendly language. Group by what the client cares about:

- **New features** — new skills, new templates, new capabilities
- **Improvements** — better drafting, smarter voice matching, etc.
- **Fixes** — bugs that were squashed

Example:

> "Updated! Here's what's new:
>
> - **Smarter voice learning** — I'm now better at picking up on your style preferences when you give feedback on drafts.
> - **New deep dive template** — a longer-form option for when you want to go deep on a single topic.
>
> All your personal files (brand, voice, sources, drafts) are exactly as you left them."

Always end by reassuring them their personal files are untouched.

## Rules

- **Never touch user files.** Brand profile, style profile, writing samples, sources, drafts, and newsletter configs are sacred. This skill only updates system files (skills, templates, agents, docs).
- **Plain language only.** Never show git output, diffs, or technical details unless the client asks. They should hear "you're updated" not "git pull origin main succeeded."
- **When in doubt, don't pull.** If anything looks risky — merge conflicts, user files in the diff, unexpected state — stop and explain rather than forcing it.
- **Be brief.** This should feel like a 5-second check, not a process. Get in, update, summarize, done.
ENDOFFILE__update_skill

echo "  - update SKILL.md done"
cat > "$KIT_DIR/HOW-TO-USE.md" << 'ENDOFFILE__how_to_use'
# How to Use This

This is the detailed guide for everything you can do with the AI Creator Kit. You don't need to memorize any of this — just talk naturally. But if you want to know what's possible, it's all here.

---

## First time? Start here

Open this folder in Claude and say anything. Claude will:

1. **Build your brand** (20-30 min) — Who you are, how you sound, what your brand looks like. If you have existing brand docs, writing samples, or visual references, drop them in during this step.

2. **Set up your first engine** (5-10 min) — Tell Claude what you want to create ("write a newsletter", "make a carousel", etc.) and it'll tune your voice for that specific medium.

3. **Create** — From here on, you just say what you want and Claude handles the rest.

---

## Creating content

### Newsletters

```
Write a newsletter about why most people overthink their first hire
Draft something about the difference between being busy and being productive
I want to write about pricing — riff on Hormozi's value equation
What should I write about this week?
```

Claude researches the topic (including browsing your inspiration sources in Chrome if connected), drafts in your voice using one of 4 templates (standard weekly, deep dive, curated links, announcement), self-edits, and saves.

After a draft: "Write a TLDR for this" adds a one-sentence curiosity hook at the top.

### Carousels

```
Make a carousel about why most startups fail at hiring
Create a step-by-step carousel on setting up a morning routine
Give me a myth-bust carousel about passive income
```

Claude picks from 10 templates (educational, storytelling, step-by-step, before/after, myth-bust, data-driven, quote-series, case-study, hot-take, curated-list), writes 5 cover slide options, drafts every slide with copy AND design direction (colors, fonts, layout, visual elements).

### LinkedIn posts

```
Write a post about why most companies hire wrong
I had this experience today — turn it into a post
Write a contrarian take on remote work
Help me with hooks for a post about delegation
```

Claude writes 10 hook options (with character counts), a rehook, the full draft, and self-edits against your voice, brand, and LinkedIn's algorithm. Targets 1,300-1,900 characters. AI-detection defense built in.

### Short-form video scripts

```
Write a script about why morning routines fail
Script a myth-bust about passive income
Give me a hot take script on hustle culture
```

Claude picks from 11 templates, writes hooks, drafts the full script with timestamps, visual direction, text overlay specs, and a filming guide with shot list.

---

## Batching content

Create a week's worth of content in one session:

```
Give me 5 LinkedIn posts for the week
Batch my carousels for next week
Write 3 newsletters for the month
Give me a week of scripts
```

Claude checks your content pillars and post history to ensure variety — different templates, different topics, different hooks. Every piece is saved as its own draft.

---

## Managing your brand

### See your current brand
```
/brand
Who am I?
Show me my brand
```

### Evolve your brand
```
/brand evolve
I want to sound more concise
Make me less corporate and more direct
My audience has shifted to enterprise buyers
Here are new visual references [drop files]
I want to be more like @creator — show me what that would look like
```

Claude shows before/after on every change. You approve, it updates. Every content engine picks up the change automatically.

### Refresh a specific engine's style
After evolving your brand, you can re-derive any engine's medium-specific profile:
```
Refresh my newsletter style
Refresh my LinkedIn style
Refresh my carousel style
Refresh my shortform persona
```

---

## Managing sources and inspiration

### Add inspiration sources
```
Add Seth Godin to my sources
Add Lenny's Newsletter
Add this creator to my carousel inspiration
Who are my current sources?
```

### Browse what they're writing about
```
What has Lenny's Newsletter been writing about lately?
Go check what Morning Brew published this week
Read Stratechery's latest
```
(Requires Chrome connection for live browsing)

### Study a creator's style
```
Study how Justin Welsh writes on LinkedIn
Analyze how @creator designs carousels
```

Claude deep-dives into their content, identifies patterns, and offers to incorporate specific techniques into your style.

### Per-engine inspirations

Each engine has its own inspirations folder for examples specific to that medium:

- **Newsletter:** Drop newsletters or long-form writing you like into `kits/newsletter/inspirations/`
- **Carousel:** Drop screenshots of carousels you admire into `kits/carousel/inspirations/screenshots/`
- **LinkedIn:** Drop screenshots or copy-paste posts you like into `kits/linkedin/inspirations/`
- **Shortform:** Drop references into `kits/shortform/inspirations/` (video ref support expanding soon)

Tell Claude when you've added new inspirations and it'll incorporate them.

---

## Publishing

When you're happy with a draft:

```
Publish this
This is ready
Move to published
Finalize this draft
```

Claude moves the draft from `output/drafts/` to `output/published/` and logs it in your post history. Platform integrations (auto-publish to LinkedIn, email platform, etc.) are coming — for now, copy and paste the finished content.

---

## Training your voice

The most powerful thing you can do is **push back on drafts.** Not just "I don't like it" — but showing Claude how you'd actually say it:

| What to say | What Claude learns |
|-------------|-------------------|
| "I wouldn't say it like that. I'd say: 'Just start. The plan comes later.'" | You're more direct, shorter sentences |
| "I never open with the thesis. Tell a story first, then get to the point." | Your structural preference |
| "Too corporate. I write like I'm texting a smart friend." | Your register and tone |
| "The intro is way too long. One line, maybe two, then dive in." | Your pacing preference |
| "I always end with a question, not a summary." | Your closing pattern |

**One correction is a note. Two is a pattern. Three becomes a permanent rule.** Early feedback compounds — the more you push back in the first few sessions, the faster Claude nails your voice.

---

## Tips for best results

1. **Writing samples are the biggest lever.** 5-10 real pieces of your writing make more difference than anything else. Drop them into `brand/identity/writing-samples/` anytime.

2. **Brand depth matters.** "I help businesses grow" produces generic content. "I help B2B SaaS founders who've hit $2M ARR figure out why their second product keeps failing" produces specific, differentiated content.

3. **Feed it more writing over time.** Anytime you publish something, write a LinkedIn post, or draft an email that feels very *you* — add it to your writing samples.

4. **Use natural language.** You don't need commands or special syntax. Talk like you would to a person.

5. **Ask for rewrites, not just edits.** "Rewrite the opening with a personal story" or "Make the whole thing shorter and punchier" — Claude iterates as many times as you want.

---

## All available commands

You don't need to memorize these — natural language works. But they're here if you want them.

| Command | What it does |
|---------|-------------|
| `/brand` | Show, set up, or evolve your brand |
| `/newsletter` | Write a newsletter |
| `/carousel` | Create a carousel |
| `/linkedin-post` | Write a LinkedIn post |
| `/script` | Write a video script |
| `/batch` | Create a week of content |
| `/publish` | Move draft to published |
| `/add-source` | Manage inspiration sources |
| `/study-creator` | Deep-dive a creator's patterns |
| `/read-source` | Browse what a source is writing about |
| `/hook-workshop` | Brainstorm and improve hooks |
| `/tldr` | Write a curiosity hook for a newsletter |
| `/research-trends` | Research trending formats in your niche |
ENDOFFILE__how_to_use

echo "  - HOW-TO-USE.md done"
cat > "$KIT_DIR/README.md" << 'ENDOFFILE__readme'
# AI Creator Kit

**One folder. One brand. Every content format.**

This is a portable AI content studio powered by Claude. It builds your brand from scratch, then creates newsletters, carousels, LinkedIn posts, and short-form video scripts — all in your voice, all from one place.

You open it. You talk. It handles the rest.

---

## What this is

A folder on your computer that contains everything an AI needs to create content as you. Your brand identity, your writing voice, your visual style, your inspiration sources — captured once, used everywhere.

No coding. No APIs. No databases. No build steps. Just a conversation with Claude.

---

## What you get

**Your brand (built once, used everywhere):**
- Brand document — who you are, who you serve, what you stand for
- Voice guide — how you sound across all mediums
- Visual identity — what your brand looks like

**Four content engines:**

| Engine | What it creates |
|--------|----------------|
| **Newsletter** | Long-form newsletters with research, drafting, and your voice |
| **Carousel** | Slide-by-slide posts with copy + design direction for Instagram/LinkedIn |
| **LinkedIn** | Algorithm-aware posts with hooks, rehooks, and AI-detection defense |
| **Shortform** | Ready-to-film scripts with timestamps, visual cues, and filming guides |

**Each engine includes:**
- Medium-specific style profile (derived from your brand)
- Templates for every content format
- An inspiration folder for examples you like
- Draft and published output folders
- Batch creation for a week of content at once

---

## Getting started

### 1. Install Claude

You need Claude Code, the Claude desktop app, or access to claude.ai. Any of them work. Claude Code gives you the best experience.

- **Claude Code (CLI):** [docs.anthropic.com/claude-code](https://docs.anthropic.com/en/docs/claude-code)
- **Claude Desktop App:** [claude.ai/download](https://claude.ai/download)

### 2. Open this folder

Point Claude at this folder. In Claude Code, just `cd` into it. In the desktop app, open it as a project.

### 3. Say anything

Claude will detect that you're new and walk you through brand setup. After that, you tell it what you want to create and it handles the rest.

That's it. See **HOW-TO-USE.md** for the full usage guide.

---

## How it works

```
You open the folder
        |
        v
Claude checks: do you have a brand?
        |
   No --+--> Brand setup (20-30 min, one time)
        |
   Yes -+--> What do you want to create?
        |
        +---> "Write a newsletter" ---> Is newsletter set up? 
        |                                  No --> Quick setup (5-10 min)
        |                                  Yes --> Writes the newsletter
        |
        +---> "Make a carousel" -------> Is carousel set up?
        |                                  No --> Quick setup (5-10 min)
        |                                  Yes --> Creates the carousel
        |
        +---> "Write a LinkedIn post" -> Is LinkedIn set up?
        |                                  No --> Quick setup (5-10 min)
        |                                  Yes --> Writes the post
        |
        +---> "Write a script" --------> Is shortform set up?
                                           No --> Quick setup (5-10 min)
                                           Yes --> Writes the script
```

**Brand setup** happens once. It produces three documents that every content engine reads from.

**Kit setup** happens once per engine, the first time you use it. It's fast because your brand already exists — Claude just needs to tune your voice for that specific medium.

**After setup**, you just talk. "Write a newsletter about X." "Give me 5 LinkedIn posts for the week." "Make a carousel about Y." Claude reads your files and creates.

---

## Your files at a glance

```
ai-creator-kit/
├── brand/                    Your brand identity (source of truth)
│   └── identity/
│       ├── brand-document.md
│       ├── voice-guide.md
│       └── visual-identity.md
│
├── kits/
│   ├── newsletter/           Newsletter engine
│   ├── carousel/             Carousel engine
│   ├── linkedin/             LinkedIn engine
│   └── shortform/            Short-form video engine
│
├── sources.yaml              Your inspiration sources
├── README.md                 You're reading this
└── HOW-TO-USE.md             Detailed usage guide
```

---

## Evolving your brand

Your brand isn't static. Come back anytime and say:

- "I want to sound more concise and punchy"
- "My audience is shifting toward experienced founders"
- "I love how @creator writes — give me some of that energy"
- "Update my brand colors"

Claude shows you the before and after, you approve, and every content engine picks up the change automatically.

---

## FAQ

**Do I need to set up all four engines?**
No. Set up only the ones you use. Each engine activates the first time you ask for that content type.

**What if I already have a brand?**
Drop your brand docs, writing samples, and visual references into the `brand/identity/` subfolders. Claude will analyze them instead of interviewing you from scratch.

**Can I use this for clients?**
Yes. One kit per person or brand. Duplicate the folder and start fresh.

**What if my voice changes over time?**
Push back on drafts. Every correction trains the system. You can also say "refresh my LinkedIn style" to re-derive your kit profile from your updated brand.

**Can I use this from my phone?**
Yes, with limitations. On claude.ai, create a project and paste in your brand documents. You won't have all the features, but it works for quick drafts.
ENDOFFILE__readme

echo "  - README.md done"
cat > "$KIT_DIR/WRITING-STARTER.md" << 'ENDOFFILE__writing_starter'
# Writing Starter — Get Your First Samples

This system writes LinkedIn posts in **your** voice. To do that, it needs to study how you actually write. No existing posts? No problem — here's how to get started.

## Why samples matter

Claude doesn't just follow instructions like "write in a casual tone." It studies the specific patterns in YOUR writing — your sentence length, your word choices, how you open posts, how you use line breaks, how you close. The more real writing it has, the more it sounds like you.

Without samples, Claude can still interview you about your preferences, but the results won't be as accurate. Even 3-5 short posts make a huge difference.

## Quick-start: write 5 posts right now

Don't overthink these. Write them the way you'd actually talk to someone. Spend 5-10 minutes each. They don't need to be published — they just need to sound like you.

**Post 1 — A lesson you learned the hard way**
Think of a mistake you made professionally. What happened? What did you learn? Write it the way you'd tell a friend over coffee.

**Post 2 — An opinion you hold strongly**
What's something you believe about your industry that most people get wrong? Why do you think differently?

**Post 3 — A story from your career**
Think of a specific moment — a conversation, a decision, a turning point. Set the scene and tell the story.

**Post 4 — Advice you'd give your younger self**
If you could go back 5-10 years, what would you tell yourself about your career, your industry, or how you work?

**Post 5 — Something you're excited about right now**
What's a project, trend, idea, or change that has your attention? Why does it matter?

## What to do with them

1. Save your posts as text files (or just paste them directly into Claude when asked)
2. Open your ai-linkedin-kit folder in Claude
3. When Claude asks for writing samples during setup, share them
4. Claude will analyze your voice and build your profile

## Tips

- Write like you talk. Don't try to sound "professional" or "LinkedIn-y." The whole point is capturing YOUR voice.
- Longer is better than shorter. A 200-word post gives Claude more signal than a 50-word one.
- Variety helps. Different topics and moods help Claude capture the full range of your voice.
- Already have writing elsewhere? Blog posts, emails, Slack messages, tweets — anything in your natural voice works. LinkedIn posts are ideal but not required.
ENDOFFILE__writing_starter

echo "  - WRITING-STARTER.md done"
cat > "$KIT_DIR/kits/carousel/content-strategy/hooks-swipe-file.md" << 'ENDOFFILE__carousel_hooks'
# Cover Slide Hooks — Swipe File

Proven carousel cover slide headlines organized by type. These are templates — adapt to your brand voice and topic.

---

## Bold Statements

- "Everything you know about [X] is wrong"
- "The [X] playbook nobody talks about"
- "This changed how I think about [X]"
- "The real reason [X] doesn't work"
- "[X] is dead. Here's what replaced it."

## Number-Driven

- "[N] mistakes killing your [X]"
- "The [N]-step framework for [outcome]"
- "[N] things I wish I knew about [X]"
- "I studied [N] [things]. Here's what I found."
- "[N]% of [people] get [X] wrong"

## Curiosity Gap

- "I stopped doing [X]. Here's what happened."
- "The [X] nobody is talking about"
- "What [successful people] know about [X] that you don't"
- "The hidden cost of [common thing]"
- "Why [obvious thing] is actually [unexpected thing]"

## Questions

- "Are you making these [X] mistakes?"
- "What if [common belief] is actually wrong?"
- "Why does [frustrating thing] keep happening?"
- "What separates [good] from [great] at [X]?"
- "Ready to [outcome] in [timeframe]?"

## How-To / Tutorial

- "How to [outcome] in [N] steps"
- "The exact process I use to [outcome]"
- "How I [impressive result] (step by step)"
- "The [X] cheat sheet you didn't know you needed"
- "Stop overcomplicating [X]. Here's how."

## Contrast / Before-After

- "What [X] looks like before and after [Y]"
- "[Beginner] vs [Expert] at [X]"
- "I did [X] for [time]. The difference is insane."
- "What they told me vs what actually works"
- "[Old way] → [New way]"
ENDOFFILE__carousel_hooks

echo "  - carousel hooks-swipe-file.md done"
cat > "$KIT_DIR/kits/carousel/content-strategy/pillars.yaml" << 'ENDOFFILE__carousel_pillars'
# Content Pillars
# Populated during onboarding — defines the themes and cadence for carousel content

pillars: []
  # - name: "Expertise & Education"
  #   allocation: 35
  #   description: ""
  #   example_angles: []
  # - name: "Personal Stories"
  #   allocation: 25
  #   description: ""
  #   example_angles: []
  # - name: "Industry Commentary"
  #   allocation: 20
  #   description: ""
  #   example_angles: []
  # - name: "Culture & Values"
  #   allocation: 20
  #   description: ""
  #   example_angles: []

posting_cadence:
  frequency: ""          # e.g., "3x per week"
  preferred_days: []     # e.g., [Monday, Wednesday, Friday]
  platforms: []          # e.g., [instagram, linkedin]
  batch_preference: ""   # "one at a time" or "weekly batch"
ENDOFFILE__carousel_pillars

echo "  - carousel pillars.yaml done"

cat > "$KIT_DIR/kits/carousel/content-strategy/post-history.yaml" << 'ENDOFFILE__carousel_post_history'
# Post History
# Auto-populated by /carousel and /batch-carousels skills
# Used to track variety and avoid repetition

# Schema:
# - date: YYYY-MM-DD
#   title: ""
#   template: ""
#   pillar: ""
#   platform: ""
#   slides: 0
#   status: draft | published

posts: []
ENDOFFILE__carousel_post_history

echo "  - carousel post-history.yaml done"
cat > "$KIT_DIR/kits/linkedin/content-strategy/algorithm-guide.md" << 'ENDOFFILE__linkedin_algo_guide'
# LinkedIn Algorithm Guide (2025-2026)

A reference file for all writing skills. Read this before making strategic decisions about post format, length, timing, or engagement approach.

**Last updated:** April 2026
**Sources:** Hootsuite, Buffer (4.8M posts), Sprout Social (2B engagements), SocialInsider (1.3M posts), AuthoredUp (372K posts), ConnectSafely (10K posts)

---

## Engagement Signal Weights

The algorithm ranks engagement signals in this order:

| Signal | Weight | Notes |
|--------|--------|-------|
| **Saves/Bookmarks** | Highest | 1 save = 5x more reach than 1 like, 2x more than a comment |
| **Dwell time** | Very high | 61+ seconds = 13x baseline engagement; the #1 indicator of content quality |
| **Substantive comments** | Very high | Comments >15 words carry 2.5x more weight; comments overall are 15x more valuable than likes |
| **Indirect comments** (replies) | High | Threaded conversations boost reach up to 2.4x |
| **Shares with commentary** | High | Shares where the sharer adds perspective outweigh simple reposts |
| **Likes/Reactions** | Lowest | Easily gamed; minimal algorithmic impact |

**Key rule:** Optimize for saves and dwell time first, comments second, likes last.

---

## The Three-Stage Distribution System

| Stage | Timing | Audience | Threshold |
|-------|--------|----------|-----------|
| Stage 1 | 0-60 minutes | 2-5% of your network | Need 5-10% engagement rate to advance |
| Stage 2 | 1-6 hours | 10-20% of network + 2nd-degree | NLP evaluates comment substance |
| Stage 3 | 6+ hours | Non-connections via interest matching | Less than 1% of posts reach this |

**The Golden Hour:** The first 60 minutes determine ~70% of a post's total reach. Reply to every comment immediately during this window — it doubles engagement.

**Late Engagement Bonus:** Posts getting saves and substantive comments 24-72 hours after publishing perform 4-6x better. Post longevity is now 2-3 weeks (not 24 hours).

---

## Optimal Post Length

| Length | Performance | Use case |
|--------|-------------|----------|
| Under 500 characters | 35% less engagement | Avoid unless it's a coaching-truth format |
| 500-900 characters | Average | Quick observations, polls |
| **1,300-1,900 characters** | **47% higher engagement** | **The sweet spot** — optimizes dwell time + completion rate |
| 1,900-2,500 characters | Still strong (2.6% rate) | Deep frameworks, detailed stories |
| Over 2,500 characters | 35% engagement drop | Completion rate falls off |

**Platform limit:** 3,000 characters total.

**Mobile rule:** 57%+ of LinkedIn traffic is mobile. Always preview on mobile.

---

## The "See More" Fold

| Device | Characters before fold |
|--------|----------------------|
| Mobile | ~140 characters |
| Desktop | ~210 characters |

**60-70% of readers never click "see more."** The hook must work within 140 characters (mobile-first).

After the fold, the **rehook** (lines 2-3) must lock the reader in. The hook gets them to click; the rehook keeps them reading.

---

## Post Format Performance (2026 data)

| Format | Engagement Rate | Trend | Notes |
|--------|----------------|-------|-------|
| **Document/Carousel (PDF)** | **7.00%** | +14% YoY | Highest engagement. 2.5x more shares than video/image |
| Multi-image | 6.45% | -2.3% | Custom 3-4 image collages get 2x comment rates |
| Video | 6.00% | Views down 36-53% | High dwell time but declining distribution |
| Single image | 5.30% | +9% | Underperforms text-only by 30% — a 2025 reversal |
| **Text-only** | **4.50%** | **+12% YoY** | Fastest growth. Highest organic reach |
| Poll | 4.20% | Reach up 206% | Works best for accounts >10K followers |
| Link post | 3.25% | -1.5% | **Suppressed.** -40-50% reach vs same post without link |

**Recommended mix:** 40-60% carousels/documents, 30-40% text posts, 10-20% engagement content (polls, questions).

**Carousel sweet spot:** 6-9 slides. 7 slides performs 18% better than other lengths. Click-through rate below 35% triggers visibility penalty.

---

## Posting Times & Frequency

### Best Times (2026 data)

| Day | Peak windows |
|-----|-------------|
| **Tuesday** | 11am-5pm (strongest overall day) |
| **Wednesday** | 3pm-5pm |
| **Thursday** | 11am, 1pm-5pm |
| Friday | 3pm-5pm |
| Monday | 5pm-9pm |
| Weekend | 50% lower engagement — avoid |

**Key trend:** Peak engagement is shifting later in the day (3-8pm) compared to 2024-2025.

### Frequency

| Posts/week | Engagement lift vs 1x/week |
|------------|---------------------------|
| 2-5 | +1,182 impressions/post |
| 6-10 | +5,001 impressions/post |
| 11+ | +16,946 impressions/post, 3x total engagements |

**Minimum for algorithm recognition:** 2-3 posts/week. Going from 1 to 2-5 posts/week is described as "flipping a switch."

**Minimum gap between posts:** 12 hours.

---

## What Gets Suppressed

| Signal | Reach penalty |
|--------|--------------|
| **External links in post body** | **-40% to -50%** |
| External links in first comment | -5% to -10% |
| **AI-generated content** | **-30% reach, -55% engagement** |
| Engagement bait ("like if you agree") | Detected and suppressed |
| Engagement pods | 97% detection accuracy |
| Rapid posting (5-7+/day) | Spam flag |
| Low dwell time + high likes | Flagged as inauthentic |

---

## AI Content Detection

LinkedIn uses a 150B-parameter model (360Brew) to detect AI content. Detected AI content receives -30% reach and -55% engagement.

### How detection works
- Scans for AI-generated patterns before any distribution
- Looks for generic language, absence of specific expertise signals
- Posts that "could have been written by anyone" get distributed to no one

### AI vocabulary tells to avoid
These phrases are overused 14-34x in AI content vs human content:
- "Here's the thing" (34x)
- "Let that sink in" (28x)
- "Read that again" (22x)
- "Game-changer" (19x)
- "Full stop" (14x)
- "Unpack this"
- "Navigate"
- "Lean into"
- "Double down"

### Anti-detection principles
1. Include specific personal details (names, numbers, dates, places)
2. Use domain-specific vocabulary from real experience
3. Include at least one deliberate imperfection (fragment, tangent, parenthetical)
4. Vary structure between posts — never use the same format twice in a row
5. Write the opening line LAST (after the body) for more natural hooks
6. Target grade 3-5 reading level (Hemingway App)
7. Max 3 lines per paragraph, single-sentence paragraphs are preferred

### Data point
82% of AI posts use one of just 3 opening patterns. Posts scoring high on "AI polish" get 5x less engagement than imperfect-looking posts.

---

## Formatting Rules

- **Line breaks:** Every 1-2 sentences. Short paragraphs (max 3 lines) get 3x more engagement than wall-of-text
- **Emoji:** 1-3 relevant emojis can increase engagement 25%. More than 3-4 hurts. Standard emojis = 2 characters; complex = 4-7
- **Hashtags:** 3-5 per post, placed at the end (not inline)
- **Bold/caps:** Use sparingly for emphasis. Overuse hurts readability and accessibility
- **Reading level:** Grade 3-5 (Hemingway App). Short sentences under 12 words perform 20% better
- **Links:** Never in the post body. If essential, add in comments (still carries a small penalty)

---

## Key Principles for the Writing Kit

1. **Saves are king.** Structure posts to be reference-worthy. Ask: "Would someone bookmark this?"
2. **Dwell time > likes.** Write for 60-90 seconds of reading (1,300-1,900 characters).
3. **The hook must work in 140 characters** (mobile fold). 60-70% never click "see more."
4. **The rehook locks them in.** Lines 2-3 after the fold must eliminate the reason to leave.
5. **Comments > likes (15x).** End with a genuine question that invites substantive replies (CTC, not CTA).
6. **Carousels dominate** at 7% engagement. Include at least 1 per week.
7. **Never put links in the post body** (-40-50% reach).
8. **AI content is penalized.** Every post needs personal specificity and voice-specific patterns.
9. **Post Tue-Thu, 3-6pm.** Reply to every comment in the first 60 minutes.
10. **Vary everything.** Never repeat the same format, hook type, or structure in consecutive posts.
ENDOFFILE__linkedin_algo_guide

echo "  - linkedin algorithm-guide.md done"
cat > "$KIT_DIR/kits/linkedin/content-strategy/hooks-swipe-file.md" << 'ENDOFFILE__linkedin_hooks'
# Hooks Swipe File

A curated collection of proven LinkedIn hook patterns organized by type. Use this as inspiration when generating hooks — not for copying verbatim, but for understanding what makes an opening line earn the "see more" click.

Add new hooks here as you find ones that work. Include source when it's not your own work.

---

## Bold Statements

Direct, declarative claims that stake out a position. Best for contrarian takes, frameworks, and opinion posts.

### "Most people think [X]. They're wrong."
*Type: bold-statement*
*Why it works: Challenges the reader's existing belief immediately. Creates a gap between what they think and what's true.*

### "The best employees are the ones you almost didn't hire."
*Type: bold-statement*
*Why it works: Specific, counterintuitive, and immediately makes any hiring manager think of someone on their team.*

### "Your pricing is the problem. Not your product."
*Type: bold-statement*
*Why it works: Reassigns the cause of a familiar pain. Reframes the problem before the reader has a chance to defend themselves.*

### "More meetings will not fix a communication problem."
*Type: bold-statement*
*Why it works: Names a common mistake, states it as fact, creates friction with the reader's instinct to schedule a meeting.*

### "Networking is overrated. Reputation is not."
*Type: bold-statement/contrarian-reframe*
*Why it works: Two short sentences in contrast. Dismisses something widely valued, then gives something to hold onto instead.*

### "There is no such thing as a people problem. Only a system problem."
*Type: bold-statement*
*Why it works: Challenges blame-assignment instinct. Forces the reader to reconsider their framing.*

### "Most founders are solving the wrong hiring problem."
*Type: bold-statement*
*Why it works: Specific audience (founders), specific claim (wrong problem), forces them to read on to find out what they're missing.*

### "You don't have a productivity problem. You have a clarity problem."
*Type: bold-statement/reframe*
*Why it works: Reframes a common pain point at the root level. Short, parallel structure.*

---

## Questions

Questions that make the reader think "I actually don't know the answer to this" — genuine curiosity hooks, not rhetorical setups.

### "When was the last time you felt genuinely proud of something you built?"
*Type: question*
*Why it works: Pulls the reader into self-reflection before they realize they've started reading. Emotional, specific.*

### "What would you do if your best employee told you they were leaving?"
*Type: question*
*Why it works: Drops the reader into a scenario they've probably feared. Immediately active.*

### "Why do the best candidates always turn down the best jobs?"
*Type: question*
*Why it works: Counterintuitive premise. The reader thinks they know the answer, then wonders if they're right.*

### "What does your team think of you when you're not in the room?"
*Type: question*
*Why it works: Slightly uncomfortable. Specific enough to feel personal. Hard to dismiss.*

### "If you couldn't use the word 'strategy,' how would you explain what you do?"
*Type: question*
*Why it works: Challenges the reader to think differently. Works for anyone who uses abstraction-heavy language in their work.*

### "What's the real reason that deal fell through?"
*Type: question*
*Why it works: Implies there is a real reason beyond the obvious one. Opens a gap the reader wants to close.*

---

## Story Openers

First lines that drop the reader into a specific moment. The reader wants to know what happened.

### "I got a call from my best client at 7am on a Tuesday. They were canceling."
*Type: story-opener*
*Why it works: Specific detail (7am, Tuesday), immediate stakes, no setup needed. Pure curiosity.*

### "Three years ago, I took a meeting that changed everything. It also nearly cost me the company."
*Type: story-opener*
*Why it works: Double payoff — transformative AND threatening. The contrast creates irresistible tension.*

### "I hired someone everyone loved. Six months later, I had to let them go."
*Type: story-opener*
*Why it works: Ironic contrast between the hire's reception and the outcome. Sets up a story about judgment.*

### "My co-founder and I didn't speak for three weeks. Here's what we learned."
*Type: story-opener*
*Why it works: High stakes relationship tension. "Here's what we learned" signals a resolution worth waiting for.*

### "I almost missed the most important signal my business ever sent me."
*Type: story-opener*
*Why it works: Near-miss structure. The word "almost" creates relief and curiosity simultaneously.*

### "The project shipped on time, under budget. We still lost the client."
*Type: story-opener*
*Why it works: Expectation reversal. Every metric met, yet failure. Demands an explanation.*

---

## Number-Driven

Open with a specific number, timeframe, or data point. Signals credibility and creates a concrete anchor.

### "In 10 years of building teams, I've made 4 hiring mistakes that I still think about."
*Type: number-driven*
*Why it works: Specific count (10 years, 4 mistakes) and emotional weight ("still think about"). Feels honest.*

### "We turned down $500K in contracts last year. Revenue grew 40%."
*Type: number-driven*
*Why it works: The contrast between what was rejected and the growth creates immediate "how?" curiosity.*

### "I've interviewed 200+ people in the last 3 years. One question tells me everything."
*Type: number-driven*
*Why it works: Scale signals experience; "one question" creates an immediate want to know what it is.*

### "5 years. 3 failed product launches. One that changed everything."
*Type: number-driven*
*Why it works: Compressed timeline with emotional arc. The ratio of failure to success makes the win feel earned.*

### "I fired someone last week. It was 9 months overdue."
*Type: number-driven*
*Why it works: Specific delay (9 months) signals self-awareness and a lesson about waiting too long.*

### "Our customer churn rate is 2%. Here's the one thing that changed it."
*Type: number-driven*
*Why it works: Specific metric, implied before state (higher), and a clear promise of the mechanism.*

---

## Pattern Interrupts

Opens that break the reader's scroll pattern through unexpected structure, format, or framing.

### "I'm going to say something that will make some of you close this post."
*Type: pattern-interrupt*
*Why it works: Meta-framing that creates reverse psychology. The reader stays to see if they're the type who would close it.*

### "Don't hire for culture fit."
*Type: pattern-interrupt*
*Why it works: Three words, full stop. Challenges a sacred cow of hiring. No hedge, no explanation — yet.*

### "The meeting went perfectly. That was the problem."
*Type: pattern-interrupt*
*Why it works: Short contrast structure. "Perfectly" and "problem" in the same sentence force reconciliation.*

### "We had no strategy. That's why it worked."
*Type: pattern-interrupt*
*Why it works: Undermines the conventional wisdom that strategy is necessary. Short, declarative, counterintuitive.*

### "I stopped setting goals. My business got better."
*Type: pattern-interrupt*
*Why it works: Challenges a near-universal business belief with a personal outcome. Demands an explanation.*

### "Here's a thing that happened. I have no lessons from it. I'm still thinking."
*Type: pattern-interrupt*
*Why it works: Breaks the expectation that LinkedIn posts must have lessons. Authentic uncertainty is rare and compelling.*

---

## "I Was Wrong" / Vulnerability

Hooks built on admission, reversal, or honest self-assessment. These build trust faster than almost any other type.

### "I was wrong about remote work. Here's what changed my mind."
*Type: vulnerability/i-was-wrong*
*Why it works: Clear reversal, specific topic. The reader wants to know what the evidence was.*

### "For two years, I thought I was building a company. I was building a job."
*Type: vulnerability*
*Why it works: The "job vs. company" distinction is real and resonant. Two years signals how long the blindspot lasted.*

### "I gave someone advice last week that I didn't follow myself. It's bothering me."
*Type: vulnerability*
*Why it works: Admits hypocrisy before anyone else has to point it out. Rare on LinkedIn. Immediately earns trust.*

### "I didn't take my own product seriously enough. That almost ended the company."
*Type: vulnerability/confession*
*Why it works: Stakes are high (almost ended the company). The admission is about something close to home.*

---

## Framework-Reveal Hooks

Open by naming a specific framework, method, or system. Signals structured value and creates "I need to save this" energy.
*Source: Sahil Bloom pattern*

### "A relationship framework that changed my life: Helped, Heard, or Hugged."
*Type: framework-reveal*
*Why it works: Named framework creates curiosity. "Changed my life" raises stakes. The three-word name is memorable and specific.*

### "Try this 5-minute trick to improve your mental health: The 1-1-1 Method."
*Type: framework-reveal*
*Why it works: Time-bound promise (5 minutes), specific benefit (mental health), named method creates save-worthy content.*

### "I use a simple framework for [goal]: it changed how I approach [topic]."
*Type: framework-reveal (template)*
*Why it works: "Simple" lowers barrier. Named framework signals structure. Personal testimony adds proof.*

---

## Relatable Enemy Hooks

Name something the audience already resists, then position yourself as an ally against it. Creates instant alignment.
*Source: Justin Welsh pattern*

### "The 9 to 5 is getting pummeled. The great resignation is growing faster than ever. And I love it. Why?"
*Type: relatable-enemy*
*Why it works: Names the enemy (9-to-5), champions the hero (resignation), injects personal stance (I love it), teaser question forces the click.*

### "Most career advice is terrible. Here's what actually works."
*Type: relatable-enemy*
*Why it works: "Most" implies the reader has been misled. "Actually works" promises insider truth.*

### "The {RelatableEnemy} is {Negativity}. The {Hero} is {StrongPositiveStatement}."
*Type: relatable-enemy (template)*
*Why it works: Justin Welsh's viral template -- attack the enemy, champion the alternative, add personal gasoline.*

---

## Transformation / Before-After Hooks

Drop the reader into a moment of change. The gap between before and after creates irresistible curiosity.
*Source: Lara Acosta pattern*

### "I packed a one-ticket flight, and it changed my life."
*Type: transformation*
*Why it works: Specific action (one-ticket flight) + massive claim (changed my life). The specificity makes the claim believable.*

### "One day I'm signing up to LinkedIn, and the next I'm ranked #1."
*Type: transformation*
*Why it works: Compressed timeline creates drama. The gap between "signing up" and "#1" demands explanation.*

### "Hired a Gen-Z candidate without interviewing him."
*Type: transformation/unexpected-scenario*
*Why it works: Breaks every hiring convention in one sentence. The "why" is irresistible. Lara Acosta's most engaging hook.*

---

## Cinematic Scene-Setters

Drop the reader into a specific moment with sensory details. Like a movie that starts mid-scene.
*Source: Alex Lieberman pattern*

### "1 month into my first job in Finance, 25% of my division was laid off in 2 hours."
*Type: cinematic*
*Why it works: Specific time (1 month), specific stakes (25% laid off), specific speed (2 hours). Feels like you're there.*

### "People anxiously sat at their desks waiting to see if they got a call from 'FRONT DESK.' If they did, they knew what that meant."
*Type: cinematic*
*Why it works: Vivid scene with universal dread. The detail "FRONT DESK" is specific enough to feel real.*

### "WARNING: this is a long ass post. But I have a sneaky suspicion it's the most valuable post you'll read all week."
*Type: cinematic/meta*
*Why it works: Breaks the fourth wall. The warning creates reverse psychology. The confidence of "most valuable" is a bold bet.*

---

## Coaching Truth Hooks

Short, authoritative declarations that sound like a coach delivering a hard truth. Maximum impact in minimum words.
*Source: Dr. Julie Gurner pattern*

### "If your work, company, or life isn't moving in the direction you wish... it's often because you are obsessing over the wrong things."
*Type: coaching-truth*
*Why it works: Addresses the reader directly. "Often because" implies insider knowledge. Reframes a common frustration.*

### "Contrary to belief, knowledge is not power... execution is power."
*Type: coaching-truth*
*Why it works: Flips a famous quote. The replacement ("execution") is actionable and challenges the reader to act.*

### "Anytime you are 'rushing' in the day, you are diluting your effectiveness -- not covering more ground."
*Type: coaching-truth*
*Why it works: Challenges the hustle mentality. "Diluting" is a vivid verb. Reframes speed as weakness, not strength.*

---

## Specificity + Credibility Hooks

Lead with precise numbers, timeframes, or data points. Specificity signals expertise and creates concrete curiosity.
*Source: Chris Donnelly + Nicolas Cole patterns*

### "In 2025, I interviewed 100 CFOs about remote work -- here's what shocked me."
*Type: specificity*
*Why it works: Year anchors timeliness. "100 CFOs" signals scale. "Shocked me" raises emotional stakes.*

### "Our startup cut customer churn from 8% to 2% in six months. The first thing we fixed was..."
*Type: specificity*
*Why it works: Before/after numbers are concrete. "First thing" implies a prioritized list. Trailing sentence forces the click.*

### "How Middle-Market SaaS Product Managers Can Use The Eisenhower Matrix To Streamline Their Day"
*Type: specificity (template)*
*Why it works: Ultra-specific audience (middle-market SaaS PMs) + named tool (Eisenhower Matrix) + specific benefit (streamline their day).*

---

## Mic-Drop / Power Statement Hooks

Ultra-short declarations that make the reader stop and reconsider. Under 45 characters.
*Source: Jasmin Alic pattern*

### "Formatting your LinkedIn posts matters a lot."
*Type: power-statement*
*Why it works: Under 45 characters. Simple, declarative, challenges people who focus only on content over format.*

### "This might be my biggest LinkedIn post ever."
*Type: power-statement*
*Why it works: Meta-curiosity. "Biggest" is undefined -- biggest how? The reader must click to find out.*

### "Don't hire for culture fit."
*Type: power-statement/pattern-interrupt*
*Why it works: Three words challenge a sacred cow. No hedge, no explanation. The boldness IS the hook. Under 45 characters.*

---

## The Playbook / Listicle Hook

Promise a structured set of takeaways. Numbers signal scannability and commitment to value.
*Source: Justin Welsh + Dickie Bush/Nicolas Cole patterns*

### "One idea = 5 LinkedIn posts: 1. Teach 2. Observe 3. Contrarian 4. Listicle 5. Story"
*Type: playbook*
*Why it works: Math-based hook (1 = 5). Immediate value in the hook itself. The reader gets the framework AND wants the explanation.*

---

## Anti-Corporate / Contrarian Identity Hooks

Challenge workplace norms and career conventions. Signals membership in a counter-culture.
*Source: Tim Denning pattern*

### "The safe path isn't safe."
*Type: contrarian-identity*
*Why it works: Five words that flip the core career assumption. Creates a feeling of being told a secret truth.*

### "Stop climbing their ladder. Build your own."
*Type: contrarian-identity*
*Why it works: "Their" creates an us-vs-them. "Build your own" provides the alternative. Concise, branded, quotable.*

---

## Hook Anti-Patterns: What to AVOID

### The Three Overused AI Opening Patterns (82% of AI posts use these)
1. **"Most people think [belief]. They're wrong. Here's why."**
2. **"I [achievement]. But here's what nobody tells you about [topic]."**
3. **"[Bold claim]." Then: "Let me explain."**

### Vocabulary to Avoid (AI tells)
- "Here's the thing" (34x overuse)
- "Let that sink in" (28x overuse)
- "Read that again" (22x overuse)
- "Game-changer" (19x overuse)
- "Full stop" (14x overuse)

### Cringe Opening Patterns
- "I'm excited to share..."
- Three-emoji headlines
- "What do you think? Drop a comment below" closers
ENDOFFILE__linkedin_hooks

echo "  - linkedin hooks-swipe-file.md done"
cat > "$KIT_DIR/kits/linkedin/content-strategy/pillars.yaml" << 'ENDOFFILE__linkedin_pillars'
# Content Pillars
# This file defines the core themes you want to be known for on LinkedIn.
# Each pillar has an allocation percentage that guides how often you post about each theme.
# The allocations should sum to 100%.

pillars:
  - name: "Expertise & Craft"
    description: >
      The deep, specific knowledge that comes from doing the work. Tactical lessons,
      hard-won insights, and the honest truths about how things actually work in your field.
      This pillar makes you the expert readers consult, not just follow.
    allocation: 35
    example_angles:
      - "The specific skill most people in your field overlook"
      - "A framework or system you've developed from experience"
      - "A common mistake you see professionals making"
      - "The honest truth about how [industry process] actually works"
      - "What you know now that you wish you'd known 5 years ago"
    typical_formats:
      - listicle
      - framework
      - contrarian-take

  - name: "Personal Stories"
    description: >
      Real experiences from building, working, and living — told with honesty and a clear
      takeaway. Stories build trust, humanize the brand, and generate the highest-quality
      comments. They also do the work that tactical posts cannot: they let the audience
      know who you actually are.
    allocation: 25
    example_angles:
      - "A failure and what it revealed"
      - "A moment where your assumptions were wrong"
      - "A conversation that changed how you think"
      - "An early experience that shaped your current approach"
      - "A decision you made that felt risky — and how it turned out"
    typical_formats:
      - story-lesson
      - i-was-wrong
      - before-after
      - milestone-insight

  - name: "Industry Commentary"
    description: >
      Your informed take on trends, debates, and developments in your industry.
      This pillar establishes you as someone who has a point of view — not just skills,
      but judgment. Opinion posts, reactions to industry news, and takes on where
      the field is heading.
    allocation: 20
    example_angles:
      - "A trend you think is being overhyped"
      - "A practice the industry should retire"
      - "A debate in your field and where you stand"
      - "What's being missed in the current conversation about [topic]"
      - "Your prediction about where [industry/field] is heading"
    typical_formats:
      - contrarian-take
      - framework
      - poll-context

  - name: "Culture & Values"
    description: >
      Who you are, what you care about, and how you work. Behind-the-scenes glimpses,
      team dynamics, values in action, and the human side of building something.
      This pillar builds community and attracts people who want to work with, for,
      or alongside you — not just learn from you.
    allocation: 20
    example_angles:
      - "How you make decisions in your company/work"
      - "A principle you've never compromised on"
      - "What your team/clients would say about working with you"
      - "A belief about how work should work"
      - "Something you're learning about yourself as a builder/leader"
    typical_formats:
      - story-lesson
      - before-after
      - milestone-insight

posting_cadence:
  posts_per_week: 4
  preferred_days:
    - Tuesday
    - Wednesday
    - Thursday
    - Friday
  preferred_times: "Afternoon (3-6pm your timezone) — 2026 data shows late-day engagement trending up"
  batch_mode: true
  format_mix: >
    Include at least 1 carousel/document post per week — carousels get 7% engagement
    vs 4.5% for text-only. Remaining posts should be text-only.
  strongest_post_day: "Tuesday — consistently the highest-performing day across all data"
ENDOFFILE__linkedin_pillars

echo "  - linkedin pillars.yaml done"

cat > "$KIT_DIR/kits/linkedin/content-strategy/post-history.yaml" << 'ENDOFFILE__linkedin_post_hist'
# Post History
# Running log of LinkedIn posts created with this system.
# Used by /linkedin-post and /batch-create to enforce variety across pillars and templates.
#
# Schema for each entry:
#   date:      "YYYY-MM-DD"
#   topic:     "short topic label"
#   pillar:    "pillar name"
#   template:  "template-name"
#   hook_type: "bold / story / question / number / pattern-interrupt / vulnerability"
#   status:    "draft|published"
#   file:      "path/to/draft.md"

posts: []
ENDOFFILE__linkedin_post_hist

echo "  - linkedin post-history.yaml done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/00-research-synthesis.md" << 'ENDOFFILE__creator_00_research_synthesis'
# LinkedIn Creator Research Synthesis

**Date:** April 2026
**Scope:** 10 creators analyzed, hook psychology research, anti-pattern analysis

---

## Creators Studied

| Creator | Niche | Signature Move | Followers |
|---------|-------|---------------|-----------|
| Justin Welsh | Systems, solopreneurship | Content Matrix, Trailer/Meat/CTC | 750K+ |
| Sahil Bloom | Frameworks, mental models | Named frameworks (1-1-1 Method, etc.) | 1M+ |
| Lara Acosta | Personal branding | SLAY Framework, "how I" over "how to" | 200K+ |
| Alex Lieberman | Business storytelling | Cinematic scenes, raw vulnerability | 200K+ |
| Jasmin Alic | LinkedIn ghostwriting | Hook/Rehook, staircase formatting | 200K+ |
| Chris Donnelly | Business breakdowns | Emotional hooks, green visual brand, carousels | 1M+ |
| Dickie Bush / Nicolas Cole | Writing frameworks | 4A Framework, 1/3/1 rhythm, atomic essays | 500K+ combined |
| Tim Denning | Writing, anti-corporate | Visceral storytelling, confessional tone | 585K+ |
| Dr. Julie Gurner | Executive coaching | Ultra-brief coaching truths (2-4 sentences) | 125K+ |
| Sam Browne | Engagement strategies | Perfect Post Checklist, visual-always rule | 100K+ |

---

## Cross-Creator Pattern Analysis

### Universal Truths (Every successful creator does these)

1. **Hook investment.** Every creator treats the first 1-3 lines as the most important part of the post. Sam Browne spends 10-15 minutes on hooks alone. Jasmin Alic has a <45 character rule. Welsh writes hooks last.

2. **Specificity over generality.** Real numbers, real names, real timeframes. "I interviewed 100 CFOs" beats "I've talked to many executives." Nicolas Cole/Dickie Bush: "Specificity = credibility."

3. **One idea per post.** No creator tries to cover multiple topics. Jasmin Alic: "Only 1 problem per post." Dr. Gurner: one topic across ALL platforms.

4. **Short paragraphs.** Maximum 3 lines per paragraph (Alic's rule). Single-sentence paragraphs are common across all creators.

5. **Engagement close.** Every creator ends with something designed to generate comments -- a question, a prompt, or a call-to-conversation.

### Divergent Strategies (Where creators differ)

| Dimension | Short-Form Camp | Long-Form Camp |
|-----------|----------------|----------------|
| Post length | Dr. Gurner (2-4 sentences) | Alex Lieberman (long essays) |
| Formatting | Jasmin Alic (heavy formatting) | Dr. Gurner (zero formatting tricks) |
| Tone | Tim Denning (raw, provocative) | Sahil Bloom (warm, encouraging) |
| Structure | Justin Welsh (systematic, templated) | Alex Lieberman (narrative, organic) |
| Visual | Chris Donnelly (always visual) | Dr. Gurner (never visual) |
| Authority | Credentials-backed (Dr. Gurner) | Results-backed (Justin Welsh) |

### The Four Creator Archetypes

**1. The Systems Builder** (Welsh, Bush/Cole, Browne)
- Approach: Frameworks, templates, repeatable processes
- Strength: Consistency, scalability, teachability
- Risk: Can feel mechanical if overdone

**2. The Storyteller** (Lieberman, Denning, Acosta)
- Approach: Personal narratives, vulnerability, emotional arcs
- Strength: Connection, memorability, loyalty
- Risk: Requires personal experience to draw from

**3. The Authority** (Dr. Gurner, Bloom)
- Approach: Distilled wisdom, frameworks with named labels, coaching insights
- Strength: Save-worthy, shareable, positions as expert
- Risk: Can feel distant without personal stories

**4. The Optimizer** (Alic, Donnelly, Browne)
- Approach: Platform-specific tactics, formatting, algorithm awareness
- Strength: Maximizes reach and engagement per post
- Risk: Can feel like gaming the system if not paired with substance

---

## Hook Psychology: What the Research Shows

### Why Hooks Work (5 Psychological Drivers)

1. **Curiosity Gap** -- Promise info without revealing it. The Zeigarnik effect: unresolved questions compel continuation.
2. **Pattern Disruption** -- Break the expected scroll pattern. Force the brain from passive scanning to active reading.
3. **Emotional Arousal** -- High-arousal emotions (awe, anger, excitement, frustration) drive attention and sharing.
4. **Specificity + Credibility** -- Numbers, names, data, timeframes add concrete intrigue.
5. **Self-Interest** -- "What's in it for me?" must be answerable within 3 seconds.

### The 5-Criteria Hook Test

Before publishing, evaluate against:
1. **3-Second Test** -- Can the hook be understood instantly?
2. **Scroll-Stop Test** -- Would this pause YOUR scrolling?
3. **Curiosity Test** -- Does it create a knowledge gap?
4. **Relevance Test** -- Does it address your audience's priorities?
5. **Clarity Test** -- Is the promise immediately understandable?

### Technical Constraints

- LinkedIn shows ~210 characters above the fold on desktop, ~110 on mobile
- Hooks should work within ~15-20 words
- Posts with short sentences under 12 words perform 20% better
- Hooks longer than 1 line perform 20% worse (Jasmin Alic data)
- Hooks with negative words perform 30% worse (Jasmin Alic data)
- Ending with an easy-to-answer question shows 72% better engagement

### Classic Copywriting Wisdom Applied to LinkedIn

**David Ogilvy:** "When you advertise fire extinguishers, open with fire." Start with drama and immediacy.

**John Caples:** A hook should make an offer clear and appeal to self-interest immediately.

**Joseph Sugarman:** The first sentence's sole purpose is to get readers to read the second. Short, intriguing openings that create curiosity loops.

**General Principle:** Don't reveal everything. Withhold just enough to stir curiosity. End on a colon or question to imply more content follows.

---

## 10 Proven Hook Categories (Synthesized Across All Creators)

| # | Hook Type | Template | Best For |
|---|-----------|----------|----------|
| 1 | Bold Statement | "[Contrarian claim]. Here's why." | Opinion posts, reframes |
| 2 | Framework Reveal | "A [type] framework that changed [outcome]: [Name]." | Teaching, methodology |
| 3 | Story Opener | "[Specific time/place], [dramatic event]." | Personal narrative |
| 4 | Number-Driven | "[Number] [timeframe]. [Surprising outcome]." | Credibility, proof |
| 5 | Question | "[Question the reader can't immediately answer]?" | Engagement, reflection |
| 6 | Relatable Enemy | "The {enemy} is {negative}. The {hero} is {positive}." | Alignment, values |
| 7 | Transformation | "[Before state] -> [After state]. Here's how." | Journey posts |
| 8 | Coaching Truth | "[Direct reframe of common assumption]." | Authority, brevity |
| 9 | Specificity | "How [specific audience] can [specific action] to [outcome]" | Targeted value |
| 10 | Pattern Interrupt | "[Unexpected statement that breaks format expectations]." | Standing out |

---

## Anti-Patterns: The AI-Detection Problem

### The Data (from 500 AI-generated LinkedIn posts analyzed)
- 82% use one of just 3 opening patterns
- 91% use identical single-sentence-per-line formatting
- 73% contain the same vocabulary tells ("Here's the thing," "Let that sink in," "Game-changer")
- Posts scoring high on "AI polish" get 5x LESS engagement than imperfect-looking posts

### Rules to Avoid AI Detection
1. Write the opening line LAST
2. Include one deliberate imperfection (sentence fragment, tangent, parenthetical)
3. Use domain-specific vocabulary, not generic keywords
4. Vary structure between posts -- never use the same format twice in a row
5. Avoid: "Here's the thing," "Let that sink in," "Read that again," "Game-changer," "Full stop"
6. Avoid: emoji bullets, three-point structures with no specifics, "What do you think? Drop a comment below"
7. The top-performing post in the study had intentional "errors": mid-thought openings, standalone "Anyway," and no neat conclusion

---

## Encodable Techniques Summary

### For Post Templates (patterns that can be systematized)

1. **Welsh Scroll-Stopper:** RelatableEnemy -> Hero -> Gasoline + Teaser
2. **Bloom Named Framework:** Hook -> Context -> Named Framework -> Numbered Breakdown -> Story -> Takeaway -> CTA
3. **Acosta SLAY:** Story -> Lesson -> Actionable Advice -> You (engagement)
4. **Lieberman Vivid Scene:** Cinematic opener -> Story with stakes -> Turning point -> Extracted lesson -> Reflective close
5. **Alic Mic-Drop:** Hook (<45 chars) -> Rehook -> Problem -> Solution (staircase format) -> Power ending -> P.S.
6. **Donnelly Emotional Carousel:** Emotional hook -> Supporting line -> Carousel breakdown -> Engagement question
7. **Cole/Bush Atomic Essay:** 1/3/1 rhythm, under 250 words, one idea, clear > clever
8. **Denning Sacred Cow Attack:** Contrarian hook -> Archetype story -> Principle -> Tactical takeaways
9. **Gurner Coaching Truth:** Bold statement -> Brief reframe -> Prescriptive close (ultra-short)
10. **Browne Perfect Post:** Hook (10-15 min investment) -> Visual element -> Bold key points -> Self-tag -> Follow ask

### For the Hooks Swipe File (already updated)

Added 10 new hook categories with templates and examples:
- Framework-Reveal, Relatable Enemy, Transformation, Cinematic Scene-Setter, Coaching Truth, Specificity + Credibility, Mic-Drop/Power Statement, Playbook/Listicle, Anti-Corporate/Contrarian Identity
- Plus comprehensive Anti-Patterns section with data

### For Style Rules (cross-creator principles)

- Hook: under 45 characters (Alic), or under 210 characters (technical max), or 9 words max (Cole/Bush)
- Paragraphs: never more than 3 lines
- Reading level: grade 3-5 (Hemingway App)
- Always include visual element (Browne, Donnelly)
- 1/3/1 rhythm for pacing (Cole)
- Write hooks LAST (Welsh)
- One idea per post, one problem per post
- CTC (call-to-conversation) over CTA (call-to-action)
- Check post on mobile before publishing
- Vary format between posts -- never repeat the same structure consecutively

ENDOFFILE__creator_00_research_synthesis

echo "  - 00-research-synthesis creator study done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/alex-lieberman.md" << 'ENDOFFILE__creator_alex_lieberman'
# Creator Study: Alex Lieberman

**Niche:** Business storytelling, entrepreneurship, mental health, content strategy
**Followers:** 200K+ on LinkedIn, co-founder Morning Brew (acquired for $75M+)
**Known for:** Narrative-driven posts, raw vulnerability, conversational wit, cinematic storytelling

---

## Signature Format: The Vivid Scene + Extracted Lesson

Lieberman's posts drop readers into a specific, cinematic moment before extracting a broader principle. Unlike list-based creators, his posts read like short essays or mini-memoirs.

### Structure:
```
[Vivid scene-setting with specific details]

[The story unfolds with stakes and tension]

[The turning point or realization]

[Extracted principle or lesson]

[Reflective question or vulnerable admission]
```

---

## Hook Patterns (Actual Examples)

**Cinematic Scene-Setters:**
- "1 month into my first job in Finance, 25% of my division was laid off in 2 hours. People anxiously sat at their desks waiting to see if they got a call from 'FRONT DESK.' If they did, they knew what that meant..."
- "Day 1 of Morning Brew, all we had was a product & a vision."

**Vulnerability Bombs:**
- "WARNING: this is a long ass post. But I have a sneaky suspicion it's the most valuable post you'll read all week."
- "A few reflections on post-exit founder life: feeling like a failure, finding new purpose..."
- "The painful lessons I learned as CEO..."

**Contrarian/Reframe:**
- "The idea of 'stability' in Corporate America is a fallacy. Quick story..."
- "Insecurity is a superpower."

**Rules/Framework Hooks:**
- "RULES OF CONNECTION: 1. depth of connection > # of connections..."
- "6 things that made Morning Brew's 8-figure exit possible..."

---

## Structural Approach: Hook to CTA

1. **Opening:** Drops into a specific moment with sensory details -- time, place, emotional state. No preamble. Like a movie that starts mid-scene.
2. **Story:** Unfolds with real stakes (layoffs, near-failure, relationship tension). Uses real names, real companies, real numbers.
3. **Turning Point:** A moment of realization or reversal. Often framed as "here's what I didn't see at the time."
4. **Principle Extraction:** The lesson is drawn FROM the story, never imposed ON it. Feels discovered rather than taught.
5. **Reflective Close:** Often a question that invites the reader to share their own version. Sometimes an admission that he's still figuring it out.

---

## Writing Style Characteristics

**Voice:**
- Conversational and witty -- Morning Brew hired "a voice editor from Michigan's improv troupe" to create this tone
- Self-deprecating humor balanced with genuine insight
- Reads like a smart friend texting you a story, not a LinkedIn post

**Sentence Structure:**
- Mix of long narrative sentences and short punchy fragments
- Parenthetical asides that add personality
- Rhetorical questions sprinkled throughout to maintain engagement

**Content Approach:**
- "Everything is a case study where everything is a story that has specificity, but then it's actionable with a higher level lesson"
- Teaches by asking: "How will someone apply what I'm saying to their job or life in the near future?"
- Playbook creation process: Answer "If I could have just 1 follower, who would that follower be?", identify repeatable processes they'd find helpful, document the process, turn it into a long post

---

## Key Themes

- **Post-exit identity crisis.** Openly discusses feeling lost after selling Morning Brew.
- **Vulnerability as leadership.** "Vulnerability begets vulnerability" -- he started the "Imposters" podcast to normalize insecurity.
- **Building vs. coasting.** Posts about the tension between achievement and satisfaction.
- **Storytelling as competitive advantage.** "The ability to storytell is what gave us legitimacy."

---

## What Makes Lieberman Distinctive

- **Cinematic quality.** His posts read like short films. Specific details (7am, Tuesday, FRONT DESK) make scenes feel real and lived, not manufactured.
- **Unpolished authenticity.** He doesn't clean up his vulnerability. Posts about failure, confusion, and not having answers feel genuine because he doesn't wrap them in neat lessons.
- **Story BEFORE lesson.** Many creators state the lesson then tell the story. Lieberman inverts this -- the story earns the right to teach.
- **Morning Brew credibility without leaning on it.** He has massive credibility but uses it as context, not as the point.
- **Wit as formatting.** Where others use bullets and bold text, Lieberman uses humor and rhythm to keep readers engaged through longer-form content.
- **Mental health as content.** He's one of the few business creators who openly discusses anxiety, impostor syndrome, and identity crisis -- and ties it back to entrepreneurship without making it feel performative.

---

## Encodable Techniques

**For templates:**
- The Vivid Scene Post (cinematic opener -> story with stakes -> turning point -> extracted lesson -> reflective close)
- The Playbook Post (identify 1 ideal follower -> their repeatable process -> document it -> teach it)
- The Rules Post (RULES OF [TOPIC]: numbered principles from experience)

**For hooks swipe file:**
- "[Time detail] into [situation], [dramatic event]. [Specific sensory detail]."
- "WARNING: this is a long post. But [compelling reason to read]."
- "A few reflections on [vulnerable topic]:"
- "The idea of '[sacred cow]' is a fallacy. Quick story..."
- "[Number] things that made [specific achievement] possible:"

**For style rules:**
- Drop into scenes mid-action, no preamble
- Use specific details (names, numbers, times, places)
- Story earns the right to teach -- never lead with the lesson
- Leave in imperfections and uncertainty
- Humor and personality are formatting tools
- Reflective questions > prescriptive CTAs

ENDOFFILE__creator_alex_lieberman

echo "  - alex-lieberman creator study done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/chris-donnelly.md" << 'ENDOFFILE__creator_chris_donnelly'
# Creator Study: Chris Donnelly

**Niche:** Business breakdowns, leadership, entrepreneurship coaching
**Followers:** 1M+ on LinkedIn
**Known for:** Green visual brand, emotional hooks, carousel mastery, mentor tone

---

## Signature Format: The Emotional Hook + Carousel Breakdown

Donnelly's signature is combining emotionally resonant text hooks with visually consistent carousel images. His posts feel like a mentor pulling you aside to share a hard-won lesson.

### Structure:
```
[Emotional hook -- evokes a feeling, not just curiosity]

[Short, impactful supporting statement]

[The breakdown -- often delivered as a carousel]

[Closing question to spark engagement]
```

---

## Five Hook Types (From Donnelly's Own Teaching)

1. **"How I..." (Personal Experience)**
   - Shares a real experience with specific outcomes
   - Example: "How I built a personal brand with 1M followers"

2. **"How to..." (Actionable Advice)**
   - Practical, step-by-step guidance
   - Example: "How to grow your LinkedIn from 0 to 10K followers"

3. **Start a Story (Curiosity-Driven)**
   - Opens with a narrative moment that demands resolution
   - Example: "People don't just quit bad jobs..."

4. **Captivating Quote (Emotional Pull)**
   - Opens with a quote that evokes a strong feeling
   - Example: "Follow your passion is bad career advice."

5. **Surprising Statistic (Data-Backed)**
   - Leads with a number that challenges assumptions
   - Example: "90% of a high-performing post: The hook."

---

## Hook Rules (From Donnelly)

- Keep hooks under 100 characters
- Personal stories always outperform corporate talk
- Add data whenever possible for credibility
- Use white space for readability
- End with a question to spark engagement
- Hooks should evoke an emotional response, not just be catchy headlines

---

## Content Format Distribution

- **Image-based posts:** 57% of content (highest average likes at ~2,900 per post)
- **Carousels:** 32% (superior engagement and reach -- his most effective format for educational content)
- **Short videos:** Recently incorporated

---

## Visual Brand Strategy

- Consistent **green color theme** throughout profile banner and carousel images
- Creates "instantly recognizable" branding in the feed
- Carousel covers are bold, clean, high-contrast
- Visual consistency means followers recognize his content before reading a word

---

## Structural Approach: Hook to CTA

1. **Hook:** Emotionally resonant opening. Under 100 characters. Evokes surprise, empathy, or challenge -- not just curiosity.
2. **Supporting Line:** Short, impactful phrase that deepens the hook. Easy to read and scan.
3. **Body/Carousel:** Addresses audience pain points with clear, actionable advice. Each point is concise.
4. **Closing:** Question designed to spark engagement. Direct asks for likes, comments, or shares.

---

## Writing Style Characteristics

**Tone:**
- Conversational and motivational
- Speaks directly to the reader like a one-on-one conversation
- Empathetic and direct -- rarely uses jokes or sarcasm
- "Feels more like a mentor than a marketer"

**Writing Rules:**
- Write like you speak
- Talk to one person, not the crowd
- Short, impactful phrases
- White space for readability
- Data for credibility

**Content Focus:**
- Leadership (27% of posts)
- Entrepreneurship
- Coaching/personal development
- Business breakdowns

---

## Posting Cadence

- 8 times per week (daily+)
- Peak time: 7:00-8:00 AM
- Fridays generate peak engagement
- Like clockwork -- consistency is core to his strategy

---

## What Makes Donnelly Distinctive

- **Visual brand identity.** The green theme makes his content recognizable at scroll speed. This is rare -- most creators are visually interchangeable.
- **Emotional hooks over clever hooks.** Where Jasmin Alic optimizes for format and Justin Welsh optimizes for systems, Donnelly optimizes for FEELING. His hooks make you feel something before you read anything.
- **Mentor energy.** His tone is that of an experienced mentor giving advice, not a peer sharing what they learned today. This authority + warmth combination is his voice signature.
- **Carousel mastery.** He understands that carousels get more reach AND more saves (algorithm signal), and designs them as educational mini-courses.
- **Posting volume.** 8x/week is significantly higher than most creators, and he maintains quality throughout.

---

## Encodable Techniques

**For templates:**
- The Emotional Hook + Carousel Post (emotional hook -> supporting line -> carousel breakdown -> engagement question)
- The 5 Hook Types framework (How I / How to / Story / Quote / Statistic)
- The Mentor Advice Post (empathetic opener -> hard-won lesson -> actionable takeaway -> engagement close)

**For hooks swipe file:**
- "People don't just quit bad jobs. [They quit...]"
- "Follow your passion is bad career advice."
- "How I [specific achievement with number]"
- "How to [desired outcome] in [timeframe or steps]"
- "[Surprising statistic]% of [topic]."
- "[Emotional quote that challenges a belief]."

**For style rules:**
- Hooks under 100 characters
- Emotional resonance > cleverness
- Add data for credibility
- Write like you speak, to one person
- Mentor tone: authoritative + warm
- End every post with an engagement question
- Consistent visual brand across all content

ENDOFFILE__creator_chris_donnelly

echo "  - chris-donnelly creator study done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/dickie-bush-nicolas-cole.md" << 'ENDOFFILE__creator_dickie_bush_nicolas_cole'
# Creator Study: Dickie Bush & Nicolas Cole

**Niche:** Digital writing, ghostwriting, writing frameworks
**Platform:** Ship 30 for 30, Premium Ghostwriting Academy
**Followers:** Combined 500K+ on LinkedIn
**Known for:** Atomic essays, 4A framework, 1/3/1 rhythm, credible headlines, systematic writing

---

## Signature Format: The Atomic Essay

A short, high-impact piece of writing under 250 words that distills one idea clearly and effectively. The constraint is the point -- it forces precision.

### Atomic Essay Structure:
```
[Credible Headline -- tells who, what, and benefit]

[1-sentence hook: bold claim or curiosity gap]

[3-sentence expansion: explain, build, create momentum]

[1-sentence takeaway]

[Repeat 1/3/1 pattern as needed]

[One-sentence engagement question]
```

---

## The 4A Framework (Idea Generation)

Every idea can be written in 4 different ways. This is their core ideation system:

### 1. Actionable (Here's how)
Tips, hacks, resources, guides. Teaches the reader HOW to do something.
- Example: "Here's how to buy your first property in 90 days"

### 2. Analytical (Here are the numbers)
Breakdowns with data, frameworks, processes. Supports with analysis.
- Example: "Here's what's happening in the economy and real estate trends"

### 3. Aspirational (Yes, you can!)
Stories of how you or others put the idea into practice. Lessons, mistakes, reflections.
- Example: "I bought my first property at 23. Here's what I wish I knew."

### 4. Anthropological (Here's why)
Speaks to universal human nature. Fears, failures, struggles, paradoxes, observations.
- Example: "Why most people never buy property -- and the psychological barrier behind it"

**Key insight:** The same core idea attracts DIFFERENT readers depending on which of the 4A angles you choose. Actionable attracts doers. Analytical attracts thinkers. Aspirational attracts dreamers. Anthropological attracts observers.

---

## The 1/3/1 Writing Rhythm

Nicolas Cole's signature formatting technique -- "the most underrated writing format on the Internet":

### Structure:
- **(1)** First sentence: one strong, declarative statement
- **(3)** Next three sentences: shorter, drive the point home, build momentum
- **(1)** Last sentence: one big takeaway

### Why it works:
- Single sentences stand out visually, signaling ease of consumption
- The psychological effect encourages readers to continue before they consciously decide to
- Creates rhythm readers experience subconsciously
- Improves skimmability
- Creates visual breaks from dense text blocks
- "Keep the bookends short" -- flexibility in the middle sections

### Example:
```
This is the single most important writing skill.

Most people bury their point in long paragraphs.
They lose the reader halfway through.
Clarity wins every time.

The 1/3/1 rhythm makes your writing impossible to skim past.
```

---

## The Credible LinkedIn Post Template

Their formula for LinkedIn posts that borrow authority:

```
The {superlative} {credible thing}: {Credible Source}.

{Personal connection to benefit}.

Here are {number of things} you can use to {desired outcome}.

[Num] [Thing]: {What you're talking about.}
{Benefits / why it's relevant.}
{How the audience can apply it.}

---

[One-sentence takeaway that ties it all together].

{Easy-to-answer engagement question}
```

---

## Hook Patterns (Actual Examples and Formulas)

**The Bold Promise:**
- Opening hook must be 9 words or less maximum
- Creates a curiosity gap immediately

**The Credibility Borrow:**
- Lead with someone else's authority
- "According to [Expert], the single biggest mistake in [topic] is..."

**The Specificity Hook:**
- "How Middle-Market SaaS Product Managers Can Use The Eisenhower Matrix To Streamline Their Day"
- Target one specific person to unlock a specific benefit
- Specificity = credibility

**The How-To with Promise:**
- "How to [specific outcome] without [pain point]"
- "[Number] simple steps to [desired result]"

**The 1-5-50 Method:**
- Start with 1 topic
- Turn it into 5 proven hooks
- Transform those into 50 variations
- Scale idea generation mathematically

---

## Structural Approach: Hook to CTA

1. **Headline/Hook:** Maximum 9 words. Clear, not clever. Tells the reader what AND who it's for.
2. **Lead-In:** Preview the value. Create curiosity without revealing everything.
3. **Main Points:** Numbered, scannable. Each point has: what it is, why it matters, how to apply it.
4. **One-Sentence Takeaway:** Ties everything together.
5. **CTA:** In comments, not in the post. Easy-to-answer engagement question.

---

## 10 Curateable Content Types

Universal content categories that always perform:
1. Lessons worth learning
2. Mistakes worth avoiding
3. Tips worth following
4. Frameworks worth using
5. Stories worth hearing
6. People worth following
7. Books worth reading
8. YouTube videos worth watching
9. TED Talks worth listening to
10. Podcasts worth listening to

---

## What Makes Bush/Cole Distinctive

- **Frameworks for everything.** They don't just teach writing -- they build systems that remove creative friction. 4A, 1/3/1, Atomic Essays, the Credible Headline -- everything is systematized.
- **Constraint-based writing.** The 250-word atomic essay, the 9-word hook, the 1/3/1 pattern -- their entire philosophy is that constraints produce better writing.
- **"Clear beats clever."** They reject wordplay, puns, and creative headlines in favor of headlines that tell you exactly what you're getting.
- **Borrowed credibility.** Their curation framework lets new writers publish authoritative content by curating from established sources.
- **Cross-platform thinking.** They teach writing that works on Twitter, LinkedIn, newsletters, and blog posts -- not platform-specific hacks.
- **Volume + speed.** Ship 30 for 30 is about publishing daily. Their entire philosophy prioritizes output over perfection.

---

## Encodable Techniques

**For templates:**
- The Atomic Essay (under 250 words, one idea, 1/3/1 rhythm)
- The 4A Variation (same idea in 4 angles: actionable, analytical, aspirational, anthropological)
- The Credible LinkedIn Post (superlative + source + personal connection + numbered points + takeaway)
- The Curation Post (10 curateable content types as frameworks)

**For hooks swipe file:**
- Maximum 9 words
- "The {superlative} {credible thing}: {Source}."
- "How [specific audience] can [specific action] to [specific outcome]"
- "[Number] [things] worth [verb]-ing"
- "The single most [adjective] [thing] about [topic]:"

**For style rules:**
- 1/3/1 rhythm throughout every post
- Keep bookends short (opening and closing sentences)
- 250-word maximum for atomic essays
- Clear over clever -- always
- CTAs in comments, not in the post
- Every numbered point: what it is + why it matters + how to apply
- Specificity = credibility

ENDOFFILE__creator_dickie_bush_nicolas_cole

echo "  - dickie-bush-nicolas-cole creator study done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/dr-julie-gurner.md" << 'ENDOFFILE__creator_dr_julie_gurner'
# Creator Study: Dr. Julie Gurner

**Niche:** Executive coaching, high performance, psychology-backed leadership
**Followers:** 125K+ on X, significant LinkedIn presence
**Known for:** "Ultra Successful" newsletter (40K+ subscribers), short-form wisdom, behind-the-scenes coaching insights

---

## Signature Format: The Coaching Insight

Dr. Gurner's posts are distinctly different from other LinkedIn creators. While most write long-form content with hooks and formatting tricks, her posts are SHORT -- often just 2-4 sentences of distilled wisdom from her coaching sessions with ultra-high performers.

### Structure:
```
[Bold declarative statement -- a coaching truth]

[Brief explanation or reframe -- 1-2 sentences]

[Prescriptive close or actionable principle]
```

This is the shortest format of any major LinkedIn creator. No stories, no numbered lists, no carousels. Just pure, concentrated insight.

---

## Hook Patterns (Actual Examples)

**Declarative Coaching Truths:**
- "If your work, company, or life isn't moving in the direction you wish... it's often because you are obsessing over the wrong things."
- "Contrary to belief, knowledge is not power... execution is power."
- "Anytime you are 'rushing' in the day, you are diluting your effectiveness -- not covering more ground."

**Reframing Posts:**
- "What you obsess over will be incredibly predictive of the results you get."
- "Working to become 'undeniable' is far different than working to become competent... A Category Defining Person... The Best."
- "Paying too much attention to what other people are doing disrupts your own clarity."

**Prescriptive Commands:**
- "Do not get stuck in the cycle of endless learning. Make the move, and jump in."
- "Take the time, and do it right."
- "Sometimes you have to put the phone down, grab a notebook, and really start writing about what you want for yourself."

---

## Writing Style Characteristics

**Brevity as Authority:**
- Her posts are dramatically shorter than competitors
- This brevity signals: "I don't need to explain myself. This is how it is."
- The short format feels like a coaching session distillation -- what the coach would say in 30 seconds

**Tone:**
- Direct and unvarnished -- "NOT sugarcoating anything"
- Professional truth-bomber
- Down-to-earth despite premium positioning ($8K/month coaching, 2-year waitlist)
- Authoritative without being academic

**Content Source:**
- Pulls directly from coaching sessions with top performers
- "Behind-the-scenes" energy -- like getting a peek into conversations with CEOs and founders
- Every post has a takeaway people can use in their own lives. "If it's not providing real takeaways people can use, she won't post it."

**Focus Discipline:**
- Consistently talks about the SAME thing across all platforms
- "People go too broad so no one, they never get known for anything."
- Her niche is narrow: high-performance mindset and execution for leaders

---

## Key Philosophy: Obsession Over Discipline

The core of her teaching: "You have to be obsessed with things to get to the top 1%. I don't think you have to be obsessed to be good, but I think you have to be obsessed to be great."

This philosophy shows up in her writing approach too:
- Obsessive focus on one topic
- Obsessive brevity (every word earns its place)
- Obsessive value delivery (no post without a takeaway)

---

## Content Themes

- **Execution > knowledge.** "Knowledge is not power... execution is power."
- **Obsession > discipline.** Top 1% requires obsession, not just showing up.
- **Clarity > activity.** Stop rushing, stop overthinking, get clear on what matters.
- **Self-awareness > external validation.** Stop watching others, focus on your own path.
- **Hard conversations early.** "Fight Up Front" -- building teams that fire on all cylinders.
- **Being "undeniable."** The difference between competence and category-defining excellence.

---

## What Makes Gurner Distinctive

- **Extreme brevity.** In a world of long-form LinkedIn posts, her 2-4 sentence format is a radical differentiator. While everyone else is writing 300+ word posts, she's dropping 50-word coaching bombs.
- **Credential-backed authority.** Doctor of psychology + decade of executive coaching + $8K/month waitlisted practice. Her brevity works BECAUSE of this credibility -- she's earned the right to be concise.
- **Behind-the-scenes access.** Her content feels like leaked coaching notes. "Insanely useful tips she pulls from coaching sessions with top names in the business world." This exclusivity is her content moat.
- **No formatting tricks.** No staircase format, no emoji bullets, no carousels. Just sharp writing. This positions her above the LinkedIn game, not in it.
- **Premium positioning reflected in content.** Her posts feel expensive. The brevity, directness, and authority mirror her coaching positioning -- you get more value in fewer words.
- **Audacity in writing.** "Audacity for a writer looks like saying the things that you truly want to say. Sometimes we are too tender with our words."

---

## Encodable Techniques

**For templates:**
- The Coaching Truth Post (bold statement -> brief explanation/reframe -> prescriptive close)
- The Execution Challenge (identify common trap -> reframe it -> prescriptive action)
- Ultra-Short Wisdom Post (single powerful observation, no elaboration needed)

**For hooks swipe file:**
- "If your [area] isn't [desired state]... it's often because [surprising cause]."
- "Contrary to belief, [common assumption] is not [expected]... [real answer] is."
- "Anytime you are [common behavior], you are [unexpected negative consequence]."
- "Working to become [level] is far different than working to become [higher level]."

**For style rules:**
- Maximum brevity -- if you can say it in fewer words, do
- No formatting tricks (no emojis, no staircase, no carousels)
- Every post must have a usable takeaway
- Direct, unvarnished tone
- One topic per post, one topic across all platforms
- Credential backs up brevity -- earn the right to be concise
- "Say the things you truly want to say"

ENDOFFILE__creator_dr_julie_gurner

echo "  - dr-julie-gurner creator study done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/jasmin-alic.md" << 'ENDOFFILE__creator_jasmin_alic'
# Creator Study: Jasmin Alic

**Niche:** LinkedIn ghostwriting, content formatting, hooks
**Followers:** 200K+ on LinkedIn
**Known for:** "King of LinkedIn formatting," hook/rehook system, staircase formatting, mic-drop endings

---

## Signature Format: The Hook-Rehook-Staircase

Jasmin Alic is arguably the most format-conscious creator on LinkedIn. His posts are visually distinctive -- they look different from everything else in the feed.

### The Hook-Rehook System

**The Hook:** Gets you in the room. Makes it interesting. Must be 1 line, under 45 characters.
- "The hook gets you in the room, it makes it interesting..."

**The Rehook:** Slams the door behind you. Keeps you reading to the end.
- "...but the rehook slams the door behind you, and it keeps you reading till the very end."
- The rehook makes a promise and crushes any objections. It's the line right after the hook that removes the reader's reason to leave.

### The Staircase Format

Jasmin's posts are visually formatted to look like a staircase -- each line is short, standalone, and leads to the next. This creates a "slide" effect where the reader can't stop.

---

## Formatting Rules (From Jasmin's Teaching)

These are hard rules, not suggestions:

1. **Hooks are always 1 line.** Hooks longer than 1 line perform 20% worse.
2. **No negative words in hooks.** Hooks with "negative" words perform 30% worse.
3. **Never write paragraphs longer than 3 lines.** Break everything up.
4. **Lists use numbers, not bullet points.** Numbers create hierarchy and progress.
5. **List items are one-liners only.** No multi-sentence list items.
6. **White space is a formatting tool.** Use it aggressively between sections.
7. **Mobile-first preview.** His "secret" formatting hack: if the post doesn't fit on your phone's screen, rewrite it shorter.
8. **Writing is 90% psychology and 10% formatting.** But that 10% matters enormously.

---

## The Mic-Drop Post Recipe

Jasmin's formula for high-performing posts:

1. **Short hook** -- 1 liner, under 45 characters
2. **Clear problem displayed** -- Only 1 problem per post
3. **Visual formatting** -- Make it easy to read (staircase format)
4. **Power ending** -- Quotable statement that could stand alone as a post
5. **Simple P.S.** -- Involve the reader instantly ("P.S. What's your take?")

---

## Hook Patterns (Actual Examples)

**Short Declarative:**
- "Formatting your LinkedIn posts matters a lot."
- "This might be my biggest LinkedIn post ever."
- "Treat every word you write like you're on stage."

**Promise + Specificity:**
- "How to Format Your LinkedIn Posts" (1,500+ comments)
- "27 Proven LinkedIn Writing Tips"
- "Want the easiest way to write LinkedIn hooks?"

**Confession/Personal:**
- "I write like you're on stage. Better make your presence known."

---

## Structural Approach: Hook to CTA

1. **Hook:** Single line. Under 45 characters. Clear, specific, no negatives.
2. **Space.**
3. **Rehook:** The line that slams the door. Makes a promise or crushes objections. Also short.
4. **Space.**
5. **Problem Statement:** One problem, clearly stated. No multi-problem posts.
6. **Solution/Content:** Short paragraphs (never more than 3 lines). Numbers for lists. One-liners for list items. Staircase visual flow.
7. **Power Ending:** A quotable, standalone statement. "Mic drop" energy.
8. **P.S.:** Simple engagement hook. "P.S. What's yours?" or "P.S. Tag someone who needs this."

---

## Writing Style Characteristics

**"Dear Son" Approach:**
- Write to one person, not millions
- Conversational tone
- Don't make readers think -- present ideas clearly and simply

**Energy Matching:**
- The energy of the entire post must match the hook's energy
- If the hook is bold, the body must be bold
- If the hook is tender, the body must be tender
- Mismatch = drop-off

**Specificity:**
- "Specificity sells" -- vague posts underperform
- Use real numbers, real examples, real details
- The more specific, the more the reader "hooks" in

---

## What Makes Alic Distinctive

- **Format as brand.** His posts are visually recognizable before you read a word. The staircase format, aggressive white space, and short lines are his visual signature.
- **The rehook concept.** Most creators talk about hooks. Alic is the one who codified the REHOOK -- the second line that keeps you after the first line pulls you in.
- **Under 45 characters.** His hook length rule is the most specific, measurable hook guideline from any creator.
- **Formatting > writing (partially).** He's the only top creator who argues formatting might matter MORE than the writing itself -- a contrarian take in the content world.
- **Teaching by doing.** His most viral posts ARE about how to format LinkedIn posts -- he demonstrates the format while teaching it.
- **Ghostwriter perspective.** Unlike personal brand creators, Alic writes for others. This gives him pattern recognition across many different voices and audiences.

---

## Encodable Techniques

**For templates:**
- The Mic-Drop Post (hook -> rehook -> problem -> solution -> power ending -> P.S.)
- The Staircase Format (visual formatting rules)
- The Formatting Tutorial Post (teach the format using the format)

**For hooks swipe file:**
- Keep under 45 characters
- Single line only
- No negative words
- "[Strong claim in under 8 words]."
- "How to [specific skill or format]"
- "This might be my [superlative] [thing] ever."

**For style rules:**
- Hook: 1 line, under 45 characters, no negatives
- Rehook: promise + objection crusher, right after hook
- Max 3 lines per paragraph
- Numbers over bullet points
- One-liners for list items
- Power ending: standalone quotable statement
- P.S. for engagement
- Energy of body must match energy of hook
- Test on mobile screen before posting

ENDOFFILE__creator_jasmin_alic

echo "  - jasmin-alic creator study done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/justin-welsh.md" << 'ENDOFFILE__creator_justin_welsh'
# Creator Study: Justin Welsh

**Niche:** Systems, solopreneurship, one-person businesses
**Followers:** 750K+ on LinkedIn
**Known for:** Repeatable content systems, content matrix, viral post templates

---

## Signature Format: The Trailer / Meat / CTA Structure

Justin Welsh builds every post around a deliberate three-part architecture:

### Part 1: The Trailer (Hook Section)
Everything above LinkedIn's "...see more" button. This section has exactly two jobs:
1. Break the scroll pattern with the first line
2. Make the hook line compelling enough to click "see more"

Every line must earn the next line. The first line breaks the scroll, the second builds tension or curiosity, and the last line before "see more" promises a payoff worth clicking for.

**Format rule:** 3 short lines with spaces between them for easy readability. Never a wall of text above the fold.

### Part 2: The Meat
The core teaching, learnings, or advice. Welsh starts by identifying 2-3 key takeaways the reader needs. This is the substance -- the reason the post exists. He writes the meat FIRST, then writes the trailer to match.

### Part 3: Summary + Call-to-Conversation (CTC)
- A "TL;DR" that packages the content in 1-2 sentences
- A CTC (not CTA) -- a question or invitation designed to increase comments
- The CTC turns passive readers into participants

---

## The "Scroll-Stopper" Viral Post Template

Welsh's most detailed template for viral posts, which generated 4.7M impressions:

**Template:**
```
The {RelatableEnemy} is {Negativity}

The {Hero} is {StrongPositiveStatement}

And I {Gasoline}. {TeaserQuestion}?
```

**Example:**
```
The 9 to 5 is getting pummeled.

The great resignation is growing faster than ever.

And I love it. Why?
```

**How it works:**
1. **Scroll-Stopper** -- Names a "relatable enemy" the audience already dislikes. Must work within 210 characters (the "above the fold" limit).
2. **Flip the Script** -- Transitions from attacking the enemy to championing the hero (what readers want instead).
3. **Gasoline + Teaser** -- Amplifies emotional investment with personal enthusiasm, then a question that drives the "see more" click.

---

## The Content Matrix Framework

Welsh's system for never running out of ideas. A 2D grid:

**Y-Axis (Themes):** Topic categories relevant to your niche (e.g., "Email tools," "Customer drips," "Subject lines")

**X-Axis (Styles) -- 8 content types:**
1. **Actionable** -- Ultra-specific guide teaching HOW to do something
2. **Motivational** -- Inspirational stories about people who did something extraordinary
3. **Contrarian** -- Go against common advice, explain why
4. **Observation** -- Hidden or silent trends in the industry
5. **X vs. Y** -- Compare two entities, styles, frameworks
6. **Present vs. Future** -- Status quo vs. prediction, explain why
7. **Listicle** -- Useful list of resources, tips, mistakes, lessons, steps
8. **Analytical** -- Data-driven breakdowns

**Workflow:** Choose a topic -> Match to a style -> Write a quick headline -> Repeat until you have 10 ideas.

---

## Hook Patterns (Actual Examples)

**Contrarian/Bold:**
- "Most career advice is terrible. Here's what actually works."
- "The 9 to 5 is getting pummeled."
- "Most founders are solving the wrong hiring problem."

**Number-Driven:**
- "How to turn 1 idea into 7 pieces of LinkedIn content."
- "One idea = 5 LinkedIn posts: 1. Teach 2. Observe 3. Contrarian 4. Listicle 5. Story"

**Process/How-To:**
- "How to write viral posts on LinkedIn: 1. Pick a really specific sub-niche..."
- "5-step copywriting formula..."
- "10 of the most useful LinkedIn writing tips..."

---

## Structural Approach: Hook to CTA

1. **First line:** Short, scroll-stopping (under 12 words ideal). Uses contrarian claims, surprising numbers, or relatable enemies.
2. **Lines 2-3:** Build tension or curiosity. Never resolve the hook -- deepen it.
3. **"See more" line:** Promise of payoff ("Here are 2 big learnings and some advice").
4. **Body:** Short paragraphs (1-3 sentences each). Single-sentence paragraphs common. Each paragraph can stand alone as a tweet.
5. **TL;DR:** 1-2 sentence summary packaging the whole post.
6. **CTC:** Question that invites comment ("What's worked for you?").

---

## What Makes Welsh Distinctive

- **Systems thinking applied to content.** He doesn't just write posts -- he builds repeatable systems (content matrix, templates) that generate posts at scale. Every high-performing post becomes a template he reuses.
- **Writes the hook LAST.** Unlike most creators who start with the hook, Welsh writes the meat first, then engineers the hook to match.
- **Anti-fluff.** Short, clear, no wasted words. Single-sentence paragraphs. Grade-school reading level.
- **Templates over inspiration.** He analyzed 1,188 of his own posts from 2019-2022, templatized the top 100, and reuses the patterns.
- **CTC over CTA.** He doesn't ask people to buy or follow -- he asks a question that generates conversation.

---

## Encodable Techniques

**For templates:**
- The Scroll-Stopper template (Relatable Enemy / Hero / Gasoline + Teaser)
- The Content Matrix (Theme x Style grid for idea generation)
- The 1-idea-to-7-posts expansion system
- The Trailer / Meat / CTC post structure

**For hooks swipe file:**
- "Most [people/founders/leaders] think [X]. They're wrong."
- "The {RelatableEnemy} is {Negativity}."
- "One [thing] = [number] [things]: [list]"
- "How to [achieve result] in [number] steps"

**For style rules:**
- 3 short lines with spaces above the fold
- Write the hook last
- Every paragraph should work as a standalone tweet
- TL;DR + CTC closing pattern

ENDOFFILE__creator_justin_welsh

echo "  - justin-welsh creator study done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/lara-acosta.md" << 'ENDOFFILE__creator_lara_acosta'
# Creator Study: Lara Acosta

**Niche:** Personal branding, LinkedIn coaching, content marketing
**Followers:** 200K+ on LinkedIn (#1 female creator in UK for personal branding)
**Known for:** SLAY framework, Educational Storyteller Method, high-engagement hooks

---

## Signature Format: The SLAY Framework

Lara's core content formula, responsible for tens of millions of impressions:

### S - Story
Begin with a personal narrative. Your story is your primary competitive advantage in saturated markets. Every piece of content must have an ingrained story -- that's what makes it feel unique and hers.

### L - Lesson
Extract and share a valuable insight derived from personal experience. Connect the head -- make the reader think.

### A - Actionable Advice
Provide concrete, implementable steps readers can apply immediately. Connect the hands -- give them something to DO.

### Y - You
Close with an engagement question or call-to-action that encourages community participation. Turn the post into a conversation.

---

## The Educational Storyteller Method

A complementary framework to SLAY:
1. **Platitude** -- Makes it broad (relatable to many)
2. **Story** -- Adds personality (unique to you)
3. **Lesson** -- Keeps it niche (valuable to your audience)

This transforms "how to" into "how I" -- turning generic advice into personal testimony.

---

## Hook Patterns (Actual Examples)

**Mystery/Secrecy:**
- "I've never talked about this engagement hack before"
- "LinkedIn gurus will tell you to focus on the hook. But all my best-performing posts have more than one."

**Specific Numbers:**
- "I asked 100 of my customers why they paid me 2k+"
- "How to build your personal brand on LinkedIn: (From someone who's built hers from 0-107k)"

**Bold Claims:**
- "The number 1 mistake LinkedIn creators make"
- "The best personal branding lesson you'll receive today"

**Unexpected Scenario:**
- "Hired a Gen-Z candidate without interviewing him" (her most engaging hook -- unexpected scenarios compel engagement)
- "One day I'm signing up to LinkedIn, and the next I'm ranked #1 female creator"

**Transformation:**
- "I packed a one-ticket flight, and it changed my life."
- Her storytelling always starts with a transformation as the hook, then briefly touches the struggle, quickly shifts into a lesson, has an immediate resolution, and ends with a "feel good" statement.

---

## Structural Approach: Hook to CTA

1. **Hook:** Bold claim, mystery, or transformation opener. Always focuses on 1 topic. Uses numbers, names, or stats to add specificity.
2. **Story:** Brief personal narrative. Keeps the struggle short -- "cut the fluff." Takes the reader from low to high.
3. **Lesson:** Quick pivot to actionable insight. "Write each sentence like it's the last (be precise)."
4. **Actionable Advice:** Concrete steps or principles the reader can apply now.
5. **Feel-Good Closer:** Platitude or empowering statement that resolves the emotional arc.
6. **Engagement Question:** Direct question to the reader to spark comments.

---

## Writing Style Rules (From Lara's Own Teaching)

**Daily writing tips:**
- Write each sentence like it's the last (be precise)
- Add a "quick win" in each line (make it applicable)
- Stop over-explaining (get to the point immediately)
- Give solutions (give people a reason to come back)

**Bonus tips:**
- Use bold statements (people like confidence)
- Be immediately actionable (your post is their guide)
- Avoid complicated words (write conversationally)

**Hook-specific rules:**
- Hooks always focus on 1 topic
- Use numbers, names, or stats to add specificity
- "LinkedIn gurus will tell you to focus on the hook" -- but the best posts have a hook on every line, not just the first

---

## Content Mix

- **Image posts:** 46% (quick, digestible visuals)
- **Videos:** Emerging focus with high engagement relative to volume
- **Carousels:** Supporting format
- Heavy content repurposing across formats
- Posting frequency: Daily, with Tuesday generating strongest engagement

---

## What Makes Acosta Distinctive

- **Story-first.** While others lead with tips or frameworks, Lara leads with story. Every post is a personal narrative first, lesson second.
- **"How I" over "How to."** She turns generic advice into lived experience by grounding everything in her own journey.
- **Emotional arc.** Her posts take readers from low to high -- struggle to lesson to resolution to empowerment. This creates emotional investment.
- **Multi-hook posts.** She doesn't rely on a single opening hook. Her best posts have hooks throughout -- every line is designed to keep reading.
- **Approachability.** Her tone is warm, direct, and jargon-free. She writes like a friend explaining something over coffee, not a guru preaching.
- **Engagement-first closing.** The "Y" in SLAY is specifically designed to turn readers into commenters.

---

## Encodable Techniques

**For templates:**
- The SLAY Framework (Story -> Lesson -> Actionable -> You)
- The Educational Storyteller (Platitude -> Story -> Lesson)
- The Transformation Post (transformation hook -> brief struggle -> lesson -> resolution -> feel-good close)

**For hooks swipe file:**
- "I've never talked about [topic] before."
- "The best [topic] lesson you'll receive today:"
- "[Big claim]. (From someone who's [credibility proof])"
- "I [unexpected action]. Here's what happened."
- "[Conventional wisdom]. But [contrarian reality]."

**For style rules:**
- Story-first, lesson-second
- Write each sentence like it's the last
- Add a "quick win" in each line
- Cut the fluff -- stop over-explaining
- Multi-hook structure (not just the first line)
- Take reader from low to high (emotional arc)

ENDOFFILE__creator_lara_acosta

echo "  - lara-acosta creator study done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/sahil-bloom.md" << 'ENDOFFILE__creator_sahil_bloom'
# Creator Study: Sahil Bloom

**Niche:** Frameworks, mental models, personal development, investing
**Followers:** 1M+ on LinkedIn, 1M+ on X
**Known for:** Named frameworks, thread-to-post format, combining VC/finance background with life wisdom

---

## Signature Format: The Named Framework Post

Sahil Bloom's most distinctive move is packaging every insight into a named, memorable framework. Where other creators share advice, Bloom creates branded intellectual property.

### Structure:
```
[Hook: Personal confession or bold claim about a framework]

[Framework Name + Brief Description]

[Step-by-step breakdown with vivid metaphors]

[Personal story illustrating the framework in action]

[One-line takeaway]

[CTA: "Enjoy this? Share it with your network and follow me Sahil Bloom for more!"]
```

### Named Framework Examples:
- **The 1-1-1 Method** -- Every evening, write: 1 win from the day, 1 point of tension/anxiety/stress, 1 point of gratitude
- **The Character Alarm Method** -- Break ideal day into components, create a "character" for each by taking it to the extreme
- **The Zoom Out Strategy** -- "When in doubt, zoom out." 10,000-foot view provides perspective
- **Helped, Heard, or Hugged** -- Relationship framework for understanding what someone needs from you
- **Swallow the Frog** -- Observe your boss, figure out what they hate doing, take it off their plate

---

## Hook Patterns (Actual Examples)

**Framework-Reveal Hooks:**
- "A relationship framework that changed my life: Helped, Heard, or Hugged."
- "I use a simple framework for goal-setting for the new year."
- "Try this 5-minute trick to improve your mental health: The 1-1-1 Method."

**Personal Confession Hooks:**
- "I'm a recovering fixer." (Opens the Helped/Heard/Hugged post)
- "If I were starting my career again and I wanted to optimize for..."

**Metaphorical Hooks:**
- Describing inhibitors as "boat anchors" that "create an immense drag that holds you back from your optimal performance"

**Listicle Hooks:**
- "21 Lessons Learned in 2021"
- "Mental models are ways of thinking about..."

---

## Structural Approach: Hook to CTA

1. **Hook:** Personal confession, bold framework claim, or surprising premise. Always connects to a named concept.
2. **Context:** Brief story or situation that creates relatability. Often starts with "I" and a vulnerability.
3. **Framework Introduction:** The named framework appears with a clear, memorable label.
4. **Breakdown:** Numbered steps or components. Each step gets:
   - A clear label
   - 1-2 sentence explanation
   - Why it matters
5. **Story/Illustration:** Real-world example (often from sports, business, or personal life). Uses vivid metaphors. The New Zealand All Blacks captains sweeping locker rooms illustrate "never too big for the small."
6. **One-Line Takeaway:** Distills the entire post into a quotable sentence.
7. **Standard CTA:** "Enjoy this? Share it with your network and follow me Sahil Bloom for more!" (Consistent across virtually all posts.)

---

## Writing Style Characteristics

- **Metaphor-heavy.** Every concept gets a vivid, physical metaphor (boat anchors, frog swallowing, alarm clocks).
- **Cross-domain references.** Draws from sports (All Blacks rugby), military, philosophy, psychology, and business to illustrate single concepts.
- **Numbered everything.** Steps, lessons, takeaways -- always numbered for scannability.
- **Optimistic warmth.** Unlike contrarian creators, Bloom's tone is encouraging. He positions himself as a friend sharing what he's learned, not a critic tearing down what's broken.
- **Thread-native format.** His posts read like condensed Twitter threads -- each paragraph is a self-contained point.

---

## What Makes Bloom Distinctive

- **Framework branding.** He doesn't just share advice -- he NAMES it. The 1-1-1 Method, the Character Alarm, Zoom Out. This makes his ideas shareable and attributable.
- **VC credibility + life wisdom.** He bridges the gap between finance/business authority and personal development, which is unusual on LinkedIn.
- **Consistency of CTA.** His closing line is nearly identical on every post, creating a signature rhythm readers expect.
- **Sports and culture references.** While most LinkedIn creators reference business, Bloom pulls from athletes, coaches, and cultural moments -- making his posts feel less "LinkedIn" and more like a mentor's email.
- **High shareability by design.** Frameworks with catchy names get shared because they're easy to reference in conversation: "Have you tried the 1-1-1 Method?"

---

## Encodable Techniques

**For templates:**
- The Named Framework Post (hook -> context -> named framework -> numbered breakdown -> story -> takeaway -> CTA)
- The Year-End Lessons Post (numbered lessons from the past year)
- The Career Advice Framework (If I were starting over, here's what I'd do)

**For hooks swipe file:**
- "A [type] framework that changed my life: [Name]."
- "I use a simple framework for [goal]: [brief tease]."
- "Try this [time]-minute trick to [benefit]: The [Name] Method."
- "I'm a recovering [identity]. Here's what I learned."
- "If I were starting [thing] again and I wanted to optimize for [goal]..."

**For style rules:**
- Name every framework with a memorable label
- Use cross-domain metaphors (sports, military, nature)
- Number all steps and takeaways
- Keep tone warm and encouraging, not contrarian
- Consistent, signature CTA closing

ENDOFFILE__creator_sahil_bloom

echo "  - sahil-bloom creator study done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/sam-browne.md" << 'ENDOFFILE__creator_sam_browne'
# Creator Study: Sam Browne

**Niche:** LinkedIn engagement strategies, growth tactics, content optimization
**Followers:** 100K+ on LinkedIn (grew 50K in one year)
**Known for:** Perfect Post Checklist, algorithm secrets, carousel optimization, engagement engineering

---

## Signature Format: The Visual + Checklist Post

Sam Browne's content is meta-LinkedIn -- he teaches LinkedIn ON LinkedIn. His signature is combining clear, practical checklists with strong visual elements (carousels, images) designed to maximize feed real estate.

### Structure:
```
[Hook: 2-3 lines, copywriting-driven]

[Promise of specific, practical value]

[Visual element: carousel or image expanding on the topic]

[Engagement prompt + self-tag + follow request]
```

---

## The Perfect Post Checklist

Developed over 2 years of testing, this is Browne's system for optimizing every post:

1. **Hook** -- Spend 10-15 minutes workshopping. This is the most important element.
2. **Visual element** -- NEVER post text-only. Always include an image or carousel to take up maximum feed space.
3. **Bold key sentences** -- Use formatting tools to make headings and key points bold for easy scanning.
4. **Mobile-friendly** -- Should ideally fit on a single mobile screen without scrolling (except deep educational posts).
5. **Self-tag** -- Tag your own name at the bottom of each post.
6. **Follow ask** -- Ask people to follow you. "If you don't ask, you don't get."
7. **Grade 3-5 reading level** -- Use the Hemingway App to check. Goal: messaging that "feeds directly into their brainstem."

---

## 11 Hook Tips & Tricks

From Browne's hook framework:

1. **Get the Click** -- The sole purpose of the hook is to earn the "see more" click
2. **Get to the Punchline** -- Front-load the value, don't bury the lead
3. **Create Curiosity** -- Open a loop the reader needs to close
4. **Highlight Gain & Loss** -- What they'll get or what they'll miss
5. **Offer Easy Wins** -- Promise something achievable and quick
6. **Social Proof** -- Include numbers, results, or credibility markers
7. **Make It Specific** -- Vague hooks underperform. Use numbers and details.
8. **Value Frame** -- Signal the value proposition clearly
9. **Pleasure & Pain** -- Tap into emotional drivers
10. **Invest Time into the Hook** -- 10-15 minutes minimum workshopping
11. **Learn from the Best** -- Maintain a running note of high-performing posts from top creators

---

## Content Strategy Elements

**Format Strategy:**
- Text-only = "a waste of good content"
- Always include image or carousel to maximize newsfeed real estate
- Twitter screenshot style posts with layered messaging
- Mix of educational, personal, and case study content

**Idea Capture System:**
- Maintain a running note of high-performing posts from successful creators
- Document what worked: photo usage, vulnerability, shareability factors, engagement metrics
- Use this as an ongoing swipe file and pattern recognition tool

**Niche Positioning:**
- Become "the insert-niche guy/girl" (landing pages, stoicism, habits)
- Narrow positioning simplifies both content creation and business positioning
- Better to be the go-to person for one thing than a generalist

---

## Writing Style Characteristics

**Simplicity First:**
- Grade 3-5 reading level (Hemingway App verified)
- No jargon, no fluff
- "Clarity sells" -- speak directly to customer pain points
- Goal: instant comprehension

**Engagement Engineering:**
- Posts designed to maximize dwell time (algorithm signal)
- Comments and likes trigger wider algorithmic distribution
- Low cognitive load = higher engagement
- Specific, direct calls-to-action for lead generation

**Practical Over Philosophical:**
- Every post teaches something usable
- Case studies with specific numbers preferred
- Checklists, step-by-step guides, templates

---

## Carousel Strategy

Browne is especially known for carousel mastery:
- 12 simple tricks that work for LinkedIn carousels
- Carousel covers should be bold and clear
- Each slide should deliver a standalone insight
- End slide should include CTA and follow request
- Carousels get more saves (algorithm signal) than text posts

---

## What Makes Browne Distinctive

- **Meta-LinkedIn expertise.** He teaches LinkedIn engagement ON LinkedIn, creating a virtuous loop where his teaching demonstrates his expertise.
- **Engineering mindset.** He approaches posts like an optimization problem: maximize feed real estate, minimize cognitive load, engineer engagement signals.
- **Checklist-driven.** While other creators teach principles, Browne gives checklists. His audience can literally check boxes before hitting publish.
- **Never text-only.** His insistence on always including visual elements is a specific, testable rule that differentiates from creators who use text posts.
- **Self-tag innovation.** Tagging yourself in your own post is a growth hack most creators don't use. Simple but effective for follower growth.
- **Hemingway App requirement.** Grade 3-5 reading level is the most specific readability rule of any creator studied.

---

## Encodable Techniques

**For templates:**
- The Perfect Post Checklist (hook -> visual -> bold key points -> engagement prompt -> self-tag -> follow ask)
- The Carousel Template (bold cover -> individual insight slides -> CTA slide)
- The Algorithm Secrets Post (meta-LinkedIn content about how the platform works)

**For hooks swipe file:**
- "Everybody thinks [common belief], here's the truth..."
- "The single best way to [desired outcome] on LinkedIn:"
- "[Number] tips that [result] (from [credibility]):"
- "Stop doing [common mistake]. Start doing [alternative]."

**For style rules:**
- Never post text-only -- always include visual
- Spend 10-15 minutes on the hook alone
- Grade 3-5 reading level (Hemingway App)
- Bold key sentences for scannability
- Tag yourself at the bottom of posts
- Ask for the follow explicitly
- Single mobile screen = ideal post length
- Maintain a running swipe file of high-performing posts

ENDOFFILE__creator_sam_browne

echo "  - sam-browne creator study done"
cat > "$KIT_DIR/kits/linkedin/identity/creator-studies/tim-denning.md" << 'ENDOFFILE__creator_tim_denning'
# Creator Study: Tim Denning

**Niche:** Writing, online business, anti-corporate career philosophy, mental health
**Followers:** 585K+ on LinkedIn
**Known for:** Visceral storytelling, contrarian career takes, "brutal honesty" brand, confessional tone

---

## Signature Format: The Emotional Hook -> Archetype Story -> Tactical Takeaways

Denning's posts follow a distinctive pattern: open with an emotionally charged hook, tell a vivid story using business archetypes, extract principles, and close with tactical advice.

### Structure:
```
[Sharp, contrarian one-liner attacking a sacred cow]

[Mini-story or anecdote using vivid archetypes]
(Fortune 500 CEO, VPs, friend's dad, his daughter)

[Extraction of principle from the story]

[Bulleted tactical takeaways]

[Prescriptive close or reflective question]

[CTA: newsletter promotion or repost prompt]
```

---

## Hook Patterns (Actual Examples)

**Contrarian Sacred Cow Attacks:**
- "The safe path isn't safe."
- "Follow your passion is bad career advice."
- "Most career advice is designed to keep you stuck."

**Age + Hindsight Authority:**
- "I'm 39. After 10 years of [experience]..."
- Uses age and time markers to establish credibility without credentials

**Emotional Declaration:**
- High-stakes emotional statements tapping into shame and secrecy
- Reframes what audiences consider "safe" or "successful"

**Corporate Mythology Deconstruction:**
- "The idea of 'stability' in Corporate America is a fallacy."
- "Stop climbing their ladder. Build your own."

---

## Writing Style Hallmarks

**Sentence Structure:**
- Short, punchy fragments for emphasis: "Now." "Period." "Not a good choice."
- Single-sentence paragraphs separated by white space
- Mixed sentence lengths creating rhythmic cadence
- Intentional comma breaks within longer ideas

**Formatting Conventions:**
- Visual dividers (horizontal lines) to segment narrative beats
- Sparse emoji use (primarily at post endings)
- Bullet and numbered lists embedded within narratives
- Parallel structures for memorable concepts (Director vs. VP vs. C-suite comparisons)

**Censorship Patterns:**
- Substitutes like "sh*t," "F*cking," "su!cide" -- deliberately provocative while technically compliant

**Branded Phrases:**
- "The safe path isn't safe"
- "Choose leaders, not logos"
- "Stop climbing their ladder. Build your own."
- These function as repeated branded language reinforcing his core philosophy

---

## Structural Approach: Hook to CTA

1. **Hook:** Bold, contrarian one-liner. Attacks a belief most people hold. Short and declarative.
2. **Mini-Story:** Uses vivid archetypes as case studies. Fortune 500 CEOs, VPs, "friend's dad" -- all demonstrating hidden costs of conventional success.
3. **Principle Extraction:** Distills the story into a universal truth about work, career, or life.
4. **Tactical Takeaways:** Bulleted, actionable items the reader can implement.
5. **Prescriptive Close:** Often a call to action around identity: "Repost if success isn't what they sold you."
6. **CTA:** Newsletter promotion with social proof ("Join my unconventional Substack" + subscriber counts).

---

## Content Themes

- **Career reinvention:** Redefining success outside corporate ladders
- **Workplace mental health:** Normalizing anxiety, panic attacks, and hidden costs of corporate work
- **Risk-taking:** Calculated risks vs. playing it safe (framed as "slow-motion self-destruction")
- **Self-promotion:** Tactical visibility and personal branding
- **Anti-corporate mythology:** Deconstructing the C-suite trap and loyalty narratives
- **Writing as freedom:** Online writing as the path to career autonomy

---

## Engagement Metrics & Patterns

- ~585.5K followers
- ~1,500 average engagement per post
- Posts 9.51 times weekly (almost daily + some doubles)
- Peak days: Tuesday-Thursday evenings
- Highest engagement: vulnerability + risk narratives + self-promotion tactics
- Strong performance on mental health confessions and anti-ladder reframes

---

## What Makes Denning Distinctive

- **Emotional intensity.** Where Justin Welsh is systematic and Sahil Bloom is warm, Denning is raw. His posts have an emotional heat that most LinkedIn content avoids.
- **Anti-corporate positioning.** He's positioned himself against the LinkedIn establishment -- corporate culture, ladder-climbing, "safe" career paths. This creates natural polarity and engagement.
- **Confessional format.** He shares things most professionals wouldn't: panic attacks, impostor syndrome, career regrets. This vulnerability is strategic -- it builds intense reader loyalty.
- **Facts tell, stories sell.** His core philosophy is narrative-first. Every principle emerges from a story, never the reverse.
- **Provocative language.** Censored profanity, words like "brutal," "pummeled," "toxic" -- his vocabulary is more intense than typical LinkedIn content and signals authenticity.
- **Writing as the topic AND the medium.** He writes about writing. His content strategy IS his content topic. This creates a meta-loop that reinforces his authority.

---

## Encodable Techniques

**For templates:**
- The Sacred Cow Attack (contrarian hook -> archetype story -> principle -> tactical takeaways)
- The Career Confession (vulnerability hook -> personal struggle -> reframe -> prescriptive close)
- The Corporate Deconstruction (conventional wisdom -> why it's wrong -> what to do instead)

**For hooks swipe file:**
- "The safe path isn't safe."
- "I'm [age]. After [years] of [experience], here's what I know."
- "[Conventional belief]. [Why it's wrong in 5 words or fewer]."
- "Stop [common behavior]. [Contrarian alternative]."
- "Most [people] think [belief]. They've been lied to."

**For style rules:**
- Short fragments for emphasis ("Period." "Not a good choice.")
- Single-sentence paragraphs
- Visual dividers between narrative beats
- Parallel structure for comparisons
- Branded phrases that repeat across posts
- Vulnerability as a strategic tool, not decoration
- Reflective questions > prescriptive CTAs for engagement
- Identity-based repost prompts ("Repost if...")

ENDOFFILE__creator_tim_denning

echo "  - tim-denning creator study done"

echo "Writing kits/shortform/playbook.md..."
cat > "$KIT_DIR/kits/shortform/playbook.md" << 'ENDOFFILE__shortform_playbook'
# Shortform Video — Research Playbook

> Platform best practices, format-performance relationships, and retention principles for TikTok, Instagram Reels, and YouTube Shorts. Updated by `/research-trends`.

---

## Retention Principles

### The 1-Second Rule
The first frame must communicate something — a face with an expression, a bold text hook, an unexpected visual. Blank intros or logos-first lose viewers before the hook even registers.

### The 3-Second Gate
The hook (opening line or visual) must create a reason to keep watching. The viewer's question: "Is this for me?" must be answered with yes in 3 seconds or less.

### The 7-Second Cliff
Average watch-time data shows a significant drop-off at 7-10 seconds on TikTok and Reels. This is where the hook resolves or deepens. If the hook lands but the follow-through is weak, you lose the viewer at the first transition.

### Information Density
Attention correlates with how much new information is delivered per second. Each line of a script should introduce a new idea, fact, or emotional beat. Repeating or restating ideas in the body causes dropout.

### The Loop Effect
A video that ends in a way that invites re-watching (a loop) dramatically improves completion rate and watch time. Loop setups: ending with a call-back to the opening line, ending mid-thought that connects to the beginning, circular structure where the final line recontextualizes the first.

### Pattern Interrupt Cadence
Maintain a visual or audio pattern interrupt every 3-5 seconds to reset attention. Interrupts include: camera angle cut, text overlay change, b-roll insert, zoom, sound effect, visual transition.

### Save vs Share Optimization
- **Save-optimized content:** How-to frameworks, reference lists, step-by-step guides. Encourages bookmarking.
- **Share-optimized content:** Hot takes, identity-affirming statements, things that "perfectly describe" an experience. Encourages forwarding.
- Scripts should be deliberately optimized for one or the other — not both simultaneously.

---

## Platform Conventions

### TikTok
- **Sweet spot:** 21-34 seconds for educational/talking-head content. 45-60 seconds for storytelling.
- **Algorithm:** Watch time % and rewatch rate are the primary signals. A 20-second video watched 3 times beats a 60-second video watched once.
- **Sound:** Trending audio gives a reach boost but only if it fits. Forced audio with irrelevant content hurts watch time.
- **Text overlays:** 3-4 words max per overlay. Appear in sync with speech. Movement increases watch time.
- **Captions:** Always on. Use animated captions. Highlight 1-2 key words per line.

### Instagram Reels
- **Sweet spot:** 15-30 seconds. Longer content (45-90 seconds) can work for storytelling but is riskier.
- **Algorithm:** Share rate is the dominant engagement signal for Reels reach. Design for "I need to send this to someone."
- **Audio:** Native Instagram audio library preferred. TikTok watermarks penalized by algorithm.
- **Cover frame:** First frame is the cover in Explore. Should work as a static image hook.
- **Captions:** Same as TikTok. Safe zone adjustments required (Instagram UI differs).

### YouTube Shorts
- **Sweet spot:** 30-58 seconds. Under 30 seconds rarely ranks. Over 60 seconds exits the Shorts feed.
- **Algorithm:** Swipe-away rate is the primary kill signal. Audience retention and subscriber conversion secondary.
- **Audience intent:** YouTube viewers are more intent-driven than TikTok/Reels. Educational content and how-to performs better.
- **Sound:** Less dependent on trending audio than TikTok.
- **Search discoverability:** Titles and descriptions matter more than on other platforms. Use keywords.
- **Shelf life:** Significantly longer than TikTok/Reels — Shorts can surface 6-12 months after posting.

---

## Format-Performance Relationships

| Format | Best platform | Primary signal driven | Ideal length |
|--------|--------------|----------------------|--------------|
| Tutorial / How-to | Shorts, TikTok | Saves | 45-60s |
| Hot take / Contrarian | TikTok, Reels | Shares + Comments | 15-25s |
| Storytime | TikTok | Watch time | 45-90s |
| Day-in-my-life | TikTok, Reels | Saves + Comments | 30-60s |
| Myth-bust | All | Comments + Shares | 20-35s |
| Listicle | Shorts, TikTok | Saves | 30-45s |
| POV | Reels, TikTok | Shares + Comments | 15-30s |
| Stitch/React | TikTok | Comments | 20-40s |
| Transformation | Reels | Comments + Shares | 15-30s |
| Trend adaptation | TikTok, Reels | Shares | 10-20s |
| Hook + Story + CTA | All | Watch time | 30-60s |

---

## Audio/Sound Trend Handling

- Trending sounds have a half-life of 5-14 days on TikTok. By the time a sound is obviously trending, optimal window may have passed.
- Original audio or voiceover-first scripts age better than trend-dependent audio scripts.
- If using trending audio: script must work WITH the audio, not just over it.
- Research trending sounds via: TikTok Creative Center, Instagram Reels trending audio tab.
- For evergreen content: original audio outperforms trending audio over 30+ day windows.

---

## Caption/Subtitle Best Practices

- **Always include captions.** 80-85% of social media video is watched without sound initially.
- **Style:** 2-3 words per caption chunk, appearing in sync with speech, centered on screen
- **Designed captions > auto-captions:** Animated, styled captions (CapCut style) outperform platform auto-captions
- **Highlight key words:** Change color or size of important words within caption sequences
- **Safe zones:** Keep captions away from bottom 20% (platform UI) and top 15% (username overlay)

---

## Cross-Posting Adaptation

### TikTok → Reels
- Remove TikTok watermark (Instagram penalizes it)
- Re-export clean version at 1080x1920
- Adjust caption positioning for Instagram's UI elements
- Use Instagram's native music library instead of TikTok sounds

### TikTok → Shorts
- YouTube's safe zone for text is different — keep text more centered
- Slightly more educational framing (YouTube audience is more intent-driven)
- Lighter text overlay density
- Description and tags matter more on YouTube

### Universal Rendering
- Resolution: 1080x1920 (9:16)
- Frame rate: 30fps minimum
- Keep critical text/visuals within center 80% of frame
- Test on multiple devices before publishing

---

## Common Mistakes the System Must Prevent

1. **Starting with "Hey guys"** or any throat-clearing. First word = first value.
2. **Using first 5 seconds for context** instead of hook. Hook first, context second.
3. **Writing for reading instead of speaking.** Complex sentences, subordinate clauses, academic language — all death for spoken content.
4. **Generic CTA** that doesn't match the content's energy. "Follow for more" is invisible.
5. **Scripts too long for the format.** 200 words crammed into 30 seconds = rushed and unnatural.
6. **Same template repeatedly.** Variety prevents audience fatigue.
7. **Hooks that promise but don't deliver.** Clickbait destroys creator credibility.
8. **No pattern interrupts.** Static talking head for 60 seconds hemorrhages viewers after 10 seconds.
9. **No captions.** Losing 80%+ of initial viewers.
10. **Over-polishing.** Excessive production value can hurt on TikTok/Reels where authenticity signals relatability.

---

## Trend Updates

*This section is updated by `/research-trends`. Most recent updates appear at the top.*

(No trends researched yet — run `/research-trends` to populate this section.)
ENDOFFILE__shortform_playbook
echo "  - shortform/playbook.md done"


echo ""
echo "=================================================="
echo " AI Creator Kit setup complete!"
echo "=================================================="
echo ""
echo " Your workspace is ready at: $KIT_DIR"
echo ""
echo " What to do next:"
echo "   1. Open Claude Code in the kit directory:"
echo "      cd $KIT_DIR && claude"
echo "   2. Claude will guide you through brand setup on first run."
echo "   3. After brand setup, you can create newsletters,"
echo "      carousels, LinkedIn posts, and video scripts."
echo ""
echo " Need help? Ask Claude: 'What can I create?'"
echo ""
