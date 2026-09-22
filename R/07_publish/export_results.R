# What it does: Publishes the newest harmonised run as the Excel parameter
#   database, in the schema's column order, with the provenance columns on a
#   second sheet and the rows that need a human look on a third. Also scores
#   the run against the gold set, so every release carries its own quality
#   number.
# Reads: outputs/06_harmonise/extracted_harmonised.csv
#        outputs/05_extract/verification_report.csv
#        catalogues/gold_set.csv
# Writes: outputs/07_publish/cc4a_parameters_latest.xlsx
#         outputs/07_publish/cc4a_parameters_<stamp>.xlsx
#         outputs/07_publish/quality_score.csv
# Flags: --no-score   export without scoring
#        --stamp=     publish a named earlier run instead of the newest
#
# Run with:
#   Rscript R/07_publish/export_results.R

root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
source(file.path(root, "R/00_shared/utils.R"))

# Sheet 1. The parameter database. This column order is what the carbon
# credit model reads, so it does not change without telling the modellers.
SHEET_PARAMETERS <- c(
  "parameter", "definition", "practice", "value", "unit", "geography",
  "literature_doi", "detail", "study_design", "sample_size"
)

# Sheet 2. Where each value came from, so any number can be traced back to
# a page without opening the pipeline.
SHEET_PROVENANCE <- c(
  "record_id", "literature_doi", "parameter", "value", "page", "quote",
  "table_ref", "verify_status", "value_raw", "unit_raw", "conversion_applied"
)

# Sheet 3. Rows a person should look at before the database is used:
# anything harmonised to NOT STATED, anything verified on another page,
# anything whose value is far from the others for the same practice and unit.
SHEET_REVIEW <- c(
  "record_id", "parameter", "practice", "value", "unit", "flag", "why"
)

# Scoring. Field by field agreement against the hand checked gold set. The
# number that matters is per field, not overall, because a pipeline can be
# right about the practice and wrong about every cost.
SCORE_FIELDS <- SHEET_PARAMETERS

# TODO
# 1. read the harmonised run and the verification report
# 2. build the three sheets, in the orders above
# 3. flag the review rows: NOT STATED, found_other_page, and values more than
#    three median absolute deviations from the median for their practice and
#    unit group
# 4. write both the stamped workbook and the latest copy with openxlsx
# 5. unless --no-score, join to the gold set on record_id and parameter,
#    report agreement per field and the disagreements with both values side
#    by side
stop("not implemented yet")
