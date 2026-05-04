---
title: Phase Kickoff Brief Protocol
source: dev-agent-team v0.1.2
compiled_at: 2026-05-03T00:00:00Z
created: 2026-05-03
owner: team
tags: [protocol, mandatory]
status: current
---

# Phase Kickoff Brief Protocol

**The principle:** While agents write code in parallel, the user has things only they can do — create accounts, sign up for services, get API keys, complete approval processes. These take real-world clock time (Twilio approval = 1-3 weeks, DNS propagation = hours-days) and **must start at the beginning of the phase**, not when the agents hit a missing-credentials wall.

Every phase begins with a **Phase Kickoff Brief** that surfaces these in one prominent document.

## When to File

The TPM files a `pmo/phase-briefs/PHASE-{N}-kickoff.md` **before any work in the phase begins**. Specifically:
- Filed when prior phase exits (or, for Phase 0, when the project is bootstrapped and an MVP scope is decided)
- Updated mid-phase if new external dependencies surface
- Marked `status: completed` when the phase exits

## Ownership

| Section of the brief | Owner |
|----------------------|-------|
| External dependencies — technical (accounts, API keys, DNS, infra setup, approvals) | **Architect** identifies → TPM consolidates |
| External dependencies — product/legal (ToS acceptance, vendor contracts, GDPR posture, business verification) | **PM** identifies → TPM consolidates |
| What agents are doing in parallel | TPM (cross-references story owners) |
| Phase exit criteria | TPM (sourced from `pmo/phases.md`) |
| Forward-look (what to start preparing for the NEXT phase) | TPM + Architect |

The TPM is the writer of record. Architect and PM **must** hand off their lists to TPM at phase planning time.

## Format

```yaml
---
title: PHASE N — Kickoff Brief
phase: N
status: awaiting-external-setup | ready-to-start | in-progress | completed
filed: YYYY-MM-DD
owner: tpm
contributors: [architect, pm]
tags: [phase:N, kickoff]
---
```

Body sections (all mandatory):

```markdown
# PHASE N — {Phase Name} — Kickoff Brief

## 📋 Phase summary
1-2 sentences on what this phase delivers. Link to phases.md for full scope.

## 🔴 EXTERNAL DEPENDENCIES — ONLY YOU CAN DO THESE

Things agents cannot do. Start as soon as possible — the long-lead items gate later work.

### 🚨 Critical path — start within 24 hours

For each item:

#### N. {Title}
- **What:** Short description
- **Why:** Which phase work depends on this
- **Lead time (waiting on third party):** e.g., "1-3 weeks"
- **Your time investment:** e.g., "30 min initial + occasional checks"
- **How (step-by-step):**
  1. ...
  2. ...
- **Where:** URL / dashboard link
- **Done when:** Concrete completion criterion
- **Deliver to agents:** What credentials/info to put where (env var, secret manager, etc.)

### 🟡 Mid-phase — start within 1-2 weeks
(same format)

### 🟢 Nice-to-have / can wait
(same format)

## 🟡 What agents are doing in parallel

While you handle the above, the team is working on:

| Story | Owner | Status |
|-------|-------|--------|
| ... | ... | ... |

## ✅ Already in place from prior phases
- Item carried over from Phase {N-1}
- ...

## 📋 Phase exit criteria
- [ ] Specific testable outcomes
- [ ] ...

## 🔭 Heads-up for the NEXT phase
What you should start preparing now for Phase {N+1} (long-lead items that span phases):
- e.g., "Twilio WhatsApp approval starts Phase 0 but is needed for Phase 3"
```

## How the Brief Surfaces to the User

1. **Dashboard pin** — `pmo/dashboard.md` has a "📋 Current Phase Kickoff" section at the top with a link
2. **Status briefing** — when user asks TPM for status, brief is surfaced if any external dependency is `pending`
3. **Pre-phase notification** — when one phase is about to exit, TPM files the next phase's brief and explicitly hands it to the user

## Example Patterns of External Dependencies

To help Architect/PM identify these reliably, common categories:

### Tech stack accounts (Architect identifies)
- Auth provider (Clerk, Auth0): account, project setup, OAuth/SSO config
- Notification providers (Twilio, Resend, SendGrid): account, sender verification, **approval processes** (WhatsApp Business API takes 1-3 weeks)
- Payment provider (Stripe, Paddle): account, KYC, business verification, webhook secrets
- Object storage (S3, R2, B2): account, bucket creation, IAM/access keys
- AI providers (OpenAI, Anthropic): account, API key, billing setup, rate limit tier
- DB hosting (Neon, Supabase, RDS): account, instance provisioning, connection strings
- Hosting (Vercel, Railway, Render, AWS): account, project setup, environment vars
- Domain/DNS: domain purchase, DNS records (SPF, DKIM, DMARC for email)
- CDN: account, cache config

### Product/legal (PM identifies)
- Terms of Service acceptance for vendors
- Business entity needed for some signups (LLC, EIN)
- Privacy policy / Terms required before launching
- GDPR/CCPA compliance posture
- Industry-specific compliance (PCI for payments, HIPAA for health, COPPA for minors)
- Vendor SLAs / contracts

### One-time human tasks (anyone can flag)
- Content seeding (drill library, default templates) — may require subject-matter expertise
- Customer/test data setup (recruit test users)
- Marketing assets (logo, screenshots) for vendor approval forms (Twilio asks for these)

## Anti-Patterns

- ❌ Discovering "we need Twilio WhatsApp Business approval" 5 weeks into the project
- ❌ Listing dependencies in an obscure architecture doc the user never reads
- ❌ Burying lead times — "this takes a few weeks" without saying which weeks
- ❌ No how-to instructions — assuming the user knows where to click
- ❌ Not flagging that the user can do these in parallel with agent work

## What This Protocol Replaces

Previously, dependencies were sprinkled across:
- ADR notes ("requires Twilio account")
- Architect's per-phase analysis ("net-new integrations introduced")
- Random comments in stories

Now they're consolidated, prominent, and timely.
