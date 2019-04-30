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

class(house_formula)

house1 <- lm(house_formula, data=house_train)
summary(house1)
coefplot(house1, sort='magnitude')

?glmnet

recipe(
    house_formula, 
    data=house_train
)


ny <- tibble::tribble(
    ~ Boro, ~ Pop, ~ Area, ~ Random,
    'Manhattan', 1700000, 23, 17,
    'Queens', 2600000, 104, 42,
    'Bronx', 1200000, 42, 3,
    'Staten Island', 475000, 66, 1/2,
    'Brooklyn', 2400000, 79, pi
)
ny

lm(Random ~ Pop, data=ny)

build.x(Random ~ Pop, data=ny)

lm(Random ~ Pop + Area, data=ny)
build.x(Random ~ Pop + Area, data=ny)
build.x(Random ~ Pop * Area, data=ny)
build.x(Random ~ Pop*Area - Pop - Area, ny)
build.x(Random ~ Pop:Area,ny)

build.x(Random ~ Boro, data=ny)
build.x(Random ~ Boro, 
        data=ny,
        contrasts=FALSE)

build.x(Random ~ scale(Pop) + scale(Area), ny)
build.x(Random ~ scale(Pop) + scale(Area), 
        ny) %>% 
    colMeans()
build.x(Random ~ log(Pop), ny)

recipe(
    Random ~ Pop + Area + Boro, 
    data=ny
) %>% 
    prep() %>% 
    juice()

basic_rec <- recipe(
    Random ~ Pop + Area + Boro, 
    data=ny
)
basic_rec

basic_rec %>% 
    step_dummy(Boro) %>% 
    prep() %>% 
    juice()

basic_rec %>%
    step_center(Pop, Area) %>% 
    step_scale(Pop, Area) %>% 
    step_dummy(
        Boro, 
        one_hot=FALSE) %>% 
    prep() %>% 
    juice()

boro_recipe <- basic_rec %>%
    step_center(Pop, Area) %>% 
    step_scale(Pop, Area) %>% 
    step_dummy(
        Boro, 
        one_hot=TRUE
    ) %>% 
    step_intercept()
boro_recipe
boro_prepped <- boro_recipe %>% 
    prep()
boro_prepped

boro_prepped %>% 
    juice(Random)

boro_prepped %>% 
    juice(
        all_predictors(),
        composition='dgCMatrix'
    )

boro_prepped %>% 
    juice(
        all_outcomes(),
        composition='matrix'
    )


house_rec <- recipe(
    house_formula,
    data=house_train
) %>% 
    step_log(TotalValue) %>% 
    step_other(
        all_nominal(), 
        threshold=0.1
    ) %>% 
    step_dummy(
        all_nominal(),
        one_hot=TRUE
    )
house_rec
house_prepped <- house_rec %>% 
    prep()
house_prepped

house_x <- house_prepped %>% 
    juice(all_predictors())
