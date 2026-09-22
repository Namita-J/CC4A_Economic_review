# What it does: Remembers every mapping from a verbatim extract to a
#   controlled value, so a rerun of step 6 makes the same choice and costs
#   almost nothing. A person can correct a row in the cache file and the
#   correction survives the next run.
# Reads: catalogues/vocab_decisions.csv
# Writes: catalogues/vocab_decisions.csv
# Flags: none. This file is sourced, not run.
#
# Sourced with:
#   root <- rprojroot::find_root(rprojroot::has_file("CC4A.Rproj"))
#   source(file.path(root, "R/00_shared/paths.R"))
#   source(file.path(root, "R/00_shared/vocab_cache.R"))
#
# Cache columns:
#   field           which schema field the decision is about (practice, unit)
#   verbatim        the value as the paper wrote it, normalised
#   mapped_value    the controlled value chosen
#   method          rule, cache, model, or human
#   options_hash    fingerprint of the option list the choice was made from
#   decided_on      date
#   note            why, when the decision was not obvious
#
# The options_hash is what lets the vocabulary grow safely. A decision taken
# against an older option list retires on its own, because its hash no longer
# matches, and the value is decided again.

#' Load the decision cache into memory.
#' @return a tibble with the columns above, empty on a first run
vocab_cache_load <- function() {
  # TODO: read FILE_VOCAB_CACHE with read_csv_safe()
  stop("not implemented yet")
}

#' Look a value up.
#' @param cache the tibble from vocab_cache_load()
#' @param field which schema field
#' @param verbatim the normalised verbatim value
#' @param options_hash fingerprint of the current option list
#' @return the mapped value, or NA when there is no live decision
vocab_cache_get <- function(cache, field, verbatim, options_hash) {
  # TODO: match on field and verbatim, ignore rows whose options_hash differs
  stop("not implemented yet")
}

#' Record a decision. Appends, never rewrites a human row.
#' @param cache the tibble from vocab_cache_load()
#' @param field,verbatim,mapped_value,method,options_hash,note the decision
#' @return the cache with the new row
vocab_cache_put <- function(cache, field, verbatim, mapped_value, method,
                            options_hash, note = NA_character_) {
  # TODO
  stop("not implemented yet")
}

#' Write the cache back to disk.
#' @param cache the tibble
vocab_cache_save <- function(cache) {
  # TODO: write_csv_safe(cache, FILE_VOCAB_CACHE)
  stop("not implemented yet")
}

#' Fingerprint an option list, so a vocabulary change retires the decisions
#' that were taken under the old list.
#' @param options a character vector of controlled values
#' @return a short string
vocab_options_hash <- function(options) {
  # TODO: sort, paste, hash
  stop("not implemented yet")
}
