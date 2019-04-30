library(useful)
library(coefplot)
library(recipes)
library(parsnip)
library(xgboost)

land_train <- readr::read_rds(
    'data/manhattan_Train.rds'
)
land_val <- readr::read_rds(
    'data/manhattan_Validate.rds'
)
land_test <- readr::read_rds(
    'data/manhattan_Test.rds'
)

table(land_train$HistoricDistrict)
hist_formula <- HistoricDistrict ~ FireService + 
    ZoneDist1 + ZoneDist2 + 
    Class + LandUse + OwnerType + LotArea + 
    BldgArea + ComArea + ResArea + OfficeArea + 
    RetailArea + NumBldgs + NumFloors + 
    UnitsRes + UnitsTotal + 
    LotFront + LotDepth + BldgFront + 
    BuiltFAR + 
    TotalValue + Built
