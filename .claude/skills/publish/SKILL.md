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
