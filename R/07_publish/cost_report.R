# What it does: Says what the pipeline has cost in model calls and what the
#   rest of the corpus would cost, from measured prompt sizes rather than
#   estimates. Run it before a full extraction, not after.
# Reads: outputs/logs/*.csv                  token counts per call
#        outputs/03_screen/screen_scope.csv
#        outputs/05_extract/extracted_verbatim.csv
# Writes: outputs/07_publish/cost_report.csv
# Flags: --forecast  price the records not yet processed and stop
#        --by=step   group the report by step, model, or practice
#
# Run with:
#   Rscript R/07_publish/cost_report.R
#   Rscript R/07_publish/cost_report.R --forecast

root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
source(file.path(root, "R/00_shared/utils.R"))

# Prices per million tokens, in USD. Check these against the provider's
# page before trusting a forecast; they change.
#   cached_in is the price of a prompt prefix the provider has already seen.
#   It is the reason the extraction sends the document once and asks five
#   questions after it, rather than five times.
PRICES <- data.frame(
  model     = c("gpt-5-nano", "gpt-5-mini"),
  input     = c(NA_real_, NA_real_),
  cached_in = c(NA_real_, NA_real_),
  output    = c(NA_real_, NA_real_)
)

# TODO
# 1. read the token counts every model calling script logs
# 2. join to PRICES, compute spend per call, roll up by --by
# 3. with --forecast, take the median prompt size per record from the runs
#    already done and multiply by the records still to do
# 4. write FILE_COST_REPORT and print the headline numbers
stop("not implemented yet")
