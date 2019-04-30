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

xg1 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=1
)

xg1
xgb.plot.multi.trees(
    xg1,
    feature_names=colnames(hist_x)
)

xg2 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=1,
    max_depth=4
)

xgb.plot.multi.trees(
    xg2,
    feature_names=colnames(hist_x)
)

xg3 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=1,
    eval_metric='logloss',
    watchlist=list(train=hist_xgd),
    print_every_n=1
)

xg4 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=100,
    eval_metric='logloss',
    watchlist=list(train=hist_xgd),
    print_every_n=1
)

xg5 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=1000,
    eval_metric='logloss',
    watchlist=list(train=hist_xgd),
    print_every_n=1
)

xg6 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=1000,
    eval_metric='logloss',
    watchlist=list(
        train=hist_xgd,
        validate=hist_val_xgd
    ),
    print_every_n=1
)

xg6$evaluation_log

library(dygraphs)
dygraph(xg6$evaluation_log)
xg6$evaluation_log$validate_logloss %>% min
xg6$evaluation_log$validate_logloss %>% 
    which.min
