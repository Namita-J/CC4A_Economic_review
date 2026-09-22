---
name: add-practice
description: Add a climate adaptation practice to the CC4A controlled vocabulary and the search keyword list, and rerun the steps that depend on it.
---

# Adding a practice

A practice lives in two files. Change one without the other and the search
finds records the vocabulary cannot code, or the vocabulary holds a code the
search never looks for.

## 1. The vocabulary

Add one row to `catalogues/vocab_practices.csv`.

| Column | What goes in it |
|---|---|
| `practice_code` | snake_case, lower case, no spaces. This is what the Excel output carries. |
| `label` | Sentence case, how a person would say it. |
| `definition` | One sentence. What the practice is, not why it matters. |
| `synonyms` | Semicolon separated, every spelling the literature uses, including hyphenated and abbreviated forms. This is what the rule based mapping in step 6 matches on. |
| `carbon_relevant` | yes, no, or unknown. Whether the practice can carry a carbon claim. |
| `notes` | The boundary. Say what it is not, and which neighbouring code a borderline paper goes to. |

Write the boundary note even when it feels obvious. Cover crops and
conservation agriculture overlap, and the note is the only place that
overlap is settled.

## 2. The keyword list

Add a group to `KW_PRACTICE` in `catalogues/keyword_list.R`, named for the
practice code. Put the search terms there, not in the vocabulary file. Terms
have to be specific enough that the records returned carry numbers. Test the
group on its own before adding it:

```
Rscript R/01_search/openalex_search.R --block=cost --dry
```

The dry run prints the expected count per query. A query returning tens of
thousands of records is too broad; narrow it before running it for real.

## 3. Rerun what depends on it

| Step | Rerun | Why |
|---|---|---|
| 1 search | yes | The new terms have never been queried. |
| 2 dedup | yes | New records join the pool. |
| 3 screen | new records only | The screener is resumable, judged records are skipped. |
| 4 fetch | new in scope records only | Also resumable. |
| 5 extract | new records only | Also resumable. |
| 6 harmonise | yes, whole run | The option list changed, so the options hash changed, and decisions taken under the old list retire on their own. |
| 7 publish | yes | The database is rebuilt from the harmonised run. |

Nothing already extracted is read again. That is the point of keeping the
vocabulary out of the extraction prompt.

## 4. Check it landed

- The practice appears in the option list `harmonize.R` prints on a dry run.
- `outputs/review/proposed_vocab_terms.csv` no longer lists the terms that
  prompted the addition.
- No row in the published database is coded `other` for a paper that is
  plainly about the new practice.
