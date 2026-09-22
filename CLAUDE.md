# Working rules for AI coding sessions on this repo

Read this before writing anything. If a rule here disagrees with something in
`.claude/`, this file wins.

## Contents

1. [What this repo is](#1-what-this-repo-is)
2. [Standing rules](#2-standing-rules)
3. [Script anatomy](#3-script-anatomy)
4. [Style](#4-style)
5. [Adding a practice to the vocabulary](#5-adding-a-practice-to-the-vocabulary)
6. [Extending the keyword list](#6-extending-the-keyword-list)
7. [Adding a parameter or a schema field](#7-adding-a-parameter-or-a-schema-field)
8. [Known gotchas](#8-known-gotchas)
9. [Before you commit](#9-before-you-commit)

## 1. What this repo is

An R pipeline that collects the costs and the adoption rates of climate
adaptation practices in African agriculture, from the published literature,
and publishes them as an Excel parameter database for a carbon credit
project. Seven steps, one folder per step under `R/`.

The numbers this pipeline produces go into a financial model. A wrong number
that looks plausible is worse than no number. Every rule below follows from
that.

## 2. Standing rules

**Deterministic first, model second.** If a pattern, a lookup or a table
read can decide, no model call is spent. Where a model is needed, batch the
calls and cache the answers.

**Every extracted value carries a page number and is checked against that
page.** The model returns the paper's own words. Code string matches the
quote against the cited page. A value that is not found is dropped, not kept.
Never relax this check to raise the yield.

**Two sessions, not one.** Reading the paper (step 5) and choosing a
controlled value (step 6) are separate jobs. Reading is expensive and done
once. Choosing is cheap and is redone whenever a vocabulary changes, without
opening a PDF again. Do not move vocabulary lists into the extraction
prompt.

**No analytical rule is hardcoded in a script.** Practices, units, keywords,
the year window and the geography list live in `catalogues/` and
`R/00_shared/paths.R`, and are read at run time.

**paths.R is the only file that knows a path.** No script builds a path from
a literal. If a new file is needed, add it to `paths.R` first.

**The pipeline proposes, the team decides.** A new practice, a new unit or an
unmatched term goes to `outputs/review/`, never silently into the data. When
no controlled value fits, the answer is NOT STATED and the cell stays empty.

**Nothing is lost.** Duplicates are registered, not deleted. The model's own
verdict is kept beside the ruled one. A person's override is kept in
`catalogues/screen_overrides.csv` and wins over the rules.

**Every step is resumable.** Append results after each record, never only at
the end. A run stopped halfway must continue where it left off.

**Every model calling step has a `--dry` flag** that plans and prices the run
without calling anything. Build that flag first, not last.

## 3. Script anatomy

Every script opens with this block, filled in for real:

```r
# What it does: one or two sentences, plain language.
# Reads: every input file, by repo relative path
# Writes: every output file, by repo relative path
# Flags: --source=   what it does
#        --limit=    what it does
#        --dry       what it does
#
# Run with:
#   Rscript R/0X_step/script.R --dry
```

Then, always these two lines, in this order, before anything else:

```r
root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
```

`utils.R` and any other shared file are sourced after those two, the same
way. The pattern works from RStudio, from `Rscript`, and from a working
directory anywhere inside the repo, so no script ever calls `setwd()`.

A placeholder script carries the real header, the real constants, and the
real sourcing lines, with the logic left as a numbered TODO and a final
`stop("not implemented yet")`. A placeholder that runs silently and does
nothing is worse than one that stops.

## 4. Style

- Plain language, in code and in documents. Sentence case. No em dashes.
- Comments say why, not what. The code already says what.
- Constants in `SCREAMING_SNAKE_CASE` at the top of the file, under a
  comment saying what changing them does.
- Functions and variables in `snake_case`.
- Files in `snake_case.R`, prefixed with nothing. The folder carries the
  step number, the file does not.
- One job per script. If a script needs two verbs to describe it, split it.
- Prefer a data frame over a list of lists. Everything here is tabular.
- Commits follow the conventional style: `feat:`, `fix:`, `docs:`,
  `refactor:`.

## 5. Adding a practice to the vocabulary

Short version. The walkthrough is `.claude/skills/add-practice/SKILL.md`.

1. Add a row to `catalogues/vocab_practices.csv`: `practice_code` in
   snake_case, `label`, one sentence `definition`, semicolon separated
   `synonyms` covering every spelling the literature uses, `carbon_relevant`,
   and a `notes` field that says what the practice is not.
2. Add a group of the same name to `KW_PRACTICE` in
   `catalogues/keyword_list.R`.
3. Rerun step 1, then steps 2 to 5 for the new records only (they are
   resumable), then step 6 in full, then step 7.

Step 6 is rerun in full because the option list changed. Decisions taken
under the old list retire on their own, because each cached decision is
keyed to a fingerprint of the list it was taken from. Nothing already
extracted is read again.

Never add a practice code without its boundary note. The overlaps are where
the coding goes wrong.

## 6. Extending the keyword list

`catalogues/keyword_list.R` holds four blocks: the practices, and the cost,
adoption and carbon outcome terms. The search crosses a practice group with
an outcome block.

- Terms are matched against title and abstract.
- Prefer a term that promises a number (`cost per hectare`, `adoption rate`)
  over one that promises a topic (`farming`, `sustainability`).
- Include hyphenated, abbreviated and non-hyphenated forms. `no-till`,
  `no till` and `zero tillage` are three terms.
- Do not put country names in the keyword list. OpenAlex filters on country
  server side, and a name based filter misses most of the corpus.
- Test a new term on its own with `--dry` and look at the expected count. A
  query returning tens of thousands of records is too broad.
- Adding a term means rerunning step 1 only. Everything downstream is keyed
  to the record, not to the query.

## 7. Adding a parameter or a schema field

The schema is the Excel column set. Its one definition is `SCHEMA_FIELDS` in
`R/05_extract/extract_verbatim.R`, and its publication order is
`SHEET_PARAMETERS` in `R/07_publish/export_results.R`. Both have to change
together.

- A new `parameter` value (a new kind of number) needs a line in the
  extraction prompt saying exactly what counts and what does not, plus an
  entry in `NEVER_A_PARAMETER` for the confusion it invites.
- A new schema field means step 5 is rerun, because the evidence for it was
  never asked for. This is the expensive kind of change. Be sure first.
- Tell the modellers before changing the column order. The carbon credit
  model reads that order.

## 8. Known gotchas

**OpenAlex rate limits.** Ten requests per second, 100,000 a day, and the
polite pool is faster and more reliable. Send a contact address on every
request (`OPENALEX_EMAIL`). Page with a cursor, never with an offset: deep
offset paging silently truncates. The abstract arrives as an inverted index
and has to be reconstructed. Country is on the author institution, not on
the study, so a paper about Kenya written in Wageningen carries NL, and the
screening has to catch it.

**Unpaywall needs an email on every request** and answers for a DOI only. A
record without a DOI has to go through another route. `is_oa = false` is not
proof there is no free copy: check the DOI directly and the publisher page
before writing `paywalled`.

**PDF encoding.** Table text scrambles when it is extracted, columns
interleave, and a number can lose its decimal point. Where a value comes
from a table, keep the table reference and treat the extracted text as a
hint, not as truth. Scanned PDFs hold no text at all, and `pdftools` returns
empty pages rather than failing, so check for text before spending a model
call. Ligatures and non-breaking spaces break exact string matching, so
normalise whitespace and unicode before verifying a quote.

**Windows paths.** Some publisher filenames are long enough to pass 260
characters. Files are saved as `<record_id>.pdf` for that reason. Never keep
the publisher's filename.

**Model prompt order.** The document text goes first and the per call
instruction after it, so the shared prefix is cached and the five extraction
calls for one paper cost little more than one. Putting an instruction before
the document roughly doubles the bill.

**Currency.** A cost is comparable only once the currency, the study year
and the area are all fixed. Record all three as the paper gives them, then
convert in code. Never ask the model to convert a currency.

**Person-days are not money.** Do not price labour. The carbon model does
that with its own wage assumptions.

**A review or a meta-analysis can double count.** The pooled figure and the
underlying studies can both enter the corpus. Flag these at screening and
settle the rule in `docs/protocol.md` before the full run.

## 9. Before you commit

- The script runs end to end with `--dry`.
- Every new file path is in `paths.R`.
- Every new analytical term is in `catalogues/`, not in a script.
- The header block names every file the script reads and writes.
- No key, no absolute local path and no PDF is in the diff.
- The README's folder by folder section describes the new script.
