## code to prepare `DATASET` dataset goes here

usethis::use_data(DATASET, overwrite = TRUE)
#
# # https://www.altalis.com/map;id=110
# twpShp <- sf::st_read("data-raw/geo/V4-1_TWP.shp")
# #https://www.aer.ca/providing-information/data-and-reports/statistical-reports/st37
# wellSurfShp <- sf::st_read("data-raw/ST37_SH/ST37_SH_NAD83_10TM_AEPForest.shp")
# wellBotShp <- sf::st_read("data-raw/ST37_BH/ST37_BH_NAD83_10TM_AEP.shp")
# #"https://www2.aer.ca/t/Production/views/COM-VentFlowGasMigrationReport/VentFlowGasMigrationReport.csv"
# aer <- readRDS("data-raw/AERgas.rds")
# # https://www.petrinex.gov.ab.ca/publicdata/API/Files/AB/Infra/Facility%20Infrastructure/CSV
# wellInfraF <- readr::read_csv('data-raw/Well Licence-AB.CSV')
#
# aer <- aer %>%
#   dplyr::rename_with(.fn = ~ stringr::str_remove(., "^\\d+\\.") %>%
#                        stringr::str_replace_all("\\s+", "_") %>%
#                        stringr::str_replace_all("[()]", "") %>%
#                        stringr::str_replace_all("[/]", "per") %>%
#                        tolower()) %>%
#   dplyr::mutate(report_date = as.Date(report_date, format = "%m/%d/%Y %H:%M:%S"),
#          resolution_date = as.Date(resolution_date, format = "%m/%d/%Y %H:%M:%S")) %>%
#   dplyr::select(-current_licence_status) %>%
#   dplyr::mutate(licence_number = stringr::str_remove_all(licence_number, "[^0-9]"))
#
#
# wellInfraF <- wellInfraF %>%
#   dplyr::mutate(LicenceNumber = stringr::str_remove_all(LicenceNumber, "[^0-9]")) %>%
#   dplyr::distinct(LicenceNumber, LicenceLocation, .keep_all = TRUE) %>%
#   dplyr::select(-LicenceType, -ProjectedTotalDepth,
#          -TargetPool, -WellCompletionType) %>%
#   dplyr::mutate(DrillingOperationType = tolower(DrillingOperationType))
#
#
# wellBotShp <- wellBotShp %>%
#   dplyr::distinct(License, .keep_all = TRUE) %>%
#   dplyr::select(uwiB = UWI, Field, Pool, Licence = License, TotalDep, Fluid_Desc,
#          ModeDesc, BH_Long, BH_Lat, KBE, geometryB = geometry)
#
#
# wellSurfShp <- wellSurfShp %>%
#   dplyr::distinct(Licence, .keep_all = TRUE) %>%
#   dplyr::select(Licence, CompName, Latitude, Longitude, SurfLoc, EDCT, geometryS = geometry)
#
#
# wellComp <- dplyr::inner_join(aer, wellInfraF,
#                        by = c("licence_number" = "LicenceNumber", 'surface_location' = 'LicenceLocation')) %>%
#   dplyr::rename(TWP = LicenceTownship, RGE = LicenceRange, M = LicenceMeridian, LSD = LicenceLegalSubdivision, SEC = LicenceSection)
#
# wellComp <- dplyr::left_join(wellComp, twpShp, by = c("TWP", "RGE", "M"), relationship = 'many-to-many')
#
#
# compWellBot <- dplyr::inner_join(wellComp, wellBotShp, by = c("licence_number" = "Licence"))
#
# compWellSurfBot <- dplyr::inner_join(compWellBot, wellSurfShp, by = c("licence_number" = "Licence"))
#
# leakReport <- compWellSurfBot %>%
#   dplyr::mutate(LicenceStatus = tolower(LicenceStatus),
#          LicenceStatus = stringr::str_to_title(LicenceStatus),
#          reported_resolution = tolower(reported_resolution),
#          reported_resolution = stringr::str_to_title(reported_resolution)) %>%
#   dplyr::mutate(reportType = dplyr::if_else(is.na(reported_resolution), "No Resolution Reported", "Resolution Reported"),
#                 resolutionType = dplyr::case_when(
#                   reported_resolution %in% c("Problem Repaired", "Repaired - Scvf/Gm", "Well Abandoned",
#                                              "Entry Error-Ignore", "Casing Failure", "Casing Vent Produced",
#                                              "Not Converted", "Wellhead Seal Leak", "Casing Failure", "Died Out") ~ "Repaired",
#                   reported_resolution %in% c("Monitor As Required", "Considered Non-Serious", "Well Capped W/ Pressure") ~ "Abated",
#                   reported_resolution == "Repair Unsuccessful" ~ "Repair Unsuccessful",
#                   TRUE ~ NA
#                 )
#   )


usethis::use_data(leakReport, overwrite = TRUE)


# Age of the well, company that drilled the well, depth, and propensity for a well to leak
# realationship betweeen the size of the leak and the depth
# calmar

#


