# Meridian Wealth Advisors — Content Change Log

This document tracks all planned content changes for the demo site. Changes follow a 12-week rotation cycle.

## Rotation Schedule

**Cycle Start Date:** February 16, 2026
**Cycle Length:** 12 weeks (repeating)

---

### Week 1 — Regulatory Disclosure Update
**Target Pages:** Disclosures & Legal
**Changes:**
- SEC filing reference updated from January 2026 to March 2026 amendment
- Two new risk factors added: Cybersecurity risk and Geopolitical risk
- ADV Part 2A link updated to amended version
**Compliance Relevance:** Regulatory disclosure change requiring client notification

---

### Week 2 — Fee Schedule Reduction
**Target Pages:** Fee Schedule
**Changes:**
- Management fees reduced across all tiers (e.g., 1.25% → 1.15% for entry tier)
- New note added explaining fee reduction rationale
- Effective date updated to March 15, 2026
**Compliance Relevance:** Fee change notification required under SEC Rule 275.204-3

---

### Week 3 — Blog Content Rotation
**Target Pages:** Insights (blog)
**Changes:**
- "Q1 2026 Market Outlook" post published (publishDate triggered)
- "Q4 2025 Market Review" post expires (expiryDate triggered)
**Compliance Relevance:** Forward-looking statements in market outlook need review

---

### Week 4 — Personnel Changes
**Target Pages:** Our Team
**Changes:**
- Maria Rodriguez promoted: Associate → Vice President, Wealth Advisory
- Alexandra Foster added: VP, Business Development (new hire from JPMorgan)
- Robert Kim removed from team page
**Compliance Relevance:** Personnel changes affect Form ADV Part 2B (Brochure Supplement)

---

### Week 5 — Privacy Policy Update
**Target Pages:** Disclosures & Legal, Footer
**Changes:**
- Data retention clause added to privacy policy (7-year retention, AES-256 encryption)
- Client data deletion request process documented
**Compliance Relevance:** Privacy policy change under SEC Regulation S-P

---

### Week 6 — New Service Offering
**Target Pages:** Wealth Planning (service page)
**Changes:**
- ESG/sustainable investment options paragraph added to wealth planning page
- New investment approach described: ESG integration, impact measurement
**Compliance Relevance:** New service offering requires updated ADV disclosure

---

### Week 7 — Fee Structure Expansion
**Target Pages:** Fee Schedule
**Changes:**
- New "Ultra High Net Worth ($10M+)" tier added at 0.65%
- Previous $5M+ tier split into $5M-$10M and $10M+ tiers
**Compliance Relevance:** Fee structure change requiring updated Form ADV Part 2A

---

### Week 8 — Tax Guidance Content
**Target Pages:** Insights (blog)
**Changes:**
- "Estate Tax Changes" blog post published
- Content discusses legislative changes to estate tax exemption
**Compliance Relevance:** Tax guidance content needs compliance review for accuracy

---

### Week 9 — Careers Update
**Target Pages:** Careers
**Changes:**
- Two new positions posted: Senior Tax Strategist, Digital Marketing Coordinator
- Client Service Associate position removed
**Compliance Relevance:** General site activity (staffing changes)

---

### Week 10 — Critical Regulatory Update
**Target Pages:** Disclosures & Legal
**Changes:**
- ADV Part 2A link updated to May 2026 version
- DOL Fiduciary Rule compliance language added
- New regulatory disclosure: DOL Fiduciary Compliance Statement
- Environmental risk factor added
- Form CRS updated reference
**Compliance Relevance:** Critical regulatory document update — DOL compliance

---

### Week 11 — AUM & Personnel Update
**Target Pages:** Our Team, About, Home
**Changes:**
- AUM updated: $2.1B → $2.3B
- Client families updated: 340+ → 365+
- One team member removed (Robert Kim)
- Average experience adjusted: 18 → 17 years
**Compliance Relevance:** AUM accuracy requirement; departed advisor affects ADV filing

---

### Week 12 — Testimonial & Fee Changes
**Target Pages:** Home, Fee Schedule
**Changes:**
- Featured testimonials rotated (new client quotes)
- Account minimum raised: $250,000 → $500,000
- Fee tiers restructured to reflect new minimum
**Compliance Relevance:** Testimonial compliance under SEC Marketing Rule; fee change

---

## How to Use This Log

1. **Before a demo:** Check which week is active and review the corresponding changes above
2. **To verify changes:** Compare the active data files against the base (_v1) versions
3. **To force a specific week:** Set `FORCE_VARIANT=N` when running the activation script
4. **To add new changes:** Create new variant files and add entries to `data/schedule.yaml`
