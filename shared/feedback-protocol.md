---
title: Feedback Protocol (Self-Improvement)
source: dev-agent-team v0.1.0
compiled_at: 2026-05-03T00:00:00Z
created: 2026-05-03
owner: team
tags: [protocol, mandatory, meta]
status: current
---

# Feedback Protocol (Self-Improvement)

How agents handle user feedback that implies a behavior change. **This is what makes the team get smarter over time.**

## Detection

Watch for:
- **Corrections**: "don't do X", "stop doing X", "that's wrong"
- **New rules**: "from now on...", "always...", "never..."
- **Confirmations of non-obvious choices**: "yes, that approach was right" (after you did something unusual)
- **Preferences**: "I prefer...", "I'd rather you..."
- **Process changes**: "next time...", "in the future..."

If the user gives feedback that fits the above, **do not silently absorb it**. Trigger this protocol.

## Classify the Feedback

Three categories:

| Category | What it means | What to do |
|----------|---------------|-----------|
| **One-off** | Just for this turn / task | Apply silently, no record needed |
| **Project-only** | Applies to this project's domain (e.g., "always use kebab-case URLs in this app") | Add to the project's `CLAUDE.md` |
| **Permanent** | Applies to all future projects (e.g., "always file decisions before implementing") | Update agent prompt in `dev-agent-team/agents/` |

If unsure, **ask the user**.

## The Standard Question

When you detect feedback that might be project-only or permanent, ask:

> "Got it. I want to make sure I apply this correctly. Should this:
> **(a)** apply just for this task,
> **(b)** be added to this project's `CLAUDE.md` (project-specific behavior), or
> **(c)** permanently update my agent prompt at `dev-agent-team/agents/{my-name}.md` (so all future projects inherit this)?
>
> My recommendation: **{a/b/c}** because {reason}."

Wait for the user's choice before applying.

## Applying a Permanent Change

If user picks (c):

1. **Show the diff first** — quote the current relevant section of your prompt and the proposed change
2. **Get confirmation** — "Apply this change?"
3. **Edit the agent prompt** — write to `/Users/sravansunkaranam/github/dev-agent-team/agents/{my-name}.md`
4. **Append to CHANGELOG.md**:
   ```
   ## [{new-version}] — YYYY-MM-DD
   ### Changed — {agent-name}
   - {what changed}
     - **Why:** {user feedback verbatim or paraphrased}
     - **Source:** {project-name} session, YYYY-MM-DD
   ```
5. **Bump VERSION** (patch for clarifications, minor for new behaviors, major for breaking changes)
6. **Append to applied.md**:
   ```
   ## YYYY-MM-DD — {agent-name} — {short title}
   **Source:** {project}
   **Feedback:** {user said}
   **Change applied:** {what was added}
   **CHANGELOG entry:** {version}
   ```
7. **Confirm to user** — "Done. Updated {agent-name}.md, CHANGELOG, bumped to v{X.Y.Z}. All future projects using the team will inherit this."

## Applying a Project-Only Change

If user picks (b):

1. Append a section to the project's `CLAUDE.md` under "## Project-specific agent rules"
2. Note the agent and the rule
3. Confirm to user

## Applying a One-Off

If user picks (a):

Just do it. No record needed.

## Pending Bin

If you detect feedback but the user is mid-conversation and you don't want to interrupt, append to `dev-agent-team/feedback/pending.md` and bring it up at the end of the task:

> "Before we wrap, I noticed earlier you mentioned [X]. Want me to file that as a permanent change?"

## Examples

### Example 1: Permanent
```
User: "PM, your stories are too long. Cap acceptance criteria at 5 bullets."

PM: "Got it. Should this be:
  (a) just this story,
  (b) project rule for AAUClubManager, or
  (c) permanent for all projects?
  My recommendation: (c) — clean, scannable stories help every project."

User: "c"

PM:
  → Shows diff to product-manager.md (adds "Cap acceptance criteria at 5 bullets unless complexity demands more.")
  → Bumps VERSION 0.1.0 → 0.1.1
  → Appends to CHANGELOG
  → "Done. v0.1.1. All projects now inherit this rule."
```

### Example 2: Project-only
```
User: "In this project, always include parent-vs-coach role context in user stories."

PM: "Got it. Should this be:
  (a) just this story, (b) project rule, (c) permanent?
  Recommendation: (b) — this is AAU-specific (coaches and parents are central personas)."

User: "yeah, project rule"

PM: → Adds to AAUClubManager/CLAUDE.md → "Done."
```

### Example 3: One-off
```
User: "For this story specifically, skip the wireframe — it's an admin-only API."

UX: → Skips wireframe, notes in story metadata, no further action.
```

## What NOT to Do

- Don't silently change behavior — always confirm permanent changes
- Don't update prompts without bumping VERSION and CHANGELOG
- Don't forget to surface pending feedback before the session ends
- Don't apply project-only feedback as permanent (or vice versa) — ask if unsure
