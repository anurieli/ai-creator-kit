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
