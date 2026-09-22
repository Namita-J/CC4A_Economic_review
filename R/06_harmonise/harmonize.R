# What it does: Maps the verified extracts to the controlled vocabularies and
#   standardises the units. Sees only the extracted rows, never the papers.
#   Rules first, the decision cache second, and one batched model call for
#   what is left. Every decision is cached, so a rerun is identical and costs
#   almost nothing. A term the vocabulary lacks is proposed for the team,
#   never written into the data.
# Reads: outputs/05_extract/extracted_verbatim.csv
#        catalogues/vocab_practices.csv
#        catalogues/vocab_units.csv
#        catalogues/vocab_decisions.csv
# Writes: outputs/06_harmonise/extracted_harmonised.csv
#         catalogues/vocab_decisions.csv       updated cache
#         outputs/review/proposed_vocab_terms.csv  new terms for the team
# Flags: --rules-only  no model call, leave the rest unmapped
#        --no-cache    ignore the cache, decide everything again
#        --dry         report what would be mapped and how
#
# Run with:
#   Rscript R/06_harmonise/harmonize.R
#   Rscript R/06_harmonise/harmonize.R --rules-only

root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
source(file.path(root, "R/00_shared/utils.R"))
source(file.path(root, "R/00_shared/vocab_cache.R"))

HARMONIZE_MODEL_DEFAULT <- "gpt-5-mini"

# Which fields are mapped, and to what.
#   practice      to the practice_code column of vocab_practices.csv
#   unit          to the unit_code column of vocab_units.csv
#   geography     to an ISO 3166-1 alpha-2 code, or a named sub-region
#   study_design  to the fixed list in the schema
MAPPED_FIELDS <- c("practice", "unit", "geography", "study_design")

# Unit standardisation. Currency is the part that needs care, because a cost
# is only comparable once the currency, the year and the area are all fixed.
#   1. record the currency and the study year as the paper gives them
#   2. convert local currency to USD at the rate of the study year
#   3. deflate to the review's base year with the US GDP deflator
#   4. leave person-days alone, they are a labour unit and not a price
# The base year and the rate source live here, not in the model prompt.
CURRENCY_BASE_YEAR <- 2025
CURRENCY_TARGET    <- "USD"

# When no controlled value fits, the cell stays empty and the row carries
# NOT STATED. An empty cell is honest; a guessed code is not.
NO_MATCH_VALUE <- "NOT STATED"

# TODO
# 1. read the extracts and the two vocabularies
# 2. rules first: exact match on the vocabulary synonyms column, case and
#    punctuation folded
# 3. cache second: vocab_cache_get() with the current options hash
# 4. one batched model call for the rest, showing the full option list and
#    the vocabulary definitions, asking for a code or NO_MATCH_VALUE
# 5. vocab_cache_put() every decision, then vocab_cache_save()
# 6. standardise units per the note above, writing value_std, unit_std and
#    the conversion applied, keeping the original value and unit untouched
# 7. write anything that matched nothing to FILE_VOCAB_PROPOSED
stop("not implemented yet")
