# What it does: Holds the search vocabulary in one place. Three blocks of
#   terms, crossed by the search step: a practice term has to appear with
#   either a cost term or an adoption term. The geography is not a keyword,
#   because OpenAlex filters on country server side and a keyword filter on
#   country names misses most of the corpus.
# Reads: nothing.
# Writes: nothing. This file is sourced by R/01_search/openalex_search.R.
# Flags: none.
#
# Terms are matched against title and abstract. Keep them specific: a broad
# term such as "farming" returns tens of thousands of records and none of
# them carry a number. Adding a term means rerunning step 1 only; everything
# downstream is keyed to the record, not to the query.

# ---- block 1: the practice ---------------------------------------------

# One group per practice code in catalogues/vocab_practices.csv, so a new
# practice is added in both files at once. Synonyms and the common spelling
# variants belong here, not in the vocabulary file.
KW_PRACTICE <- list(
  agroforestry = c(
    "agroforestry", "agro-forestry", "farmer managed natural regeneration",
    "FMNR", "parkland", "alley cropping", "shade trees", "silvopastoral"
  ),
  conservation_agriculture = c(
    "conservation agriculture", "conservation tillage", "minimum tillage",
    "zero tillage", "no-till", "reduced tillage", "mulching"
  ),
  improved_fallows = c(
    "improved fallow", "planted fallow", "fallow enrichment",
    "rotational fallow"
  ),
  biochar = c(
    "biochar", "pyrolysis char", "charcoal amendment"
  ),
  cover_crops = c(
    "cover crop", "green manure", "living mulch", "legume intercrop"
  ),
  drought_tolerant_varieties = c(
    "drought tolerant variety", "drought resistant variety",
    "stress tolerant maize", "improved variety adoption", "DTMA"
  ),
  water_harvesting = c(
    "water harvesting", "rainwater harvesting", "zai", "tassa",
    "half moon", "contour bund", "stone bund", "micro-catchment",
    "supplemental irrigation"
  )
)

# ---- block 2: the cost side --------------------------------------------

# A record has to look like it carries a number, not just a discussion of
# affordability. Terms that promise a figure are worth more than terms that
# promise a topic.
KW_COST <- c(
  "establishment cost", "installation cost", "investment cost",
  "capital cost", "operating cost", "maintenance cost", "variable cost",
  "labour requirement", "labor requirement", "person-day", "man-day",
  "cost per hectare", "cost benefit analysis", "net present value",
  "internal rate of return", "gross margin", "profitability",
  "budget analysis", "economic analysis"
)

# ---- block 3: the adoption side ----------------------------------------

KW_ADOPTION <- c(
  "adoption rate", "adoption intensity", "uptake", "dis-adoption",
  "disadoption", "adoption determinants", "willingness to adopt",
  "willingness to pay", "share of farmers", "proportion of households",
  "diffusion", "scaling"
)

# ---- block 4: the carbon side ------------------------------------------

# Used for the carbon_share parameter: how much of a project's carbon
# revenue reaches the farmer, and how the credits are split.
KW_CARBON <- c(
  "carbon credit", "carbon revenue", "benefit sharing", "revenue sharing",
  "carbon payment", "payment for ecosystem services", "PES",
  "carbon finance", "carbon project", "voluntary carbon market"
)

# ---- what the search step crosses --------------------------------------

# Each query is one practice group and one outcome block. The search log
# records which pairing found each record, so it is easy to see which
# pairings earn their keep and which return noise.
KW_BLOCKS <- list(
  cost     = KW_COST,
  adoption = KW_ADOPTION,
  carbon   = KW_CARBON
)

# ---- terms that mark a record as noise ---------------------------------

# Not used to filter the query, because a title-only exclusion throws away
# good records. Used in the search log to show how much noise each pairing
# returns, and read again by the screener prompt.
KW_EXCLUDE_HINTS <- c(
  "urban forestry", "greenhouse gas inventory", "life cycle assessment",
  "laboratory incubation", "pot experiment", "glasshouse"
)
