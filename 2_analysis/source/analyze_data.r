# =============================================================================
# Short description of script's purpose
# =============================================================================

library(tidyverse)
library(stargazer)
library(ggplot2)
library(estimatr)
library(modelsummary)

# Paths
input_dir <- "../../1_data/output"
output_dir <- "../output"

# =============================================================================

main <- function() {
  load("../input/mpg.Rdata")
  regression_table(mpg_clean)
  city_figure(mpg_clean)
  hwy_figure(mpg_clean)
}

regression_table <- function(data) {
  reg_cty <- lm_robust(displ ~ cty, data = data, clusters = year)
  summary(reg_cty)

  reg_hwy <- lm_robust(displ ~ hwy, data = data, clusters = year)
  summary(reg_hwy)

  reg_hwy_cty <- lm_robust(displ ~ hwy + cty, data = data, clusters = year)
  summary(reg_hwy_cty)

  modelsummary(
    list("City FE"    = reg_cty,
         "Highway FE" = reg_hwy,
         "Both"       = reg_hwy_cty),
    output     = "../output/table_reg.tex",
    title      = "Results",
    gof_omit = 'DF|Deviance|AIC|BIC|RMSE'
  )
}

city_figure <- function(data) {
  p <- ggplot(data, aes(x = displ, y = log(cty), color = year)) +
    geom_point() +
    xlab("Engine displacement (L)") +
    ylab("Log City fuel economy (mpg)")
  ggsave("../output/figure_city.jpg", plot = p)
}

hwy_figure <- function(data) {
  p <- ggplot(data, aes(x = displ, y = hwy, color = year)) +
    geom_point() +
    xlab("Engine displacement (L)") +
    ylab("Highway fuel economy (mpg)")
  ggsave("../output/figure_hwy.jpg", plot = p)
}

# Execute
main()
