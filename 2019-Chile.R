# Librerias -----------------------------------------------------------------------------------

library(dplyr)
library(forcats)
library(ggplot2)
library(purrr)
library(readr)
library(tidyr)
library(tabulizer)
library(rvest)

# Funciones comunes

source("R/save_object.R")

# Carabineros y PDI -------------------------------------------------------------

source("R/extraer_carabineros_pdi.R")

# Minsal -------------------------------------------------------------

source("R/extraer_minsal.R")


# Carabineros +   Minsal -------------------------------------------------------------

# source("R/carabinerosPDI_minsal.R")
