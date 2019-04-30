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

xg7 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=1000,
    eval_metric='logloss',
    watchlist=list(
        train=hist_xgd,
        validate=hist_val_xgd
    ),
    print_every_n=1,
    early_stopping_rounds=70
)

xg7 %>% 
    xgb.importance(
        feature_names=colnames(hist_x),
        model=.
    ) %>% 
    xgb.plot.importance()

xg8 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=1000,
    eval_metric='logloss',
    watchlist=list(
        train=hist_xgd,
        validate=hist_val_xgd
    ),
    print_every_n=1,
    early_stopping_rounds=70,
    eta=0.1
)

library(yardstick)

?xgb.train

xg9 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=1000,
    eval_metric='logloss',
    watchlist=list(
        train=hist_xgd,
        validate=hist_val_xgd
    ),
    print_every_n=1,
    early_stopping_rounds=70,
    eta=0.1,
    max_depth=3
)
xg7$best_score
xg8$best_score
xg9$best_score

xg10 <- xgb.train(
    data=hist_xgd,
    nrounds=1000,
    early_stopping_rounds=70,
    eval_metric='logloss',
    objective='reg:logistic',
    watchlist=list(
        train=hist_xgd,
        validate=hist_val_xgd
    ),
    print_every_n=1,
    booster='gblinear',
    alpha=.03, lambda=.2
)

coefplot(xg10, sort='magnitude')

xg11 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=1,
    eval_metric='logloss',
    watchlist=list(
        train=hist_xgd,
        validate=hist_val_xgd
    ),
    print_every_n=1,
    early_stopping_rounds=70,
    eta=0.3,
    max_depth=6,
    subsample=0.5,
    colsample_bytree=0.5,
    num_parallel=50
)

xg12 <- xgb.train(
    data=hist_xgd,
    objective='binary:logistic',
    nrounds=50,
    eval_metric='logloss',
    watchlist=list(
        train=hist_xgd,
        validate=hist_val_xgd
    ),
    print_every_n=1,
    early_stopping_rounds=70,
    eta=0.3,
    max_depth=6,
    subsample=0.5,
    colsample_bytree=0.5,
    num_parallel=100
)
dygraph(xg12$evaluation_log)
xg12$best_score

boost_base <- boost_tree(
    mode='classification',
    trees=100,
    tree_depth=4,
    learn_rate=0.2
)
boost_base    

boost_xg <- boost_base %>% 
    set_engine('xgboost')
boost_c5 <- boost_base %>% 
    set_engine('C5.0')

xg13 <- boost_xg %>% 
    fit_xy(x=as.matrix(hist_x), y=factor(hist_y))

c5_1 <- boost_c5 %>% 
    fit_xy(x=as.matrix(hist_x), y=factor(hist_y))

preds13 <- predict(xg12, newdata=hist_val_x)

?xgb.train

depth_choice <- sample(x=1:8, size=10, 
                       replace=TRUE)
eta <- runif(10, min=0.05, max=0.4)
round_choice <- sample(c(100, 75, 200, 300, 150),
                       size=10,
                       replace=TRUE)

params <- tibble::tibble(
    max_depth=depth_choice,
    eta=eta,
    nrounds=round_choice
) %>% 
    dplyr::mutate(
        params=purrr::pmap(
            list(max_depth, eta),
            ~list(max_depth=..1,
                  eta=..2
            )
        )
    )
params$params

models <- params %>% 
    dplyr::mutate(
        model=purrr::map(
            params, 
            ~ xgb.train(params=., 
                        data=hist_val_xgd,
                        nrounds=100,
                        watchlist=list(
                            train=hist_xgd,
                            validate=hist_val_xgd
                        ),
                        eval_metric='logloss'
            )
        )
    )

models %>% 
    dplyr::mutate(
        Eval=purrr::map_dbl(
            
        )
    )
