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
