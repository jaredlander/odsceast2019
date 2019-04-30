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

hist_recipe <- recipe(
    hist_formula, 
    data=land_train
) %>%
    step_other(
        all_nominal(), -HistoricDistrict,
        threshold=.10
    ) %>% 
    step_dummy(
        all_nominal(), -HistoricDistrict, 
        one_hot=TRUE
    ) %>% 
    step_downsample(HistoricDistrict) %>% 
    step_dummy(HistoricDistrict, 
               one_hot=FALSE)
hist_recipe

hist_prepped <- hist_recipe %>% 
    prep(data=land_train)
hist_prepped$template

hist_x <- hist_prepped %>% 
    juice(
        all_predictors(), 
        -HistoricDistrict_Yes,
        composition='dgCMatrix'
    )
class(hist_x)
colnames(hist_x)

hist_y <- hist_prepped %>% 
    juice(
        HistoricDistrict_Yes,
        composition='matrix'
    )
head(hist_y)

hist_val_x <- hist_prepped %>% 
    bake(
        all_predictors(),
        -HistoricDistrict_Yes,
        new_data=land_val,
        composition='dgCMatrix'
    )
hist_val_y <- hist_prepped %>% 
    bake(
        HistoricDistrict_Yes,
        new_data=land_val,
        composition='matrix'
    )

hist_xgd <- xgb.DMatrix(
    hist_x,
    label=hist_y
)
hist_val_xgd <- xgb.DMatrix(
    hist_val_x,
    label=hist_val_y
)

