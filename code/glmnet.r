library(useful)
library(coefplot)
library(glmnet)
library(recipes)
library(parsnip)

house_train <- readr::read_rds(
    'data/manhattan_Train.rds'
)

names(house_train)

house_formula <- TotalValue ~ FireService + 
    ZoneDist1 + ZoneDist2 + 
    Class + LandUse + OwnerType + LotArea + 
    BldgArea + ComArea + ResArea + OfficeArea + 
    RetailArea + NumBldgs + NumFloors + 
    UnitsRes + UnitsTotal + 
    LotFront + LotDepth + BldgFront + Landmark + 
    BuiltFAR + 
    HistoricDistrict + Built
