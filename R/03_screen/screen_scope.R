# What it does: The screener. Sends each deduplicated record's title and
#   abstract to a model and asks one question: does this study report a cost
#   or an adoption rate for a climate adaptation practice in Africa? The
#   model returns in, out or unsure, the reason, and the quote from the
#   abstract that supports it. Resumable: a record already judged is skipped.
# Reads: outputs/02_dedup/records_deduped.csv
# Writes: outputs/03_screen/screen_scope.csv  one row per judged record
# Flags: --limit=    judge this many records, for a test run
#        --shard=k/n split the corpus for parallel runs
#        --reask=    a CSV of record_ids to judge again
#        --model=    override SCREEN_MODEL
#        --dry       print the prompt and the price of the run, call nothing
#
# Run with:
#   Rscript R/03_screen/screen_scope.R --dry
#   Rscript R/03_screen/screen_scope.R --limit=50

root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
source(file.path(root, "R/00_shared/utils.R"))

SCREEN_MODEL_DEFAULT <- "gpt-5-nano"

# What the model is asked to return. One JSON object per record.
#   verdict          in | out | unsure
#   reason           one sentence, plain language
#   failed_criterion which of the four below failed, when the verdict is out
#   quote_parameter  the abstract's own words showing a cost or adoption rate
#   quote_geography  the abstract's own words naming the African country
#   practice_guess   a practice from vocab_practices.csv, or other
#   confidence       high | medium | low
SCREEN_FIELDS <- c(
  "verdict", "reason", "failed_criterion", "quote_parameter",
  "quote_geography", "practice_guess", "confidence"
)

# The four scope criteria. The screener judges all four; the year window and
# the geography are checked again in code by screen_rules.R, so widening the
# review never means reading an abstract again.
SCOPE_CRITERIA <- c(
  parameter = "Reports a cost or an adoption rate, as a number",
  practice  = "The subject is a climate adaptation practice in agriculture",
  geography = "The study is set in an African country",
  period    = "Published inside the year window set in paths.R"
)

# TODO
# 1. read FILE_DEDUP_CLEAN, drop records already in FILE_SCREEN unless --reask
# 2. build the prompt: the four criteria, the practice vocabulary, and the
#    instruction to quote the abstract rather than paraphrase it
# 3. one ellmer call per record with a structured type for SCREEN_FIELDS
# 4. keep the prompt instructions after the abstract text, so the shared
#    prefix stays cacheable and the bill stays low
# 5. append to FILE_SCREEN after every batch, so a stopped run resumes
# 6. record prompt and completion tokens per call, for cost_report.R
stop("not implemented yet")
