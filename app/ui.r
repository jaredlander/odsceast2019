library(shiny)
library(shinythemes)

countryPanel <- tabPanel(
    title='Country Info',
    selectInput(
        inputId='CountrySelector',
        label='Choose a Country',
        choices=list(
            'USA', 'Canada', 'Italy', 
            'Gabon', 'China',
            'Venezuela', 'Switzerland',
            'Colombia', 'Iran'
        )
    ),
    textOutput(
        outputId='DisplayCountry'
    )
)

plotPanel <- tabPanel(
    title='Simple Plot',
    fluidRow(
        column(
            width=3,
            selectInput(
                inputId='CarColumn',
                label='Please choose a column to plot',
                choices=names(mtcars)
            )
        ),
        column(
            width=9,
            plotOutput(
                outputId='CarHist'
            )
        )
    )
)

pizzaStuff <- tabPanel(
    title='Pizza',
    fluidRow(
        column(
            width=6,
            DT::dataTableOutput(
                outputId='PizzaTable'
            )
        ),
        column(
            width=6,
            leaflet::leafletOutput(
                outputId='PizzaMap'
            )
        )
    )
)

navbarPage(
    title='Flight of the Navigator',
    # themeSelector(),
    theme=shinytheme(theme='cerulean'),
    selected='Pizza',
    tabPanel(
        title='The World',
        'Hello'
    ),
    tabPanel(
        title='Second Page',
        'Your quest begins here'
    ),
    countryPanel,
    plotPanel,
    pizzaStuff,
    tabPanel(
        title='Predictions',
        textInput(
            inputId='Lambda',
            label='Choose a lambda',
            value=0.06
        ),
        tableOutput(outputId='Preds')
    )
)
