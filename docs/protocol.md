# CC4A review protocol

Draft v0.1. Placeholder. Filled in as each step is built.

Carbon Credits 4 Adaptation (CC4A). A systematic review of the costs and the
adoption rates of climate adaptation practices in African agriculture, for
use in a carbon credit project.

## 1. Question

What does it cost to put a climate adaptation practice in place on a hectare
of African farmland, and what share of farmers take it up?

## 2. Scope

A record is in scope when all four hold.

| Criterion | Rule |
|---|---|
| Parameter | The study reports a cost or an adoption rate, as a number |
| Practice | The subject is a climate adaptation practice in agriculture |
| Geography | The study is set in an African country |
| Period | Published inside the year window in `R/00_shared/paths.R` |

The practice list is `catalogues/vocab_practices.csv`. The year window is
`YEAR_MIN` and `YEAR_MAX`, applied in code by `screen_rules.R`, so widening
the review does not mean reading an abstract again.

## 3. Search

To be written when step 1 is built. It will record, per query: the exact
string sent, the filters, the date, the number returned and the number kept.
The query set is built from `catalogues/keyword_list.R`.

## 4. Screening

To be written when step 3 is built. Model verdict and code rules are kept
separate, and a person's decisions win over both.

## 5. Extraction

To be written when step 5 is built. Every value carries a page number and a
quote, and every quote is checked against the page it cites.

## 6. Harmonisation

To be written when step 6 is built. Controlled vocabularies are
`vocab_practices.csv` and `vocab_units.csv`. Currency conversion and
deflation are done in `harmonize.R`, not by the model.

## 7. Quality

To be written. A gold set of records extracted by hand, scored field by
field. The score that matters is per field, not overall.

## 8. Open questions

- How to treat a meta-analysis: extract the pooled figure, the underlying
  studies, or both, and how to stop the same study entering twice.
- Whether a cost reported per household can be used at all without an area.
- Which base year and which deflator series to use for currency conversion.
- Whether grey literature and project reports belong in the corpus, given
  the search starts from OpenAlex.
