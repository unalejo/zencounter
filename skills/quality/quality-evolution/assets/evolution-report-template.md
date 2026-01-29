# Quality Tool Evolution Report

**Date**: YYYY-MM-DD
**Research Conducted By**: AI Agent (quality-evolution skill)
**Target Stack**: javascript / python / [language]
**Original Tool**: [tool-name]
**Proposed Tool**: [tool-name]

---

## Executive Summary

This report documents research into modern quality tools for the project. Research was conducted using WebSearch to find state-of-the-art alternatives to existing tools.

**Recommendation**: [APPROVE / REJECT]

---

## Research Methodology

### Search Queries Used

1. "[Stack] best [tool-type] alternatives 2026 [benchmark]"
   - Example: "JavaScript best ESLint alternatives 2026 performance"

2. "[New tool] vs [Old tool] 2026 [comparison metric]"
   - Example: "Ruff vs Black vs Pyright 2026 Python linting"

3. "[Tool name] GitHub stars community adoption"
   - Example: "SWC GitHub stars JavaScript compiler"

### Evaluation Criteria

| Criterion   | Weight | Threshold             | Rationale                    |
| ----------- | ------ | --------------------- | ---------------------------- |
| Performance | High   | 2x faster             | Measurable productivity gain |
| Maturity    | High   | >6 months old         | Proven stability             |
| Community   | Medium | 10k+ stars            | Market adoption signal       |
| Activity    | Medium | <90 days since commit | Active development           |
| Features    | Low    | Parity+               | Must not lose capabilities   |

---

## Tools Evaluated

### Current Tool: [CURRENT_TOOL]

**Status**: In use
**Version**: [version]
**Community**: [stars] GitHub stars, [downloads] weekly npm downloads
**Last Update**: [date]
**Performance**: [benchmark] ms per file

**Strengths**:

- [strength 1]
- [strength 2]
- [strength 3]

**Weaknesses**:

- [weakness 1]
- [weakness 2]

---

### Candidate Tool 1: [TOOL_NAME]

**Status**: [Published / Active / Stable]
**Version**: [version]
**Community**: [stars] GitHub stars, [downloads] weekly downloads
**Last Update**: [date]
**Performance**: [benchmark] ms per file

**Maturity Score**: ✅ / ❌

- Age: [months] months old
- Meets 6-month threshold: ✅ / ❌

**Adoption Score**: ✅ / ❌

- GitHub stars: [count] (threshold: 10k)
- Weekly downloads: [count] (threshold: 500k)

**Activity Score**: ✅ / ❌

- Last commit: [days] days ago (threshold: 90 days)
- Commits in last 30 days: [count]

**Performance Improvement**: [2.3x faster] or [1.2x slower]

**Strengths**:

- [strength 1]
- [strength 2]
- [advantage over current tool]

**Weaknesses**:

- [weakness 1]
- [feature gap]

**Overall Assessment**: ✅ RECOMMEND / ❌ REJECT

---

### Candidate Tool 2: [TOOL_NAME]

[Same structure as above]

---

## Comparative Analysis

### Performance Comparison

```
Current Tool:    ███████████████░░ 150 ms
Candidate 1:     ██████░░░░░░░░░░  65 ms (2.3x faster)
Candidate 2:     ████████░░░░░░░░  90 ms (1.7x faster)
```

### Feature Parity

| Feature         | Current | Candidate 1 | Candidate 2 |
| --------------- | ------- | ----------- | ----------- |
| Linting         | ✅      | ✅          | ✅          |
| Formatting      | ❌      | ✅          | ✅          |
| Auto-fix        | ✅      | ✅          | ✅          |
| Config file     | ✅      | ✅          | ✅          |
| IDE integration | ✅      | ✅          | ✅          |
| CLI             | ✅      | ✅          | ✅          |

### Community Adoption

| Tool        | GitHub Stars | Weekly Downloads | Growth           |
| ----------- | ------------ | ---------------- | ---------------- |
| Current     | [count]      | [count]          | [stable/growing] |
| Candidate 1 | [count]      | [count]          | [stable/growing] |
| Candidate 2 | [count]      | [count]          | [stable/growing] |

---

## Decision Analysis

### Why Recommend [TOOL_NAME]

1. **Performance**: 2.3x faster execution time (measurable productivity gain)
2. **Maturity**: 18 months old, proven in production at [companies]
3. **Community**: 42k GitHub stars, 2.1M weekly downloads
4. **Activity**: 47 commits in last 30 days (actively maintained)
5. **Features**: Feature parity + [new advantage]
6. **Risk**: Low - [similar architecture / easy migration]

### Migration Path

```bash
# 1. Backup current config
cp skills/quality/stacks/[stack]/SKILL.md \
   skills/quality/stacks/[stack]/SKILL.md.bak

# 2. Review proposed changes (diff shown below)
# 3. Accept or reject changes
# 4. If accepted: Update package.json / pyproject.toml
npm install --save-dev [new-tool]  # or equivalent

# 5. Run: npm run lint  # or equivalent
# 6. Commit changes
```

### Rollback Procedure

If the new tool doesn't work as expected:

```bash
# Restore original SKILL.md
mv skills/quality/stacks/[stack]/SKILL.md.bak \
   skills/quality/stacks/[stack]/SKILL.md

# Uninstall new tool and reinstall old
npm uninstall [new-tool]
npm install --save-dev [old-tool]
```

---

## Diff Preview

### SKILL.md Changes

```diff
--- a/skills/quality/stacks/[stack]/SKILL.md
+++ b/skills/quality/stacks/[stack]/SKILL.md
@@ -1,5 +1,5 @@
-name: quality-[stack]-old
+name: quality-[stack]
-description: >
-  [old description]
+description: >
+  [new description]
```

[Full diff would be shown here]

---

## Recommendation

### ✅ APPROVED

Proceed with updating to [TOOL_NAME]. The performance improvement (2.3x faster) combined with active community support and feature parity makes this a low-risk upgrade.

**Action Items**:

1. ✅ User confirmed changes
2. ⏳ Update package.json / pyproject.toml
3. ⏳ Reinstall dependencies
4. ⏳ Run test suite
5. ⏳ Commit: "chore(quality): upgrade to [tool-name]"

### Timeline

- **Research Date**: 2026-01-24
- **Implementation Date**: [pending approval]
- **Review Date**: [+1 week]
- **Rollback Deadline**: [+30 days]

---

## Resources

- Tool Documentation: [URL]
- Migration Guide: [URL]
- Performance Benchmarks: [URL]
- Community Discussion: [URL]

---

## Approval

- **Researched By**: AI Agent (quality-evolution)
- **Approved By**: [User] on [Date]
- **Implemented By**: [Agent/User] on [Date]
- **Rolled Back By**: [N/A or User/Date]

---

## Appendix: Full Research Log

### Query 1: "[Stack] best [tool-type] alternatives 2026"

**Results Summary**:

- [Result 1]: Description...
- [Result 2]: Description...
- [Result 3]: Description...

### Query 2: "[Tool name] vs [Tool name] 2026"

**Results Summary**:

- [Result 1]: Description...
- [Result 2]: Description...

### Query 3: "[Tool name] benchmark [metric]"

**Results Summary**:

- [Result 1]: Description...
- [Result 2]: Description...

---

**Report Version**: 1.0
**Report Status**: [DRAFT / APPROVED / IMPLEMENTED]
**Last Updated**: YYYY-MM-DD
