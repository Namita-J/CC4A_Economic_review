# What it does: Code checks on the screener's verdicts. The year window and
#   the Africa check are applied here, from the record metadata, not by the
#   model. A verdict of in with no quoted number becomes unsure. A person's
#   decisions in the overrides file win over everything. Writes the queue of
#   records a person still has to judge.
# Reads: outputs/03_screen/screen_scope.csv
#        outputs/02_dedup/records_deduped.csv
#        catalogues/screen_overrides.csv  a person's decisions, if any
# Writes: outputs/03_screen/screen_ruled.csv  the ruled verdict beside the
#           model's own, never replacing it
#         outputs/review/screen_unsure.csv    the queue for a person
# Flags: --report  print the counts and write nothing
#
# Run with:
#   Rscript R/03_screen/screen_rules.R
#   Rscript R/03_screen/screen_rules.R --report

root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
source(file.path(root, "R/00_shared/paths.R"))
source(file.path(root, "R/00_shared/utils.R"))

# The rules, in the order they are applied. Each one writes its name into a
# rule_applied column, so any verdict can be traced back to the rule that
# set it.
#
#   year_window     publication_year outside YEAR_MIN to YEAR_MAX goes out
#   africa_tie      no African country in the record or the quote goes out
#   no_number       in, but quote_parameter holds no digit, becomes unsure
#   low_confidence  in, with confidence low, becomes unsure
#   bare_reason     a one word reason is listed for a re ask
#   review_paper    a review or meta-analysis stays in, flagged for step 5
#                   to extract the underlying studies rather than the pooled
#                   figure where it can
#   human_override  a decision in screen_overrides.csv wins over all of these
RULES <- c(
  "year_window", "africa_tie", "no_number", "low_confidence",
  "bare_reason", "review_paper", "human_override"
)

# Columns a person fills in catalogues/screen_overrides.csv:
#   record_id, verdict, reason, decided_by, decided_on
OVERRIDE_COLS <- c("record_id", "verdict", "reason", "decided_by", "decided_on")

# TODO
# 1. join FILE_SCREEN to FILE_DEDUP_CLEAN on record_id
# 2. apply RULES in order, writing verdict_ruled and rule_applied, and
#    leaving the model's verdict column untouched
# 3. write FILE_SCREEN_RULED
# 4. write every unsure record to FILE_SCREEN_UNSURE with the reason and the
#    quotes, so a person can judge without opening the paper
# 5. print the counts: in, out, unsure, and the top failed criteria
stop("not implemented yet")
