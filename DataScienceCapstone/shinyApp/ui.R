library(shiny)

# Define UI for miles per gallon application
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Daniel Moore's Text Predictor"),
    
    sidebarLayout(
    sidebarPanel(
        p("Please be patient while the prediction model loads. You will know it is loaded when the word 'technology' appears in red. This could take over a minute."),
        
        
        textInput("inputstringA", "input your string (up to 3 words): ", "Georgia Institute of"),
        
        actionButton("goButton", "Go!"),
        
        h4("How to Use This Page"),
        p("Please insert a text phrase above."),
        p("And then press the 'Go!' button"),
        p(),
        hr(),
        p("Daniel Moore"),
        a("Email", href="mailto:dfmjunk-at-notreal.com")
        
        ),
    
    mainPanel(
        tabsetPanel(
            tabPanel("Predicted Next Word",
                     h3(textOutput("outputstring"), style="color:red")
                     #h3(textOutput("outputstringnostop"))
                     ),
            tabPanel("Input Text",
                     p(textOutput("inputtext"))
                     )

            )
    )
    )
))