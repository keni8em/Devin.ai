## Objective

Provide structured, low-friction daily journaling for engineering work by maintaining:

1. Activity Log (execution layer)
2. Notes (cognitive layer)

The system must:
- Infer missing details where possible
- Minimise user effort
- Maintain high signal-to-noise ratio
- Produce reusable, structured outputs

---

## When to Use

Trigger this skill when the user:
- Requests to "log activity", "log note", or "log this"
- Provides information that appears to be a work update or reflection
- Mentions completed work, debugging, decisions, or insights

---

## Section Definitions

### Activity Log (Execution Layer)

Purpose:
Capture objective actions and outcomes.

Format:
- [Time] Action → Outcome (Context/Artifact)

Rules:
- One entry per meaningful action
- Use past tense
- Include tools/systems where possible
- No reasoning, speculation, or opinion
- Be concise and verifiable

---

### Notes (Cognitive Layer)

Purpose:
Capture interpretation, insights, decisions, and reasoning.

Format:
- 2–3 sentences MAX
- Must include a type tag

Allowed Types:
- [Insight]
- [Observation]
- [Hypothesis]
- [Friction]
- [Decision]
- [Question]

Rules:
- Do not restate activity log
- Focus on meaning, implications, or uncertainty
- Keep concise and standalone
- No overlap between notes

---

## Interpretation & Classification

### Step 1: Determine Intent

If user explicitly states:
- "log activity" → Activity only (unless promotion applies)
- "log note" → Note only

If ambiguous ("log this"):
- Infer based on content:
  - Action-oriented → Activity
  - Reflective/thought → Note

---

## Inference Policy

When information is incomplete:

Infer:
- Time → use current time
- Action → extract from verbs
- Outcome → infer conservatively
- Context → infer tools/systems from keywords

Rules:
- Do NOT fabricate unknown outcomes
- If unclear, use neutral phrasing:
  "→ Investigated issue"
  "→ Partial progress"

---

## Clarification Policy

Only ask questions if:
- Cannot determine Activity vs Note
- Action is unclear
- Outcome is critical and unknown
- Multiple interpretations would change meaning

Process:
1. Produce best-effort log
2. Ask minimal follow-up if needed

---

## Dual Logging Policy (Activity + Note)

### Principle
Only create Notes when there is clear cognitive value.

### Promote Activity → Note if:

- Insight was formed
- Non-trivial problem solved
- Decision made
- Reusable learning identified
- Unexpected behaviour observed

### Do NOT promote if:

- Routine work
- Mechanical execution
- No new understanding

### Default:
→ Activity ONLY

---

## Note Aggregation Awareness

Across related activities:
- Avoid fragmented notes
- Prefer one higher-quality note when insight matures

---

## Multi-Note Decomposition Policy

### Allow multiple notes ONLY if:

- Different cognitive types apply (e.g., Insight + Decision)
- Each note serves a distinct purpose
- Each note stands independently

### Do NOT split if:

- Same idea rephrased
- Overlapping meaning

---

## De-duplication Check (Mandatory)

Before finalising notes:

Ask:
"Do any of these notes repeat meaning or context?"

If YES:
→ Merge into one stronger note

---

## Category Selection Discipline

- Do not force categories
- Only assign if clearly justified
- Prefer fewer, higher-value notes

### Priority (if unsure):
1. Decision
2. Insight
3. Friction
4. Hypothesis
5. Observation
6. Question

---

## Output Structure

### Activity Only

- [Time] Action → Outcome (Context)

---

### Note Only

[Type]
2–3 sentence note

---

### Activity + Note

- [Time] Action → Outcome (Context)

[Type]
2–3 sentence note

---

### Activity + Multiple Notes

- [Time] Action → Outcome (Context)

[Type]
Note 1

[Type]
Note 2

---

## Style Rules

- Clean markdown only
- No extra commentary unless clarifying
- No section headers unless explicitly requested
- Consistent phrasing and tense
- No redundancy

---

## Anti-Patterns (Strictly Avoid)

- Logging notes for every activity
- Notes that restate activity
- Overlapping or redundant notes
- Vague entries ("worked on X")
- Excessive verbosity

---

## Conservative Bias Rule

When uncertain:
→ Log Activity ONLY

Only create Notes when confident they:
- Add value
- Will be useful later (reports, decisions, documentation)

---

## Optional Suggestion Behavior

If a potential note exists but confidence is low:

- Log Activity
- Suggest note instead of forcing it

Example:
"A potential insight here may be worth logging as a note — would you like me to add it?"

---

## Output Expectations

Each response must:
- Be immediately usable in a journal
- Require minimal or no editing
- Maintain structural consistency
- Maximise clarity and reuse