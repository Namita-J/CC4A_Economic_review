# What it does: Reads one full text and returns the parameter rows it holds,
#   in the paper's own words. For every value the model returns the number,
#   the unit as the paper wrote it, the page, and the sentence it came from.
#   Code then checks each quote against the page it cites. A value that is
#   not found on its page is dropped, not kept.
# Reads: outputs/04_fulltext/pdf/<record_id>.pdf
#        catalogues/vocab_practices.csv  the practice list shown to the model
# Writes: outputs/05_extract/extracted_verbatim.csv    one row per parameter
#         outputs/05_extract/verification_report.csv   the page check result
#         outputs/05_extract/raw/<record_id>.json      the untouched answer
# Flags: <path>    a single PDF or a manifest CSV with a record_id column
#        --model=  override EXTRACT_MODEL
#        --pages=  send only these pages, for a test
#        --dry     print the prompt and the price, call nothing
#
# Run with:
#   Rscript R/05_extract/extract_verbatim.R outputs/04_fulltext/pdf/W123.pdf
#   Rscript R/05_extract/extract_verbatim.R manifest.csv --dry

root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
source(file.path(root, "R/00_shared/utils.R"))

EXTRACT_MODEL_DEFAULT <- "gpt-5-mini"

# The extraction schema. These are the Excel columns the review is filling,
# and this is the only place their order and meaning are written down. Step 6
# maps the free text ones to controlled values; nothing here is controlled
# yet, because session one returns the paper's own words.
SCHEMA_FIELDS <- c(
  "parameter",       # adoption_rate | cost_total | cost_installation |
                     #   cost_variable | carbon_share
  "definition",      # free text, what exactly is measured
  "practice",        # verbatim here, mapped to vocab_practices.csv in step 6
  "value",           # the number as the paper gives it
  "unit",            # verbatim here, mapped to vocab_units.csv in step 6
  "geography",       # country or sub-region within Africa
  "literature_doi",  # filled from the record, not from the model
  "detail",          # sample size, discount rate, study context
  "study_design",    # RCT | observational | DCE | meta-analysis | review | other
  "sample_size"      # farmers, plots, or studies
)

# Returned alongside every row so the value can be checked and traced.
PROVENANCE_FIELDS <- c(
  "record_id",
  "page",            # the page the value sits on
  "quote",           # the sentence, word for word
  "table_ref",       # table or figure number, when the value came from one
  "verify_status"    # found | found_other_page | not_found
)

# Values that can never fill a parameter slot. Decided in code, not by the
# model, because these are the confusions that cost most to find later.
NEVER_A_PARAMETER <- c(
  "project_budget_totals",   # a programme budget is not a per hectare cost
  "exchange_rates",
  "years_and_dates",
  "sample_sizes",            # the sample size has its own column
  "percentages_of_sample",   # 60 percent of respondents were male
  "carbon_prices",           # a price is not a cost of the practice
  "yield_figures"
)

# TODO
# 1. read the PDF with pdftools, keep the page numbers with the text
# 2. build one prompt per parameter family (cost, adoption, carbon share),
#    each seeing the same page tagged document, so the shared prefix is
#    cached and the five calls cost little more than one
# 3. keep every per call instruction after the document text
# 4. one ellmer call per family, structured to SCHEMA_FIELDS plus
#    PROVENANCE_FIELDS
# 5. verify: string match the quote against the cited page, then the rest of
#    the document, then give up and mark not_found
# 6. drop not_found rows from the results, keep them in the audit
# 7. apply NEVER_A_PARAMETER in code, log what it removed
# 8. write the raw JSON per record before any of this, so a bad run can be
#    diagnosed without paying for it again
stop("not implemented yet")
