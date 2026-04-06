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
