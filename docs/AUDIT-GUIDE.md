# Audit Behavior Guide

These are behavioral suggestions to improve your auditing effectiveness, not rigid rules to follow mechanically.

*Core principles that transform passive code review into active bug hunting*

## 1. Start at the Danger, Work Backward

Begin at sensitive operations (money transfers, auth checks, crypto operations, privilege escalations) and trace backward asking: "What should have protected this?"

Missing controls become obvious when you trace backward from danger rather than only forward from input.

## 2. One Bug Means Many Bugs

Every bug you find is a template. Extract its pattern and search for:
- The same mistake elsewhere in your scope
- Similar code structures
- The inverse operation (if you found a missing check on "delete", check "create")

For system-wide patterns, recommend a global audit focus area in PROGRESS.md.

## 3. Never Trust, Always Verify

When you think "validation probably happens in the caller" - STOP. Navigate to the caller and verify. Keep tracing until you either find the security control or confirm it doesn't exist.

Never assume security controls exist because the code structure suggests they should.

## 4. Hunt Where Developers Rush

Focus your effort where developers cut corners under pressure:
- Error handling paths (often untested)
- Edge cases and early returns
- "Temporary" fixes (grep for TODO, FIXME, HACK)
- Component boundaries (where different teams' assumptions meet)
- Cleanup/shutdown functions (where state clearing is often missed)

Security failures cluster around complexity and time pressure.

## 5. Form Attack Hypotheses

After reading code, ask: "What could go wrong here?" Form specific theories:
- What assumptions might be violated?
- What invariants could break?
- Are libraries being used correctly?
- How might the code be incorrect?
- Which variables are controlled by user input and where do they go?
- Try to argue that the code is correct - where does the argument break down?

Then actively hunt for evidence that these failures are possible.

## 6. Complete Each Path

Follow each suspicious path to its conclusion before starting another. Don't bounce between different leads - pick one and trace it fully. Go deep, but do not sacrifice the breadth or completeness of the overall task you have been assigned.

Shallow analysis finds shallow bugs. Deep, complete analysis finds the bugs that matter.

## Key Mindset Shift

**Don't just read code. Hunt for bugs.**

Don't be a passive reviewer hoping to spot issues. Be an active attacker with hypotheses to test. Form specific theories about what could be broken, then prove or disprove them.

The best auditors aren't just careful readers - they're systematic hunters who know where vulnerabilities hide.
